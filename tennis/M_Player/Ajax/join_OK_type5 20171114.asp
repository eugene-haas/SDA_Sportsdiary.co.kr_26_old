<!--#include file="../Library/ajax_config.asp"-->
<%
	'==============================================================================================
	'생활체육 회원가입 페이지
	'EnterType = A		
	'선수 PlayerReln = R, 지도자 PlayerReln = T
	'==============================================================================================
	dim UserID 			: UserID 			= fInject(trim(Request("UserID")))
	dim UserPass 		: UserPass 			= fInject(trim(Request("UserPass")))		
	dim UserName 		: UserName 			= fInject(trim(Request("UserName")))
	dim UserBirth 		: UserBirth 		= fInject(trim(Request("UserBirth")))
	dim UserEnName 		: UserEnName   		= fInject(trim(Request("UserEnName")))
	dim UserPhone 		: UserPhone 		= fInject(trim(Request("UserPhone")))
	dim UserEmail 		: UserEmail 		= ReplaceTagText(fInject(trim(Request("UserEmail"))))
	dim UserAddr 		: UserAddr 			= ReplaceTagText(fInject(trim(Request("UserAddr"))))
	dim UserAddrDtl 	: UserAddrDtl 		= ReplaceTagText(fInject(trim(Request("UserAddrDtl"))))
	dim SEX 			: SEX 				= fInject(Request("SEX"))	
	dim ZipCode 		: ZipCode 			= fInject(Request("ZipCode"))	
	dim SmsYn 			: SmsYn 			= fInject(Request("SmsYn"))				'휴대폰 수신동의
	dim EmailYn 		: EmailYn 			= fInject(Request("EmailYn"))			'이메일 수신동의	
	
	dim BloodType 		: BloodType 		= fInject(Request("BloodType"))
	dim PlayerStartYear : PlayerStartYear 	= fInject(Request("PlayerStartYear"))
	dim PlayerTall	 	: PlayerTall 		= fInject(Request("PlayerTall"))
	dim PlayerWeight 	: PlayerWeight 		= fInject(Request("PlayerWeight"))
	dim PlayerReln 		: PlayerReln 		= fInject(Request("PlayerReln"))		'회원구분[A,B,Z:선수보호자 | T:팀매니저 | D:일반회원 | R:선수]	
	dim Team 			: Team				= fInject(Request("Team"))				'소속팀
	dim Team2 			: Team2				= fInject(Request("Team2"))				'소속팀2
	dim TeamNm 			: TeamNm			= fInject(Request("TeamNm"))			'소속팀명
	dim TeamNm2 		: TeamNm2			= fInject(Request("TeamNm2"))			'소속팀명2
	dim SportsType	 	: SportsType 		= fInject(Request("SportsType"))		'종목구분
	dim EnterType	 	: EnterType 		= fInject(Request("EnterType"))			'회원구분[E:엘리트 | A:아마추어]
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
		
	
	dim CSQL, CRs, LSQL, LRs, JRs
	dim PersonCode, PersonNum		
	dim PlyaerIDX, LeaderIDX	'각 지도자|선수 IDX
	dim LeaderTypeNm			'지도자 타입명
	dim Birthday				'tblLeader 입력타입 형식 변경하기 위한 변수 ex)2017-01-01 
	dim i, bufNum

	
	IF UserID = "" OR UserPass = "" OR PlayerReln = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		On Error Resume Next
			
		DBcon3.BeginTrans()
		
		'tblMember 가입내역 조회		
		CSQL =  	  " SELECT UserID"
		CSQL = CSQL & " FROM [SD_Member].[dbo].[tblMember] "
		CSQL = CSQL & " WHERE DelYN = 'N' "
		CSQL = CSQL & "		AND UserName = '" & UserName & "'"  	
		CSQL = CSQL & "		AND Birthday = '" & UserBirth & "'" 
		
'		response.Write "CSQL=" & CSQL&"<br>"
						
		SET CRs = DBcon3.Execute(CSQL)	
		IF Not(CRs.eof or CRs.Bof) Then
			'Response.Write "FALSE|99"
			'서브계정생성
			'=====================================================================================================	
			'지도자테이블[tblLeader] 등록
			'=====================================================================================================	
			IF PlayerReln = "T" Then

				'===============================================================================================
				'지도자 테이블[tblLeader] PersonNum 값 조회
				'===============================================================================================
				LSQL = "		SELECT ISNULL(MAX(PersonNum), '') PersonNum "
				LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblLeader]"						
				LSQL = LSQL & " WHERE PersonNum like 'A%'"						
				
'						response.Write "LSQL=" & LSQL&"<br>"
				
				SET LRs = DBCon3.Execute(LSQL)	
				IF LRs(0) = "" Then
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
				
