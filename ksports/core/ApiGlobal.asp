<%
	Dim API_LIST_EVENT
	Dim SITE_KEY, PROTOCOL, DOMAIN, URI_LIST_EVENT
	
	' API 코드
	API_LIST_EVENT			= "020"	' 대회목록(경기실적)
	
	'Dim SITE_KEY					= "여기에 부여받은 사이트키를 입력해야 합니다."		' 부여받은 사이트키 입력
'	SITE_KEY						= "2eCAc5s6dUlmyxu231rJWA=="		' 부여받은 사이트키 입력
	SITE_KEY						= "Hd3nERuyrnfUUkwmgillDg=="

	PROTOCOL					= "http://"
	
	DOMAIN						= "api.sports.or.kr"
	URI_LIST_EVENT				= "/rest/stat/list/eventRetrieveService.do"	' 대회목록
	
	' 접속할 서버 Host를 리턴
	Function getSiteKey()
		getSiteKey = SITE_KEY
	End Function

	' 접속할 서버 Host를 리턴
	Function getHost()
		getHost = PROTOCOL + DOMAIN
	End Function

	' API코드에 따른 접속 URL을 리턴
	Function getURI(apiCd)
		Dim retval
		
		If strComp(API_LIST_EVENT, apiCd) = 0 Then	
			retval = URI_LIST_EVENT	
		end if						
		
		getURI = retval
	End Function
%>