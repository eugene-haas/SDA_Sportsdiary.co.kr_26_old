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

	'루키테니스
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_RookieTennis;Data Source=" & DB_IP & ";"
	
	'공통 (관리자 로그인, 메뉴관리등)
	B_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"

	'아이템센터(SMS발송 관련)
	I_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID=widsql;Password=ic%^&1058!@#;Initial Catalog=ITEMCENTER;Data Source=db.itemcenter.co.kr;"

	'통합회원DB
	T_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_Member;Data Source=" & DB_IP & ";"

	'베너DB
	BN_ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog=SD_AD;Data Source=" & DB_IP & ";"

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
	FIURL = "http://img.sportsdiary.co.kr"
	LURL = "/tennis/M_Player" '로컬절대경로

	'PAGENAME = LCase(Mid(URL_PATH, InStrRev(URL_PATH, "/") + 1))	##cfg에서 정의##

	CHKDOMAIN = mid(URL_HOST,instr(URL_HOST,".")+1)
	COOKIENM = Split(CHKDOMAIN,".")(0) '생성되는 쿠키명


	'사이트코드 (관리자생성, 메뉴관리)
	sitecode = "RTN01"


	'코드정의
	CONST_CODE_PERSON = "tn001001"
	CONST_CODE_GROUP = "tn001002"

	CONST_CODE_PERSON_SINGLE = "200"
	CONST_CODE_PERSON_DOUBLE = "201"
	CONST_CODE_GROUP_DOUBLE = "202"


	CONST_JSVER = "?v=1.1.2"
	CONST_CSVER = "?v=1.1.1"
	CONST_PAYCOM = "위드라인" '가상계좌
	CONST_BANKNM = "KEB하나은행" '가상계좌




'==================================
'기존에 정의 되어있던 내용들 붙여놓음
'==================================
	'-------------------------전역 변수-----------------------
	global_PagePerData = 6   				 ' 한화면에 출력할 갯수
	global_PagePerGalleryData = 8 	 ' 한화면에 출력할 갯수
	global_PagePerTeamPlayerData = 10 ' 팀/선수 한화면에 출력할 갯수
	global_PagePerInfoData = 10 		 ' 협회 정보 한화면에 출력할 갯수


	global_BlockPage = 6  ' 페이징수, 5면 1,2,3,4,5 까지 나오고 다음페이지 나옴

	global_Id = "junida"
	global_userName = "주니"
	global_Admin ="admin"
	global_AdminName ="admin"

	global_Name_Val = "성명을 입력해 주세요."
	global_ID_Val = "ID를 입력해 주세요."
	global_Pass_Val = "암호를 입력해 주세요."
	global_Subject_Val = "제목을 입력해 주세요."
	global_Contents_Val = "내용을 입력해 주세요."
	global_Link_Val = "링크를 입력해 주세요."
	global_File_Val = "파일을 첨부해 주세요."
	global_Column_Val = "칼럼구분을 선택해 주세요."

  global_sketch_PagePerData = "16"
  global_sketch_BlockPage = "3"


	global_fileNum = 5 ' 첨부파일 최대 갯수
	global_filepath = "D:\sportsdiary.co.kr\tennis\File\FileDown" ' 첨부파일 저장경로
	global_filepathUrl = "/FileDown/" ' Common_Js.js 에서 global_filepathUrl_script
	global_filepath_temp = "D:\sportsdiary.co.kr\tennis\File\FileTemp" ' 첨부파일 Temp 경로
	global_filepath_tempUrl = "/FileTemp/"
	global_filepathImg = "D:\sportsdiary.co.kr\tennis\File\FileImg" ' 이미지업로드 저장 경로
	global_filepathImgUrl = "/FileImg/" ' Common_Js.js 에서 global_filepathImgUrl_script
	golbal_youtubeEmbeded = "https://www.youtube.com/embed/" '유투브 IFrame 나오게 하는 방법
	golbal_youtubeImg = "https://img.youtube.com/vi/" '유투브 이미지 https://img.youtube.com/vi/HatQmVJ5Uew/hqdefault.jpg

  global_filepath_ADIMG = "D:\ADIMG\tennis"
	global_filepathUrl_ADIMG = "/ADImgR/tennis/"
	global_filepath_temp_ADIMG = "D:\ADIMG\temp"
	global_filepath_tempUrl_ADIMG = "/ADImgR/temp/"

	global_HP = "tennis"
	global_domain = "tennis.sportsdiary.co.kr"

	global_MainNoticeCnt = "6"	' 메인공지사항출력갯수
	global_MainTNewsCnt = "3"		' 메인일반뉴스출력갯수
	global_MainMNewsCnt = "2"		' 메인영상뉴스출력갯수
	global_MainCLCnt = "5"			' 메인칼럼리스트출력갯수

	ImgCLDefault = "images/column/news_defalt.png" '칼럼리스트 기본이미지
	'ImgCLDefault = "../images/public/btn_x_circle@3x.png" '칼럼리스트 기본이미지


	'====================================================================================
	'global 변수
	'====================================================================================
	global_num1   		= "010-6312-6655"		'최보라팀장
	global_num2   		= "02-704-0282"			'최보라팀장	
	global_num3   		= "02-715-0282(#3)"		'대표번호
	global_name1  		= "최보라"				'담당1
	global_name2  		= "스포츠다이어리" 		'담당2
	global_fax   		= "02-3483-8113"			'팩스번호
	global_email1 		= "sd1@sportsdiary.co.kr"	'담당자메일1
	global_companycode 	= "108-81-66493"		'사업자번호
	global_address     	= "서울 마포구 삼개로16 근신빌딩 본관5층"
	global_site 		= "www.sportsdiary.co.kr"
	SportsGb 			= "tennis"
	ImgDefault  		= "../images/public/profile@3x.png"	'회원프로필 기본이미지

  tpara = "MemberIDX="&request.Cookies("SD")("MemberIDX")&"&SportsGb="&SportsGb&"&PlayerReln="&request.Cookies(SportsGb)("PlayerReln")

  GLOBAL_DT  = Year(now)&AddZero(Month(now))&AddZero(Day(now))'현재일자 예)20150609
'==================================
'기존에 정의 되어있던 내용들 붙여놓음
'==================================
%>

