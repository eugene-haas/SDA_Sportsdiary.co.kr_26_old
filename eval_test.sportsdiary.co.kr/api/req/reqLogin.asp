<!-- #include virtual = "/admin/inc/header.admin.asp" -->
<%
'############################################

	If request("test") = "t" Then
		REQ = "{""CMD"":10,""ID"":""20170703"",""PWD"":""m12345"",""CODE"":""2001"",""CHK"":false,""RETURNURL"":""/index.asp""}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") > 0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if



	CMD_LOGINCHK = 10 '로그인 체크 쿠키생성


	Select Case CDbl(CMD)
	Case CMD_LOGINCHK
		%><!-- #include virtual = "/api/ajax/login/api.adminlogin.asp" --><%
		Response.end

	End select
%>
