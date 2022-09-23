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


	B_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"

	'아이템센터(SMS발송 관련)
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=ITEMCENTER;Data Source=db.itemcenter.co.kr;"
	I_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=ITEMCENTER;Data Source=db.itemcenter.co.kr;"

	'통합회원DB
	T_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_Member;Data Source=" & DB_IP & ";"
	'베너DB
	BN_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_AD;Data Source=" & DB_IP & ";"
	'승마
	R_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_Riding;Data Source=" & DB_IP & ";"
	'유도
	UD_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sportsdiary;Password=dnlemfkdls715)@*@;Initial Catalog=sportsdiary;Data Source=db.itemcenter.co.kr;"
	'KATA
	KATA_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_Tennis;Data Source=" & DB_IP & ";"
	'민턴
	BM_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=Korbm;Password=qoemalsxjs;Initial Catalog=KoreaBadminton;Data Source=" & DB_IP & ""
	'json
	WK_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=APIClient;Password=$%^APIClient20190403!@#;Initial Catalog=WorkAPI;Data Source=" & DB_IP & ""

     '스포츠Player
	SP_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=SportsPlayer;Data Source=db.itemcenter.co.kr;"

    '스포츠Diary
	SD_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=Sportsdiary;Data Source=db.itemcenter.co.kr;"

	'한체대게임
	KN_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=KSUGame;Data Source=" & DB_IP & ";"



	dbnmarr = array("공통","멤버","아이템센터","베드민턴","테니스","SD테니스","수영","승마","자전거","유도","APITESTER","대회실적","스포츠Player", "스포츠Diary","한체대")

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
	CONST_BODY = "" 'style 또는 스크립트 포함

	IURL = "/images/"

	CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)
	COOKIENM = Split(CHKDOMAIN,".")(0) '생성되는 쿠키명

	PAGENAME = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))
	C_PAGENAME = PAGENAME

	CONST_PATH = "admin"

	'===================================================================================
	'Function : encode(), decode() 암호화
	'Description : 암호화
	'===================================================================================
	R_e_f = "GPQRSATWXVYBCHL640MN598OIJKZ12D7EF3U"


	'SNS인증번호 랜덤숫자
	Function random_Disigt_str() 'Check_AuthNum.asp 에서 사용
		Randomize '랜덤 초기화
		'4자리
		bufNum = int(9000 * rnd) + 1000
		random_Disigt_str = bufNum
	End Function

	SITECODE = "EVAL1"
%>
