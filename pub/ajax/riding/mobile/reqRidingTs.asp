<!-- #include virtual = "/pub/header.ridingAdmin.asp" -->
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
		'REQ = "{""CMD"": ""63400"",""tidx"": ""146"",""PN"": ""1"",""PT"": ""N"",""YS"": ""2019"",""MS"": ""3"",""poplink"": ""4"",""vidx"":"""",""searchtxt"":"""",""gno"":""1""}"
		REQ = "{""CMD"": ""63400"",""tidx"": ""43"",""PN"": ""1"",""PT"": ""N"",""YS"": ""2019"",""MS"": ""3"",""poplink"": ""4"",""vidx"":"""",""searchtxt"":"""",""gno"":""6""}"
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
	CMD_MAINVIEW = 50000 '메인뷰

	CMD_GAMEGETDATE = 60000 '경기일정 월별
	CMD_GAMEGETDATEYEAR = 61000 '경기일정 년별
	CMD_GAMEGETYEAR = 61100 '경기일정 년도 검색어
	CMD_GAMEGETDATEPOP = 62000 '경기일정 팝업
	CMD_GAMEGETDATEPOP_GAMESTATE = 62100 '경기일정 대회요강
	CMD_GAMEGETDATEPOP_GAMESTATE_FILE = 62200 '경기일정 대회요강 첨부

	CMD_GAMEGETMATCHTITLE = 63000 '매치 대회타이틀
	CMD_GAMEGETMATCHLIST = 63100 '매치 경기 리스트
	CMD_GAMEGETMATCHDATESEARCH = 63200 '매치 경기 검색키
	CMD_GAMEGETMATCHDATESEARCHTEXT = 63300 '매치 경기 검색어
	CMD_GAMEGETMATCHPLAYERLIST = 63400 '매치 경기 플레이어 리스트(출전순서)
	CMD_GAMEGETMATCHPLAYERLISTRANK = 63401 '매치 경기 플레이어 리스트(순위순서)


	CMD_GAMEGETMATCHLIVE = 63500 '실시간 매치 경기 리스트

	CMD_GAMEVIDEO = 70000 'video 경기영상 조회
	CMD_GAMEVIDEO_SEARCH = 71000 'video 경기영상 검색키
	CMD_GAMEVIDEO_SEARCHTEXT = 71100 'video 경기영상 검색어

	CMD_PHOTOSKETCH = 80000 'photo 현장스케치 조회
	CMD_PHOTOSKETCH_SEARCH = 81000 'photo 현장스케치 검색어


	'CMD_TEST = 	63401 '복합마술 경기진행순서 CMD_CMORDERLIST



	Select Case CDbl(CMD)


		'Case CMD_TEST
			%><%'<!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_playerListTest.asp" -->%><%
			'Response.end





		Case CMD_MAINVIEW
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.ridingMainView.asp" --><%
			Response.end
		Case CMD_GAMEGETDATE
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetDate.asp" --><%
			Response.end
		Case CMD_GAMEGETDATEYEAR
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetDate_year.asp" --><%
			Response.end
		Case CMD_GAMEGETYEAR
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetDate_yearSearch.asp" --><%
			Response.end
		Case CMD_GAMEGETDATEPOP
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetDate_pop.asp" --><%
			Response.end
		Case CMD_GAMEGETDATEPOP_GAMESTATE
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetDate_pop_gamestate.asp" --><%
			Response.end
		Case CMD_GAMEGETDATEPOP_GAMESTATE_FILE
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetDate_pop_gamestate_file.asp" --><%
			Response.end
		Case CMD_GAMEGETMATCHTITLE
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_title.asp" --><%
			Response.end
		Case CMD_GAMEGETMATCHLIST
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_list.asp" --><%
			Response.end
		Case CMD_GAMEGETMATCHDATESEARCH
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_dateSearch.asp" --><%
			Response.end
		Case CMD_GAMEGETMATCHDATESEARCHTEXT
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_dateSearchText.asp" --><%
			Response.end
		Case CMD_GAMEGETMATCHPLAYERLIST
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_playerListTest.asp" --><%
			Response.End
			
		Case CMD_GAMEGETMATCHPLAYERLISTRANK
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_playerListRank.asp" --><%
			Response.end

		
		
		Case CMD_GAMEGETMATCHLIVE
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameGetMatch_live.asp" --><%
			Response.end
		Case CMD_GAMEVIDEO
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameVideo.asp" --><%
			Response.end
		Case CMD_GAMEVIDEO_SEARCH
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameVideoSearch.asp" --><%
			Response.end
		Case CMD_GAMEVIDEO_SEARCHTEXT
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.gameVideoSearchText.asp" --><%
			Response.end
		Case CMD_PHOTOSKETCH
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.photoSketch.asp" --><%
			Response.end
		Case CMD_PHOTOSKETCH_SEARCH
			%><!-- #include virtual = "/pub/api/Riding/mobile/api.photoSketchSearch.asp" --><%
			Response.end

	End Select
%>
