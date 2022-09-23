<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->


<%
	JsonData = "{""CMD"":400,""LIDX"":11365,""inputId"":""다이빙_1"",""inputPw"":""1234""}"
%>

<!-- #include virtual = "/game_manager/ajax/setReq.asp" -->
<%
'command
	'100 로그인 (inputId, inputPw)

	'200 로그아웃 ('')

	'300 '/game_manager/pages/list.asp  ('')
	'대회 종목 리스트

	'400 종목 상세(대회 진행 선수 목록) (LIDX)

	'500 



Server.Execute ("/game_manager/ajax/api/api.SWIM_" & CMD & ".asp")
%>
