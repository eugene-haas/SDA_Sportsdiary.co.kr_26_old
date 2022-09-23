<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	If Left(PAGENAME, 3) = "req" Then 'ajax 콜파일만 적용되도록
		Response.Expires = -1
		Response.Expiresabsolute = Now() - 1
		Response.AddHeader "pragma","no-cache"
		Response.AddHeader "cache-control","private"
		Response.CacheControl = "no-cache"
	End if
%>
<!-- #include virtual = "/pub/cfg/cfg.bike.asp" -->
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn_bike.asp" -->


<!-- #include virtual = "/pub/class/aes.asp" -->
<!-- #include virtual = "/pub/class/sha256.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->
<!-- #include virtual = "/pub/fn/fn.dminclude.asp" -->

<!-- #include virtual = "/pub/cookies/bike.cookies.asp" --><%'암호화 모듈 아래쪽에%>
<!-- #include virtual = "/pub/class/json2.asp" -->

<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
