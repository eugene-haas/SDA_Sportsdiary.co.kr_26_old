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
	If request("test") = "t" Then
		REQ = "{""CMD"":30010,""IDX"":37171}"
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
	CMD_GAMEAUTO = 30007
	CMD_FINDPLAYER = 30008

	CMD_DELPLAYER = 30009
	CMD_SETPLAYER = 30010
	CMD_REQUESTMANINFO = 30011
	
	CMD_PAYSTATE = 200
	CMD_RESTOREPLAYER = 300 '복구
	CMD_RESTOREPLAYER_2 = 333 '복구
	CMD_REFUND = 334	'환불상태변경

	CMD_ATTDELMEMBERLIST = 31000	'참가신청취소 명단


	'//예선 선수교체에서 사용 contentlevel.asp
	CMD_FINDPLAYER2 = 50000
	CMD_CHANGEBOO = 201	'부서변경

	CMD_REFUNDINFO = 301 '환불계좌정보 저장 (대회신청정보에서)

	Select Case CDbl(CMD)

	Case CMD_REFUNDINFO
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.saverefund.asp" --><%
	Response.end	


	Case CMD_REFUND '환불상태변경
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.refund.asp" --><%
	Response.end	


	Case CMD_CHANGEBOO '부서변경
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.changeboo.asp" --><%
	Response.end	


	Case CMD_ATTDELMEMBERLIST
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.attDelList.asp" --><%
	Response.end		

	Case CMD_PAYSTATE
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.paystate.asp" --><%
	Response.end		
	

	Case CMD_RESTOREPLAYER,CMD_RESTOREPLAYER_2 '복구
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.restoreplayer.asp" --><%
	Response.end	
	
	Case CMD_SETPLAYER
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.setplayer.asp" --><%
	Response.end	
	Case CMD_DELPLAYER
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gameplayer/api.delplayer.asp" --><%
	Response.end	



	Case CMD_FINDPLAYER
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.gameinputPlayerFind.asp" --><%
	Response.end	

	Case CMD_FINDPLAYER2
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.gameinputPlayerFind2.asp" --><%
	Response.end	


	Case CMD_REQUESTMANINFO
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.requestManInfo.asp" --><%
	Response.end	


	Case CMD_AUTOCOMPLETE
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.searchPlayer.asp" --><%
	Response.End


	Case CMD_CONTESTAPPEND
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.contestmoreplayer.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.gameinputplayer.asp" --><%
	Response.end	

	Case CMD_GAMEAUTO
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.gameInputPlayerAuto.asp" --><%
	Response.end	

	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.gameinputPlayerEdit.asp" --><%
	Response.end	
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.gameinputPlayerEditok.asp" --><%
	Response.end	


	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/api.gameinputPlayerDel.asp" --><%
	Response.end	
	End select
%>