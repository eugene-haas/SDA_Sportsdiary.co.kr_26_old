<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
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
		REQ ="{""CMD"":55555,""TIDX"":""56"",""DIDX"":""167"",""NO"":0}"
	Else
		REQ = request("REQ")
	End If
	


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
	CMD_INSERTDATA = 30008

	CMD_MAKEGAME = 55555 '대회 참가자 밀어넣기

	Select Case CDbl(CMD)

	Case CMD_MAKEGAME
		%><!-- #include virtual = "/pub/api/RidingAdmin/pub/api.makerequest.asp" --><%
	Response.end	
	
	
	Case CMD_INSERTDATA
		%><!-- #include virtual = "/pub/api/RidingAdmin/pub/api.insertDATA.asp" --><%
	Response.end	

	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/pub/api.insertINPUT.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTEDIT
		%><%'<!-- #include virtual = "/pub/api/RidingAdmin/pub/api.insertEdit.asp" -->%><%
	Response.end	
	Case CMD_GAMEINPUTEDITOK
		%><%'<!-- #include virtual = "/pub/api/RidingAdmin/pub/api.insertEditok.asp" -->%><%
	Response.end	
	Case CMD_GAMEINPUTDEL
		%><%'<!-- #include virtual = "/pub/api/RidingAdmin/pub/api.insertDel.asp" --><%
	Response.end	
	End select
%>