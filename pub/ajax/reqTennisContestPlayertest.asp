<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	REQ = request("REQ")
'	REQ ="{""CMD"":100,""SVAL"":""테스""}"

'	If REQ = "" Then
'		Response.End
'	End if

	Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD

	'define CMD
	'CMD_AUTOCOMPLETE = 100


	%><!-- #include virtual = "/pub/api/tennisadmin/api.searchPlayer.asp" --><%
%>