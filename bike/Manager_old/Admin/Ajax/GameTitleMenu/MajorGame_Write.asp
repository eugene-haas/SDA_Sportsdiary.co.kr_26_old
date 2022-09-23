<!--#include file="../../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'주요국제대회 정보 저장
	'==============================================================================================
	Check_AdminLogin()
	
	dim fnd_Division 	: fnd_Division 	= fInject(trim(request("fnd_Division")))
	dim fnd_MajorGame 	: fnd_MajorGame = fInject(trim(request("fnd_MajorGame")))
	dim fnd_MajorCub 	: fnd_MajorCub 	= fInject(trim(request("fnd_MajorCub")))
	dim GameYear 		: GameYear 		= fInject(trim(request("GameYear")))
	dim GamePlace 		: GamePlace 	= HtmlSpecialChars(fInject(trim(request("GamePlace")))) 	 
	dim Contents 		: Contents	 	= Replace(trim(request("Contents")),"'","&#039;")
	dim CIDX 			: CIDX 			= crypt.DecryptStringENC(fInject(trim(request("CIDX"))))
	dim valType 		: valType 		= fInject(trim(request("valType")))
	dim UserID 			: UserID 		= crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))	 
																									
																									
	
	'일부컨텐츠 1개만 등록																									
	FUNCTION CHK_REG_INFO(valType, valType2)
		dim CSearch, CSearch2
							
		IF fnd_MajorCub <> "" Then 	CSearch = " AND GameTypeSub = '"&fnd_MajorCub&"'"
		IF GameYear <> "" Then 	CSearch2 = " AND GameYear = '"&GameYear&"'"																					 
																			 
		IF valType = "INTL" Then
						   
			LSQL = "		SELECT ISNULL(COUNT(*), 0) cnt"
			LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblMajorGameInfo] "
			LSQL = LSQL & "	WHERE delYN = 'N'"
			LSQL = LSQL & "		AND Division = '"&valType&"'"
			LSQL = LSQL & "		AND GameType = '"&valType2&"'"&CSearch

			SET LRs = DBCon.Execute(LSQL)
			IF LRs(0) = 0 Then
				CHK_REG_INFO = TRUE
			Else					
				CHK_REG_INFO = FALSE
			End IF															  
		Else	
			LSQL = "		SELECT ISNULL(COUNT(*), 0) cnt"
			LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblMajorGameInfo] "
			LSQL = LSQL & "	WHERE delYN = 'N'"
			LSQL = LSQL & "		AND Division = '"&valType&"'"
			LSQL = LSQL & "		AND GameType = '"&valType2&"'"&CSearch2

			SET LRs = DBCon.Execute(LSQL)
			IF LRs(0) = 0 Then
				CHK_REG_INFO = TRUE
			Else					
				CHK_REG_INFO = FALSE
			End IF														  
		End IF				   
						   							
	END FUNCTION
															  
															  
																									
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		
		SELECT CASE valType			
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblMajorGameInfo] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND MajorGameIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then											 
																				 
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblMajorGameInfo]" 
						LSQL =  LSQL & " SET DelYN = 'Y'"
						LSQL =  LSQL & "	,ModDate = GETDATE()"						
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE MajorGameIDX = '" & CIDX & "'"

						DBCon.Execute(LSQL)

						IF DBCon.Errors.Count > 0 Then
							response.Write "FALSE|66"
							response.End()
						Else
							response.Write "TRUE|70"
							response.End()
						End IF
					Else
						response.Write "FALSE|99"
						response.End()
					End IF
						
				Else
					response.Write "FALSE|200"
					response.End()
				End IF
				
				
			CASE "MOD"
		
				IF CIDX <> "" Then
				
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblMajorGameInfo] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND MajorGameIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblMajorGameInfo] " 
						LSQL =  LSQL & " SET Division = '" & fnd_Division & "'"
						LSQL =  LSQL & "	,GameYear = '" & GameYear & "'"
						LSQL =  LSQL & "	,GamePlace = '" & GamePlace & "'"																		   
						LSQL =  LSQL & "	,GameType = '" & fnd_MajorGame & "'"
						LSQL =  LSQL & "	,GameTypeSub = '" & fnd_MajorCub & "'"
						LSQL =  LSQL & "	,Contents = '" & Contents & "'"
						LSQL =  LSQL & "	,ModDate = GETDATE()"
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE MajorGameIDX = '" & CIDX & "'"
						
						DBCon.Execute(LSQL)
						
						IF DBCon.Errors.Count > 0 Then
							response.Write "FALSE|66"
							response.End()
						Else
							response.Write "TRUE|80"
							response.End()
						End IF
					
					Else
						response.Write "FALSE|99"
						response.End()
					End IF
						
				Else
					response.Write "FALSE|200"
					response.End()
				End IF
				
				
			CASE "SAVE"
				
				IF CHK_REG_INFO(fnd_Division, fnd_MajorGame) = TRUE Then
					   
					LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblMajorGameInfo] (" 
					LSQL =  LSQL & "	Division "  
					LSQL =  LSQL & "	,GameType "
					LSQL =  LSQL & "	,GameTypeSub "
					LSQL =  LSQL & "	,GameYear "  
					LSQL =  LSQL & "	,GamePlace "  							   
					LSQL =  LSQL & "	,Contents" 			
					LSQL =  LSQL & "	,DelYN "  					
					LSQL =  LSQL & "	,InsDate "  					
					LSQL =  LSQL & "	,ModDate "  					
					LSQL =  LSQL & "	,InsId "  					
					LSQL =  LSQL & ") VALUES( " 
					LSQL =  LSQL & "	'" & fnd_Division & "'" 
					LSQL =  LSQL & "	,'" & fnd_MajorGame & "'" 
					LSQL =  LSQL & "	,'" & fnd_MajorCub & "'" 
					LSQL =  LSQL & "	,'" & GameYear & "'" 
					LSQL =  LSQL & "	,'" & GamePlace & "'" 									
					LSQL =  LSQL & "	,'" & Contents & "'" 				
					LSQL =  LSQL & "	,'N'" 
					LSQL =  LSQL & "	,GETDATE()" 
					LSQL =  LSQL & "	,GETDATE()" 
					LSQL =  LSQL & "	,'" & UserID & "'" 
					LSQL =  LSQL & ")"				

					DBCon.Execute(LSQL)

					IF DBCon.Errors.Count > 0 Then
						response.Write "FALSE|66"
						response.End()
					Else
						response.Write "TRUE|90"
						response.End()
					End IF
				Else
					response.Write "FALSE|33"
					response.End()							
				End IF
												
		END SELECT
			
	End IF 
%>