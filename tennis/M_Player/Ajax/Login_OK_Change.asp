<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'현소속팀-국가대표계정 로그인 전환 페이지
	'===========================================================================================
	Check_Login()
	
	dim CMemberIDX		: CMemberIDX   	= fInject(Request("MemberIDX"))
	dim CPlayerIDX 		: CPlayerIDX 	= fInject(Request("PlayerIDX"))
	dim CPlayerIDXNow 	: CPlayerIDXNow = fInject(Request("PlayerIDXNow"))
	dim CTeam	 		: CTeam 		= fInject(request("Team"))
	dim CTeamNow 		: CTeamNow 		= fInject(request("TeamNow"))
	dim CBirthday 		: CBirthday		= fInject(request("Birthday"))
	dim CEnterType 		: CEnterType	= fInject(request("EnterType"))	'현재계정구분	
	
	
	dim LSQL, LRs, CSQL, CRs
	dim LogSQL
	dim CHK_SESSION
	
	
	IF CMemberIDX = "" Or CPlayerIDX = "" OR CTeam = "" OR CEnterType = "" OR CBirthday = "" Then 	
		FndData = "FALSE"	
	Else 
		
		CSQL =  " 		SELECT UserID "
		CSQL = CSQL & "  	,UserPass "
		CSQL = CSQL & " FROM [SportsDiary].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & " 	AND SportsType = '"&SportsGb&"' "
		CSQL = CSQL & " 	AND PlayerReln = 'R' "
		CSQL = CSQL & " 	AND Birthday = '"&CBirthday&"' "
		CSQL = CSQL & " 	AND EnterType = '"&CEnterType&"' "
		
		SELECT CASE CEnterType
			'현 소속팀 계정으로 로그인 전환
			CASE "E" 	
				CSQL = CSQL & " AND PlayerIDX = '"&CPlayerIDXNow&"' "
				CSQL = CSQL & " AND Team = '"&CTeamNow&"' "
				
			'국가대표 계정으로 로그인 전환
			CASE "K"	
				CSQL = CSQL & " AND PlayerIDXNow = '"&CPlayerIDX&"' "
				CSQL = CSQL & " AND TeamNow = '"&CTeam&"' "
				
		END SELECT
		
		SET CRs = DBcon.Execute(CSQL)
		IF Not(CRs.Eof OR CRs.Bof) Then 
			'쿠키삭제 처리
			FndData = SESSION_EMPTY()
			
			'로그인 정보 쿠키설정
			CALL SESSION_USER_INFO(CRs("UserID"), CRs("UserPass"))
			
		ELSE      
			FndData = "FALSE"	
		End IF 
			CRs.Close
		SET CRs = Nothing

	End IF 
	
	
	'=================================================================================================
	'쿠키 삭제 처리
	'=================================================================================================
	FUNCTION SESSION_EMPTY()
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
	
			.addheader "pragma","no-cache"
			.addheader "cache-control","no-cache"
		End with  
		
		Session.Abandon
		
		SESSION_EMPTY = "TRUE"
		
	END FUNCTION
	'=================================================================================================
	'로그인 전환 후 쿠키설정
	'=================================================================================================
	SUB SESSION_USER_INFO(valID, valPass)
		'회원DB
		LSQL =  " 		SELECT a.PlayerIDX" 
		LSQL = LSQL & "		,a.MemberIDX"  					
		LSQL = LSQL & "		,a.UserName" 
		LSQL = LSQL & "		,a.UserPhone" 										
		LSQL = LSQL & "		,a.Birthday" 
		LSQL = LSQL & "		,a.PhotoPath" 
		LSQL = LSQL & "		,a.Sex " 
		LSQL = LSQL & "		,a.Team " 	
		LSQL = LSQL & "		,a.PlayerLevel "	
		LSQL = LSQL & "		,a.Auth_YN" 	
		LSQL = LSQL & "		,a.PlayerReln " 		
		LSQL = LSQL & "		,a.EnterType " 	
		LSQL = LSQL & "		,CONVERT(CHAR(10), CONVERT(DATE, a.SrtDate), 102) SrtDate "  			
		LSQL = LSQL & "		,b.PlayerGb "		
		LSQL = LSQL & "		,b.NowSchIDX " 		
		LSQL = LSQL & "		,T.SvcStartDt " 		
		LSQL = LSQL & "		,T.SvcEndDt " 		
		LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] a "
		LSQL = LSQL & "		left join [SportsDiary].[dbo].[tblPlayer] b on a.PlayerIDX = b.PlayerIDX " 
		LSQL = LSQL & "			AND b.DelYN = 'N' "
		LSQL = LSQL & "			AND b.SportsGb = '"&SportsGb&"'"
		LSQL = LSQL & "		left join [SportsDiary].[dbo].[tblTeamInfo] T on a.Team = T.Team " 
		LSQL = LSQL & "			AND T.DelYN = 'N' "
		LSQL = LSQL & "			AND T.SportsGb = '"&SportsGb&"'"
		LSQL = LSQL & " WHERE a.DelYN = 'N'" 
		LSQL = LSQL & " 	AND a.SportsType = '"&SportsGb&"'" 
		LSQL = LSQL & "		AND UserID = '"&valID&"' " 
		LSQL = LSQL & "		AND UserPass = '"&valPass&"' " 
					
