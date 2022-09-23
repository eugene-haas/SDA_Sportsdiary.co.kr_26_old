<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%

'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "CHKNO") = "ok" then
		chkno = oJSONoutput.Get("CHKNO")
	End if

	'내부테스트
	' If USER_IP = DEBUG_IP Then
	' 	Session.Contents.Remove("chkrndno")
	' 	Call oJSONoutput.Set("result", "0" )
	' 	strjson = JSON.stringify(oJSONoutput)
	' 	Response.Write strjson
	' 	Response.end
	' End if

	Set db = new clsDBHelper

	'인증번호 확인
	sessionChkno = session("chkrndnopwd")
	id = session("pwdcheckid")
	If CStr(chkno) = CStr(sessionChkno)  Then
		'session("chkrndno") = ""
		Session.Contents.Remove("chkrndnopwd")
		Session.Contents.Remove("pwdcheckid")

		'임시비밀번호 발급
		temppwd =  rndno(10, 8)
		'업데이트
		'문자발송
		SQL = " select dbo.FN_DEC_TEXT(PHONE_NUMBER) from tblWebMember where DELYN = 'N' and USERID = '"& InjectionChk(id) &"'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		mobileno = rs(0)

		SQL = " update tblWebMember set [PASSWORD] = HASHBYTES('SHA1', '"& temppwd &"') where DELYN = 'N' and USERID =  '"& InjectionChk(id) &"'"
		Call db.execSQLRs(SQL , null, ConStr)

		SMS_title = "["&CONST_GROUPNAME&"] 임시비밀번호"
		SMSMsg = "["&CONST_GROUPNAME&"]   ["&temppwd&"]로 임시비밀번호로 변경되었습니다."
		Call sendPhoneMessage(db,3, SMS_title, SMSMsg, sitecode, CONST_SENDPHONENO, mobileno)

		Call oJSONoutput.Set("result", "0" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	Else
		Call oJSONoutput.Set("result", "4" )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
	End if

	db.Dispose
	Set db = Nothing
%>
