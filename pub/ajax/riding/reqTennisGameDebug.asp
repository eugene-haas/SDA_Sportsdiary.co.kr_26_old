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
		REQ ="{""CMD"":30013,""SETINDEX"":""2"",""RESULTINDEX"":""1581"",""VALUE"":""6""}"
	else
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
	CMD_AUTOCOMPLETE = 100

	CMD_CONTESTAPPEND = 30000
	CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004
	'CMD_FIND1 = 30005
	'CMD_FIND2 = 30006
	CMD_GAMEAUTO = 30007
	CMD_FINDPLAYER = 30008
	'CMD_FINDRANK = 30009

	CMD_RANKINGINPUT = 30010
	CMD_RANKPOINT = 30011
	CMD_UPDATEGAMESETPOINT = 30013

	Select Case CDbl(CMD)
	Case CMD_RANKPOINT
		%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.RankingPoint.asp" --><%
	Response.End
	Case CMD_CONTESTAPPEND
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerMore.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerINPUT.asp" --><%
	Response.end
	Case CMD_RANKINGINPUT
	%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.RankingPointInput.asp" --><%
		Response.end	

	Case CMD_UPDATEGAMESETPOINT
	%><!-- #include virtual = "/pub/api/RidingAdmin/gametable/api.UpdateGameSetPoint.asp" --><%
		Response.end			
	
	Case CMD_GAMEAUTO
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerAuto.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerEdit.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerEditok.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerDel.asp" --><%
	Response.end	
	Case CMD_FINDPLAYER
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.PlayerFind.asp" --><%
	Response.end	
	End select
%>