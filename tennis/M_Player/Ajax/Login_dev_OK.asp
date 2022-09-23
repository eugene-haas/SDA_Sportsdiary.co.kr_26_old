<!--#include file="../Library/ajax_config.asp"-->
<%
	dim UserID 		: UserID   	= fInject(Request("UserID"))
	dim UserPass 	: UserPass 	= fInject(Request("UserPass"))
	dim saveid		: saveid 	= fInject(request("saveid"))
					
	If UserID = "" Or UserPass = "" Then 	
		Response.Write "FALSE"
		Response.End
	Else 
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
		LSQL = LSQL & "		AND UserID = '"&UserID&"' " 
		LSQL = LSQL & "		AND UserPass = '"&UserPass&"' " 
		LSQL = LSQL & "		AND EdSvcReqTp = 'A' " 
					
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
			Auth_YN 	= LRs("Auth_YN")
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
			LogSQL = "INSERT INTO [SportsDiary].[dbo].[tblLoginLog] "
			LogSQL = LogSQL&"("
			LogSQL = LogSQL&" PlayerIDX"
			LogSQL = LogSQL&",SportsGb"
			LogSQL = LogSQL&",PlayerGb"
			LogSQL = LogSQL&",SchIDX"
			LogSQL = LogSQL&",Sex"
			LogSQL = LogSQL&",Team"
			LogSQL = LogSQL&",UseOS"
			LogSQL = LogSQL&",UseModel"
			LogSQL = LogSQL&",HttpRefer"
			LogSQL = LogSQL&",Agent"
			LogSQL = LogSQL&",WriteDate"
			LogSQL = LogSQL&",WriteIP"
			LogSQL = LogSQL&")"
			LogSQL = LogSQL&" VALUES"
			LogSQL = LogSQL&"("
			LogSQL = LogSQL&" '"&PlayerIDX&"'"
			LogSQL = LogSQL&",'"&SportsGb&"'"
			LogSQL = LogSQL&",'"&PlayerGb&"'"
			LogSQL = LogSQL&",'"&NowSchIDX&"'"
			LogSQL = LogSQL&",'"&Sex&"'"
			LogSQL = LogSQL&",'"&Team&"'"
			LogSQL = LogSQL&",''"
			LogSQL = LogSQL&",''"
			LogSQL = LogSQL&",'"&Request.Servervariables("HTTP_REFERER")&"'"
			LogSQL = LogSQL&",'"&Request.Servervariables("HTTP_USER_AGENT")&"'"
			LogSQL = LogSQL&",GETDATE()"
			LogSQL = LogSQL&",'"&Request.Servervariables("REMOTE_ADDR")&"'"
			LogSQL = LogSQL&")"
			Dbcon.Execute(LogSQL)
			'==============================================================================
			'선수보호자 로그인의 경우 선수정보로 쿠키변경처리
			'==============================================================================		
			IF PlayerReln ="A" OR PlayerReln ="B" OR PlayerReln ="Z" Then
					
					'선수정보 조회
					CSQL =  " 		SELECT a.PlayerIDX" 
					CSQL = CSQL & "		,a.MemberIDX"  					
					CSQL = CSQL & "		,a.UserName" 
					CSQL = CSQL & "		,a.Birthday" 
					CSQL = CSQL & "		,a.Sex " 
					CSQL = CSQL & "		,a.Team " 	
					CSQL = CSQL & "		,a.PlayerLevel "	
					CSQL = CSQL & "		,a.Auth_YN "  	
					CSQL = CSQL & "		,ISNULL(a.PlayerReln, '') PlayerReln " 		
					CSQL = CSQL & "		,b.PlayerGb "		
					CSQL = CSQL & "		,b.NowSchIDX " 		
					CSQL = CSQL & "		,T.SvcStartDt " 		
					CSQL = CSQL & "		,T.SvcEndDt " 		
					CSQL = CSQL & " FROM [SportsDiary].[dbo].[tblMember] a "
					CSQL = CSQL & "		left join [SportsDiary].[dbo].[tblPlayer] b on a.PlayerIDX = b.PlayerIDX " 
					CSQL = CSQL & "			AND b.DelYN = 'N' "
					CSQL = CSQL & "			AND b.SportsGb = '"&SportsGb&"'"
					CSQL = CSQL & "		left join [SportsDiary].[dbo].[tblTeamInfo] T on a.Team = T.Team " 
					CSQL = CSQL & "			AND T.DelYN = 'N' "
					CSQL = CSQL & "			AND T.SportsGb = '"&SportsGb&"'"
					CSQL = CSQL & " WHERE a.DelYN = 'N'"
					CSQL = CSQL & " 	AND a.SportsType = '"&SportsGb&"' "
					CSQL = CSQL & "		AND a.PlayerIDX = '"&PlayerIDX&"' " 
					CSQL = CSQL & "		AND (a.PlayerReln IS NULL OR a.PlayerReln = '' OR a.PlayerReln = 'K')"
					
					SET CRs = Dbcon.Execute(CSQL)
					IF Not(CRs.Eof Or CRs.Bof) Then 
						'==============================================================================================
						'선수보호자의 경우 선수정보 조회 후 쿠키셋팅
						'==============================================================================================
						Response.Cookies("P_MemberIDX") = encode(MemberIDX, 0)  			'회원등록번호[선수보호자]			
						'==============================================================================================
						'선수정보
						'==============================================================================================
						Response.Cookies("MemberIDX") 	= encode(CRs("MemberIDX"), 0)  		'회원등록번호						
						Response.Cookies("PlayerIDX") 	= encode(CRs("PlayerIDX"), 0)  		'선수번호
						Response.Cookies("Sex")       	= CRs("Sex")         				'성별
						
	
						IF Team <> "" Then 	Response.Cookies("Team") = encode(CRs("Team") , 0)   	  		'팀소속
						IF PlayerGb <> "" Then Response.Cookies("PlayerGb") 	= CRs("PlayerGb")   		'선수구분			
						IF SvcStartDt <> "" Then 	Response.Cookies("SvcStartDt") 	= CRs("SvcStartDt")    	'팀 관리 서비스 시작일
						IF SvcEndDt <> "" Then 	Response.Cookies("SvcEndDt") = CRs("SvcEndDt ")				'팀 관리 서비스 종료일
						'==============================================================================================
						
					End IF
						CRs.Close
					SET CRs = Nothing
					
					
				ELSE
					
					'==============================================================================================
					'로그인 정보 쿠키셋팅
					'==============================================================================================
					Response.Cookies("MemberIDX") 	= encode(MemberIDX, 0)  '회원등록번호			
					Response.Cookies("Sex")       	= Sex         			'성별
					
					IF Team <> "" Then 	Response.Cookies("Team") = encode(Team , 0)     			'팀소속	
					IF PlayerGb <> "" Then Response.Cookies("PlayerGb") 	= PlayerGb   			'선수구분			
					IF PlayerIDX <> "" Then Response.Cookies("PlayerIDX") 	= encode(PlayerIDX, 0)  '선수번호
					IF SvcStartDt <> "" Then 	Response.Cookies("SvcStartDt") 	= SvcStartDt    	'팀 관리 서비스 시작일
					IF SvcEndDt <> "" Then 	Response.Cookies("SvcEndDt") = SvcEndDt    				'팀 관리 서비스 종료일
					
					'==============================================================================================
					
			END IF
			
			IF PlayerReln <> "" Then Response.Cookies("PlayerReln") 	= encode(PlayerReln, 0) '선수와의 관계
			
			Response.Cookies("SrtDate") 	= SrtDate									'회원가입일[선수보호자]									
			Response.Cookies("EnterType") 	= EnterType  								'선수구분[E:엘리트 | A:아마추어]			
			Response.Cookies("UserID")    	= encode(UserID, 0)							'사용자ID
			Response.Cookies("PhotoPath")  	= encode(Server.HTMLEncode(PhotoPath), 0)	'회원프로필 이미지
			Response.Cookies("BirthDay")  	= encode(BirthDay, 0)						'생년월일
			Response.Cookies("SportsGb")  	= SportsGb    								'종목구분
			Response.Cookies("UserName")  	= UserName    								'사용자명			


			'자동로그인 기능
			IF saveid = "Y" then
				response.cookies("idsave") 	= UserID
				response.cookies("pwsave") 	= encode(UserPass, 0)
				response.cookies("idsave").expires 	= Date() + 365
				response.cookies("pwsave").expires 	= Date() + 365
			Else
				response.cookies("idsave") 	= ""
				response.cookies("pwsave") 	= ""
				response.cookies("idsave").expires 	= Date() + 365				
				response.cookies("pwsave").expires 	= Date() + 365
			End IF
			
			
			Response.Write "TRUE"
			Response.End 
		
		Else
			Response.Write "FALSE"
			Response.End
		End IF
		
			LRs.Close
		SET LRs = Nothing
		
		Dbclose()

	End If 

	
%>