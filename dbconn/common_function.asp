<!--#include virtual="/dbconn/ICDbPath-utf8.inc"-->
<%	
	'========================================================================================================
	'종목별 코드, IP, 도메인 조회
	'========================================================================================================
   		 
   	'dim arrayType
   	'dim arrayNum	
	'dim vtinckfist	
	 
	strip		    = trim(Request.ServerVariables("REMOTE_ADDR"))
   	strseturl 	    = trim(Request.ServerVariables("HTTP_HOST")&Request.ServerVariables("PATH_INFO"))	
    'strsetdomain 	= trim(Request.ServerVariables("HTTP_HOST"))
   	'vtinckfist 	    = trim(Request.Cookies("vtinck"))
   
   	IF strseturl <> "" Then
		
		arrayType 	= Split(strseturl, "/")
		arrayNum	= Ubound(arrayType)
        
        strSportstype = "SDLOG_"&LCase(arrayType(1))                    '종목
     
		SELECT CASE LCase(arrayType(1))
			CASE "sdmain"	: strsetmedia = "CO1"						'통합코드

			CASE "tennis"	'테니스 
				SELECT CASE LCase(arrayType(2))
					CASE "m_player" 	: strsetmedia = "EE1"			'선수용
					'CASE "m_teamcoach" 	: strsetmedia = "TE2"		'팀매니저용	
				End SELECT

   			CASE "bike"		'자전거 
				SELECT CASE LCase(arrayType(2))
					CASE "m_player" 	: strsetmedia = "BK1"			'선수용
					'CASE "m_teamcoach" 	: strsetmedia = "TE3"		'팀매니저용	
				End SELECT	

		END SELECT

	End IF	
	'========================================================================================================
	 
	 
	
%>