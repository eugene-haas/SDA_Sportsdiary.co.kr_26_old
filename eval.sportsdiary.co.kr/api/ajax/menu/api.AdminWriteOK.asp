<%
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
		SQL = "Select UserID  from tblAdminMember where delYN = 'N' and SiteCode = '"&sitecode&"'  and UserID = '" & AID & "' "
		Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
		If Not rs.eof then
			Call oJSONoutput.Set("servermsg", "중복 된 아이디가 존재합니다." ) '중복
			strjson = JSON.stringify(oJSONoutput)
			Response.Write strjson
			Response.End
		End if
	'#################################



		insertfield = "UserID,UserPass,adminName,Authority,USEYN,WriteID,SiteCode,encPass,AssociationIDX,AssociationNM ,adminbirth,adminphone"
		
		insertvalue = " '"&aid&"','"&apwd&"','"&aname&"','"&aclass&"','N', '"&Cookies_aID&"','"&sitecode&"',HASHBYTES('SHA2_512','"&apwd&"'), "&asso&", (select AssociationNM from tblAssociation where AssociationIDX = "&asso&" )  "
		insertvalue = insertvalue & "," &  fldEnc(abirth) & "," & fldEnc(aphone) 
		
		SQL = QueryKeyOpenClose ( " insert into tblAdminMember ("&insertfield&") values ("&insertvalue&")" )
		
		
' response.write SQL
' response.end

		Call db.execSQLRs(SQL , null, B_ConStr)


		If menuidxarr <> "" Then

			SQL = "Select AdminMemberIDX  from tblAdminMember where delYN = 'N' and SiteCode = '"&sitecode&"'  and UserID = '" & AID & "' "
			Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
			AdminMemberIDX = rs(0)





			'여러사이트 등록###################
			session_scode = session("scode")
			if session_scode <> "" then
				sitecode = session_scode
			end if
			'여러사이트 등록###################

			SQL = "insert into tblAdminMenuRole ( AdminMemberIDX, RoleDetail, WriteID,sitecode) values "
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



