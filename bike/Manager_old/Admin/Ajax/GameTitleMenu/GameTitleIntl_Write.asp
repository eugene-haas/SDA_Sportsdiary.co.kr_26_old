<!--#include file="../../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'국제대회 정보 저장
	'==============================================================================================
	Check_AdminLogin()
	 
	dim Upload, FSO

	dim GameTitleName, GameTitleEnName, ct_serial, City, GamePlace, GameS, GameE, ViewYN
	dim Summary, PlayerList, GameScedule, GameResult, PlayerListFile, GameSceduleFile, GameResultFile
	dim URLMatch, URLSchedule
	dim Del_PlayerListFileYN, Del_GameSceduleFileYN, Del_GameResultFileYN 
	 
	dim valType, CIDX
	dim LSQL, LRs		
	dim upFileName1, upFileName2, upFileName3
	dim ExtensionType1, ExtensionType2, ExtensionType3
	
	dim UserID 			: 	UserID 		= crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))	
	
	SET FSO = CreateObject("Scripting.FileSystemObject") 	
		
	'Tab Upload 4.5 업로드 컴포넌트를 생성합니다.
	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start global_filepath, False

	GameTitleName = fInject(trim(Upload.Form("GameTitleName")))
	GameTitleEnName = fInject(trim(Upload.Form("GameTitleEnName")))
	ct_serial = fInject(trim(Upload.Form("fnd_Country")))
	City = fInject(trim(Upload.Form("City")))
	GamePlace = fInject(trim(Upload.Form("GamePlace")))
	GameS = fInject(trim(Upload.Form("GameS")))
	GameE = fInject(trim(Upload.Form("GameE")))
	Summary = Replace(trim(Upload.Form("Summary")),"'","&#039;")		
	PlayerList = Replace(trim(Upload.Form("PlayerList")),"'","&#039;")		
	GameScedule = Replace(trim(Upload.Form("GameScedule")),"'","&#039;")		
	GameResult = Replace(trim(Upload.Form("GameResult")),"'","&#039;")	   
	ViewYN = fInject(trim(Upload.Form("ViewYN")))
	URLMatch = fInject(trim(Upload.Form("URLMatch")))
	URLSchedule = fInject(trim(Upload.Form("URLSchedule")))																	

   	Del_PlayerListFileYN = fInject(trim(Upload.Form("Del_PlayerListFileYN")))
   	Del_GameSceduleFileYN = fInject(trim(Upload.Form("Del_GameSceduleFileYN")))
   	Del_GameResultFileYN = fInject(trim(Upload.Form("Del_GameResultFileYN")))
	
   	CIDX = fInject(trim(Upload.Form("CIDX")))
	valType = fInject(trim(Upload.Form("valType")))	
   
	SET PlayerListFile = Upload.Form("PlayerListFile")
   	SET GameSceduleFile = Upload.Form("GameSceduleFile")
   	SET GameResultFile = Upload.Form("GameResultFile")
																	
		
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		
		'---------------------------------------------------------------------------------------------------------
		IF PlayerListFile <> "" Then 
			
			ExtensionType1 = PlayerListFile.FileType			'파일확장자
   			
   			'파일 확장자 체크
			IF LCase(ExtensionType1) = "exe" OR LCase(ExtensionType1) = "asp" OR LCase(ExtensionType1) = "php" OR LCase(ExtensionType1) = "html" OR LCase(ExtensionType1) = "jsp" Then 				
				response.Write "FALSE|33"
				response.End()
			Else
				Upload.Save global_filepath, False			'업로드
				upFileName1 = PlayerListFile.ShortSaveName		'저장된업로드 파일명				
			End IF 	
		End IF
		'---------------------------------------------------------------------------------------------------------
		IF GameSceduleFile <> "" Then 
			
			ExtensionType2 = GameSceduleFile.FileType			
		
			'파일 확장자 체크
			IF LCase(ExtensionType2) = "exe" OR LCase(ExtensionType2) = "asp" OR LCase(ExtensionType2) = "php" OR LCase(ExtensionType2) = "html" OR LCase(ExtensionType2) = "jsp" Then 				
				response.Write "FALSE|33"
				response.End()
			Else
			 	Upload.Save global_filepath, False			
				upFileName2 = GameSceduleFile.ShortSaveName			
			End IF 	
		End IF
		'---------------------------------------------------------------------------------------------------------
		IF GameResultFile <> "" Then 
			
			ExtensionType3 = GameResultFile.FileType			
		
			'파일 확장자 체크
			IF LCase(ExtensionType3) = "exe" OR LCase(ExtensionType3) = "asp" OR LCase(ExtensionType3) = "php" OR LCase(ExtensionType3) = "html" OR LCase(ExtensionType3) = "jsp" Then 				
				response.Write "FALSE|33"
				response.End()
			Else
			 	Upload.Save global_filepath, False			
				upFileName3 = GameResultFile.ShortSaveName				
			End IF 	
		End IF	
		'---------------------------------------------------------------------------------------------------------
												 
		SELECT CASE valType			
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitleIntl] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND GameTitleIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then											 
																				 
						
						'기존 업로드된 파일이 존재하면 삭제
						'---------------------------------------------------------------------------------------------------------
						IF FSO.FileExists(global_filepath & LRs("PlayerListFile")) Then FSO.DeleteFile(global_filepath & LRs("PlayerListFile"))
						IF FSO.FileExists(global_filepath & LRs("GameSceduleFile")) Then FSO.DeleteFile(global_filepath & LRs("GameSceduleFile"))
						IF FSO.FileExists(global_filepath & LRs("GameResultFile")) Then FSO.DeleteFile(global_filepath & LRs("GameResultFile"))
						'---------------------------------------------------------------------------------------------------------

						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblGameTitleIntl]" 
						LSQL =  LSQL & " SET DelYN = 'Y'"
						LSQL =  LSQL & "	,PlayerListFile = ''"
						LSQL =  LSQL & "	,GameSceduleFile = ''"
						LSQL =  LSQL & "	,GameResultFile = ''"
						LSQL =  LSQL & "	,URLMatch = ''"
						LSQL =  LSQL & "	,URLSchedule = ''"
						LSQL =  LSQL & "	,ModDate = GETDATE()"						
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE GameTitleIDX = '" & CIDX & "'"

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
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitleIntl] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND GameTitleIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblGameTitleIntl] " 
						LSQL =  LSQL & " SET GameTitleName = '" & GameTitleName & "'"
						LSQL =  LSQL & "	,GameTitleEnName = '" & GameTitleEnName & "'"
						LSQL =  LSQL & "	,ct_serial = '" & ct_serial & "'"
						LSQL =  LSQL & "	,City = '" & City & "'"
						LSQL =  LSQL & "	,GamePlace = '" & GamePlace & "'"
						LSQL =  LSQL & "	,GameS = '" & GameS & "'"
						LSQL =  LSQL & "	,GameE = '" & GameE & "'"
						LSQL =  LSQL & "	,ViewYN = '" & ViewYN & "'"
						LSQL =  LSQL & "	,URLMatch = '" & URLMatch & "'"
						LSQL =  LSQL & "	,URLSchedule = '" & URLSchedule & "'"
																	  
						'파일업로드할 경우
						'---------------------------------------------------------------------------------------------------------
						IF upFileName1 <> "" Then 
							LSQL =  LSQL & " ,PlayerListFile = '" & upFileName1 & "'"
							
							'기존 업로드된 파일이 존재하면 삭제
							IF FSO.FileExists(global_filepath & LRs("PlayerListFile")) Then FSO.DeleteFile(global_filepath & LRs("PlayerListFile"))							
						Else
							'업로드된 이미지 삭제 체크박스 체크시 삭제처리
							IF Del_PlayerListFileYN = "Y" Then
								LSQL =  LSQL & " ,PlayerListFile = ''"								
								'기존 업로드된 파일이 존재하면 삭제
								IF FSO.FileExists(global_filepath & LRs("PlayerListFile")) Then FSO.DeleteFile(global_filepath & LRs("PlayerListFile"))
							End IF							
						End IF
						'---------------------------------------------------------------------------------------------------------
						IF upFileName2 <> "" Then 
							LSQL =  LSQL & " ,GameSceduleFile = '" & upFileName2 & "'"							
							IF FSO.FileExists(global_filepath & LRs("GameSceduleFile")) Then FSO.DeleteFile(global_filepath & LRs("GameSceduleFile"))							
						Else
							IF Del_GameSceduleFileYN = "Y" Then
								LSQL =  LSQL & " ,GameSceduleFile = ''"								
								IF FSO.FileExists(global_filepath & LRs("GameSceduleFile")) Then FSO.DeleteFile(global_filepath & LRs("GameSceduleFile"))							
							End IF							
						End IF	
						'---------------------------------------------------------------------------------------------------------
						IF upFileName3 <> "" Then 
							LSQL =  LSQL & " ,GameResultFile = '" & upFileName3 & "'"							
							IF FSO.FileExists(global_filepath & LRs("GameResultFile")) Then FSO.DeleteFile(global_filepath & LRs("GameResultFile"))
						Else
							IF Del_GameResultFileYN = "Y" Then
								LSQL =  LSQL & " ,GameResultFile = ''"
								IF FSO.FileExists(global_filepath & LRs("GameResultFile")) Then FSO.DeleteFile(global_filepath & LRs("GameResultFile"))
							End IF							
						End IF	
						'---------------------------------------------------------------------------------------------------------

						LSQL =  LSQL & "	,Summary = '" & Summary & "'"
						LSQL =  LSQL & "	,PlayerList = '" & PlayerList & "'"
						LSQL =  LSQL & "	,GameScedule = '" & GameScedule & "'"
						LSQL =  LSQL & "	,GameResult = '" & GameResult & "'"
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
				
				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblGameTitleIntl] (" 
				LSQL =  LSQL & "	GameTitleName "  
				LSQL =  LSQL & "	,GameTitleEnName " 
				LSQL =  LSQL & "	,ct_serial " 										
				LSQL =  LSQL & "	,City " 
				LSQL =  LSQL & "	,GamePlace " 
				LSQL =  LSQL & "	,ViewYN "  
				LSQL =  LSQL & "	,GameS " 
				LSQL =  LSQL & "	,GameE "  
				LSQL =  LSQL & "	,Summary "  
				LSQL =  LSQL & "	,PlayerList"  
				LSQL =  LSQL & "	,GameScedule"  
				LSQL =  LSQL & "	,GameResult" 
				LSQL =  LSQL & "	,PlayerListFile"  
				LSQL =  LSQL & "	,GameSceduleFile"  
				LSQL =  LSQL & "	,GameResultFile"  
				LSQL =  LSQL & "	,URLMatch"  
				LSQL =  LSQL & "	,URLSchedule"  
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,EnterType"  					
				LSQL =  LSQL & "	,InsDate "  					
				LSQL =  LSQL & "	,ModDate "  					
				LSQL =  LSQL & "	,InsId "  					
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & GameTitleName & "'" 
				LSQL =  LSQL & "	,'" & GameTitleEnName & "'" 
				LSQL =  LSQL & "	,'" & ct_serial & "'" 
				LSQL =  LSQL & "	,'" & City & "'" 
				LSQL =  LSQL & "	,'" & GamePlace & "'" 
				LSQL =  LSQL & "	,'" & ViewYN & "'" 
				LSQL =  LSQL & "	,'" & GameS & "'" 			
				LSQL =  LSQL & "	,'" & GameE & "'" 			
				LSQL =  LSQL & "	,'" & Summary & "'" 			
				LSQL =  LSQL & "	,'" & PlayerList & "'" 			
				LSQL =  LSQL & "	,'" & GameScedule & "'" 			
				LSQL =  LSQL & "	,'" & GameResult & "'" 			
				LSQL =  LSQL & "	,'" & upFileName1 & "'" 			
				LSQL =  LSQL & "	,'" & upFileName2 & "'" 			
				LSQL =  LSQL & "	,'" & upFileName3 & "'" 			
				LSQL =  LSQL & "	,'" & URLMatch & "'" 			
				LSQL =  LSQL & "	,'" & URLSchedule & "'" 			
				LSQL =  LSQL & "	,'N'" 
				LSQL =  LSQL & "	,'E'" 
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