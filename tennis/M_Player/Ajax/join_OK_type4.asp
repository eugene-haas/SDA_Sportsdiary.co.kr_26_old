<!--#include file="../Library/ajax_config.asp"-->
<%
	'=================================================================
	'테니스 일반 회원가입
		'PlayerReln --> [D]
	'=================================================================
	dim UserID			: UserID 			= fInject(trim(Request.Cookies("SD")("UserID")))
   	dim UserName		: UserName 			= fInject(trim(Request.Cookies("SD")("UserName")))
   	dim UserBirth		: UserBirth 		= decode(fInject(trim(Request.Cookies("SD")("UserBirth"))), 0)
   	dim SEX				: SEX 				= fInject(trim(Request.Cookies("SD")("SEX")))
   
   	dim SportsType	 	: SportsType 		= fInject(Request("SportsType"))		'스포츠종목
	dim EnterType	 	: EnterType 		= fInject(Request("EnterType"))			'회원구분[E:엘리트 | A:아마추어 | K:국가대표]
	dim PlayerReln 		: PlayerReln 		= fInject(Request("PlayerReln"))		'선수와의 관계[A:부 | B:모 | Z:기타 | T:팀매니저 | K:비등록선수 | D:일반]
	dim Job	 			: Job 				= fInject(Request("Job"))				'직업
	dim Interest	 	: Interest 			= fInject(Request("Interest"))			'관심분야
	
	dim CSQL, CRs, LSQL, LRs, JSQL, JRs
	dim SD_GameIDSET, txt_MemberIDX			'종목메인설정 값 [Y | N]
   
	If UserID = "" OR SportsType = "" OR EnterType = "" OR PlayerReln = "" OR Job = "" OR Interest = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		On Error Resume Next
			
		DBcon3.BeginTrans()
		
		'회원가입
		SUB MAKE_INFO_USER(valID, valIDSET, valType)
   
			JSQL =  	" 	SELECT ISNULL(COUNT(*), 0) cnt " 
			JSQL = JSQL & " FROM [SD_Tennis].[dbo].[tblMember] " 
			JSQL = JSQL & " WHERE DelYN = 'N' " 
			JSQL = JSQL & " 	AND UserName = '"&UserName&"'"	
			JSQL = JSQL & " 	AND PlayerReln = '" & valType & "'" 
			JSQL = JSQL & " 	AND SD_UserID = '" & valID & "'" 

			SET JRs = DBCon3.Execute(JSQL)	
			IF JRs(0) > 0 Then
				Response.Write "FALSE|99"
				response.End()
			Else
				LSQL = "		SET NOCOUNT ON "
				LSQL = LSQL & "	INSERT INTO [SD_Tennis].[dbo].[tblMember] (" 
				LSQL = LSQL & "		 SD_UserID"  
				LSQL = LSQL & "		,SD_GameIDSET "	
				LSQL = LSQL & "		,SportsType"  
				LSQL = LSQL & "		,UserName" 										
				LSQL = LSQL & "		,Job" 
				LSQL = LSQL & "		,Interest" 
				LSQL = LSQL & "		,PlayerReln "
				LSQL = LSQL & "		,EnterType " 
				LSQL = LSQL & "		,SrtDate"  
				LSQL = LSQL & "		,WriteDate"  					
				LSQL = LSQL & "		,DelYN "  	
				LSQL = LSQL & "	) VALUES(" 
				LSQL = LSQL & "		'"  & valID			& "'" 
				LSQL = LSQL & "		,'" & valIDSET		& "'" 
				LSQL = LSQL & "		,'" & SportsType 	& "'" 
				LSQL = LSQL & "		,'" & UserName 		& "'" 
				LSQL = LSQL & "		,'" & Job 			& "'" 
				LSQL = LSQL & "		,'" & Interest 		& "'" 
				LSQL = LSQL & "		,'" & valType 		& "'" 
				LSQL = LSQL & "		,'" & EnterType 	& "'" 
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
	
				Response.Write "TRUE|"
			End IF

		Else
			Response.Write "FALSE|200"
			response.end
		End IF
			CRs.Close
		SET CRs = Nothing
			 
		
		DBClose3()
		
	End IF 

%>