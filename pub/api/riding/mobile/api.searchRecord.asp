<%
'######################
'검색리스트  http://tennis.sportsdiary.co.kr/tennis/tsm_player/record/record_sd.asp or ajax에서 사용
'######################


	If hasown(oJSONoutput, "YY") = "ok" Then '년도
		YY = oJSONoutput.YY
	End If
	If hasown(oJSONoutput, "GB") = "ok" Then '코드
		GB = oJSONoutput.GB
	End If
	If hasown(oJSONoutput, "F1") = "ok" Then '이름 검색어
		F1 = oJSONoutput.F1
	End If

	Set db = new clsDBHelper
	
	nowyear = YY
	startyy = nowyear
	Endyy = nowyear
	startyy = CDbl(startyy) -4

	If CDbl(startyy) < 2019 Then
		startyy = 2019
	End if

	'원스타 승급자인 경우 gameday 보다 큰 투스타 정보를 원스타에 출력
	'tblPlayer.stateNO 상태 : 0 기본 / 1 박탈 /  원스타승급 100 승급  / 200 투스타 승급 /201( 투스타 승급박탈 )
	'sd_TennisRPoint_log.upgrade 상태 : 0 기본 / 1원스타승급(승급이후 계속 1유지) /  2투스타승급

  chkdateS  = nowyear & "-01-01"
  chkdateE  = CDbl(nowyear) + 1 & "-01-01"
  chkyear = "2019"
  teamgb = GB
%>
<!-- #include virtual = "/pub/query/mobile/q.record.asp" --><%'리스트, ajax 에서 같이 사용%>

<!-- #include virtual = "/pub/html/riding/html.mobile.searchrecordlist.asp" --><%'리스트, ajax 에서 같이 사용%>

<%
	db.Dispose
	Set db = Nothing
%>