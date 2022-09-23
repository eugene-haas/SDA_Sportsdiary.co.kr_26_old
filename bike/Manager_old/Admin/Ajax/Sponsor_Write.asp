<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'후원사관리
	'==============================================================================================
	Check_AdminLogin()
	 
	dim Upload, FSO
	dim upFileName1 
	dim ExtensionType1	
	dim Subject, SponLink, SponUseYN, SponSort
	dim valType, CIDX
	dim LSQL, LRs		
	dim UserID 	: UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))	
	
	SET FSO = CreateObject("Scripting.FileSystemObject") 	
		
	'Tab Upload 4.5 업로드 컴포넌트를 생성합니다.
	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
'		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start global_filepath_temp, False

	Subject = fInject(trim(Upload.Form("Subject")))
	SponLink = fInject(trim(Upload.Form("SponLink")))
	SponUseYN = fInject(trim(Upload.Form("SponUseYN")))
	SponSort = fInject(trim(Upload.Form("SponSort")))
   	SponType = fInject(trim(Upload.Form("SponType")))
	CIDX = fInject(trim(Upload.Form("CIDX")))
	valType = fInject(trim(Upload.Form("valType")))	
	Del_SponImageYN = fInject(trim(Upload.Form("Del_SponImageYN")))
	
	SET SponImage = Upload.Form("SponImage")
	
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		IF SponImage <> "" Then 
			
			ExtensionType1 = SponImage.FileType	'파일확장자
		
			'파일 확장자 체크
			IF LCase(ExtensionType1) = "jpeg" Or LCase(ExtensionType1) = "jpg" Or LCase(ExtensionType1) = "gif" Or LCase(ExtensionType1) = "png" Or LCase(ExtensionType1) = "bmp" Then 
				
				Upload.Save global_filepath_temp, False			'이미지 업로드
				upFileName1 = SponImage.ShortSaveName		'저장된업로드 파일명
			Else
				response.Write "FALSE|33"
				response.End()
			End IF 	
		End IF

		SELECT CASE valType
			
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblSponsorManage]" 
					LSQL =  LSQL & " SET DelYN = 'Y'"
					LSQL =  LSQL & "	,ModDate = GETDATE()"
					LSQL =  LSQL & "	,ModId = '" & UserID & "'"
					LSQL =  LSQL & " WHERE SponsorIDX = '" & CIDX & "'"
					
					DBCon.Execute(LSQL)
					
					IF DBCon.Errors.Count > 0 Then
						response.Write "FALSE|66"
						response.End()
					Else
						response.Write "TRUE|70"
						response.End()
					End IF
				Else
					response.Write "FALSE|200"
					response.End()
				End IF
				
				
			CASE "MOD"
		
				IF CIDX <> "" Then
				
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblSponsorManage] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND SponsorIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblSponsorManage] " 
						LSQL =  LSQL & " SET Subject = '" & Subject & "'"
						LSQL =  LSQL & "	,SponLink = '" & SponLink & "'"
						LSQL =  LSQL & "	,SponUseYN = '" & SponUseYN & "'"
						LSQL =  LSQL & "	,SponSort = '" & SponSort & "'"
						LSQL =  LSQL & "	,SponType = '" & SponType & "'"
						
						'이미지업로드할 경우
						IF upFileName1 <> "" Then 
							LSQL =  LSQL & " ,SponImage = '" & upFileName1 & "'"
							
							'기존 업로드된 파일이 존재하면 삭제
							IF FSO.FileExists(global_filepath_temp & LRs("SponImage")) Then 
								FSO.DeleteFile(global_filepath_temp & LRs("SponImage"))
							End IF	
						
						Else
							'업로드된 이미지 삭제 체크박스 체크시 삭제처리
							IF Del_SponImageYN = "Y" Then
								LSQL =  LSQL & " ,SponImage = ''"
								
								'기존 업로드된 파일이 존재하면 삭제
								IF FSO.FileExists(global_filepath_temp & LRs("SponImage")) Then 
									FSO.DeleteFile(global_filepath_temp & LRs("SponImage"))
								End IF		
							End IF
							
						End IF	
						
						LSQL =  LSQL & "	,ModDate = GETDATE()"
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE SponsorIDX = '" & CIDX & "'"
						
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
				
				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblSponsorManage] (" 
				LSQL =  LSQL & "	Subject "  
				LSQL =  LSQL & "	,SponLink " 
				LSQL =  LSQL & "	,SponUseYN " 										
				LSQL =  LSQL & "	,SponSort " 
				LSQL =  LSQL & "	,SponType " 
				LSQL =  LSQL & "	,SponImage"  
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,InsDate "  					
				LSQL =  LSQL & "	,ModDate "  					
				LSQL =  LSQL & "	,InsId "  					
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & Subject & "'" 
				LSQL =  LSQL & "	,'" & SponLink & "'" 
				LSQL =  LSQL & "	,'" & SponUseYN & "'" 
				LSQL =  LSQL & "	,'" & SponSort & "'" 
				LSQL =  LSQL & "	,'" & SponType & "'" 
				LSQL =  LSQL & "	,'" & upFileName1 & "'" 			
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