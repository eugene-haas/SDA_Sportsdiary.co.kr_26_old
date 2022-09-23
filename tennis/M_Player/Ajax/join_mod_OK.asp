<!--#include file="../Library/ajax_config.asp"-->
<%
	'===========================================================================================
	'회원정보 수정페이지
	'===========================================================================================
	'Check_Login()
	
	dim Cookie_SDMemberIDX: Cookie_SDMemberIDX	= fInject(Request("Cookie_SDMemberIDX"))			
	dim MemberIDX	 	: MemberIDX 		= fInject(Request("MemberIDX"))		
	dim PlayerIDX 		: PlayerIDX 		= fInject(Request("PlayerIDX"))			
	dim UserEnName 		: UserEnName   		= ReplaceTagText(fInject(Request("UserEnName")))
	dim UserPhone 		: UserPhone 		= fInject(Request("UserPhone"))
	dim UserEmail 		: UserEmail 		= ReplaceTagText(fInject(Request("UserEmail")))
	dim UserAddr 		: UserAddr 			= ReplaceTagText(fInject(Request("UserAddr")))
	dim UserAddrDtl 	: UserAddrDtl 		= ReplaceTagText(fInject(Request("UserAddrDtl")))
	dim BloodType 		: BloodType 		= fInject(Request("BloodType"))
	dim ZipCode 		: ZipCode 			= fInject(Request("ZipCode"))	
	dim PlayerStartYear : PlayerStartYear 	= fInject(Request("PlayerStartYear"))
	dim PlayerTall 		: PlayerTall 		= fInject(Request("PlayerTall"))
	dim PlayerWeight 	: PlayerWeight 		= fInject(Request("PlayerWeight"))
	dim SmsYn 			: SmsYn 			= fInject(Request("SmsYn"))			'휴대폰 수신동의
	dim EmailYn 		: EmailYn 			= fInject(Request("EmailYn"))		'이메일 수신동의
	dim Hidden_SmsYn 	: Hidden_SmsYn 		= fInject(Request("Hidden_SmsYn"))	'Old 휴대폰 수신동의
	dim Hidden_EmailYn 	: Hidden_EmailYn	= fInject(Request("Hidden_EmailYn"))'Old 이메일 수신동의		
	dim PlayerReln 		: PlayerReln 		= fInject(Request("PlayerReln"))	
	dim Job		 		: Job		 		= fInject(Request("Job"))			'직업군
	dim Interest 		: Interest 			= fInject(Request("Interest"))		'관심분야
	dim LeaderType 		: LeaderType 		= fInject(Request("LeaderType"))	'팀매니저 타입
	dim Team 			: Team 				= fInject(Request("Team"))
	dim Team2 			: Team2 			= fInject(Request("Team2"))
	dim TeamNm 			: TeamNm 			= fInject(Request("TeamNm"))
	dim TeamNm2 		: TeamNm2 			= fInject(Request("TeamNm2"))
	dim HandUse 		: HandUse 			= fInject(Request("HandUse"))
	dim PositionReturn	: PositionReturn 	= fInject(Request("PositionReturn"))
	dim HandType 		: HandType 			= fInject(Request("HandType"))
	dim Specialty 		: Specialty 		= fInject(Request("Specialty"))
	dim LessonArea 		: LessonArea 		= fInject(Request("LessonArea"))
	dim LessonArea2 	: LessonArea2 		= fInject(Request("LessonArea2"))
	dim LessonAreaDt 	: LessonAreaDt 		= fInject(Request("LessonAreaDt"))
	dim CourtNm 		: CourtNm 			= fInject(Request("CourtNm"))
	dim ShopNm 			: ShopNm 			= fInject(Request("ShopNm"))	

						
	'PubCode  ex)sd039001[PlayerGb:선수], sd045001[PlayerType:내국인]
	
  
	dim LSQL, LRs, JSQL
	
	If Cookie_SDMemberIDX = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
	
		On Error Resume Next
			
		DBcon3.BeginTrans()
		
		
		'tblMember 가입내역 조회		
		LSQL = "		SELECT * "
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember] "
		LSQL = LSQL & " WHERE DelYN = 'N'"		
		LSQL = LSQL & " 	AND MemberIDX = '" & Cookie_SDMemberIDX & "' "
		
