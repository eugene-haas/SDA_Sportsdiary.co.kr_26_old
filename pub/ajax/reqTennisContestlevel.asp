<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
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
		'REQ =  "{""CMD"":820,""titleidx"":25,""levelno"":20104001,""playeridx"":3037,""itemIDX"":""2""}"
    'REQ = "{""CMD"":50,""ONEMORE"":""notok"",""roundSel"":"""",""IDX"":168,""RESET"":""notok"",""TitleIDX"":24,""Title"":""예선 업로드"",""TeamNM"":""오픈부"",""AreaNM"":""파주"",""T_MIDX"":275964,""T_SORTNO"":1,""T_DIVID"":""cell_3_1"",""T_ATTCNT"":1,""T_NOWRD"":3,""T_RDID"":""set_Round_7"",""S3KEY"":""20105001"",""SCIDX"":0,""POS"":0,""result"":0,""GN"":1}"
    REQ = "{""CMD"":30008,""IDX"":628,""TitleIDX"":144,""Title"":""2019 아산이충무공배"",""TeamNM"":""개나리부"",""AreaNM"":""아산"",""ONEMORE"":""notok"",""roundSel"":"""",""RESET"":""notok""}"

	ElseIf request("test") = "z" Then
		REQ ="{""CMD"":30017,""IDX"":52,""RESET"":""notok"",""TitleIDX"":13,""Title"":""송근호배"",""TeamNM"":""오픈부"",""AreaNM"":""목동"",""MEMBERIDX"":""2269"",""STR"":""2"",""RNDNO"":""2""}"

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
	CMD_LOGIN = 1
	CMD_GAMEGRADEPERSONAPPEND = 30000
	CMD_GAMEINPUT = 30001
	CMD_GAMEINPUTEDIT = 30002
	CMD_GAMEINPUTEDITOK = 30003
	CMD_GAMEINPUTDEL = 30004
	CMD_FIND1 = 30005
	CMD_FIND2 = 30006
	CMD_LEAGUE = 30007  '리그
	CMD_LEAGUEPRE = 31007 '대회준비

	CMD_TOURN = 30008   '토너먼트
	CMD_LEAGUEJOO = 30009 '리그 조별 대진표
	CMD_RPOINTEDIT = 30011
	CMD_GAMEADDITIONFLAG = 30012
	CMD_CHANGESELECTAREA = 30013
	CMD_FILLINGEMPTYENTRY = 30014
	CMD_SEEDEDIT = 30015
	CMD_TOURNCHANGESELECTAREA = 30016 '토너먼트 소팅변경
	CMD_RNDNOEDIT = 30017
	CMD_CourtBoxReLoad = 30018  '코트 상태 조회
	CMD_REFRESHLEAGUEJOO = 30019
	CMD_REFRESHGAMECOURT = 30020
	CMD_INPUTLEVEL = 30021
	CMD_INSERTGROUPGAMEGB = 30022
    CMD_INSERTLEVELGB = 30023
	CMD_UPDATEMEMBER = 30024
	CMD_JOODIVISION = 30025
	CMD_JOOAREA = 30026
	CMD_SETWINNER = 10   '승자결정
	CMD_SETCOURT = 11	'코트결정
	CMD_SETRANKING = 12 '순위 결정
	CMD_SETJOO = 13 '조 설정 완료
	CMD_MAKETEMPPLAYER = 14  '부전승만들기
	CMD_SETTOURN  = 15	'토너먼트 편성완료 1라운드
	CMD_SETTOURNJOO = 16 ' 토너먼트 조 편성
    CMD_SETCOURT_Try= 17	'예선 코트 배정

	CMD_GAMECANCEL = 50 '승 취소
	CMD_INITRULL = 51	'본선룰 다시 적용


	CMD_SETTOURNWINNER = 20  '본선 승자결정
	CMD_SETLEAGUERANKING = 18
	CMD_INPUTREGION = 19
	CMD_SETJOORULE = 21
	CMD_TOURNLASTROUND = 30050 '최종라운드 검사및 생성 화면 뷰
	CMD_ATTSTATE = 200 '신청 수정 삭제

	CMD_CHANGEPLAYER = 300	'선수교체 요청
	CMD_SETTEAM = 301 '신규팀 생성
	CMD_CHKPLAYER = 302 '중복체크 선수생성
	CMD_SETPLAYER = 303 '선수생성
	CMD_DELTEAM = 304  '팀참여 취소

	CMD_LASTIN = 400 '결승 참가
	CMD_LASTOUT = 401 '결승 참가 취소
	CMD_LASTIN2 = 402 '결승 참가 리그
	CMD_LASTOUT2 = 403 '결승 참가 취소 리그
	CMD_UPDATEJOOCNT = 500 '조수 변경

	CMD_SETLAKET = 820 '테니스 라켓 설정


	'define  0 예선 1 예선대진표완료 2본선진출 3 본선대진표완료 4본선대진완료 (sd_TennisMember gubun)
	LEAGUESET = 0
	LEAGUESTART = 1
	TOURNSET = 2
	TOURNSTART = 3
	RESULTHIDE = 4
	RESULTSHOW = 5

	STARTROUND = 1 '시작라운드



	Select Case CDbl(CMD)

	Case CMD_INITRULL '본선룰 다시 적용
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.tournInitRull.asp" --><%
	Response.End


	Case CMD_UPDATEJOOCNT
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.updatejoocnt.asp" --><%
	Response.end

	Case CMD_LASTIN2
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.lastin2.asp" --><%
	Response.end
	Case CMD_LASTOUT2
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.lastout2.asp" --><%
	Response.end


	Case CMD_LASTIN
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.lastin.asp" --><%
	Response.end
	Case CMD_LASTOUT
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.lastout.asp" --><%
	Response.end


	Case CMD_CHKPLAYER '중복체크
		%><!-- #include virtual = "/pub/api/tennisadmin/api.chkPlayer.asp" --><%
	Response.end

	Case CMD_SETPLAYER '선수생성
		%><!-- #include virtual = "/pub/api/tennisadmin/api.setPlayer.asp" --><%
	Response.end

	Case CMD_CHANGEPLAYER '선수교체
		%><!-- #include virtual = "/pub/api/tennisadmin/api.changePlayer.asp" --><%
	Response.end

	Case CMD_DELTEAM '선수삭제
		%><!-- #include virtual = "/pub/api/tennisadmin/api.delTeam.asp" --><%
	Response.end


	Case CMD_SETTEAM '신규팀 등록
		%><!-- #include virtual = "/pub/api/tennisadmin/api.setTeam.asp" --><%
	Response.end

	Case CMD_SETLAKET '라켓 등록
		%><!-- #include virtual = "/pub/api/tennisadmin/api.setRacket.asp" --><%
	Response.end



	Case CMD_ATTSTATE
		%><!-- #include virtual = "/pub/api/tennisadmin/gameplayer/api.attState.asp" --><%
	Response.end


	Case CMD_SETCOURT_Try
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setCourt_try.asp" --><%
	Response.End

	Case CMD_REFRESHGAMECOURT
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.RefreshGameCourt.asp" --><%
	Response.End

	Case CMD_CourtBoxReLoad
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.gameCourt_re.asp" --><%
	Response.end

	Case CMD_REFRESHLEAGUEJOO
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.RefreshLeagueJoo.asp" --><%
	Response.end

	Case CMD_SETTOURN
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.SetTourn.asp" --><%
	Response.End

	Case CMD_INSERTGROUPGAMEGB
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.insertGroupGameGb.asp" --><%
	Response.End

	Case CMD_JOODIVISION
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.SetJooDivision.asp" --><%
	Response.End

	Case CMD_JOOAREA
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.SetJooArea.asp" --><%
	Response.End

	Case CMD_INSERTLEVELGB
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.insertLevelGb.asp" --><%
	Response.End

		Case CMD_UPDATEMEMBER
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.LeagueUpdateMemeber.asp" --><%
	Response.End

	Case CMD_MAKETEMPPLAYER
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.makeTempPlayer.asp" --><%
	Response.End

	Case CMD_SETJOO
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setJoo.asp" --><%
	Response.End
	Case CMD_INPUTREGION
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.InputRegion.asp" --><%
	Response.End

	Case CMD_SETJOORULE
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.SetJooRule.asp" --><%
	Response.End

	Case CMD_SETTOURNJOO
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setTournJoo.asp" --><%
	Response.End

	Case CMD_SETTOURNWINNER '승자결정
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.tournSetWinner.asp" --><%
	Response.End
	Case CMD_GAMECANCEL '승자취소
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.gameCancel.asp" --><%
	Response.End


	CASE CMD_SETLEAGUERANKING
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setRanking.asp" --><%
	Response.End

	CASE CMD_INPUTLEVEL
	%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.InputLevel.asp" --><%
	Response.End

	Case CMD_SETRANKING
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setRanking.asp" --><%
	Response.End
	Case CMD_SETWINNER
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setWinner.asp" --><%
	Response.End
	Case CMD_SETCOURT
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.setCourt.asp" --><%
	Response.End

	Case CMD_LEAGUE, CMD_LEAGUEPRE
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.league.asp" --><%
	Response.End

	Case CMD_LEAGUEJOO
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.leagueJoo.asp" --><%
	Response.End
	Case CMD_TOURN
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.tourn.asp" --><%
	Response.End

	Case CMD_TOURNLASTROUND
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.tournLastRound.asp" --><%
	Response.End


	case CMD_GAMEADDITIONFLAG
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.gameadditionflag.asp" --><%
	Response.End

	case CMD_CHANGESELECTAREA
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.leagueChangeSelectionArea.asp" --><%
	Response.End

	Case CMD_TOURNCHANGESELECTAREA
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.torunChangeSelectionArea.asp" --><%
	Response.End

	case CMD_FILLINGEMPTYENTRY
		%><!-- #include virtual = "/pub/api/tennisadmin/gametable/api.fillingEmptyEntry.asp" --><%
	Response.End



	Case CMD_GAMEGRADEPERSONAPPEND
		%><!-- #include virtual = "/pub/api/tennisadmin/api.contestmorelevel.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameinputlevel.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameinputleveledit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameinputleveleditok.asp" --><%
	Response.end

	Case CMD_FIND1
		%><!-- #include virtual = "/pub/api/tennisadmin/api.find1.asp" --><%
	Response.end
	Case CMD_FIND2
		%><!-- #include virtual = "/pub/api/tennisadmin/api.find2.asp" --><%
	Response.end

	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gameinputleveldel.asp" --><%
	Response.end


	Case CMD_SEEDEDIT
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gametryoutSeedEdit.asp" --><%
	Response.end

	Case CMD_RNDNOEDIT
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gametryoutRndNo.asp" --><%
	Response.end

	Case CMD_RPOINTEDIT
		%><!-- #include virtual = "/pub/api/tennisadmin/api.gametryoutRPointEdit.asp" --><%
	Response.end




	End Select
%>
