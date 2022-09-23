<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->




<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	REQ = request("REQ")
	'REQ ="{""CMD"":100,""SVAL"":""테스""}"

	'If REQ = "" Then
	'	Response.End
	'End if

	Set oJSONoutput = JSON.Parse(REQ)

	%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchTeam.asp" --><%
%>