'		response.Write LSQL
		SET LRs = Dbcon.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			EnterType 	= LRs("EnterType")
			MemberIDX 	= LRs("MemberIDX")
			PlayerIDX 	= LRs("PlayerIDX")
			PlayerLevel	= LRs("PlayerLevel")
			UserName 	= ReplaceTagReText(LRs("UserName"))
			UserPhone 	= LRs("UserPhone")
			Birthday 	= LRs("Birthday")
			Sex 		= LRs("Sex")
			Team 		= LRs("Team")
'			Auth_YN 	= LRs("Auth_YN")
			PlayerGb 	= LRs("PlayerGb")
			NowSchIDX 	= LRs("NowSchIDX")
			SvcStartDt 	= LRs("SvcStartDt")
			SvcEndDt 	= LRs("SvcEndDt")
			PlayerReln	= LRs("PlayerReln")
			SrtDate		= LRs("SrtDate")

			
			'회원프로필 이미지 세팅
			IF len(LRs("PhotoPath")) > 0  Then
				PhotoPath 	= "../"& mid(LRs("PhotoPath"), 4, len(LRs("PhotoPath")))
			Else
				PhotoPath 	= ImgDefault
			End IF	
			'==============================================================================
			'로그인로그
			'==============================================================================
			LogSQL = "			INSERT INTO [SportsDiary].[dbo].[tblLoginLog] ("
			LogSQL = LogSQL & " 	PlayerIDX"
			LogSQL = LogSQL & "		,SportsGb"
			LogSQL = LogSQL & "		,PlayerGb"
			LogSQL = LogSQL & "		,SchIDX"
			LogSQL = LogSQL & "		,Sex"
			LogSQL = LogSQL & "		,Team"
			LogSQL = LogSQL & "		,UseOS"
			LogSQL = LogSQL & "		,UseModel"
			LogSQL = LogSQL & "		,HttpRefer"
			LogSQL = LogSQL & "		,Agent"
			LogSQL = LogSQL & "		,WriteDate"
			LogSQL = LogSQL & "		,WriteIP"
			LogSQL = LogSQL & ") VALUES ("
			LogSQL = LogSQL & " 	'"&PlayerIDX&"'"
			LogSQL = LogSQL & "		,'"&SportsGb&"'"
			LogSQL = LogSQL & "		,'"&PlayerGb&"'"
			LogSQL = LogSQL & "		,'"&NowSchIDX&"'"
			LogSQL = LogSQL & "		,'"&Sex&"'"
			LogSQL = LogSQL & "		,'"&Team&"'"
			LogSQL = LogSQL & "		,''"
			LogSQL = LogSQL & "		,''"
			LogSQL = LogSQL & "		,'"&Request.Servervariables("HTTP_REFERER")&"'"
			LogSQL = LogSQL & "		,'"&Request.Servervariables("HTTP_USER_AGENT")&"'"
			LogSQL = LogSQL & "		,GETDATE()"
			LogSQL = LogSQL & "		,'"&Request.Servervariables("REMOTE_ADDR")&"'"
			LogSQL = LogSQL & "	)"
			
			DBcon.Execute(LogSQL)
				
			'==============================================================================================
			'로그인 정보 쿠키셋팅
			'==============================================================================================
			IF PlayerGb <> "" Then Response.Cookies("PlayerGb") = PlayerGb   			'선수구분			
			IF SvcStartDt <> "" Then Response.Cookies("SvcStartDt") = SvcStartDt    	'팀 관리 서비스 시작일
			IF SvcEndDt <> "" Then Response.Cookies("SvcEndDt") = SvcEndDt 				'팀 관리 서비스 종료일
					
			Response.Cookies("MemberIDX") 	= encode(MemberIDX, 0)  		'회원등록번호			
			Response.Cookies("Sex")       	= Sex         					'성별
			Response.Cookies("Team") 		= encode(Team , 0)     			'팀소속	
			Response.Cookies("PlayerIDX") 	= encode(PlayerIDX, 0) 			'선수번호
			Response.Cookies("PlayerReln") 	= encode(PlayerReln, 0) 		'선수와의 관계
			Response.Cookies("SrtDate") 	= SrtDate									'회원가입일[선수보호자]									
			Response.Cookies("EnterType") 	= EnterType  								'선수구분[E:엘리트 | A:아마추어]			
			Response.Cookies("UserID")    	= encode(UserID, 0)							'사용자ID
			Response.Cookies("PhotoPath")  	= encode(Server.HTMLEncode(PhotoPath), 0)	'회원프로필 이미지
			Response.Cookies("BirthDay")  	= encode(BirthDay, 0)						'생년월일
			Response.Cookies("SportsGb")  	= SportsGb    								'종목구분
			Response.Cookies("UserName")  	= UserName    								'사용자명			
			'==============================================================================================
		End IF
		
			LRs.Close
		SET LRs = Nothing
		
	END SUB
	'=================================================================================================
	
	
	response.Write FndData
	
	DBclose()

	
%>