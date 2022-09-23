<%
	'## 사이트 URL정보
	URL_METHOD      = Request.ServerVariables("HTTP_METHOD")

	If Request.ServerVariables("HTTPS")="off" Then
		URL_HTTP        = "http://"
	Else
	URL_HTTP        =  "https://"
	End if

	URL_PORT        = Request.ServerVariables("SERVER_PORT")
	If URL_PORT=80 then
		URL_HOST        = Request.ServerVariables("HTTP_HOST")
	Else
		URL_HOST        = Request.ServerVariables("HTTP_HOST")&":"&URL_PORT
	End If

	SVR_NAME		 = Request.ServerVariables("SERVER_NAME")
	URL_PATH        = Request.ServerVariables("URL")
	URL_QUERYSTRING = Request.ServerVariables("QUERY_STRING")
	URL_REFERER     = Request.ServerVariables("HTTP_REFERER")

	M_AGENT = LCase(Request.ServerVariables("HTTP_USER_AGENT")) '아이폰여부체크

	If URL_QUERYSTRING = "" Then
		NOW_URL = URL_PATH
	Else
		NOW_URL = URL_PATH & "?" & Request.ServerVariables("QUERY_STRING")
	End If

	'## 접속 사용자 아이피
	USER_IP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	If Len(USER_IP) = 0 Then USER_IP = Request.ServerVariables("REMOTE_ADDR")

	'##DB 설정
	DB_IP	= "49.247.9.88\SQLExpress,1433"
	DB_NAME = "KS_Evaluation"
	DB_ID	= "eval_rk3%rh4wl*ak" 
	DB_PW	= "eval_rr$A8%^kv94~*kn7Yh&YB"

	'공통 (관리자 계정)
	B_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"

	'혁신평가
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"


	'## 접속 사용자 세션아이디
	USER_SESSION = session.sessionid

	'## 디버깅 설정
	IS_DEV = False
	DEBUG_MODE = IS_DEV
	Const DEBUG_IP = "112.187.195.132"
	DEBUG_CHECK = False


	'년도 공통 마지막 년도
	CONST_START_YEAR = Year(Date)
	CONST_LAST_YEAR = Year(Date) - 85


	IURL = "/images/"

	CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)
	'COOKIENM = Split(CHKDOMAIN,".")(0) '생성되는 쿠키명

	PAGENAME = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))
	C_PAGENAME = PAGENAME

	CONST_PATH = "admin"

	'===================================================================================
	'Function : encode(), decode() 암호화
	'Description : 암호화
	'===================================================================================
	R_e_f = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"



	SITECODE = "EVAL1" '디비자리수 5
	COOKIENM = SITECODE  '생성되는 쿠키명

	CONST_HTMLVER = "<!DOCTYPE html>"&vbCrLf&"<html>"
	CONST_BODY = " class=""hold-transition skin-blue sidebar-mini""    id=""sc_body""     " 'style 또는 스크립트 포함
%>
