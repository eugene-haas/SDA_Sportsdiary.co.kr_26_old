<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================================
	'생활체육 회원가입 페이지
	'EnterType = A		
	'선수 PlayerReln = R, 지도자 PlayerReln = T   	
	'==============================================================================================
	dim UserID 			: UserID 			= fInject(trim(Request.Cookies("SD")("UserID")))
	dim UserName 		: UserName 			= fInject(trim(Request.Cookies("SD")("UserName")))
	dim UserBirth 		: UserBirth 		= fInject(trim(Request.Cookies("SD")("UserBirth")))
	 
	dim BloodType 		: BloodType 		= fInject(Request("BloodType"))
	dim PlayerStartYear : PlayerStartYear 	= fInject(Request("PlayerStartYear"))
	dim PlayerTall	 	: PlayerTall 		= fInject(Request("PlayerTall"))
	dim PlayerWeight 	: PlayerWeight 		= fInject(Request("PlayerWeight"))
	
	dim SportsType	 	: SportsType 		= fInject(Request("SportsType"))		'종목구분
	dim EnterType	 	: EnterType 		= fInject(Request("EnterType"))			'회원구분[E:엘리트 | A:아마추어] 
	dim PlayerReln 		: PlayerReln 		= fInject(Request("PlayerReln"))		'회원구분[A,B,Z:선수보호자 | T:팀매니저 | D:일반회원 | R:선수]	
	dim Team 			: Team				= fInject(Request("Team"))				'소속팀
	dim Team2 			: Team2				= fInject(Request("Team2"))				'소속팀2
	dim TeamNm 			: TeamNm			= fInject(Request("TeamNm"))			'소속팀명
	dim TeamNm2 		: TeamNm2			= fInject(Request("TeamNm2"))			'소속팀명2	
	dim LeaderType	 	: LeaderType 		= fInject(Request("LeaderType"))		'지도자구분[5:관장 | 6:사범 | 7:지도자(기타)]
	dim PlayerIDX	 	: PlayerIDX 		= decode(fInject(Request("PlayerIDX")) ,0)		'선수IDX tblPlayer [PlayerIDX]
	
	'테니스스킬정보
	dim HandUse	 		: HandUse 			= fInject(Request("HandUse"))
	dim PositionReturn	: PositionReturn 	= fInject(Request("PositionReturn"))
	dim HandType	 	: HandType 			= fInject(Request("HandType"))
	dim Skill	 		: Skill 			= fInject(Request("Skill"))
	
	'레슨정보
	dim LessonArea	 	: LessonArea 		= fInject(Request("LessonArea"))
	dim LessonArea2		: LessonArea2 		= fInject(Request("LessonArea2"))
	dim LessonAreaDt	: LessonAreaDt 		= fInject(Request("LessonAreaDt"))
	dim CourtNm	 		: CourtNm 			= fInject(Request("CourtNm"))
	dim ShopNm	 		: ShopNm 			= fInject(Request("ShopNm"))
		
	
	dim CSQL, CRs, LSQL, LRs, JRs, JSQL
	dim PersonCode, PersonNum		
	dim PlyaerIDX, LeaderIDX	'각 지도자|선수 IDX
	dim LeaderTypeNm			'지도자 타입명
	dim Birthday				'tblLeader 입력타입 형식 변경하기 위한 변수 ex)2017-01-01 
	dim i, bufNum
	dim SD_GameIDSET, txt_MemberIDX			'종목메인설정 값 [Y | N]
	
	IF UserName = "" OR UserBirth = "" OR SportsType = "" OR EnterType = "" OR PlayerReln = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		On Error Resume Next
			
		DBcon3.BeginTrans()
		
		'=====================================================================================================	
		'SD_Tennis.dbo.tblLeader 지도자테이블 등록
		'=====================================================================================================
		SUB MAKE_INFO_LEADER()
			
			'지도자 테이블[tblLeader] PersonNum 값 조회			
			LSQL = "		SELECT TOP 1 PersonNum "
			LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblLeader]"						
			LSQL = LSQL & " WHERE PersonNum like 'A%'"						
			LSQL = LSQL & " ORDER BY LeaderIDX DESC"
			