'						response.Write "PersonNum=" & PersonNum&"<br>"
				
				'===============================================================================================	
				'지도자 타입
				'SELECT *
				'FROM tblPubCode
				'WHERE SportsGb = 'tennis' AND DelYN = 'N' AND PubCode LIKE 'sd039%' AND EnterType = 'A'
				'===============================================================================================	
				IF LeaderType <> "" Then
					SELECT CASE LeaderType
						CASE 2 : LeaderTypeNm = "감독"
						CASE 3 : LeaderTypeNm = "코치"
						CASE 4 : LeaderTypeNm = "지도자(기타)"
					END SELECT	
				End IF
				
				'Birthday 입력형식 변환 ex)2012-01-01
				IF UserBirth <> "" Then
					Birthday = DateSerial(left(UserBirth, 4), mid(UserBirth, 5, 2), right(UserBirth, 2))							
				End IF
				'===============================================================================================	
				'지도자테이블[tblLeader] 등록
				'===============================================================================================
				LSQL =  "		INSERT INTO [SD_tennis].[dbo].[tblLeader] (" 
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
				LSQL = LSQL & "		,'" & UserEnName 	& "'" 
				LSQL = LSQL & "		,'" & UserPhone 	& "'" 
				LSQL = LSQL & "		,'" & UserEmail 	& "'" 
				LSQL = LSQL & "		,'" & Sex 			& "'" 
				LSQL = LSQL & "		,'" & Birthday 		& "'" 									
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,'" & Team 			& "'" 
				LSQL = LSQL & "		,'" & Team2 		& "'" 
				LSQL = LSQL & "		,'" & ZipCode 		& "'" 
				LSQL = LSQL & "		,'" & UserAddr 		& "'" 
				LSQL = LSQL & "		,'" & UserAddrDtl 	& "'" 	
				LSQL = LSQL & "		,'" & LeaderType 	& "'" 	
				LSQL = LSQL & "		,'" & LeaderTypeNm 	& "'" 	
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,'" & Year(Date())	&"'" 
				LSQL = LSQL & "		,'89'" 					'생활체육 TeamGb
				LSQL = LSQL & "		,'N'" 									
				LSQL = LSQL & "		,'Y'" 
				LSQL = LSQL & "	)"
				
'response.Write "LSQL=" & LSQL&"<br>"
					
				DBCon3.Execute(LSQL)	
				ErrorNum = ErrorNum + DBCon3.Errors.Count
				
'						response.Write "ErrorNum=" & ErrorNum&"<br>"	
				'===============================================================================================
				'지도자 테이블 최종 LeaderIDX 값 조회
				'===============================================================================================
				LSQL = "		SELECT MAX(LeaderIDX) "
				LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblLeader]"	
				
'						response.Write "LSQL=" & LSQL&"<br>"	
									
				SET LRs = DBCon3.Execute(LSQL)	
					LeaderIDX = LRs(0)
				'===============================================================================================

			END IF
			
			'=====================================================================================================	
			'SD_tennis.dbo.tblMember 회원테이블 등록
			'=====================================================================================================	
			LSQL =  "		INSERT INTO [SD_tennis].[dbo].[tblMember] (" 
			LSQL = LSQL & "		SportsType "
			LSQL = LSQL & "		,UserName " 										
			LSQL = LSQL & "		,BloodType " 

			SELECT CASE PlayerReln
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
			LSQL = LSQL & "	) VALUES('" & SportsType & "'" 
			LSQL = LSQL & "		,'" & UserName 		& "'" 
			LSQL = LSQL & "		,'" & BloodType 	& "'" 
			
			SELECT CASE PlayerReln
				CASE "R" : LSQL = LSQL & ",'" & PlayerIDX & "'" 						
				CASE "T" 
					LSQL = LSQL & ",'" & LeaderIDX 		& "'" 
					LSQL = LSQL & ",'" & LeaderType		& "'" 
			END SELECT
			
			LSQL = LSQL & "		,'" & PlayerStartYear 	& "'" 
			LSQL = LSQL & "		,'" & PlayerReln 		& "'" 
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
			LSQL = LSQL & "		,'" & Specialty			& "'" 
			LSQL = LSQL & "		,'" & LessonArea		& "'" 
			LSQL = LSQL & "		,'" & LessonArea2		& "'" 
			LSQL = LSQL & "		,'" & LessonAreaDt		& "'" 
			LSQL = LSQL & "		,'" & CourtNm			& "'" 
			LSQL = LSQL & "		,'" & ShopNm			& "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,'N'"
			LSQL = LSQL & "	)"
			
	'		response.Write "LSQL=" & LSQL&"<br>"	
			
			DBCon3.Execute(LSQL)	
			ErrorNum = ErrorNum + DBCon3.Errors.Count	
			
