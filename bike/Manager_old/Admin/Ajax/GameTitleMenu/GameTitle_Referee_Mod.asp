<!--#include file="../../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'정보 저장
	'==============================================================================================
	Check_AdminLogin()

	dim UserID 		: UserID 		= crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))	
	dim valType 	: valType 		= fInject(trim(request("valType")))
	dim tIDX 		: tIDX 			= crypt.DecryptStringENC(fInject(trim(request("tIDX"))))
	dim CIDX 		: CIDX 			= crypt.DecryptStringENC(fInject(trim(request("CIDX"))))
	dim UserName 	: UserName 		= HtmlSpecialChars(fInject(trim(request("UserName"))))
	dim UserEnName 	: UserEnName 	= HtmlSpecialChars(fInject(trim(request("UserEnName"))))
	dim RefereeGb 	: RefereeGb 	= fInject(trim(request("RefereeGb"))) 
	dim Sex 		: Sex 			= fInject(trim(request("Sex"))) 
	dim Nationality : Nationality 	= fInject(trim(request("Nationality")))  
	
	IF valType = "" AND tIDX = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
									 
		SELECT CASE valType			
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitleReferee] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND GameTitleIDX = '" & tIDX & "'"
					LSQL =  LSQL & " 	AND GameRefereeIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then											 
																				 
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblGameTitleReferee]" 
						LSQL =  LSQL & " SET DelYN = 'Y'"
						LSQL =  LSQL & "	,ModDate = GETDATE()"						
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE GameTitleIDX = '" & tIDX & "'"
						LSQL =  LSQL & " 	AND GameRefereeIDX = '" & CIDX & "'"																			

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
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitleReferee] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND GameTitleIDX = '" & tIDX & "'"
					LSQL =  LSQL & " 	AND GameRefereeIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblGameTitleReferee] " 
						LSQL =  LSQL & " SET UserName = '" & UserName & "'"
						LSQL =  LSQL & "	,UserEnName = '" & UserEnName & "'"
						LSQL =  LSQL & "	,ct_serial = '" & Nationality & "'"
						LSQL =  LSQL & "	,RefereeGb = '" & RefereeGb & "'"
						LSQL =  LSQL & "	,Sex = '" & Sex & "'"
						LSQL =  LSQL & "	,ModDate = GETDATE()"
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE GameTitleIDX = '" & CIDX & "'"
						
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
				
				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblGameTitleReferee] (" 				
				LSQL =  LSQL & "	GameTitleIDX "  
				LSQL =  LSQL & "	,UserName "  
				LSQL =  LSQL & "	,UserEnName " 
				LSQL =  LSQL & "	,ct_serial " 										
				LSQL =  LSQL & "	,RefereeGb " 
				LSQL =  LSQL & "	,Sex " 
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,InsDate "  					
				LSQL =  LSQL & "	,ModDate "  					
				LSQL =  LSQL & "	,InsId "  					
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & tIDX & "'" 
				LSQL =  LSQL & "	,'" & UserName & "'" 	
				LSQL =  LSQL & "	,'" & UserEnName & "'" 
				LSQL =  LSQL & "	,'" & Nationality & "'" 
				LSQL =  LSQL & "	,'" & RefereeGb & "'" 
				LSQL =  LSQL & "	,'" & Sex & "'" 
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
			
		END SELECT
			
	End IF 
%>