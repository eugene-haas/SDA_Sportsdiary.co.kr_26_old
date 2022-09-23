<%
	'쿠키 삭제 처리
	with Response
		.Expires = -1
		.Cookies("MemberIDX") 	= ""	'회원등록번호
		.Cookies("P_MemberIDX") = ""   	'부모의 경우 회원등록번호
		.Cookies("PlayerIDX") 	= ""	'선수번호
		.Cookies("SportsGb") 	= ""   	'종목구분
		.Cookies("PlayerGb")  	= ""   	'선수구분
		.Cookies("NowSchIDX")  	= ""   	'소속IDX
		.Cookies("UserName")  	= ""   	'사용자명		
		.Cookies("UserID")  	= ""   	'사용자아이디		
		.Cookies("UserPhone")  	= ""   	'사용자연락처
		.Cookies("BirthDay") 	= ""   	'생년월일
		.Cookies("Sex")  		= ""   	'성별
		.Cookies("PlayerLevel") = ""   	'체급코드
		.Cookies("PhotoPath") 	= ""   	'사용자프로파일 이미지
		.Cookies("SvcStartDt") 	= ""   	'팀관리서비스시작일
		.Cookies("SvcEndDt") 	= ""   	'팀관리서비스종료일
		.Cookies("Team") 		= ""   	'소속팀
		.Cookies("PlayerReln") 	= ""   	'회원구분
		.Cookies("EnterType") 	= ""   	'회원구분[E:엘리트 | A;아마추어]
'		.Cookies("idsave") 		= ""   	'사용자ID
'		.Cookies("pwsave") 		= ""   	'사용자PWD

		.addheader "pragma","no-cache"
		.addheader "cache-control","no-cache"
	End with  
	
	Session.Abandon

	Response.Redirect("/M_Player/Main/Login.asp")
	Response.End
%>