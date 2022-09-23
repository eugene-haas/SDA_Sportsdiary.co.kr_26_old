<!-- #include virtual = "/pub/header.tennis.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
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
'참조 2: http://widecloud.tistory.com/143

	If request("test") = "t" Then
		REQ  = "{""CMD"":20003,""IDX"":""162"",""S1"":""tn001001"",""S2"":""201"",""S3"":""20101023"",""TT"":""1"",""SIDX"":0,""Round_s"":"""",""EnterType"":""K""}"
	Else
		REQ = request("REQ")
	End if

	If REQ = "" Then
		Response.End
	End if


	If InStr(REQ, "CMD") >0 then
	Set oJSONoutput = JSON.Parse(REQ)
		CMD = oJSONoutput.CMD
	Else
		Set oJSONoutput = JSON.Parse("{}")
		CMD = REQ
	End if

'	If request("t") = "t" Then
'		Response.write CMD
'		Response.end
'	End if


	'define CMD
	CMD_LOGIN = 1
	CMD_LOGOUT = 2
	CMD_LOGINCHK = 3

	CMD_CAL = 4
	CMD_PCODE = 5
	CMD_TEAMCODE = 6

	CMD_FINDSCORE = 7	'스코어 입력 창으로 이동 없을경우 인서트 
	CMD_RECORDER = 8	'기록관입력
	CMD_SAVECOURT = 9	'코트 정보저장
	CMD_MODECHANGE = 10	'코트정보 수정모드
	CMD_SETPOINT = 11 '포인트 입력
	CMD_SETDPOINT = 26


	CMD_TEST = 12 '테스트 입력데이터 삭제
	CMD_GAMEEND = 13	'한게임 종료
	'CMD_GAMEPOINT = 14 '게임포인트 로컬스토리지 생성
	SETSERVE = 15 '서브 설정
	CMD_PRE = 16	'이전단계로
	CMD_ENTERSCOREEND = 17	'경기종료 버튼클릭
	CMD_TEAMCODERALLY  = 18  '대회별 생성된 팀코드
	CMD_DELETESCORE = 19	'마지막 기록삭제
	CMD_FINDMAINSCORE = 20	'스코어 입력 본선시작
	CMD_ENTERSCORESTOP = 21 '경기중단
	CMD_ENTERSCORERESET = 22	'경기초기화

	CMD_CAL_Popup = 23 ' 대회 일정 경기 켈린더 상세 조회용 
	CMD_CAL_Popup_detail = 24 ' 대회 일정 경기 켈린더 상세 조회용 
	CMD_CAL_app = 25

	CMD_RESET = 100	'리셋 (1세트 노플레이 수정시)    


	CMD_GAMESEARCH = 20000  '경기스코어 입력
	CMD_SETSCORE = 20001
	CMD_STATUSSEARCH = 20002 '현황보기 조회

    ''app 대진표 조회
    CMD_GAMESEARCH_app= 20003  '경기 대진표 조회(app)
	CMD_ScoreBoard = 20004   '경기스코어 결과 조회(app)
    CMD_ScoreDetailBoard = 20005   '경기스코어 결과 상세조회(app)

    
	CMD_ScoreBoardLive = 20006   'live 경기스코어 조회(app)
	CMD_ScoreDetailBoardLive = 20007   'live 경기스코어 결과 상세조회(app)
    
    ''app 대진표 조회
    ''homepage 대진표 조회
	CMD_GAMESEARCH_Home = 20031   '경기 대진표 조회(home)
	CMD_GAMESEARCH_Result_Home = 20032   '경기 결과 조회(home)
    ''homepage 대진표 조회

	CMD_GAMEGRADEPERSON = 30000 'CMD_GAMEGRADEPERSON
	CMD_GAMEGRADEPERSONAPPEND = 30001
	CMD_GAMEGRADEGROUP = 30002
	CMD_GAMEGRADEGROUPAPPEND = 30003
	CMD_RANKINGRATE = 30004
	CMD_RANKINGMEDAL = 30005
	CMD_RANKINGMEDALTOTAL = 30006
	CMD_ENTERSCORE = 30007 '스코어 입력 화면
	CMD_INPUTPOINT = 30008	'포인트 입력화면 진입
	CMD_SCORELIST = 30009		'포인트 기록화면 불러오기
	CMD_CHANGESCORE = 30010	'경기승패 변경

	CMD_COURTLIST = 30011											'코트 목록 불러오기 (지정상태 포함)
	CMD_COURTNO = 30012											'코트 번호 지정하고 목록 다시 호출

	Select Case CDbl(CMD)
	Case CMD_LOGIN
		%><!-- #include virtual = "/pub/api/tennis/api.login.asp" --><%
		Response.end	
	Case CMD_LOGOUT

		session.Abandon
		
		for each Item in request.cookies
			if item = "saveinfo" or IsNumeric(item) = true then 'popup info / login info 
				'pass
			else
				Response.cookies(item).expires	= date - 1365
				Response.cookies(item).domain	= CHKDOMAIN	
			end if
		Next
		jstr = "{""result"":""0"",""chk"":""1""}"
		Response.write jstr
		Response.end	
	Case CMD_LOGINCHK
		%><!-- #include virtual = "/pub/api/tennis/api.loginchk.asp" --><%
		Response.end	
	Case CMD_CAL 
		%><!-- #include virtual = "/pub/api/tennis/api.gametitlecalendar.asp" --><%
		Response.End

	Case  CMD_CAL_app
		%><!-- #include virtual = "/pub/api/tennis/api.gametitlecalendarAPP.asp" --><%			'앱켈린더
		Response.end
		
	Case CMD_CAL_Popup
		%><!-- #include virtual = "/pub/api/tennis/api.gametitlecalendarPopup.asp" --><%		'켈린더팝업
		Response.end
	Case CMD_CAL_Popup_detail
		%><!-- #include virtual = "/pub/api/tennis/api.gametitlecalendarPopup_sub.asp" --><%	'켈린더 상세내용
		Response.end			
        
	Case CMD_PCODE
		%><!-- #include virtual = "/pub/api/tennis/api.pcode.asp" --><%
		Response.end	
	Case CMD_TEAMCODE
		%><!-- #include virtual = "/pub/api/tennis/api.teamcode.asp" --><%
		Response.end	
	Case CMD_TEAMCODERALLY
		%><!-- #include virtual = "/pub/api/tennis/api.teamcoderally.asp" --><%		'대진표 부명 가져오기
		Response.end	
	Case CMD_DELETESCORE
		%><!-- #include virtual = "/pub/api/tennis/api.deletescore.asp" --><%
		Response.end	
	
	Case CMD_FINDSCORE
		%><!-- #include virtual = "/pub/api/tennis/api.findscore.asp" --><%
		Response.end	

	Case CMD_RECORDER
		%><!-- #include virtual = "/pub/api/tennis/api.recorder.asp" --><%
		Response.end	

	Case CMD_SAVECOURT
		%><!-- #include virtual = "/pub/api/tennis/api.savecourt.asp" --><%
		Response.end	

	Case CMD_MODECHANGE
		%><!-- #include virtual = "/pub/api/tennis/api.modechangecourt.asp" --><%
		Response.end	

	Case CMD_PRE
		%><!-- #include virtual = "/pub/api/tennis/api.preLoad.asp" --><%
		Response.end	


	Case CMD_SETPOINT
		%><!-- #include virtual = "/pub/api/tennis/api.setpoint.asp" --><%
		Response.end	

	Case CMD_SETDPOINT '직업 포인트 주기
		%><!-- #include virtual = "/pub/api/tennis/api.setdpoint.asp" --><%
		Response.end	


	Case CMD_TEST
		%><!-- #include virtual = "/pub/api/tennis/api.test.asp" --><%
		Response.end	
	Case CMD_GAMEEND
		%><!-- #include virtual = "/pub/api/tennis/api.gameend.asp" --><%
		Response.End
	Case SETSERVE
		%><!-- #include virtual = "/pub/api/tennis/api.setserve.asp" --><%
		Response.End
	Case CMD_ENTERSCOREEND

		gubun = oJSONoutput.GN '예선 0 본선 1
		Select Case gubun
		Case "0"
		%><!-- #include virtual = "/pub/api/tennis/api.enterscoreend.asp" --><%
		Case "1"
		%><!-- #include virtual = "/pub/api/tennis/api.enterScoreEndTourn.asp" --><%
		End Select
		
		Response.End
	Case CMD_ENTERSCORESTOP
		%><!-- #include virtual = "/pub/api/tennis/api.enterscorestop.asp" --><%
		Response.End
	Case CMD_ENTERSCORERESET
		%><!-- #include virtual = "/pub/api/tennis/api.enterscoreReset.asp" --><%
		Response.End

	Case CMD_RESET
		%><!-- #include virtual = "/pub/api/tennis/api.Reset.asp" --><%
		Response.End



	Case CMD_FINDMAINSCORE
		%><!-- #include virtual = "/pub/api/tennis/api.findmainscore.asp" --><%
		Response.end	

    Case CMD_GAMESEARCH_Result_Home
		%><!-- #include virtual = "/pub/api/tennis/api.gamesearch.asp" --><%
		Response.end	
    Case CMD_GAMESEARCH_Home
		%><!-- #include virtual = "/pub/api/tennis/api.gamesearch.asp" --><%
		Response.end	

    Case CMD_GAMESEARCH_app
		%><!-- #include virtual = "/pub/api/tennis/api.gamesearch.asp" --><% '경기대진표조회 앱
		Response.end	

	Case CMD_GAMESEARCH
		%><!-- #include virtual = "/pub/api/tennis/api.gamesearch.asp" --><%
		Response.end	

	Case CMD_SETSCORE
		%><!-- #include virtual = "/pub/api/tennis/api.setscore.asp" --><%
		Response.end	

	Case CMD_ScoreBoard
		%><!-- #include virtual = "/pub/api/tennis/api.setscore_app.asp" --><% '앱 스코어
		Response.end
        		
	Case CMD_ScoreDetailBoard
		%><!-- #include virtual = "/pub/api/tennis/api.setscore_app.asp" --><% '라이브상세
		Response.end	
        
	Case CMD_ScoreBoardLive
		%><!-- #include virtual = "/pub/api/tennis/api.setscoreLive_app.asp" --><% '스코어 상새 앱 
		Response.end	



	Case CMD_STATUSSEARCH
		%><!-- #include virtual = "/pub/api/tennis/api.statussearch.asp" --><%
		Response.end	


	Case CMD_RANKINGRATE
		%><!-- #include virtual = "/pub/api/tennis/api.rankingrate.asp" --><%
		Response.end		
	Case CMD_RANKINGMEDAL
		%><!-- #include virtual = "/pub/api/tennis/api.rankingmedal.asp" --><%
		Response.end		
	Case CMD_RANKINGMEDALTOTAL
		%><!-- #include virtual = "/pub/api/tennis/api.rankingmedaltotal.asp" --><%
		Response.end		

	Case CMD_ENTERSCORE
		%><!-- #include virtual = "/pub/api/tennis/api.enterscore.asp" --><%
		Response.end		


	Case CMD_ScoreDetailBoardLive
		%><!-- #include virtual = "/pub/api/tennis/api.scorelist_app.asp" --><% '포인트 기록화면 불러오기
		Response.end	

	Case CMD_SCORELIST
		%><!-- #include virtual = "/pub/api/tennis/api.scorelist.asp" --><% '포인트 기록화면 불러오기
		Response.end		

	Case CMD_CHANGESCORE
		%><!-- #include virtual = "/pub/api/tennis/api.changescorelist.asp" --><% '포인트 기록화면 불러오기(수정해서)
		Response.end		


	Case CMD_INPUTPOINT
		%><!-- #include virtual = "/pub/api/tennis/api.inputpoint.asp" --><%
		Response.end	

	Case CMD_COURTLIST
		%><!-- #include virtual = "/pub/api/tennis/api.getCourtList.asp" --><%
		Response.end	
	Case CMD_COURTNO
		%><!-- #include virtual = "/pub/api/tennis/api.setCourtNo.asp" --><%
		Response.end	
	End select
%>