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

''######################################
'헤더가 두개 잘못 링크됨 
'?????? rading riding 두개가 들어가졌다 나중에 고치자 %%%%
%>
<!-- #include virtual = "/pub/cfg/cfg.ridingAdmin.asp" -->

<!-- #include virtual = "/pub/class/db_helper.asp" -->

<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn_riding.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->


<!-- #include virtual="/pub/class/JSON_2.0.4.asp" -->
<!-- #include virtual="/pub/class/JSON_UTIL_0.1.1.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<%'<!-- #include virtual = "/pub/fn/fn.query.asp" -->%>


<%'request 후 쿠키 값 정의 순서대로 include%>
<!-- #include virtual = "/pub/inc/requestRiding.asp" -->

<!-- #include virtual = "/pub/cookies/cookies.pub.asp" --><%'암호화 모듈 아래쪽에%>




