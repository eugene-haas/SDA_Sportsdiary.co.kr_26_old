<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<!-- #include virtual = "/pub/charset.asp" -->
<%
	pagename = LCase(Mid(Request.ServerVariables("URL"), InStrRev(Request.ServerVariables("URL"), "/") + 1))
	If Left(pagename, 3) = "req" Then 'ajax 콜파일만 적용되도록
		Response.Expires = -1
		Response.Expiresabsolute = Now() - 1
		Response.AddHeader "pragma","no-cache"
		Response.AddHeader "cache-control","private"
		Response.CacheControl = "no-cache"
	End if
%>
<!-- #include virtual = "/pub/cfg/cfg.tennisAdmin.asp" -->

<!-- #include virtual = "/pub/class/db_helper.asp" -->

<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->
<!-- #include virtual = "/pub/fn/fn_tennis.asp" -->

<!-- #include virtual = "/pub/class/aes.asp" -->
<!-- #include virtual = "/pub/class/sha256.asp" -->
<!-- #include virtual = "/pub/fn/fn.cipher.asp" -->



<%If sitecode = "KTN01" Then '코트 진행자 모바일인경우%>
<!-- #include virtual="/pub/class/json2.asp" -->
<!-- #include virtual = "/pub/inc/request.asp" -->
<!-- #include virtual = "/pub/cookies/cookies.pub.asp" -->


<%
	ck_id = Cookies_aID
	ck_gubun = Cookies_AUTH

	Select Case ck_gubun
	Case "A","B"
	ADGRADE = 700
	Case "C"
	ADGRADE = 600
	Case "D","E"
	ADGRADE = 500 '코트 관리자...이걸로 테스트 할수 있게
	End Select

	'ADGRADE = 500 '코트 관리자...이걸로 테스트 할수 있게
%>


<%else%>
<!-- #include virtual = "/pub/cookies.asp" --><%'암호화 모듈 아래쪽에%>
<%End if%>