'		response.Write LSQL & "<br>"
		
		SET LRs = DBCon3.Execute(LSQL)	
		IF LRs.eof or LRs.bof Then
			response.Write "FALSE|99"
			response.End()
		Else
	
			JSQL = "		UPDATE [SD_Member].[dbo].[tblMember] " 
			JSQL = JSQL & " SET UserEnName = '" & UserEnName & "'" 
			JSQL = JSQL & "		,UserPhone = '" & UserPhone & "'" 
			JSQL = JSQL & "		,Email = '" & UserEmail & "'"  
			JSQL = JSQL & "		,Address = '" & UserAddr & "'" 
			JSQL = JSQL & "		,AddressDtl = '" & UserAddrDtl & "'" 
			JSQL = JSQL & "		,ZipCode = '" & ZipCode & "'" 
			
			IF SmsYn <> Hidden_SmsYn Then
				JSQL = JSQL & "	,SmsYn = '" & SmsYn & "'"  					
				JSQL = JSQL & "	,SmsYnDt = '" &  replace(left(now(),10),"-","") & "'"  					
			End IF
			
			IF EmailYn <> Hidden_EmailYn Then
				JSQL = JSQL & "	,EmailYn = '" & EmailYn & "'"  
				JSQL = JSQL & "	,EmailYnDt = '"& replace(left(now(),10),"-","") & "'"  					
			End IF
			
			JSQL = JSQL & "		,ModDate = GETDATE() "  					
			JSQL = JSQL & " WHERE MemberIDX = '" & Cookie_SDMemberIDX & "' " 			
			
			DBCon3.Execute(JSQL)	
			ErrorNum = ErrorNum + DBCon3.Errors.Count
			'===============================================================================
			
            IF MemberIDX <> "" Then

                SELECT CASE PlayerReln
                    '일반회원(PlayerReln = D)
                    CASE "D"		
                        JSQL = "		UPDATE [SD_tennis].[dbo].[tblMember] " 
                        JSQL = JSQL & " SET Job = '" & Job & "'" 
                        JSQL = JSQL & "		,Interest = '" & Interest & "'" 
                        JSQL = JSQL & "		,WriteDate = GETDATE() "  
                        JSQL = JSQL & " WHERE MemberIDX = '" & MemberIDX & "' " 

                        DBCon3.Execute(JSQL)	
                        ErrorNum = ErrorNum + DBCon3.Errors.Count

                    CASE "R","K","S"
                        JSQL = "		UPDATE [SD_tennis].[dbo].[tblMember] " 
                        JSQL = JSQL & " SET BloodType = '" & BloodType & "'" 
                        JSQL = JSQL & "		,PlayerStartYear = '" & PlayerStartYear & "'" 
                        JSQL = JSQL & "		,Tall = '" & PlayerTall & "'" 
                        JSQL = JSQL & "		,Weight = '" & PlayerWeight & "'" 
                        JSQL = JSQL & "		,Specialty = '" & Specialty & "'" 
                        JSQL = JSQL & "		,HandUse = '" & HandUse & "'" 
                        JSQL = JSQL & "		,HandType = '" & HandType & "'" 
                        JSQL = JSQL & "		,PositionReturn = '" & PositionReturn & "'" 
                        JSQL = JSQL & "		,Team = '" & Team & "'" 
                        JSQL = JSQL & "		,Team2 = '" & Team2 & "'" 
                        JSQL = JSQL & "		,TeamNm = '" & TeamNm & "'" 
                        JSQL = JSQL & "		,TeamNm2 = '" & TeamNm2 & "'" 
                        JSQL = JSQL & "		,WriteDate = GETDATE() "  			
                        JSQL = JSQL & " WHERE MemberIDX = '" & MemberIDX & "' " 

                        DBCon3.Execute(JSQL)	
                        ErrorNum = ErrorNum + DBCon3.Errors.Count

                    '생활체육((EnterType = A)) 팀매니저 타입	
                    CASE "T"	
                        JSQL = "		UPDATE [SD_tennis].[dbo].[tblMember] " 
                        JSQL = JSQL & " SET LeaderType = '" & LeaderType & "'"  
                        JSQL = JSQL & "		,BloodType = '" & BloodType & "'" 
                        JSQL = JSQL & "		,PlayerStartYear = '" & PlayerStartYear & "'" 
                        JSQL = JSQL & "		,Tall = '" & PlayerTall & "'" 
                        JSQL = JSQL & "		,Weight = '" & PlayerWeight & "'" 
                        JSQL = JSQL & "		,Team = '" & Team & "'" 
                        JSQL = JSQL & "		,TeamNm = '" & TeamNm & "'" 
                        JSQL = JSQL & "		,LessonArea = '" & LessonArea & "'" 
                        JSQL = JSQL & "		,LessonArea2 = '" & LessonArea2 & "'" 
                        JSQL = JSQL & "		,LessonAreaDt = '" & LessonAreaDt & "'" 
                        JSQL = JSQL & "		,CourtNm = '" & CourtNm & "'" 
                        JSQL = JSQL & "		,ShopNm = '" & ShopNm & "'" 
                        JSQL = JSQL & "		,WriteDate = GETDATE() "  					
                        JSQL = JSQL & " WHERE MemberIDX = '" & MemberIDX & "' " 

                        DBCon3.Execute(JSQL)	
                        ErrorNum = ErrorNum + DBCon3.Errors.Count

                END SELECT		

            End IF
			'========================================================									

			IF ErrorNum > 0 Then
				DBCon3.RollbackTrans()				
				Response.Write "FALSE|66"				
			Else					
				DBCon3.CommitTrans()				
				Response.Write "TRUE|"
			End IF

		End IF
			LRs.Close
		SET LRs = Nothing
		
		DBClose3()
		
	End If 

%>