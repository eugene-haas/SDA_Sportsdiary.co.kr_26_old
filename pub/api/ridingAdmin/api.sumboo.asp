<%
'#############################################
'종목 합치기
'fn_ridging.asp 참조
'#############################################
	Set db = new clsDBHelper


	Function getEngCode(ByVal pcode)
		Dim SQL ,rs
		SQL = "select engCode from tblPubCode where PPubCode = 'RDN01_4' and Pubcode = '"&pcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		
		If Not  rs.eof then
		getEngCode = rs("engCode")
		End if
        rs.Close 

	End Function

	Function getPubCode(ByVal engcode)
		Dim SQL ,rs
		SQL = "select pubcode from tblPubCode where PPubCode = 'RDN01_4' and engcode = '"&engcode&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not  rs.eof then
		getPubCode = rs("pubcode")
		End if
        rs.Close 
	End function


	'합쳐질 최종 pubcode 구하기
	Function getSumPubCode(ByVal apcode, ByVal bpcode) 'a b pubcode
		Dim Aarr, Barr, a, xorStr, aeng, beng
		aeng = getEngCode(apcode)		
		beng = getEngCode(bpcode)
		Aarr = getArrayFromStr(aeng)
		Barr = getArrayFromStr(beng)

		For a = 1 To ubound(Aarr)
			If Aarr(a) = Barr(a) Then
				If a = 1 then
					xorStr = Aarr(a)
				Else
					xorStr = xorStr & Aarr(a)
				End If
			Else
				If a = 1 then
					If Aarr(a) = "X" Then
						xorStr = Barr(a)
					Else
						xorStr = Aarr(a)
					End if
				Else
					If Aarr(a) = "X" Then
						xorStr = xorStr & Barr(a)
					Else
						xorStr = xorStr & Aarr(a)
					End if
				End If
			End if
		Next
