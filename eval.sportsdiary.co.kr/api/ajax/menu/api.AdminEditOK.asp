<%
	seq = oJSONoutput.get("SEQ")

	aid = oJSONoutput.get("AID")
	apwd = oJSONoutput.get("APWD")
	aname = oJSONoutput.get("ANAME")
	aclass = oJSONoutput.get("ACLASS")
	
	abirth = oJSONoutput.get("ABIRTH")
	aphone = oJSONoutput.get("APHONE")
		
	menuidxarr = oJSONoutput.get("CHKMNIDXARR")
	asso = oJSONoutput.get("ASSO")

	Set db = new clsDBHelper

	'#################################
		'중복체크
		SQL = "Select UserID  from tblAdminMember where delYN = 'N' and AdminMemberIDX = " & SEQ
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		
		If rs(0) <> AID Then
			SQL = "Select UserID  from tblAdminMember where delYN = 'N' and UserID = '" & AID & "' "
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)		
			If Not rs.eof then
				Call oJSONoutput.Set("servermsg", "중복 된 아이디가 존재합니다." ) '중복
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.End
			End if
		End if
	'#################################
		if apwd <> "" then
			encpassstr = " ,encPass = HASHBYTES('SHA2_512','"&apwd&"') "
		end if

		SQL = " Update tblAdminMember Set UserID = '"&aid&"' ,adminName = '"&aname&"',Authority = '"&aclass&"' ,ModID = '"&Cookies_aID&"' "
		SQL = SQL & " ,AssociationIDX="&asso&" ,AssociationNM=(select AssociationNM from tblAssociation where AssociationIDX = "&asso&" ) "
		SQL = SQL & ",adminbirth = "&fldEnc(abirth)&", adminphone ="&fldEnc(aphone) & encpassstr & " , ModDate = getdate() where AdminMemberIDX = " & seq 
		SQL = QueryKeyOpenClose (SQL)
		
		

		Call db.execSQLRs(SQL , null, B_ConStr)
		
		If menuidxarr <> "" Then

			AdminMemberIDX = seq


			'여러사이트 등록###################
			session_scode = session("scode")
			if session_scode <> "" then
				sitecode = session_scode
			end if
			'여러사이트 등록###################

			SQL = "Update tblAdminMenuRole Set delYN = 'Y' ,ModID = '"&Cookies_aID&"' , ModDate = getdate() where delYN = 'N' and sitecode = '"&sitecode&"'  and AdminMemberIDX = " & seq
			Call db.execSQLRs(SQL , null, B_ConStr)

			SQL = "insert into tblAdminMenuRole ( AdminMemberIDX, RoleDetail, WriteID ,sitecode) values "
			mnarr = Split(menuidxarr,",")
			For i = 0 To ubound(mnarr)
				If i = 0 then
					SQL = SQL & " ("&AdminMemberIDX&",'"&mnarr(i)&"','"&Cookies_aID&"', '"&sitecode&"') "
				Else
					SQL = SQL & " , ("&AdminMemberIDX&",'"&mnarr(i)&"','"&Cookies_aID&"' , '"&sitecode&"') "
				End if
			next
			Call db.execSQLRs(SQL , null, B_ConStr)
		End if

		Call oJSONoutput.Set("result", "0" ) '정상
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson


	db.Dispose
	Set db = Nothing
%>


