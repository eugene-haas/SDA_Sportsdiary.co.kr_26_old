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

	CMD_FINDTEAM = 30008 '소속검색
	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304
	CMD_COPYPLAYER = 400 '체육회 선수정보가져오기

	CMD_MSGIN = 500
	CMD_MSGOUT = 501
	CMD_MSGCFG = 502
	CMD_SENDMSG   = 503 '문자전송

	CMD_TEAMFIND = 40001 '팀검색창

	Select Case CDbl(CMD)
	Case CMD_TEAMFIND
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.teamfindwindow.asp" --><%
	Response.end


	Case CMD_SENDMSG
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.sendmessage.asp" --><%
	Response.end

	Case CMD_MSGCFG
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.setmsgcfg.asp" --><%
	Response.end

	Case CMD_MSGIN
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.messageINmember.asp" --><%
	Response.end

	Case CMD_MSGOUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.messageDELmember.asp" --><%
	Response.end


	Case CMD_COPYPLAYER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.copyPlayer.asp" --><%
	Response.end

	Case CMD_FINDTEAM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.teamFind.asp" --><%
	Response.end

	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.playerInput.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.playerInputedit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.playerInputeditok.asp" --><%
	Response.end
	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/player/api.playerInputDel.asp" --><%
	Response.end



	End Select
%>
