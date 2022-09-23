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


	sub backBoo(tidx, gbidx, pcode )
		Dim SQL 
		
		'실지로 지운데이터가 살아나지 않도록 코딩할것

		SQL = "Update tblRGameLevel Set pubcode = orgpubcode, engcode = orgengcode, "
		SQL = SQL & " pubname = orgpubname , delYN = 'N', okYN = 'N'  where gametitleidx = '"&tidx&"' and gbidx ='"&gbidx&"' and  orgpubcode =  '"&pcode&"' "
		Call db.execSQLRs(SQL , null, ConStr)

		'참가 내역 
		SQL = "Update tblGameRequest Set pubcode = orgpubcode, engcode = orgengcode,  "
		SQL = SQL & " pubname = orgpubname  where gametitleidx = '"&tidx&"' and gbidx = '"&gbidx&"' and orgpubcode = '"&pcode&"' "
		Call db.execSQLRs(SQL , null, ConStr)


		'대회 진행 
		SQL = "Update sd_tennisMember Set pubcode = orgpubcode, engcode = orgengcode,  "
		SQL = SQL & " pubname = orgpubname  where gametitleidx = '"&tidx&"' and gamekey3 = '"&gbidx&"' and orgpubcode = '"&pcode&"' "
		Call db.execSQLRs(SQL , null, ConStr)
	End sub 

    'request
    If hasown(oJSONoutput, "PARR") = "ok" then
        parr= oJSONoutput.PARR '부항목 인덱스 tblRGameLevel.RGameLevelidx
        
        WhereStr = " RGameLevelidx in ("&parr&")"
        SQL = "select top 1 GameTitleIDX,GbIDX,pubcode,pubName,RGameLevelidx,gameday from tblRGameLevel where " &  WhereStr & " order by  PubCode " 'CAST(PubCode AS int)
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        '대상은 1개

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
            For ari = LBound(arrR, 2) To UBound(arrR, 2) '1개씩임
                tidx = arrR(0, ari)
                a_gbidx = arrR(1, ari)
                a_pcode = arrR(2, ari)
                a_pnm = arrR(3, ari)
                a_lvlidx = arrR(4, ari)
                last_gameday = arrR(5, ari)

                a_engcode = getEngCode(a_pcode)
                Earr = getArrayFromStr(a_engcode)
                If Earr(1) = "E" Then

                    Call backBoo(tidx, a_gbidx, "1")

                End If
                If Earr(2) = "M" Then
                    Call backBoo(tidx, a_gbidx, "2")


                End If
                If Earr(3) = "H" Then
                    Call backBoo(tidx, a_gbidx, "3")


                End If
                If Earr(4) = "U" Then
                    Call backBoo(tidx, a_gbidx, "4")				
                
                End If
                If Earr(5) = "G" Then
                    Call backBoo(tidx, a_gbidx, "5")				
                
                End If
                If Earr(6) = "C" Then
                    Call backBoo(tidx, a_gbidx, "6")
                
                End if					
            Next
        End if
    End if

    nowgameyear = Left(last_gameday,4)
    'nowgameyear   'tidx필요

    If(cmd = CMD_DIVBOO) Then 
        %><!-- #include virtual = "/pub/html/riding/boocontrollist.asp" --><%
    ElseIf(cmd = CMD_DIVBOO_INJUDGE) Then 
        If hasown(oJSONoutput, "TIDX") = "ok" Then 
            tIdx = oJSONoutput.TIDX                   ' GameYear
        End If

        If hasown(oJSONoutput, "GBIDX") = "ok" Then 
            find_gbidx = oJSONoutput.GBIDX                   ' GameTitleIDX
        End If

        If hasown(oJSONoutput, "ODTYPE") = "ok" Then 
            orderType = oJSONoutput.ODTYPE                   ' GameTitleIDX
        End If
        
        Call orderUpdate(db, tIdx, find_gbidx, 0, 1, orderType)

        %><!-- #include virtual = "/pub/html/riding/boocontrollistno.asp" --><%
    End If
  

  db.Dispose
  Set db = Nothing
  Set rs = Nothing
%>