'		Response.write xorStr
		getSumPubCode = getPubCode(xorStr)

	End function

    'request
    If hasown(oJSONoutput, "PARR") = "ok" then
        parr= oJSONoutput.PARR '부항목 인덱스 tblRGameLevel.RGameLevelidx
        
        WhereStr = " RGameLevelidx in ("&parr&")"
        SQL = "select GameTitleIDX,GbIDX,pubcode,pubName,RGameLevelidx,gameday,engcode from tblRGameLevel where " &  WhereStr & " order by  PubCode " 'CAST(PubCode AS int)
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

        If Not rs.EOF Then
            arrR = rs.GetRows()
        End If
        rs.Close 

    ' ---------------------------------------------------------------------------------------------
    ' 게임이 2라운드 이상(대회 같은 부명칭) 진행하면 부 해체를 할수 없다. 
        If CONST_CHECK = true Then 
            If IsArray(arrR) Then 
                tidx = arrR(0, 0)
                a_gbidx = arrR(1, 0)
                
                SQL = "Select Round From sd_TennisMember where gametitleidx = '"&tidx&"' and gamekey3 = '"&a_gbidx&"' Round > 1"
                Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

                If Not (rs.Eof Or rs.Bof) Then                      
                    Call oJSONoutput.Set("result", "90" )     
                    strjson = JSON.stringify(oJSONoutput)
                    Response.Write strjson
                    Response.write "`##`"
                    rs.Close 
                    db.Dispose

                    Set db = Nothing
                    Set rs = Nothing
                    Response.end
                End if 
            End If
        End if
    ' ---------------------------------------------------------------------------------------------

        If IsArray(arrR) Then 

            '마지막 부서 인덱스
            last_lvlidx = arrR(4, UBound(arrR, 2))
            last_gameday =  arrR(5, UBound(arrR, 2))
            
            For ari = LBound(arrR, 2) To UBound(arrR, 2)
                tidx = arrR(0, ari)
                a_gbidx = arrR(1, ari)
                a_pcode = arrR(2, ari)
                a_pnm = arrR(3, ari)
                a_lvlidx = arrR(4, ari)
                a_engcode = arrR(6, ari)


                If ari = 0 Then
                    'delYN 인덱스 찾기
                    If CStr(last_lvlidx) <> CStr(a_lvlidx) then
                        delboowhere = a_lvlidx
                    End if
                    reqw = "'" & a_pcode & "'"
                    pre_pcode = a_pcode
                    pre_engcode = a_engcode '꼭바꿔야할까 두자...
                Else
                    'delYN 인덱스 찾기
                    If CStr(last_lvlidx) <> CStr(a_lvlidx) then
                        delboowhere = delboowhere & "," & a_lvlidx
                    End if
                    reqw = reqw & "," & "'" & a_pcode & "'"
                    pre_pcode = getSumPubCode(pre_pcode, a_pcode) '위에서 부터 아래로 합치기
                End if
            Next
        End if


        '통합될 부서명칭 가져오기
        SQL = "select pubcode,engcode,pubname,pubsubname from tblPubCode where PPubCode = 'RDN01_4' and pubcode = '"&pre_pcode&"' "
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

        If Not rs.eof Then
            sumpcode = pre_pcode
            sumengcode = rs("engcode")
            sumpubname = rs("pubname")
        End if
        rs.Close 



        '통합하기
        '종목 내용 통합으로 변경 앞에꺼는 delYN = Y
        SQL = "Update tblRGameLevel Set orgpubcode = case when orgpubcode is null then pubcode else orgpubcode end, "
        SQL = SQL & " orgengcode = case when orgengcode is null then engcode else orgengcode end, "
        SQL = SQL & " orgpubname = case when orgpubname is null then pubname else orgpubname end, pubcode = '"&sumpcode&"', engcode = '"&sumengcode&"' , pubname = '"&sumpubname&"' where " &  whereStr
        Call db.execSQLRs(SQL , null, ConStr)
        SQL = "Update tblRgameLevel Set delYN = 'Y' where RGameLevelidx in (" & delbooWhere & ") "
        Call db.execSQLRs(SQL , null, ConStr)

        '참가 내역 통합으로 변경
        reqwherestr = " gametitleidx = '"&tidx&"' and gbidx = '"&a_gbidx&"' and pubcode in ("&reqw&") "
        SQL = "Update tblGameRequest Set orgpubcode = case when orgpubcode is null then pubcode else orgpubcode end, "
        SQL = SQL & " orgengcode = case when orgengcode is null then engcode else orgengcode end, "
        SQL = SQL & " orgpubname = case when orgpubname is null then pubname else orgpubname end, pubcode = '"&sumpcode&"', engcode = '"&sumengcode&"' , pubname = '"&sumpubname&"' where " &  reqwherestr
        Call db.execSQLRs(SQL , null, ConStr)


        '대회 진행 통합으로 변경
        memwherestr  = " gametitleidx = '"&tidx&"' and gamekey3 = '"&a_gbidx&"' and pubcode in ("&reqw&") "
        SQL = "Update sd_tennisMember Set orgpubcode = case when orgpubcode is null then pubcode else orgpubcode end, "
        SQL = SQL & " orgengcode = case when orgengcode is null then engcode else orgengcode end, "
        SQL = SQL & " orgpubname = case when orgpubname is null then pubname else orgpubname end, pubcode = '"&sumpcode&"', engcode = '"&sumengcode&"' , pubname = '"&sumpubname&"' where " &  memwherestr
        Call db.execSQLRs(SQL , null, ConStr)
    End If


        nowgameyear = Left(last_gameday,4)
        'nowgameyear   'tidx필요

        If(cmd = CMD_SUMBOO) Then 
            %><!-- #include virtual = "/pub/html/riding/boocontrollist.asp" --><%
        ElseIf(cmd = CMD_SUMBOO_INJUDGE) Then 

            If hasown(oJSONoutput, "TIDX") = "ok" Then 
                tIdx = oJSONoutput.TIDX                   ' GameYear
            End If

            If hasown(oJSONoutput, "GBIDX") = "ok" Then 
                find_gbidx = oJSONoutput.GBIDX                   ' GameTitleIDX
            End If

            If hasown(oJSONoutput, "ODTYPE") = "ok" Then 
                orderType = oJSONoutput.ODTYPE                   ' GameTitleIDX
            End If
            %><!-- #include virtual = "/pub/html/riding/boocontrollistno.asp" --><%
        End If


  db.Dispose
  Set db = Nothing
  Set rs = Nothing
%>
