<!--#include file="../Library/ajax_config.asp"-->
<%
	'=================================================================
  	'선수보호자 회원가입
		'PlayerReln --> [A:부, B:모, Z:기타]
		'중복가입 허용
  	'=================================================================
	dim UserID 			: UserID 			= fInject(trim(Request.Cookies("SD")("UserID")))
	dim UserName 		: UserName 			= fInject(trim(Request.Cookies("SD")("UserName")))
	dim UserBirth 		: UserBirth 		= fInject(trim(Request.Cookies("SD")("UserBirth")))
	
	dim SportsType	 	: SportsType 		= fInject(Request("SportsType"))		'스포츠종목
	dim EnterType	 	: EnterType 		= fInject(Request("EnterType"))			'회원구분[E:엘리트 | A:생활체육 | K:국가대표] 
	dim PlayerReln 		: PlayerReln 		= fInject(Request("PlayerReln"))		'선수와의 관계[A:부 | B:모 | Z:기타 | T:팀매니저 | K:비등록선수 | D:일반]
   	dim PlayerRelnMemo 	: PlayerRelnMemo 	= fInject(trim(Request("PlayerRelnMemo")))	'선수와의 관계
	dim PlayerIDX 		: PlayerIDX 		= fInject(Request("PlayerIDX"))			'선수 IDX	
	dim PlayerPhone 	: PlayerPhone 		= fInject(Request("PlayerPhone"))		'선수휴대폰번호	
	dim Team	 		: Team 				= fInject(Request("Team"))				'소속팀코드
	dim Team2	 		: Team2 			= fInject(Request("Team2"))				'소속팀코드2
	dim TeamNm	 		: TeamNm 			= fInject(Request("TeamNm"))			'소속팀명
	dim TeamNm2	 		: TeamNm2 			= fInject(Request("TeamNm2"))			'소속팀명2
	
	
	dim CSQL, CRs, LSQL, LRs, JRs, JSQL
	dim PlayerRelnNm
	dim SMSMsg, ErrorNum
	dim SD_GameIDSET, txt_MemberIDX			'종목메인설정 값 [Y | N]
   
	IF  SportsType = "" OR PlayerReln = "" OR UserID = "" OR PlayerIDX = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		On Error Resume Next
			
		DBcon3.BeginTrans()
		
		
		'부모회원 가입
		SUB MAKE_INFO_USER(valID, valIDSET, valType)
			
			'tblMember 가입내역 조회		
			JSQL =  	" 	SELECT ISNULL(COUNT(*), 0) cnt " 
			JSQL = JSQL & " FROM [SD_Tennis].[dbo].[tblMember] " 
			JSQL = JSQL & " WHERE DelYN = 'N' " 
			JSQL = JSQL & " 	AND SportsType = '" & SportsType & "'" 		
			JSQL = JSQL & " 	AND EnterType = '" & EnterType & "'" 		
			JSQL = JSQL & " 	AND PlayerIDX = '" & PlayerIDX & "'" 
			JSQL = JSQL & "		AND PlayerReln = '" & valType & "'" 		
			JSQL = JSQL & " 	AND SD_UserID = '" & valID & "'" 
			
			SET JRs = DBCon3.Execute(JSQL)	
			IF JRs(0) > 0 Then
				Response.Write "FALSE|99"
				Response.End
			Else
				
				SELECT CASE valType
					CASE "A" : PlayerRelnNm = "부"
					CASE "B" : PlayerRelnNm = "모"
					CASE "Z" : PlayerRelnNm = PlayerRelnMemo
				END SELECT	
				
				LSQL = "		SET NOCOUNT ON "
				LSQL = LSQL & "	INSERT INTO [SD_Tennis].[dbo].[tblMember] (" 
				LSQL = LSQL & "		SD_UserID "	
				LSQL = LSQL & "		,SD_GameIDSET "	
				LSQL = LSQL & "	 	,SportsType"  
				LSQL = LSQL & "		,UserName" 										
				LSQL = LSQL & "		,PlayerIDX" 
				LSQL = LSQL & "		,PlayerReln" 
				LSQL = LSQL & "		,PlayerRelnMemo" 		
				LSQL = LSQL & "		,EnterType "				
				LSQL = LSQL & "		,Team" 						
				LSQL = LSQL & "		,Team2" 						
				LSQL = LSQL & "		,TeamNm" 						
				LSQL = LSQL & "		,TeamNm2" 						
				LSQL = LSQL & "		,SrtDate"  
				LSQL = LSQL & "		,WriteDate"  					
				LSQL = LSQL & "		,DelYN "  	
				LSQL = LSQL & "	) VALUES("
				LSQL = LSQL & "		'"  & valID			& "'" 
				LSQL = LSQL & "		,'" & valIDSET		& "'" 	'종목메인 계정설정	
				LSQL = LSQL & "		,'" & SportsType	& "'"
				LSQL = LSQL & "		,'" & UserName 		& "'" 
				LSQL = LSQL & "		,'" & PlayerIDX 	& "'" 
				LSQL = LSQL & "		,'" & valType	 	& "'" 	'PlayerReln
				LSQL = LSQL & "		,'" & PlayerRelnMemo & "'" 
				LSQL = LSQL & "		,'" & EnterType 	& "'" 
				LSQL = LSQL & "		,'" & Team 			& "'" 
				LSQL = LSQL & "		,'" & Team2 		& "'" 
				LSQL = LSQL & "		,'" & TeamNm 		& "'" 
				LSQL = LSQL & "		,'" & TeamNm2 		& "'" 
				LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,'N'"	
				LSQL = LSQL & "	)"
				LSQL = LSQL & " SELECT @@IDENTITY"
										
				SET LRs = DBCon3.Execute(LSQL)			
				ErrorNum = ErrorNum + DBCon3.Errors.Count
				IF Not(LRs.Eof OR LRs.Bof) Then
					txt_MemberIDX = LRs(0)
				End IF
					LRs.Close
				SET LRs = Nothing				
				
			End IF
				JRs.Close
			SET JRs = Nothing
		
		END SUB
		'==========================================================================================
		
		
		
		'tblMember 가입내역 조회		
		CSQL =  	  " SELECT * "
		CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND UserID = '" & UserID & "'"  	
		
		SET CRs = DBCon3.Execute(CSQL)	
		IF Not(CRs.eof or CRs.Bof) Then
			
			'계정추가시 종목메인 설정이 되어 있는지 체크
			SD_GameIDSET = CHK_SD_GameIDSET(UserID, SportsType)
			
			'회원정보 등록 SD_Tennis.dbo.tblMember 
			CALL MAKE_INFO_USER(UserID, SD_GameIDSET, PlayerReln)
			
   			
   			IF ErrorNum > 0 Then
				DBCon3.RollbackTrans()				
				Response.Write "FALSE|66"				
			Else					
				DBCon3.CommitTrans()
	
				'종목메인 설정값이 [Y]인 경우 계정추가 후 쿠키설정을 합니다.
				IF SD_GameIDSET = "Y" Then txt_Cookies = SET_INFO_COOKIE(UserID, txt_MemberIDX, SportsType)
				
				'==========================================================================================
				'선수에게 부모가입 공지문자발송
				'==========================================================================================
				SMSMsg = "("&PlayerRelnNm&")"&UserName&"님과데이터공유가시작되었습니다.스포츠다이어리에서정보확인바랍니다"
			
				'인증번호 SMS 발송	
				Itemcenter_DBOpen()
		
				LSQL = " 		INSERT INTO ITEMCENTER.DBO.T_SEND ("
				LSQL = LSQL & "	 	SSUBJECT "
				LSQL = LSQL & "		,NSVCTYPE "
				LSQL = LSQL & "		,NADDRTYPE"
				LSQL = LSQL & "		,SADDRS "
				LSQL = LSQL & "		,NCONTSTYPE"
				LSQL = LSQL & "		,SCONTS"
				LSQL = LSQL & "		,SFROM"
				LSQL = LSQL & "		,DTSTARTTIME"
				LSQL = LSQL & "	) VALUES ('" & SMSMsg & "'"
				LSQL = LSQL & "		,3 " '--3:SMS, 5:LMS
				LSQL = LSQL & "		,0 "
				LSQL = LSQL & "		,'" & PlayerPhone & "'" '--선수수신번호
				LSQL = LSQL & "		,0"
				LSQL = LSQL & "		,'" & SMSMsg & "'"
				LSQL = LSQL & "		,'027040282'" '--발신번호 (발신 확인번호 등록 유의)
				LSQL = LSQL & "		,GETDATE()"
				LSQL = LSQL & "	)"
				
				DBcon2.Execute(LSQL)				
				'ErrorNum = ErrorNum + DBcon2.Errors.Count
					
				Itemcenter_DbClose()
				'==========================================================================================
	
				Response.Write "TRUE|"
			End IF

		Else
			Response.Write "FALSE|200"
			response.end
		End IF
			CRs.Close
		SET CRs = Nothing
		
		
		DBClose3()
		
	End If 

%>