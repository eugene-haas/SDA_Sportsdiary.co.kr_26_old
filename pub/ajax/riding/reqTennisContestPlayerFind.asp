<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	REQ = request("REQ")
'	REQ ="{""CMD"":100,""SVAL"":""박병"",""TIDX"":24}"

	If REQ = "" Then
		Response.End
	End if

	Set oJSONoutput = JSON.Parse(REQ)
	CMD = oJSONoutput.CMD

	'define CMD
	CMD_AUTOCOMPLETE = 100
	CMD_AUTOCOMPLETEALL = 110

	Select Case CDbl(CMD)

	Case CMD_AUTOCOMPLETE
	%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchPlayer.asp" --><%
	Response.End
	Case CMD_AUTOCOMPLETEALL
	%><!-- #include virtual = "/pub/api/RidingAdmin/api.searchAllPlayer.asp" --><%
	Response.End
	End Select


%>