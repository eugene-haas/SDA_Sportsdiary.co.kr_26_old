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

	SVR_NAME = Request.ServerVariables("SERVER_NAME")

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
	DB_NAME = "SD_Pub"
	DB_ID	= "splog_ekS1dlP9djT0fl" 
	DB_PW	= "slogp_#f(6+!2!j+g04*alN9kO3"

	'수영
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=KS_Swimming_DEV;Data Source=" & DB_IP & ";"
	
	'테니스(문자사용)
	KATA_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_Tennis;Data Source=" & DB_IP & ";"

	'테니스(결제사용)
	RT_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_RookieTennis;Data Source=" & DB_IP & ";"

	'공통 (관리자 로그인, 메뉴관리등)
	B_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"


	'아이템센터(SMS발송 관련)
	I_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=ITEMCENTER;Data Source=db.itemcenter.co.kr;"

	'통합회원DB
	T_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_Member;Data Source=" & DB_IP & ";"

	'베너DB
	BN_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_AD;Data Source=" & DB_IP & ";"

	'로그
	LOG_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=LOG_INFO;Data Source=" & DB_IP & ";"

	IS_DEV = False

	'## 접속 사용자 세션아이디
	USER_SESSION = session.sessionid

	'## 디버깅 설정
	DEBUG_MODE = IS_DEV
	Const DEBUG_IP = "118.33.86.240"
	DEBUG_CHECK = False

	If DEBUG_MODE  And InStr(DEBUG_IP, USER_IP) > 0 Then
		DEBUG_WIDTH = "99%"
		DEBUG_HEIGHT = "500"
		DEBUG_CHECK = True
	Else
		DEBUG_WIDTH = "0"
		DEBUG_HEIGHT = "0"
	End If

	ACTION_IFRAME = "<iframe name=""action_ifrm"" id=""action_ifrm"" width=""" & DEBUG_WIDTH & """ height=""" & DEBUG_HEIGHT & """ frameborder=""1"" alt=""히든 프레임""></iframe>"

	'년도 공통 마지막 년도
	CONST_START_YEAR = Year(Date)
	CONST_LAST_YEAR = Year(Date) - 85

	CONST_HTMLVER = "<!DOCTYPE html>"&vbCrLf&"<html>"
	CONST_BODY = " class=""hold-transition skin-red sidebar-mini""    id=""sc_body""     " 'style 또는 스크립트 포함

	IURL = "/images/"
	IHOME  = "http://img.sportsdiary.co.kr/img/SD/swim/"

	'PAGENAME = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))	##cfg에서 정의##

	CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)
	COOKIENM = Split(CHKDOMAIN,".")(0) '생성되는 쿠키명


	'사이트코드 (관리자생성, 메뉴관리)
	sitecode = "SWN02"

	CONST_JSVER = "?v=190820"
	CONST_CSVER = "?v=1.1.3"
	CONST_PAYCOM = "위드라인" '가상계좌
	CONST_BANKNM = "KEB하나은헁" '가상계좌

	'스크립트등등 경로
	CONST_PATH = "swimming"

	'오류 또는 제약조건 체크 처리여부
	CONST_ERRCHECK = false

	'장애물타입
	'A
	CONST_TYPEA1 = "FEI 238.2.1"
	CONST_TYPEA2 = "FEI 238.2.2"

	'A1
	CONST_TYPEA_1 = "최적시간"
	'B
	CONST_TYPEB = "FEI 274-1.5.3" 'phase 1경기 2경기로 나누어지는 경기
	'C
	CONST_TYPEC = "FEI 239"

	classarr = array("S","A","B","C","D","F")
	CONST_UPIMG = "http://Upload.sportsdiary.co.kr/sportsdiary"
%>
