<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################

	REQ = request("REQ")
	'REQ ="{""CMD"":30001,""ADID"":""tennis"",""ADPWD"":""kata1234"",""ADTITLE"":""KATA""}"


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
	CMD_CONTESTAPPEND = 30000
	CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004


	Select Case CDbl(CMD)

	Case CMD_CONTESTAPPEND
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/operator/api.operatorMore.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/operator/api.operatorINPUT.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/operator/api.operatorEdit.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/operator/api.operatorEditok.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/operator/api.operatorDel.asp" --><%
	Response.end	
	End select
%>