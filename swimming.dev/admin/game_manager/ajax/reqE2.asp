<%'define%>
<!-- #include virtual = "/game_manager/include/asp_setting/ajaxHeader.asp" -->

<%'request%>
<!-- #include virtual = "/game_manager/include/asp_setting/setReq.asp" -->
<%
'command
	'100 로그인
	'200 로그아웃


'1000 이하는 공통

Server.Execute ("/game_manager/ajax/api/api.SWIM_" & CMD & ".asp")
%>
