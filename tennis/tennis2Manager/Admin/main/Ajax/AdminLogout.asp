<%
	'쿠키 삭제 처리
	with Response
		
		.Expires = -1
			
		.Cookies("MemberIDX").Domain  = ".sportsdiary.co.kr"   '사용자명
		.Cookies("MemberIDX").path = "/"
		.Cookies("MemberIDX")	= ""
		.Cookies("UserName").Domain  = ".sportsdiary.co.kr"   '사용자명
		.Cookies("UserName").path = "/"
		.Cookies("UserName")	= ""
		.Cookies("UserID").Domain  = ".sportsdiary.co.kr"   '사용자명
		.Cookies("UserID").path = "/"
		.Cookies("UserID")	= ""
		.Cookies("Team").Domain  = ".sportsdiary.co.kr"   '사용자명
		.Cookies("Team").path = "/"
		.Cookies("Team")	= ""
		.Cookies("Role").Domain  = ".sportsdiary.co.kr"   '사용자명
		.Cookies("Role").path = "/"
		.Cookies("Role")	= ""
		.Cookies("EnterType").Domain  = ".sportsdiary.co.kr"   '사용자명
		.Cookies("EnterType").path = "/"
		.Cookies("EnterType")	= ""
		.Cookies("AdminYN").Domain  = ".sportsdiary.co.kr"   '사용자명
		.Cookies("AdminYN").path = "/"
		.Cookies("AdminYN")	= ""


		''통합ID
		'.Cookies("SD").Domain = ".sportsdiary.co.kr"
		'.Cookies("SD").path = "/"	
		'.Cookies("SD")	= ""	
		'
		''유도
		'.Cookies("judo").Domain = ".sportsdiary.co.kr"
		'.Cookies("judo").path = "/"	
		'.Cookies("judo")	= ""	
		'
		''테니스
		'.Cookies("tennis").Domain = ".sportsdiary.co.kr"
		'.Cookies("tennis").path = "/"	
		'.Cookies("tennis")	= ""

		.addheader "pragma","no-cache"
		.addheader "cache-control","no-cache"
	
	End with  
	
	Session.Abandon
	Response.Write "TRUE"
	Response.End
%>

