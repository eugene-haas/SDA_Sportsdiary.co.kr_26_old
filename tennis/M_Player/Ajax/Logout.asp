<%
	'쿠키 삭제 처리
	With response
		.Expires = -1
		
		'통합ID
		.Cookies("SD").Domain = ".sportsdiary.co.kr"
		.Cookies("SD").path = "/"	
		.Cookies("SD")	= ""	
		
		'유도
		.Cookies("judo").Domain = ".sportsdiary.co.kr"
		.Cookies("judo").path = "/"	
		.Cookies("judo")	= ""	
		
		'테니스
		.Cookies("tennis").Domain = ".sportsdiary.co.kr"
		.Cookies("tennis").path = "/"	
		.Cookies("tennis")	= ""	
			
		.Addheader "pragma","no-cache"
		.Addheader "cache-control","no-cache"

	End With  
	
	Session.Abandon
	response.Write "TRUE"
	response.End
%>