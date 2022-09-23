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

	Set db = new clsDBHelper

	'#################################
		'중복체크
		SQL = "Select UserID  from tblAdminMember where delYN = 'N' and SiteCode = '"&sitecode&"'  and UserID = '" & AID & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		If Not rs.eof then
			Call oJSONoutput.Set("result", "2" ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.write "`##`"
			Response.End
		End if
	'#################################

		'단방향 암호화모듈
		Set encrypt512 = server.createobject("EncryptSha512.CESSA")
		strKey = encrypt512.GetSaultKey() 
		strEncrypt = encrypt512.EncryptUsingSHA(strKey & apwd)
		Set encrypt512 = Nothing



		insertfield = "UserID,UserPass,adminName,Authority,USEYN,WriteID,SiteCode,encKey,encPass "
		insertvalue = " '"&aid&"','"&apwd&"','"&aname&"','"&aclass&"','N', '"&Cookies_aID&"','"&sitecode&"','"&strKey&"','"&strEncrypt&"' "
		
		SQL = " insert into tblAdminMember ("&insertfield&") values ("&insertvalue&")"
		Call db.execSQLRs(SQL , null, B_ConStr)


		If menuidxarr <> "" Then



			SQL = "Select AdminMemberIDX  from tblAdminMember where delYN = 'N' and SiteCode = '"&sitecode&"'  and UserID = '" & AID & "' "
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
			AdminMemberIDX = rs(0)

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



