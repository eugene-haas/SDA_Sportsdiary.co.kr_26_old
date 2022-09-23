<%@Language="VBScript" CODEPAGE="65001"%>
	
<%Response.ContentType="text/xml;charset=utf-8"%>
<!-- #include file = "ApiGlobal.asp" -->
<!-- #include file = "ApiClient.asp" -->
<%
	' * 대회 목록을 조회
	' * 필수 파라미터
	' *		regYear 	: 등록년도
	' *		siteKey 	: 사이트키
	' *		apiCd		: API구분 코드
	' *		pageNo 		: 조회할 페이지 번호	 
	Dim pageNo 
	pageNo = 1
	
	pageNo = request("pageNo")
	
	If pageNo = "" or pageNo = NULL then
		pageNo = 1
	end If
	
	Dim m_url,siteKey,apiCd,regYear,classCd,param,content,resultStr
	Dim hostname,uri
	
	' 전송할 파라미터 : 필수 파라미터 + 선택 가능한 파라미터
	' 변수선언
	siteKey = getSiteKey()
	apiCd	= API_LIST_EVENT
	m_url = getURI(apiCd)
	regYear = request("regYear")
	'classCd = "TA"
	param = ""
	content = ""
	classCd = request("classCd")
	eventNm = request("eventNm")


	' 서버로부터 수신한 응답
	resultStr = ""
	
	' 서버에 전송할 파리미터 구성
	' 항상 제일 첫번째 위치시킴 &regYear 가 ⓡYear로 변환되어 오류 발생
	param = param & "siteKey="&siteKey&"&"		' 필수(사이트키)
	param = param & "apiCd="&apiCd&"&"			' 필수(API구분 코드)
	param = param & "regYear="&regYear&"&" 		' 필수(등록년도)
	param = param & "classCd="&classCd&"&"	' 선택(종목코드-매뉴얼의 코드표 참조. 없으면 전체)
	param = param & "eventNm="&eventNm&"&" '대회명
	param = param & "pageNo="&pageNo		' 필수(페이지번호)
	
	hostname = getHost()
	uri = getURI(apiCd)
	
	' ApiClient 초기화
	resultstr = init(hostname, uri, param)
	
	' 결과값 조회
	content = execute()
	Response.write content
%>