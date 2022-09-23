<!-- #include virtual = "/pub/header.RidingHome.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################
%><!-- #include virtual = "/pub/setReq.asp" --><%'이걸열어서 디버깅하자.%><%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "NM") = "ok" then
		id = oJSONoutput.Get("NM") 'ID
	End if


	Set db = new clsDBHelper

	tempAuth =  rndno(10, 4)

	SQL = " select dbo.FN_DEC_TEXT(PHONE_NUMBER) from tblWebMember where DELYN = 'N' and USERID = '"& InjectionChk(id) &"'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	if rs.eof Then
		Call oJSONoutput.Set("result", "22" ) '가입되지 않은 아이디'
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		db.Dispose
		Set db = Nothing
		Response.end
	else
		'세션으로 번호를 생성해 둔다. ( 인증번호 확인시 사용)
		mobileno = rs(0)
		session("chkrndnopwd") = tempAuth
		session("pwdcheckid") = id

		'If pno = "01047093650" Then
			'패스 내번호 테스트용
		'else
			SMS_title = "["&CONST_GROUPNAME&"] 비밀번호찾기 인증번호"
			SMSMsg = "["&CONST_GROUPNAME&"]  인증번호 ["&tempAuth&"] 를 입력해 주세요."
			Call sendPhoneMessage(db,3, SMS_title, SMSMsg, sitecode, CONST_SENDPHONENO, mobileno)
		'End if
	end if


	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing
%>
