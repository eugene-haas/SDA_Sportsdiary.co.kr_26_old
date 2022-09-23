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

	If URL_QUERYSTRING = "" Then
		NOW_URL = URL_PATH
	Else
		NOW_URL = URL_PATH & "?" & Request.ServerVariables("QUERY_STRING")
	End If

	'## 접속 사용자 아이피
	USER_IP = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
	If Len(USER_IP) = 0 Then USER_IP = Request.ServerVariables("REMOTE_ADDR")


	'##DB 설정
	DB_IP	= "115.68.112.26\SQLExpress,1433"
	DB_NAME = "SD_Bike"
	DB_ID	= "sportsdiary" '
	DB_PW	= "dnlemfkdls715)@*@"
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"

	'유도
	'스포츠다이어리 DB
	U_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=sportsdiary;Data Source=db.itemcenter.co.kr;"

	'아이템센터(SMS발송 관련)
	I_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=ITEMCENTER;Data Source=db.itemcenter.co.kr;"

	'통합회원DB
	T_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sportsdiary;Password=dnlemfkdls715)@*@;Initial Catalog=SD_Member;Data Source=115.68.112.26;"

  '통합회원DB
	B_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sportsdiary;Password=dnlemfkdls715)@*@;Initial Catalog=SD_BIKE;Data Source=115.68.112.26;"




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
		DEBUG_PNO = "01067878723" '"01047093650"
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


	'CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)
	CHKDOMAIN = "sportsdiary.co.kr"

	PAGENAME = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))
	C_PAGENAME = PAGENAME

  SITECODE = "BIKE01"

  ACCOUNT_MAST_TABLE_DEV = "SD_RookieTennis.dbo.TB_RVAS_MAST_20190131112735"
  ACCOUNT_LIST_TABLE_DEV = "SD_RookieTennis.dbo.TB_RVAS_LIST_20190422"
  ACCOUNT_MAST_TABLE = "SD_RookieTennis.dbo.TB_RVAS_MAST"
  ACCOUNT_LIST_TABLE = "SD_RookieTennis.dbo.TB_RVAS_LIST"
  V_ACCOUNT_MAST = ACCOUNT_MAST_TABLE
  V_ACCOUNT_LIST = ACCOUNT_LIST_TABLE







	Sub debugprint(dstr)
		Response.write  dstr
	End sub


	'참가비
    '>개인종목  : 1종목 3만원 /  2종목 5만원 (만원할인)     / 3종목 7만원(2만원할인)
    '>단체종목 1인 1만원

	SOLOATTMONEY = array(30000, 50000, 70000,90000, 110000, 130000)
	TEAMATTMONEY = 10000
	chkrule = True '관리자권한룰을 체크여부 (따라가는 페이지는 로그인 여부만 판단해서 제한한다.)

	UPURL = "http://bike.sportsdiary.co.kr/bike/m_player/upload/Sketch/"
	UPTMBURL = UPURL & "Thumbnail/"
%>
