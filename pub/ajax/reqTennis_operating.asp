<!-- #include virtual = "/pub/header.tennis.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<%
Dim intTotalCnt, intTotalPage '총갯수, 총페이지수
'############################################


'참조 2: http://widecloud.tistory.com/143

	REQ = request("REQ")
	'REQ ="{""CMD"":30005,""S1"":""2017"",""S2"":""tn001001"",""S3"":""201"",""S4"":""0"",""PN"":1,""T1"":""개인전"",""T2"":""복식"",""T3"":""전체""}"

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
	CMD_TEST = 12 '테스트 입력데이터 삭제
	CMD_GAMEEND = 13	'한게임 종료
	'CMD_GAMEPOINT = 14 '게임포인트 로컬스토리지 생성
	SETSERVE = 15 '서브 설정
	CMD_PRE = 16	'이전단계로
	CMD_ENTERSCOREEND = 17	'경기종료 버튼클릭


	CMD_GAMESEARCH = 20000  '경기스코어 입력
	CMD_SETSCORE = 20001
	CMD_STATUSSEARCH = 20002 '현황보기 조회

	CMD_GAMEGRADEPERSON = 30000 'CMD_GAMEGRADEPERSON
	CMD_GAMEGRADEPERSONAPPEND = 30001
	CMD_GAMEGRADEGROUP = 30002
	CMD_GAMEGRADEGROUPAPPEND = 30003
	CMD_RANKINGRATE = 30004
	CMD_RANKINGRATEAPPEND = 31000	'경기승률 more

	CMD_RANKINGMEDAL = 30005
	CMD_RANKINGMEDALAPPEND =  31001	'메달순위 more

	CMD_RANKINGMEDALTOTAL = 30006
	CMD_CMD_RANKINGMEDALTOTALAPPEND =  31002		'메달순위 more

	CMD_ENTERSCORE = 30007 '스코어 입력 화면
	CMD_INPUTPOINT = 30008	'포인트 입력화면 진입
	CMD_SCORELIST = 30009		'포인트 기록화면 불러오기






	Select Case CDbl(CMD)
	Case CMD_LOGIN
		%><!-- #include virtual = "/pub/api/tennis/api.login.asp" --><%
		Response.end	
	Case CMD_LOGOUT
		session.Abandon
		jstr = "{""result"":""0"",""chk"":""1""}"
		Response.write jstr
		Response.end	
	Case CMD_LOGINCHK
		%><!-- #include virtual = "/pub/api/tennis/api.loginchk.asp" --><%
		Response.end	
	Case CMD_CAL
		%><!-- #include virtual = "/pub/api/tennis/api.gametitlecalendar.asp" --><%
		Response.end	
	Case CMD_PCODE
		%><!-- #include virtual = "/pub/api/tennis/api.pcode.asp" --><%
		Response.end	
	Case CMD_TEAMCODE
		%><!-- #include virtual = "/pub/api/tennis/api.teamcode.asp" --><%
		Response.end	
	Case CMD_FINDSCORE
		%><!-- #include virtual = "/pub/api/tennis/api.findscore.asp" --><%
		Response.end	

	Case CMD_RECORDER
		%><!-- #include virtual = "/pub/api/tennis/api.recorder.asp" --><%
		Response.end	


	Case CMD_PRE
		%><!-- #include virtual = "/pub/api/tennis/api.preLoad.asp" --><%
		Response.end	

	Case CMD_GAMESEARCH
		%><!-- #include virtual = "/pub/api/tennis/api.gamesearch.asp" --><%
		Response.end	
	Case CMD_SETSCORE
		%><!-- #include virtual = "/pub/api/tennis/api.setscore.asp" --><%
		Response.end	

	Case CMD_STATUSSEARCH
		%><!-- #include virtual = "/pub/api/tennis/api.statussearch.asp" --><%
		Response.end	

	Case CMD_GAMEGRADEPERSON,CMD_GAMEGRADEPERSONAPPEND
		%><!-- #include virtual = "/pub/api/tennis/api.gradeperson.asp" --><%
		Response.end	
	Case CMD_GAMEGRADEGROUP,CMD_GAMEGRADEGROUPAPPEND
		%><!-- #include virtual = "/pub/api/tennis/api.gradegroup.asp" --><%
		Response.end	
	Case CMD_RANKINGRATE,CMD_RANKINGRATEAPPEND
		%><!-- #include virtual = "/pub/api/tennis/api.rankingrate.asp" --><%
		Response.end		
	Case CMD_RANKINGMEDAL,CMD_RANKINGMEDALAPPEND
		%><!-- #include virtual = "/pub/api/tennis/api.rankingmedal.asp" --><%
		Response.end		
	Case CMD_RANKINGMEDALTOTAL,CMD_CMD_RANKINGMEDALTOTALAPPEND
		%><!-- #include virtual = "/pub/api/tennis/api.rankingmedaltotal.asp" --><%
		Response.end		
	End select
%>