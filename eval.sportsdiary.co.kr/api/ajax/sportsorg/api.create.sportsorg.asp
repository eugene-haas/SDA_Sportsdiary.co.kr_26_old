<%
'#############################################

'대회생성저장

'#############################################
	'request
	Set reqArr = oJSONoutput.get("PARR") 
	EvalTableIDX = oJSONoutput.get("ETBLIDX") 'EvalTableIDX

	Set db = new clsDBHelper 

		EvalGroupCD 	= reqArr.Get(0)
		MemberGroupCD = reqArr.Get(1)
		AssociationNm = reqArr.Get(2)


		'공통코드
		SQL = "select pubcodeidx,kindcd,kindnm,codecd,codenm from tblPubCode where delkey = 0"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrRSP = rs.GetRows()
		End If
		Set rs = nothing

		If IsArray(arrRSP) Then 
			For ari = LBound(arrRSP, 2) To UBound(arrRSP, 2)
				l_kindnm = arrRSP(2, ari) 
				l_codecd = arrRSP(3, ari)
				l_codenm = arrRSP(4,ari)

				if l_kindnm = "평가군" then
					EvalGroupNm = l_codenm
				end if
			
				if l_kindnm = "회원군" then
					MemberGroupNm = l_codenm
				end if
			Next
		End if


		'동일 팀명칭 체크
		SQL = "Select delkey,Association_subIDX from tblAssociation_sub where delkey=0 and  AssociationNm = '"&AssociationNm&"' and EvalTableIDX = "& EvalTableIDX
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		if not rs.eof then
			delkey = rs(0)
			Association_subIDX = rs(1)

			if delkey = "0" then
				Call oJSONoutput.Set("result", 111 )
				Call oJSONoutput.Set("servermsg", "동일한 종목단체가 존재합니다." ) '중복
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.End
			else 
				SQL = "Update tblAssociation_sub Set delkey = 0 "
				SQL = SQL & ",EvalGroupCD = " & EvalGroupCD
				SQL = SQL & ",EvalGroupNm = '" &EvalGroupNm&"' "
				SQL = SQL & ",MemberGroupCD = " & MemberGroupCD
				SQL = SQL & ",MemberGroupNm =  '" &MemberGroupNm&"' "				
				SQL = SQL & " where Association_subIDX = " & Association_subIDX
				Call db.execSQLRs(SQL , null, ConStr)		
			end if
		else

			SQL = "SET NOCOUNT ON  Insert into tblAssociation (AssociationNm) values ('"&AssociationNm&"')  SELECT @@IDENTITY "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			idx = rs(0)

			SQL = " insert into tblAssociation_sub (AssociationIDX, EvalTableIDX, AssociationNm,EvalGroupCD,EvalGroupNm,MemberGroupCD,MemberGroupNm) values "
			SQL = SQL & " ("&idx&", "&EvalTableIDX&" , '"&AssociationNm&"',"&EvalGroupCD&",'"&EvalGroupNm&"',"&MemberGroupCD&",'"&MemberGroupNm&"') " 
			Call db.execSQLRs(SQL , null, ConStr)

		end if

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>