'			response.Write "ErrorNum=" & ErrorNum&"<br>"
			
			If ErrorNum > 0 Then
				DBCon3.RollbackTrans()
				
				Response.Write "FALSE|66"
				
			Else	
				
				DBCon3.CommitTrans()
				
				Response.Write "TRUE|"
			End IF
			
			
			
		Else
			'신규계정생성
			
			'=====================================================================================================	
			'지도자테이블[tblLeader] 등록
			'=====================================================================================================	
			IF PlayerReln = "T" Then

				'===============================================================================================
				'지도자 테이블[tblLeader] PersonNum 값 조회
				'===============================================================================================
				LSQL = "		SELECT ISNULL(MAX(PersonNum), '') PersonNum "
				LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblLeader]"						
				LSQL = LSQL & " WHERE PersonNum like 'A%'"						
				
'						response.Write "LSQL=" & LSQL&"<br>"
				
				SET LRs = DBCon3.Execute(LSQL)	
				IF LRs(0) = "" Then
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
				
'						response.Write "PersonNum=" & PersonNum&"<br>"
				
				'===============================================================================================	
				'지도자 타입
				'SELECT *
				'FROM tblPubCode
				'WHERE SportsGb = 'tennis' AND DelYN = 'N' AND PubCode LIKE 'sd039%' AND EnterType = 'A'
				'===============================================================================================	
				IF LeaderType <> "" Then
					SELECT CASE LeaderType
						CASE 2 : LeaderTypeNm = "감독"
						CASE 3 : LeaderTypeNm = "코치"
						CASE 4 : LeaderTypeNm = "지도자(기타)"
					END SELECT	
				End IF
				
				'Birthday 입력형식 변환 ex)2012-01-01
				IF UserBirth <> "" Then
					Birthday = DateSerial(left(UserBirth, 4), mid(UserBirth, 5, 2), right(UserBirth, 2))							
				End IF
				'===============================================================================================	
				'지도자테이블[tblLeader] 등록
				'===============================================================================================
				LSQL =  "		INSERT INTO [SD_tennis].[dbo].[tblLeader] (" 
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
				LSQL = LSQL & "		,'" & UserEnName 	& "'" 
				LSQL = LSQL & "		,'" & UserPhone 	& "'" 
				LSQL = LSQL & "		,'" & UserEmail 	& "'" 
				LSQL = LSQL & "		,'" & Sex 			& "'" 
				LSQL = LSQL & "		,'" & Birthday 		& "'" 									
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,'" & Team 			& "'" 
				LSQL = LSQL & "		,'" & Team2 		& "'" 
				LSQL = LSQL & "		,'" & ZipCode 		& "'" 
				LSQL = LSQL & "		,'" & UserAddr 		& "'" 
				LSQL = LSQL & "		,'" & UserAddrDtl 	& "'" 	
				LSQL = LSQL & "		,'" & LeaderType 	& "'" 	
				LSQL = LSQL & "		,'" & LeaderTypeNm 	& "'" 	
				LSQL = LSQL & "		,GETDATE()" 
				LSQL = LSQL & "		,'" & Year(Date())	&"'" 
				LSQL = LSQL & "		,'89'" 					'생활체육 TeamGb
				LSQL = LSQL & "		,'N'" 									
				LSQL = LSQL & "		,'Y'" 
				LSQL = LSQL & "	)"
				
'response.Write "LSQL=" & LSQL&"<br>"
					
				DBCon3.Execute(LSQL)	
				ErrorNum = ErrorNum + DBCon3.Errors.Count
				
'						response.Write "ErrorNum=" & ErrorNum&"<br>"	
				'===============================================================================================
				'지도자 테이블 최종 LeaderIDX 값 조회
				'===============================================================================================
				LSQL = "		SELECT MAX(LeaderIDX) "
				LSQL = LSQL & " FROM [SD_tennis].[dbo].[tblLeader]"	
				
