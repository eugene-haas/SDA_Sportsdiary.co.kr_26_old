<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	Response.Expires = -1
	Response.Expiresabsolute = Now() - 1
	Response.AddHeader "pragma","no-cache"
	Response.AddHeader "cache-control","private"
	Response.CacheControl = "no-cache"
%>

<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->



<!-- #include virtual = "/pub/class/aes.asp" -->
<!-- #include virtual = "/pub/class/sha256.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->


<!-- #include virtual = "/pub/class/json2.asp" -->

<!-- #include file = "fn.bike.asp" -->
<!-- #include file = "common_function.asp" -->
<!-- #include file = "cfg.bike.asp" -->
