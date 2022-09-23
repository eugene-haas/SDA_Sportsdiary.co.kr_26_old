<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<%
'참조 2: http://widecloud.tistory.com/143

	If request("test") = "t" Then
		REQ = "{""CMD"":6,""TABLENAME"":""sd_test""}"
	else
		REQ = request("REQ")
	End if
	'REQ ="{""CMD"":1}"

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
	CMD_A1 = 1 '경기기록 삭제
	CMD_A2 = 2 '참가신청 삭제
	CMD_A3 = 3 '대진표 참가자 삭제
	CMD_A4 = 4 '참여부 삭제
	CMD_A5 = 5 '예선 참가자와 총 포인트 삭제
	CMD_A6 = 6 '테이블 복사
	CMD_A7 = 7 '테이블 삭제

	'Select Case CDbl(CMD)
	'Case CMD_LOGIN
		%><!-- #include virtual = "/pub/api/RookieTennisAdmin/gametable/api.tennisDbCentertest.asp" --><%
		'Response.end	
	'End select
%>