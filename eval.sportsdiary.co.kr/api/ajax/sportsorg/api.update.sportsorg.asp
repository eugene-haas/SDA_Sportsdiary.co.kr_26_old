<%
'#############################################

'대회 정보 수정

'#############################################
	'request
	Set reqArr = oJSONoutput.get("PARR") 
	EvalTableIDX = oJSONoutput.get("ETBLIDX") 'EvalTableIDX

	Set db = new clsDBHelper 

		EvalGroupCD 	= reqArr.Get(0)
		MemberGroupCD = reqArr.Get(1)
		AssociationNm = reqArr.Get(2)
		e_idx = reqArr.Get(3)

	Set db = new clsDBHelper 

'동일 팀명칭 체크
		' SQL = "Select AssociationNm from tblAssociation where delkey = 0 AssociationNm = '"&AssociationNm&"' "
		' Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		' if not rs.eof then
		' 	Call oJSONoutput.Set("result", 111 )
		' 	Call oJSONoutput.Set("servermsg", "동일한 종목단체가 존재합니다." ) '중복
		' 	strjson = JSON.stringify(oJSONoutput)
		' 	Response.Write strjson
		' 	Response.End			
		' end if


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

				if l_kindnm = "평가군" and Cstr(EvalGroupCD) = Cstr(l_codecd) then
					EvalGroupNm = l_codenm
				end if
			
				if l_kindnm = "회원군" and Cstr(MemberGroupCD) = Cstr(l_codecd) then
					MemberGroupNm = l_codenm
				end if
			Next
		End if




		'이후에 대회명은 변경되어야한다.
		SQL = "Update tblAssociation Set AssociationNm = '"&AssociationNm&"' where  AssociationIDX = " & e_idx
		Call db.execSQLRs(SQL , null, ConStr)

		SQL = " Update tblAssociation_sub Set "
		SQL = SQL & " AssociationNm = '"&AssociationNm&"' "
		SQL = SQL & ",EvalGroupCD = " & EvalGroupCD
		SQL = SQL & ",EvalGroupNm = '" &EvalGroupNm&"' "
		SQL = SQL & ",MemberGroupCD = " & MemberGroupCD
		SQL = SQL & ",MemberGroupNm =  '" &MemberGroupNm&"' "
		SQL = SQL & " where  delkey = 0 and AssociationIDX = " & e_idx & " and EvalTableIDX = " & EvalTableIDX
		Call db.execSQLRs(SQL , null, ConStr)
		

		Call oJSONoutput.Set("result", 0 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


  Set rs = Nothing
  db.Dispose
  Set db = Nothing
%>




