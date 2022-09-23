<!-- #include virtual = "/pub/header.RidingAdmin.asp" -->
<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){2019-01-10
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
    'REQ = "{""PARR"":[""2019"",""201""],""CMD"":30005,""TitleIDX"":136,""TITLE"":""gggggg""}"
	REQ = "{""CMD"":30001,""TIDX"":41,""TITLE"":""테스트대회"",""PARR"":[""2019"",""201"",""20101"",""20101002"",""S-1"",""결승"",""2019/06/28"",""오전 10:53"",""2019/06/28"",""오전 10:53"",""2019/06/28"",""오전 10:53"",""Y"",""0"","""",""0"","""",""0"","""",""0"","""",""0"","""",""0""]}"

	ElseIf request("test") = "z" Then
		REQ ="{""CMD"":41000,""TIDX"":40,""TITLE"":""제48회 전국소년체육대회"",""PTYPE"":1,""GTYPE"":1}"

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
	CMD_RNDNOEDIT = 30017


	CMD_REFRESHGAMECOURT = 30020
	CMD_INPUTLEVEL = 30021
	CMD_INSERTGROUPGAMEGB = 30022
    CMD_INSERTLEVELGB = 30023

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

	CMD_SETGAMENO = 50001 '게임번호변경
	CMD_SETGAMENOSTR = 50002 '게임번호 출력용setGameNoStr

	CMD_LIMIT = 41000 '참가신청제한
	CMD_LIMITOK = 41001 '저장
	CMD_PHS = 900 '인상기승마설정
	CMD_HPS = 901 '기승마 인원설정

	CMD_GETLIMIT = 902 
	CMD_SETLIMIT = 903 '참가자격제한 설정, 취소


	Select Case CDbl(CMD)

	Case CMD_GETLIMIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.getlimit.asp" --><%
	Response.End

	Case CMD_SETLIMIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setlimit.asp" --><%
	Response.End

	Case CMD_PHS
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setPHS.asp" --><%
	Response.End

	Case CMD_HPS
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setHPS.asp" --><%
	Response.End

	Case CMD_LIMIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.limit.asp" --><%
	Response.End

	
	Case CMD_LIMITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.limitOK.asp" --><%
	Response.End

	case CMD_SETGAMENOSTR '게임번호변경 출력용
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgamenostr.asp" --><%
	Response.End

	case CMD_SETGAMENO '게임번호변경
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setgameno.asp" --><%
	Response.End
















	Case CMD_CHKPLAYER '중복체크
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.chkPlayer.asp" --><%
	Response.end

	Case CMD_SETPLAYER '선수생성
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setPlayer.asp" --><%
	Response.end

	Case CMD_CHANGEPLAYER '선수교체
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.changePlayer.asp" --><%
	Response.end

	Case CMD_DELTEAM '선수삭제
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.delTeam.asp" --><%
	Response.end


	Case CMD_SETTEAM '신규팀 등록
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setTeam.asp" --><%
	Response.end

	Case CMD_SETLAKET '라켓 등록
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.setRacket.asp" --><%
	Response.end




	Case CMD_GAMEGRADEPERSONAPPEND
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.contestmorelevel.asp" --><%
	Response.End
	Case CMD_GAMEINPUT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinputlevel.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinputleveledit.asp" --><%
	Response.end
	Case CMD_GAMEINPUTEDITOK
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinputleveleditok.asp" --><%
	Response.end

	Case CMD_FIND1
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.find1.asp" --><%
	Response.end
	Case CMD_FIND2
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.find2.asp" --><%
	Response.end

	Case CMD_GAMEINPUTDEL
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gameinputleveldel.asp" --><%
	Response.end


	Case CMD_SEEDEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gametryoutSeedEdit.asp" --><%
	Response.end

	Case CMD_RNDNOEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gametryoutRndNo.asp" --><%
	Response.end

	Case CMD_RPOINTEDIT
		%><!-- #include virtual = "/pub/api/RidingAdmin/api.gametryoutRPointEdit.asp" --><%
	Response.end




	End Select
%>
