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
		REQ ="{""CMD"":12000,""RIDX"":92665}"
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
	End If
	
	'define CMD
	CMD_FINDPLAYER = 30008
	CMD_FINDTEAM = 30009



	CMD_GAMEINPUTTEST = 305 '테스트용 참가자 생성
	
	
	CMD_GAMEINPUT = 301
	CMD_GAMEINPUTTEAM = 302
	'CMD_GAMEINPUTEDIT = 30002
	'CMD_GAMEINPUTEDITOK = 303
	CMD_GAMEINPUTDEL = 304

	CMD_PLAYERLIST = 12000 '계영 신청 선수
	CMD_MEMBERIN = 400
	Select Case CDbl(CMD)


	Case CMD_MEMBERIN
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.newMember.asp" --><% '계영선수추가
	Response.end	

	Case CMD_PLAYERLIST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.memberList.asp" --><%
	Response.end	
	

	
	Case CMD_GAMEINPUTTEST
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputPlayertest.asp" --><%
	Response.end	


	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputPlayer.asp" --><%
	Response.end	
	

	Case CMD_FINDTEAM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.TeamFind.asp" --><%
	Response.end		

	Case CMD_FINDPLAYER
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.PlayerFind.asp" --><%
	Response.end	


	Case CMD_GAMEINPUTTEAM
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputTeam.asp" --><%
	Response.end
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputPlayer.asp" --><%
	Response.end

	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/swimmingAdmin/contest/api.gameinputPlayerDel.asp" --><%
	Response.end

	
	End Select


%>