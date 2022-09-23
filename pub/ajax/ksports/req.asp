<!-- #include virtual = "/pub/header.tennis.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<%
'참조 2: http://widecloud.tistory.com/143

	If request("t") = "t" Then
		REQ  = "{""CMD"":25}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if


	If InStr(REQ, "CMD") >0 then
	Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if

	'define CMD
	CMD_LOGIN = 1
	CMD_LOGOUT = 2
	CMD_LOGINCHK = 3

	CMD_CAL = 4
	CMD_PCODE = 5
	CMD_TEAMCODE = 6


	Select Case CDbl(CMD)
	Case CMD_LOGIN
		%><!-- #include virtual = "/pub/api/ksports/api.login.asp" --><%
		Response.end	
	Case CMD_LOGOUT

		session.Abandon
		
		for each Item in request.cookies
			if item = "saveinfo" or IsNumeric(item) = true then 'popup info / login info 
				'pass
			Else
				'사용하지 않아 막아둠
				'Response.cookies(item).expires	= date - 1365
				'Response.cookies(item).domain	= CHKDOMAIN	
			end if
		Next
		jstr = "{""result"":""0"",""chk"":""1""}"
		Response.write jstr
		Response.end	
	Case CMD_LOGINCHK
		%><!-- #include virtual = "/pub/api/ksports/api.loginchk.asp" --><%
		Response.end	
	End select
%>