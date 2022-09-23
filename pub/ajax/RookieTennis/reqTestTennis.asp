<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<%
'참조 2: http://widecloud.tistory.com/143

	REQ = request("REQ")
	REQ ="{""CMD"":1}"

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
	CMD_A1 = 1
	CMD_A2 = 2
	CMD_A3 = 3
	CMD_A4 = 4
	CMD_A5 = 5

	'Select Case CDbl(CMD)
	'Case CMD_LOGIN
		%><!-- #include virtual = "/pub/api/api.test.asp" --><%
		'Response.end	
	'End select
%>