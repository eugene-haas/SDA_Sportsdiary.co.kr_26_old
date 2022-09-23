<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	PAGENAME = LCase(Mid(Request.ServerVariables("URL"), InStrRev(Request.ServerVariables("URL"), "/") + 1))

	If Left(PAGENAME, 3) = "req" Then 'ajax 콜파일만 적용되도록
		Response.Expires = -1
		Response.Expiresabsolute = Now() - 1
		Response.AddHeader "pragma","no-cache"
		Response.AddHeader "cache-control","private"
		Response.CacheControl = "no-cache"
	End if
%>
<!-- #include virtual = "/pub/cfg/cfg.RookieTennis.asp" -->

<!-- #include virtual = "/pub/class/db_helper.asp" -->

<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn_tennis.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->


<!-- #include virtual="/pub/class/json2.asp" -->
<!-- #include virtual = "/pub/inc/requestRookieTennis.asp" -->
<!-- #include virtual = "/pub/cookies/cookies.pub.asp" --><%'암호화 모듈 아래쪽에%>