'			response.Write "LSQL=" & LSQL&"<br>"
			
			SET LRs = DBCon3.Execute(LSQL)	
			IF LRs.Eof OR LRs.Bof Then
				'지도자 체육인번호 
				PersonNum = "A" & Right(Year(Date()),2) & "T" & "00000001"							
			Else
				'ex) A17T00000012
				'A17T을 제외한 나머지 숫자에 1을 더한 숫자의 자리수와 A17T의 자리수(4)를 뺀 자릿수 만큼 0을 붙인다
				For i = 1 to Len(LRs(0)) - len(Mid(LRs(0), 5, Len(LRs(0))) + 1) - 4
					bufNum = bufNum & "0"
				Next
				
				'A17T 이후의 숫자에 1을 더한 수를 구한 후 만든 0의 자리수를 붙인다
				bufNum = bufNum&Mid(LRs(0), 5, Len(LRs(0))) + 1
				
				'A + 년도(2자리) + T + bufNum
				PersonNum =  "A" & Right(Year(Date()),2) & "T" & bufNum
				
			End IF				
				LRs.Close
			SET LRs = Nothing
			
'			response.Write "PersonNum=" & PersonNum&"<br>"
			
			'===============================================================================================	
			'4. 지도자 타입명 조회
			'===============================================================================================	
			IF LeaderType <> "" Then
				LSQL = "		SELECT PubName "
				LSQL = LSQL & " FROM [SD_Tennis].[dbo].[tblPubCode]"						
				LSQL = LSQL & " WHERE DelYN = 'N' "
				LSQL = LSQL & "		AND SportsGb = '" & SportsType & "' "
				LSQL = LSQL & "		AND EnterType = 'A'"				
				LSQL = LSQL & "		AND PPubCode = 'sd039'"
				LSQL = LSQL & "		AND PubCode = '" & LeaderType & "'"

				SET LRs = DBCon3.Execute(LSQL)
				IF Not(LRs.Eof OR LRs.Bof) Then							
					LeaderTypeNm = LRs("PubName")								
				END IF
					LRs.Close
				SET LRs = Nothing
			End IF

			
			'Birthday 입력형식 변환 ex)2012-01-01
			IF UserBirth <> "" Then
				Birthday = DateSerial(left(UserBirth, 4), mid(UserBirth, 5, 2), right(UserBirth, 2))							
			End IF
			'===============================================================================================	
			'지도자테이블[tblLeader] 등록
			'===============================================================================================
			LSQL =  "		SET NOCOUNT ON "
			LSQL = LSQL & "	INSERT INTO [SD_Tennis].[dbo].[tblLeader] (" 
			LSQL = LSQL & "		[SportsGb]" 
			LSQL = LSQL & "		,[PersonNum]" 
			LSQL = LSQL & "		,[UserName]" 
			LSQL = LSQL & "		,[UserEnName]" 
			LSQL = LSQL & "		,[UserPhone]" 
			LSQL = LSQL & "		,[Email]" 
			LSQL = LSQL & "		,[Sex]" 
			LSQL = LSQL & "		,[Birthday]" 
			LSQL = LSQL & "		,[LeaderRegistDt]" 
			LSQL = LSQL & "		,[Team]" 
			LSQL = LSQL & "		,[Team2]" 
			LSQL = LSQL & "		,[ZipCode]" 
			LSQL = LSQL & "		,[Address]" 
			LSQL = LSQL & "		,[AddressDtl]" 
			LSQL = LSQL & "		,[LeaderType]" 
			LSQL = LSQL & "		,[LeaderTypeNm]" 
			LSQL = LSQL & "		,[WriteDate]" 
			LSQL = LSQL & "		,[RegistYear]" 
			LSQL = LSQL & "		,[PKindCode]" 	
			LSQL = LSQL & "		,[DelYN]" 									
			LSQL = LSQL & "		,[NowRegYN]" 
			LSQL = LSQL & "	) VALUES( '" & SportsType 	& "'" 
			LSQL = LSQL & "		,'" & PersonNum 	& "'" 
			LSQL = LSQL & "		,'" & UserName 		& "'" 
			LSQL = LSQL & "		,'" & CRs("UserEnName") 	& "'" 
			LSQL = LSQL & "		,'" & CRs("UserPhone") 	& "'" 
			LSQL = LSQL & "		,'" & CRs("UserEmail") 	& "'" 
			LSQL = LSQL & "		,'" & Sex 			& "'" 
			LSQL = LSQL & "		,'" & Birthday 		& "'" 									
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,'" & Team 			& "'" 
			LSQL = LSQL & "		,'" & Team2 		& "'" 
			LSQL = LSQL & "		,'" & CRs("ZipCode") 		& "'" 
			LSQL = LSQL & "		,'" & CRs("Address") 		& "'" 
			LSQL = LSQL & "		,'" & CRs("AddressDtl") 	& "'" 	
			LSQL = LSQL & "		,'" & LeaderType 	& "'" 	
			LSQL = LSQL & "		,'" & LeaderTypeNm 	& "'" 	
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,'" & Year(Date())	&"'" 
			LSQL = LSQL & "		,'89'" 					'생활체육 TeamGb
			LSQL = LSQL & "		,'N'" 									
			LSQL = LSQL & "		,'Y'" 
			LSQL = LSQL & "	)"
			LSQL = LSQL & " SELECT @@IDENTITY"

			SET LRs = DBCon3.Execute(LSQL)	
			ErrorNum = ErrorNum + DBcon.Errors.Count	

			IF Not(LRs.Eof OR LRs.Bof) Then
				LeaderIDX = LRs(0)
			End IF
				LRs.Close
			SET LRs = Nothing
			
		END SUB
		'===============================================================================================
		'SD_Tennis.dbo.tblMember 회원테이블 등록
		'===============================================================================================
		SUB MAKE_INFO_USER(valID, valIDSET, valType)
		
			'tblMember 가입내역 조회		
			JSQL =  	" 	SELECT ISNULL(COUNT(*), 0) cnt " 
			JSQL = JSQL & " FROM [SD_Tennis].[dbo].[tblMember] "
			JSQL = JSQL & " WHERE DelYN = 'N' "
			JSQL = JSQL & "		AND SportsType = '" & SportsType & "'"
			JSQL = JSQL & "		AND EnterType = '" & EnterType & "'" 
			JSQL = JSQL & " 	AND PlayerReln = '" & valType & "'" 
			JSQL = JSQL & " 	AND SD_UserID = '" & valID & "'" 
			
			'지도자의 경우 소속팀 1개			
			IF valType = "T" THEN
				JSQL = JSQL & " AND Team = '" & Team & "'"  
			
			'선수의 경우 소속팀 2개 비교
			ELSE
				JSQL = JSQL & " AND Team = '" & Team & "'"  
				JSQL = JSQL & " AND Team2 = '" & Team2 & "'"  
			END IF
			
			SET JRs = DBCon3.Execute(JSQL)	
			IF JRs(0) > 0 Then
				Response.Write "FALSE|99"
				Response.End()
			Else
				LSQL = "		SET NOCOUNT ON "
				LSQL = LSQL & "	INSERT INTO [SD_Tennis].[dbo].[tblMember] (" 
				LSQL = LSQL & "		SD_UserID "
				LSQL = LSQL & "		,SD_GameIDSET "	
				LSQL = LSQL & "		,SportsType "
				LSQL = LSQL & "		,UserName " 										
				LSQL = LSQL & "		,BloodType " 
	
				SELECT CASE valType
					CASE "R" : LSQL = LSQL & "	,PlayerIDX " 							
					CASE "T" 
						LSQL = LSQL & "	,LeaderIDX " 	
						LSQL = LSQL & "	,LeaderType " 	
				END SELECT
	
				LSQL = LSQL & "		,PlayerStartYear " 
				LSQL = LSQL & "		,PlayerReln " 
				LSQL = LSQL & "		,EnterType "  					
				LSQL = LSQL & "		,Tall " 
				LSQL = LSQL & "		,Weight " 
				LSQL = LSQL & "		,Team "  
				LSQL = LSQL & "		,Team2 " 
				LSQL = LSQL & "		,TeamNm "  
				LSQL = LSQL & "		,TeamNm2 "  
				LSQL = LSQL & "		,HandUse "  
				LSQL = LSQL & "		,HandType "  
				LSQL = LSQL & "		,PositionReturn "  
				LSQL = LSQL & "		,Specialty "  
				LSQL = LSQL & "		,LessonArea "  
				LSQL = LSQL & "		,LessonArea2 "  
				LSQL = LSQL & "		,LessonAreaDt "  
				LSQL = LSQL & "		,CourtNm "  
				LSQL = LSQL & "		,ShopNm "  			
				LSQL = LSQL & "		,SrtDate "  
				LSQL = LSQL & "		,WriteDate "  					
				LSQL = LSQL & "		,DelYN "  					
				LSQL = LSQL & "	) VALUES("
				LSQL = LSQL & "		'" & valID			& "'" 
				LSQL = LSQL & "		,'" & valIDSET		& "'" 	'종목메인 계정설정	
				LSQL = LSQL & "		,'" & SportsType	& "'"
				LSQL = LSQL & "		,'" & UserName 		& "'" 
				LSQL = LSQL & "		,'" & BloodType 	& "'" 
				
				SELECT CASE valType
					CASE "R" : LSQL = LSQL & ",'" & PlayerIDX & "'" 						
					CASE "T" 
						LSQL = LSQL & ",'" & LeaderIDX 		& "'" 
						LSQL = LSQL & ",'" & LeaderType		& "'" 
				END SELECT
				
				LSQL = LSQL & "		,'" & PlayerStartYear 	& "'" 
				LSQL = LSQL & "		,'" & valType	 		& "'" 	'PlayerReln
				LSQL = LSQL & "		,'" & EnterType 		& "'" 
				LSQL = LSQL & "		,'" & PlayerTall 		& "'" 
				LSQL = LSQL & "		,'" & PlayerWeight 		& "'" 
				LSQL = LSQL & "		,'" & Team			 	& "'" 
				LSQL = LSQL & "		,'" & Team2		 		& "'" 
				LSQL = LSQL & "		,'" & TeamNm		 	& "'" 
				LSQL = LSQL & "		,'" & TeamNm2			& "'" 
				LSQL = LSQL & "		,'" & HandUse			& "'" 
				LSQL = LSQL & "		,'" & HandType			& "'" 
				LSQL = LSQL & "		,'" & PositionReturn	& "'" 			
				LSQL = LSQL & "		,'" & Skill				& "'" 
				LSQL = LSQL & "		,'" & LessonArea		& "'" 
				LSQL = LSQL & "		,'" & LessonArea2		& "'" 
				LSQL = LSQL & "		,'" & LessonAreaDt		& "'" 
				LSQL = LSQL & "		,'" & CourtNm			& "'" 
				LSQL = LSQL & "		,'" & ShopNm			& "'" 
				LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,'N'"
				LSQL = LSQL & "	)"
				LSQL = LSQL & " SELECT @@IDENTITY"

		'		response.Write "LSQL=" & LSQL&"<br>"	
				
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
		'===============================================================================================
		
		'SD_Member.dbo.tblMember 가입내역 조회		
		CSQL =  	  " SELECT * "
		CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND UserID = '" & UserID & "'"  	
		
'		response.Write "CSQL=" & CSQL&"<br>"
						
		SET CRs = DBcon3.Execute(CSQL)	
		IF Not(CRs.eof or CRs.Bof) Then

			'지도자 테이블 정보 등록
			IF PlayerReln = "T" Then
				CALL MAKE_INFO_LEADER()	
			End IF	
			
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
			response.write "FALSE|200"
			response.end
		End IF
			CRs.Close
		SET CRs = Nothing


		DBClose3()
		
	End If 

%>