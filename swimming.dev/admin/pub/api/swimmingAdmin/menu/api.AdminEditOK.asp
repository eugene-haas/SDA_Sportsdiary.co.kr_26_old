<%
	If hasown(oJSONoutput, "AID") = "ok" then
		aid = oJSONoutput.AID
	End If

	If hasown(oJSONoutput, "APWD") = "ok" then
		apwd = oJSONoutput.APWD
	End If
	If hasown(oJSONoutput, "ANAME") = "ok" then
		aname = oJSONoutput.ANAME
	End If
	If hasown(oJSONoutput, "ACLASS") = "ok" then
		aclass = oJSONoutput.ACLASS
	End If
	
	If hasown(oJSONoutput, "CHKMNIDXARR") = "ok" then
		menuidxarr = oJSONoutput.CHKMNIDXARR
	End if

	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq = oJSONoutput.SEQ
	End if
	kindcode = oJSONoutput.Get("KIND_CODE")

	Set db = new clsDBHelper

	'#################################
		'중복체크
		SQL = "Select UserID  from tblAdminMember where delYN = 'N' and AdminMemberIDX = " & SEQ
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		
		If rs(0) <> AID Then
			SQL = "Select UserID  from tblAdminMember where delYN = 'N' and UserID = '" & AID & "' "
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)		
			If Not rs.eof then
				Call oJSONoutput.Set("result", "2" ) '중복
				strjson = JSON.stringify(oJSONoutput)
				Response.Write strjson
				Response.write "`##`"
				Response.End
			End if
		End if
	'#################################

		'단방향 암호화모듈
		'Set encrypt512 = server.createobject("EncryptSha512.CESSA")
		'strKey = encrypt512.GetSaultKey() 
		'strEncrypt = encrypt512.EncryptUsingSHA(strKey & apwd)
		'Set encrypt512 = Nothing

		
		
		'SQL = " Update tblAdminMember Set UserID = '"&aid&"',UserPass = '"&apwd&"' ,adminName = '"&aname&"',Authority = '"&aclass&"' ,ModID = '"&Cookies_aID&"' , ModDate = getdate() where AdminMemberIDX = " & seq
		SQL = " Update tblAdminMember Set UserID = '"&aid&"',UserPass = '"&apwd&"' ,adminName = '"&aname&"',Authority = '"&aclass&"' ,ModID = '"&Cookies_aID&"' ,encKey='"&strKey&"',encPass='"&strEncrypt&"' , ModDate = getdate() where AdminMemberIDX = " & seq
		Call db.execSQLRs(SQL , null, B_ConStr)
		
		If menuidxarr <> "" Then

			AdminMemberIDX = seq

			SQL = "Update tblAdminMenuRole Set delYN = 'Y' ,ModID = '"&Cookies_aID&"' , ModDate = getdate() where delYN = 'N'  and AdminMemberIDX = " & seq
			Call db.execSQLRs(SQL , null, B_ConStr)

			SQL = "insert into tblAdminMenuRole ( AdminMemberIDX, RoleDetail, WriteID) values "
			mnarr = Split(menuidxarr,",")
			For i = 0 To ubound(mnarr)
				If i = 0 then
					SQL = SQL & " ("&AdminMemberIDX&",'"&mnarr(i)&"','"&Cookies_aID&"') "
				Else
					SQL = SQL & " , ("&AdminMemberIDX&",'"&mnarr(i)&"','"&Cookies_aID&"') "
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


