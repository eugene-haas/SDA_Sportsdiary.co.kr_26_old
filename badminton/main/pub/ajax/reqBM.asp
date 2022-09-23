<!-- #include virtual = "/pub/header.bm.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
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
'############################################

	If request("test") = "t" Then
		REQ = "{""DEC_GameLevelDtlIDX"":""1181"",""DEC_TeamGameNum"":""8"",""DEC_GameNum"":""1"",""LTourneyGroupIDX"":""2324"",""RTourneyGroupIDX"":""2325"",""SetNum"":1,""CMD"":21000}"
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
	CMD_SETSCORE = 20000
	CMD_EDITRESULT = 21000

	Select Case CDbl(CMD)
	Case CMD_SETSCORE
		%><!-- #include virtual = "/pub/api/api.setscore.asp" --><%
	Response.End	

	Case CMD_EDITRESULT
		%><!-- #include virtual = "/pub/api/api.editresult.asp" --><%
	Response.End	

	End select	

	
%>