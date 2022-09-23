<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "PC") = "ok" Then '페이지코드
		pagecode = oJSONoutput.PC
	End If

	'관리자번호 쿠키값  Cookies_aIDX
	SQL = "Update tblFormState set openYN =  case when openYN = 'Y' then 'N' else 'Y' end where midx = '"&Cookies_aIDX&"'  and filecode = '"&pagecode& "' "
	Call db.execSQLRs(SQL , null, ConStr)	
	db.Dispose
	Set db = Nothing

	Response.redirect "/blank.asp"
%>