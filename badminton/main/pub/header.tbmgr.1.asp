<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"
%>
<!-- #include virtual = "/pub/cfg/cfg.tbmgr.asp" -->
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" --><%'암호화%>

<!-- #include virtual = "/pub/fnex/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fnex/fn.string.asp" -->
<!-- #include virtual = "/pub/fnex/fn.util.asp" -->
<!-- #include virtual = "/pub/fnex/fn.tbmgr.asp" -->
<!-- #include virtual = "/pub/fnex/fn.mypage.asp" -->

<!-- #include virtual="/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fnex/fn.query.asp" -->
<%'로그#######################################%>

<%'request 후 쿠키 값 정의 순서대로 include%>

<%'<!-- #include virtual = "/pub/inc/request.asp" -->%>
<%'<!-- #include virtual = "/pub/cookies/cookies.mall.asp" -->%>
<%'<!-- #include virtual = "/pub/inc/checkLogin.asp" -->%>

<%
'남은작업
'pc에서 열경우 스포츠 다이어리 홈으로 보낼것 ...
%>
