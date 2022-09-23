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




	'###### S: DB Connection String ######
'	strConnect = strConnect & "Provider=SQLOLEDB.1;Persist Security Info=True;"
'	strConnect = strConnect & "Data Source=115.68.112.26;"  
'	strConnect = strConnect & "User ID=Korbm;"             
'	strConnect = strConnect & "Password=qoemalsxjs;"             
'	strConnect = strConnect & "Initial Catalog=KoreaBadminton;" 
'	strConBK = strConBK & "Provider=SQLOLEDB.1;Persist Security Info=True;"
'	strConBK = strConBK & "Data Source=115.68.112.26;"  
'	strConBK = strConBK & "User ID=KorBadmin;"
'	strConBK = strConBK & "Password=dkzniuqjza831!$;"
'	strConBK = strConBK & "Initial Catalog=Bad_Korea_BAK;" 
	'###### E: DB Connection String ######


	'##DB 설정
	DB_IP	= "49.247.9.88\SQLExpress,1433"
	DB_NAME = "KoreaBadminton"
	DB_ID	= "Korbm" 
	DB_PW	= "qoemalsxjs" 

	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"


    '스포츠Player
	SP_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=SportsPlayer;Data Source=db.itemcenter.co.kr;"

    '스포츠Diary
	SD_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=Sportsdiary;Data Source=db.itemcenter.co.kr;"

    '통합회원DB
	T_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=sportsdiary;Password=dnlemfkdls715)@*@;Initial Catalog=SD_Member;Data Source=115.68.112.26;"



	IS_DEV = False

	'## 접속 사용자 세션아이디
	USER_SESSION = session.sessionid

	'## 디버깅 설정
	DEBUG_MODE = IS_DEV
	Const DEBUG_IP = ""
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

	CONST_HTMLVER = "<!DOCTYPE html>"&vbCrLf&"<html lang=""ko"">"
	CONST_BODY = "" 'style 또는 스크립트 포함

	IURL = "/images/"

	pagename = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))

	'CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)
	CHKDOMAIN = "sportsdiary.co.kr"
%>