<!--#include file="../../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'대회추가정보 저장
	'==============================================================================================
	Check_AdminLogin()
	 
	dim Upload, FSO
	dim GameTitleIDX, GameTitleDtlIDX, txtSummary, txtTSchedule, TScheduleFile, txtStayTravel	 
	dim Del_TScheduleFileYN
	 
	dim valType
	dim LSQL, LRs		
	dim upFileName1, ExtensionType1
	
	dim UserID 			: 	UserID 		= crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))	
	
	SET FSO = CreateObject("Scripting.FileSystemObject") 	
		
	'Tab Upload 4.5 업로드 컴포넌트를 생성합니다.
	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start global_filepath, False

	GameTitleIDX = crypt.DecryptStringENC(fInject(trim(Upload.Form("GameTitleIDX"))))
	GameTitleDtlIDX = crypt.DecryptStringENC(fInject(trim(Upload.Form("GameTitleDtlIDX"))))
	txtSummary = Replace(trim(Upload.Form("txtSummary")),"'","&#039;")		
	txtTSchedule = Replace(trim(Upload.Form("txtTSchedule")),"'","&#039;")		
	txtStayTravel = Replace(trim(Upload.Form("txtStayTravel")),"'","&#039;")		
	
   	Del_TScheduleFileYN = fInject(trim(Upload.Form("Del_TScheduleFileYN")))   	
  
	valType = fInject(trim(Upload.Form("valType")))	
   
	SET TScheduleFile = Upload.Form("TScheduleFile")
	
											   
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		
		'---------------------------------------------------------------------------------------------------------
		IF TScheduleFile <> "" Then 
			
			ExtensionType1 = TScheduleFile.FileType			'파일확장자
   			
   			'파일 확장자 체크
			IF LCase(ExtensionType1) = "exe" OR LCase(ExtensionType1) = "asp" OR LCase(ExtensionType1) = "php" OR LCase(ExtensionType1) = "html" OR LCase(ExtensionType1) = "jsp" Then 				
				response.Write "FALSE|33"
				response.End()
			Else
				Upload.Save global_filepath, False			'업로드
				upFileName1 = TScheduleFile.ShortSaveName		'저장된업로드 파일명				
			End IF 	
		End IF
		'---------------------------------------------------------------------------------------------------------		
												 
		SELECT CASE valType			
			CASE "DEL"
			
				IF GameTitleIDX <> "" AND GameTitleDtlIDX <> "" Then
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitleDtl] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND GameTitleDtlIDX = '" & GameTitleDtlIDX & "'"
					LSQL =  LSQL & " 	AND GameTitleIDX = '" & GameTitleIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then											 
																				 
						
						'기존 업로드된 파일이 존재하면 삭제
						'---------------------------------------------------------------------------------------------------------
						IF FSO.FileExists(global_filepath & LRs("TScheduleFile")) Then FSO.DeleteFile(global_filepath & LRs("TScheduleFile"))
						'---------------------------------------------------------------------------------------------------------

						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblGameTitleDtl]" 
						LSQL =  LSQL & " SET DelYN = 'Y'"
						LSQL =  LSQL & "	,ModDate = GETDATE()"						
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE GameTitleDtlIDX = '" & GameTitleDtlIDX & "'"
						LSQL =  LSQL & " 	AND GameTitleIDX = '" & GameTitleIDX & "'"
																				  
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
		
				IF GameTitleIDX <> "" AND GameTitleDtlIDX <> "" Then
				
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblGameTitleDtl] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND GameTitleDtlIDX = '" & GameTitleDtlIDX & "'"
					LSQL =  LSQL & " 	AND GameTitleIDX = '" & GameTitleIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblGameTitleDtl] " 
						LSQL =  LSQL & " SET txtSummary = '" & txtSummary & "'"
						LSQL =  LSQL & "	,txtTSchedule = '" & txtTSchedule & "'"
						LSQL =  LSQL & "	,txtStayTravel = '" & txtStayTravel & "'"
																	  
						'파일업로드할 경우
						'---------------------------------------------------------------------------------------------------------
						IF upFileName1 <> "" Then 
							LSQL =  LSQL & " ,TScheduleFile = '" & upFileName1 & "'"
							
							'기존 업로드된 파일이 존재하면 삭제
							IF FSO.FileExists(global_filepath & LRs("TScheduleFile")) Then FSO.DeleteFile(global_filepath & LRs("TScheduleFile"))							
						Else
							'업로드된 이미지 삭제 체크박스 체크시 삭제처리
							IF Del_TScheduleFileYN = "Y" Then
								LSQL =  LSQL & " ,TScheduleFile = ''"								
								
								'기존 업로드된 파일이 존재하면 삭제
								IF FSO.FileExists(global_filepath & LRs("TScheduleFile")) Then FSO.DeleteFile(global_filepath & LRs("TScheduleFile"))
							End IF							
						End IF
						'---------------------------------------------------------------------------------------------------------
						
						LSQL =  LSQL & "	,ModDate = GETDATE()"
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE GameTitleDtlIDX = '" & GameTitleDtlIDX & "'"
						LSQL =  LSQL & " 	AND GameTitleIDX = '" & GameTitleIDX & "'"
						
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
				
				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblGameTitleDtl] (" 
				LSQL =  LSQL & "	GameTitleIDX "  
				LSQL =  LSQL & "	,txtSummary " 
				LSQL =  LSQL & "	,txtTSchedule " 										
				LSQL =  LSQL & "	,txtStayTravel " 
				LSQL =  LSQL & "	,TScheduleFile " 													
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,InsDate "  					
				LSQL =  LSQL & "	,ModDate "  					
				LSQL =  LSQL & "	,InsId "  					
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & GameTitleIDX & "'" 
				LSQL =  LSQL & "	,'" & txtSummary & "'" 
				LSQL =  LSQL & "	,'" & txtTSchedule & "'" 
				LSQL =  LSQL & "	,'" & txtStayTravel & "'" 
				LSQL =  LSQL & "	,'" & upFileName1 & "'" 			
				LSQL =  LSQL & "	,'N'" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,'" & UserID & "'" 
				LSQL =  LSQL & ")"				
				
				'response.write LSQL
								  
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