'						response.Write "LSQL=" & LSQL&"<br>"	
									
				SET LRs = DBCon3.Execute(LSQL)	
					LeaderIDX = LRs(0)
				'===============================================================================================

			END IF
			
			'=====================================================================================================	
			'SD_Member.dbo.tblMember 회원테이블 등록
			'=====================================================================================================	
			LSQL =  "		INSERT INTO [SD_Member].[dbo].[tblMember] (" 
			LSQL = LSQL & "		UserID "  
			LSQL = LSQL & "		,UserPass " 
			LSQL = LSQL & "		,UserName " 										
			LSQL = LSQL & "		,UserEnName " 
			LSQL = LSQL & "		,UserPhone " 
			LSQL = LSQL & "		,Birthday "  
			LSQL = LSQL & "		,Email " 
			LSQL = LSQL & "		,ZipCode " 
			LSQL = LSQL & "		,Address " 
			LSQL = LSQL & "		,AddressDtl " 
			LSQL = LSQL & "		,Sex " 				
			LSQL = LSQL & "		,EmailYn "  					
			LSQL = LSQL & "		,EmailYnDt "  					
			LSQL = LSQL & "		,SmsYn "  					
			LSQL = LSQL & "		,SmsYnDt "  									
			LSQL = LSQL & "		,WriteDate "  
			LSQL = LSQL & "		,ModDate "  					
			LSQL = LSQL & "		,DelYN "  					
			LSQL = LSQL & "	) VALUES(" 
			LSQL = LSQL & "		'" & UserID 		& "'" 
			LSQL = LSQL & "		,'" & UserPass 		& "'" 
			LSQL = LSQL & "		,'" & UserName 		& "'" 
			LSQL = LSQL & "		,'" & UserEnName 	& "'" 
			LSQL = LSQL & "		,'" & UserPhone 	& "'" 
			LSQL = LSQL & "		,'" & UserBirth 	& "'" 
			LSQL = LSQL & "		,'" & UserEmail 	& "'" 
			LSQL = LSQL & "		,'" & ZipCode 		& "'" 
			LSQL = LSQL & "		,'" & UserAddr 		& "'" 
			LSQL = LSQL & "		,'" & UserAddrDtl 	& "'" 
			LSQL = LSQL & "		,'" & SEX 			& "'" 
			LSQL = LSQL & "		,'" & EmailYn 			& "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,'" & SmsYn 			& "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,'N'"
			LSQL = LSQL & "	)"
			
'			response.Write "LSQL=" & LSQL&"<br>"
			
			DBCon3.Execute(LSQL)	
			ErrorNum = ErrorNum + DBCon3.Errors.Count	
			
			
			'=====================================================================================================	
			'SD_tennis.dbo.tblMember 회원테이블 등록
			'=====================================================================================================	
			LSQL =  "		INSERT INTO [SD_tennis].[dbo].[tblMember] (" 
			LSQL = LSQL & "		SD_UserID "
			LSQL = LSQL & "		,SD_GameIDSET "
			LSQL = LSQL & "		,SportsType "						
			LSQL = LSQL & "		,UserName " 										
			LSQL = LSQL & "		,BloodType " 

			SELECT CASE PlayerReln
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
			LSQL = LSQL & "		'" & UserID & "'" 	'통합아이디
			LSQL = LSQL & "		,'Y'" 				'종목메인 계정설정
			LSQL = LSQL & "		,'" & SportsType & "'" 
			LSQL = LSQL & "		,'" & UserName 		& "'" 
			LSQL = LSQL & "		,'" & BloodType 	& "'" 
			
			SELECT CASE PlayerReln
				CASE "R" : LSQL = LSQL & ",'" & PlayerIDX & "'" 						
				CASE "T" 
					LSQL = LSQL & ",'" & LeaderIDX 		& "'" 
					LSQL = LSQL & ",'" & LeaderType		& "'" 
			END SELECT
			
			LSQL = LSQL & "		,'" & PlayerStartYear 	& "'" 
			LSQL = LSQL & "		,'" & PlayerReln 		& "'" 
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
			LSQL = LSQL & "		,'" & Specialty			& "'" 
			LSQL = LSQL & "		,'" & LessonArea		& "'" 
			LSQL = LSQL & "		,'" & LessonArea2		& "'" 
			LSQL = LSQL & "		,'" & LessonAreaDt		& "'" 
			LSQL = LSQL & "		,'" & CourtNm			& "'" 
			LSQL = LSQL & "		,'" & ShopNm			& "'" 
			LSQL = LSQL & "		,'" & replace(left(now(),10),"-","") & "'" 
			LSQL = LSQL & "		,GETDATE()" 
			LSQL = LSQL & "		,'N'"
			LSQL = LSQL & "	)"
			
'			response.Write "LSQL=" & LSQL&"<br>"	
			
			DBCon3.Execute(LSQL)	
			ErrorNum = ErrorNum + DBCon3.Errors.Count	
			
'			response.Write "ErrorNum=" & ErrorNum&"<br>"
			
			If ErrorNum > 0 Then
				DBCon3.RollbackTrans()
				
				Response.Write "FALSE|66"
				
			Else	
				
				DBCon3.CommitTrans()
				
				Response.Write "TRUE|"
			End IF

		End IF
			CRs.Close
		SET CRs = Nothing
		
		DBClose3()
		
	End If 

%>