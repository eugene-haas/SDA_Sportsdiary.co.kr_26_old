<!-- #include virtual = "/pub/header.mobileTennisAdmin.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn_mobile_tennis.asp" -->
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
    REQ = "{""CMD"":99,""IDX"":873,""TitleIDX"":175,""Title"":""2020 7-ELEVEN배"",""TeamNM"":""오픈부"",""AreaNM"":""부천"",""StateNo"":""0"",""Gno"":1,""S3KEY"":""20105006"",""P1"":660053,""POS"":""rankL_1_1"",""JONO"":1,""GAMEMEMBERIDX"":660053,""PLAYERIDX"":8990,""PLAYERIDXSub"":21989,""EndGroup"":4,""GUBUN"":1,""GN"":0,""RANKNO"":""2"",""result"":0}"
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

  LEAGUESET = 0
	LEAGUESTART = 1
	TOURNSET = 2
	TOURNSTART = 3
	RESULTHIDE = 4
	RESULTSHOW = 5
	STARTROUND = 1 '시작라운드

	'define CMD
	CMD_SETTOURNJOO = 16'본선대진표 - 재편성
  CMD_SETLEAGUERANKING = 18
  CMD_INPUTREGION = 19 '지역저장
	CMD_SETTOURNWINNER = 20 '본선대진표 - 승처리
	CMD_GAMECANCEL = 50 '본선대진표 - 승처리취소
  CMD_TOURN = 30008 '본선경기진행
  CMD_LEAGUEJOO = 30009
	CMD_TOURNTABLE = 30010 '본선대진표
  CMD_LEAGUEPRE = 31007
  CMD_RNDNOEDIT = 30017 '랜덤번호 업데이트
  CMD_GAMEADDITIONFLAG = 30012
  CMD_LEAGUEWIN = 40000 '예선 승처리
  CMD_LEAGUECOURT = 40001
  CMD_TOURNCOURT = 40003  '본선진행 코트 설정
  CMD_TOURNWIN = 40004 '본선진행 승처리
  CMD_TOURNEND = 40005 '종료된 목록
  CMD_LEAGUEDRAW = 41000 '본선대진추첨
  
  CMD_INITCOURT = 81000
  CMD_UPDATEMEMBER = 30024
  CMD_CHANGEPLAYER = 300	'선수교체 요청

CMD_SETTEAM = 301 '신규팀 생성
CMD_CHKPLAYER = 302 '중복체크 선수생성
CMD_SETPLAYER = 303 '선수생성
CMD_DELTEAM = 304  '팀참여 취소

CMD_BYEWIN = 99	'순위결정후 본선대진표 호출


	Select Case CDbl(CMD)
	Case CMD_BYEWIN 	'순위결정후 본선대진표 호출
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.TournByeWin.asp" --><%
	Response.end

	Case CMD_SETTEAM '신규팀 등록
		%><!-- #include virtual = "/pub/api/tennisadmin/api.setTeam.asp" --><%
	Response.end
	Case CMD_CHANGEPLAYER '선수교체
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.changePlayer.asp" --><%
	Response.end
	Case CMD_UPDATEMEMBER
	%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.LeagueUpdateMemeber.asp" --><%
	Response.End




	CASE CMD_SETTOURNJOO
	%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.setTournJoo.asp" --><%
	Response.End

  CASE CMD_SETLEAGUERANKING
	%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.setRanking.asp" --><%
	Response.End

  Case CMD_INPUTREGION
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/draw/api.InputRegion.asp" --><%
	Response.End

	Case CMD_SETTOURNWINNER
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.tournSetWinner.asp" --><%
	Response.End

	Case CMD_GAMECANCEL
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.gameCancel.asp" --><%
	Response.End

  Case CMD_TOURN
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.Tourn_ing.asp" --><%
	Response.End

  Case CMD_LEAGUEJOO '예선진행
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.league_ing.asp" --><%
	Response.End

	Case CMD_TOURNTABLE '대진표
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.Tourn.asp" --><%
	Response.End

  Case CMD_LEAGUEPRE '출전신고 예선 대진표 (대회준비)
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.league_pre.asp" --><%
	Response.End

  Case CMD_RNDNOEDIT
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/draw/api.gametryoutRndNo.asp" --><%
	Response.end

  case CMD_GAMEADDITIONFLAG
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.gmeadditionflag.asp" --><%
	Response.End

  Case CMD_LEAGUEWIN
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.league_win.asp" --><%
	Response.End

  Case CMD_LEAGUECOURT
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/league/api.league_court.asp" --><%
	Response.End

  Case CMD_TOURNCOURT
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.tourn_court.asp" --><%
	Response.End

  Case CMD_TOURNWIN
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.tourn_win.asp" --><%
	Response.End

  Case CMD_TOURNEND
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/tourn/api.Tourn_ingend.asp" --><%
	Response.end

  Case CMD_LEAGUEDRAW
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/draw/api.league_draw.asp" --><%
	Response.End

	Case CMD_INITCOURT '코트관리
		%><!-- #include virtual = "/pub/api/mobileTennisAdmin/court/api.makecourt.asp" --><%
	Response.End





	End Select
%>
