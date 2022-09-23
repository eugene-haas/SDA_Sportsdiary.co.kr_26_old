<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
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

	If request("test") = "t" Then
		REQ ="{""CMD"":503}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if

	If InStr(REQ, "CMD") >0 then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )
		CMD = oJSONoutput.CMD
	Else
		CMD = REQ
	End if


	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304
	CMD_FINDTEAM = 30008 '소속검색

	Select Case CDbl(CMD)
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/referee/api.Input.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/referee/api.modify.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/referee/api.modifyok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/referee/api.delete.asp" --><%
	Response.end


	Case CMD_FINDTEAM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.teamFind.asp" --><%
	Response.end


	End Select
%>
