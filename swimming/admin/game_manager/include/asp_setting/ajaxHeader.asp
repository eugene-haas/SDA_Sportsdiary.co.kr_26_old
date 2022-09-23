<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->
<% @CODEPAGE="65001" language="VBScript" %>
<%
      Response.CharSet="utf-8"
      Session.codepage="65001"
      Response.codepage="65001"
      Response.ContentType="text/html;charset=utf-8"

	'## 사이트 URL정보
	URL_METHOD      = Request.ServerVariables("HTTP_METHOD")
	SVR_NAME = Request.ServerVariables("SERVER_NAME")
	URL_PATH        = Request.ServerVariables("URL")
	URL_QUERYSTRING = Request.ServerVariables("QUERY_STRING")
	URL_REFERER     = Request.ServerVariables("HTTP_REFERER")

	URL_PORT        = Request.ServerVariables("SERVER_PORT")
	If URL_PORT=80 then
		URL_HOST        = Request.ServerVariables("HTTP_HOST")
	Else
		URL_HOST        = Request.ServerVariables("HTTP_HOST")&":"&URL_PORT
	End If


	If URL_QUERYSTRING = "" Then
		NOW_URL = URL_PATH
	Else
		NOW_URL = URL_PATH & "?" & Request.ServerVariables("QUERY_STRING")
	End If

	'## 접속 사용자 아이피
	USER_IP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	If Len(USER_IP) = 0 Then USER_IP = Request.ServerVariables("REMOTE_ADDR")

	'##DB 설정#################################################################################################
	DB_IP	= "49.247.9.88\SQLExpress,1433"
	DB_NAME = "SD_Pub"
	DB_ID	= "splog_ekS1dlP9djT0fl" 
	DB_PW	= "slogp_#f(6+!2!j+g04*alN9kO3"

	'수영
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=KS_Swimming;Data Source=" & DB_IP & ";"
	
	'공통 (관리자 로그인, 메뉴관리등)
	B_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"

	'로그
	LOG_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=LOG_INFO;Data Source=" & DB_IP & ";"
	'##DB 설정#################################################################################################

	'## 접속 사용자 세션아이디
	'USER_SESSION = session.sessionid

	'## 디버깅 설정
	IS_DEV = True
	Const DEBUG_IP = "112.187.195.132"

	PAGENAME = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))	
	CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)

	COOKIENM = Split( CHKDOMAIN , ".")(0) '생성되는 쿠키명
	COOKIENM =  "SEF_"& COOKIENM

	'사이트코드 (관리자생성, 메뉴관리)
	SITECODE = "SWN02"
%>
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/fn/fn.util.asp" -->




<%
If PAGENAME <> "reqswim.asp" Then '중복저장제거
'	logreqp = request("p")
'	logreq = request("REQ")
'	if logreq = "" then
'		if logreqp = "" then
'			logreq = "empty"
'		else
'			logreq = logreqp
'		end if
'	end if
'	if Cookies_aID = "" then
'		Cookies_aID = "logout"
'	end if
	'Call TraceSysInfo(logreq, 100, Cookies_aID )
End if
%>