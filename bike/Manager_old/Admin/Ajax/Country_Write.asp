<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'국가정보 등록페이지
	'==============================================================================================
	Check_AdminLogin()
	 
	dim Upload, FSO
	dim upFileName, ExtensionType	
	dim CountryGb, CountryNm, CountryEnNm, CountryEnNmShort, CountryFlag, Del_CountryFlagYN
	dim valType, CIDX
	dim LSQL, LRs	
	dim ct_serial	
	 
	dim FilePath	: FilePath = global_filepath&"\country_flag\" 
	 
	 
	SET FSO = CreateObject("Scripting.FileSystemObject") 	
		
	'Tab Upload 4.5 업로드 컴포넌트를 생성합니다.
	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
'		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start FilePath, False

	CountryGb = fInject(trim(Upload.Form("CountryGb")))
	CountryNm = HtmlSpecialChars(fInject(trim(Upload.Form("CountryNm"))))
	CountryEnNm = HtmlSpecialChars(fInject(trim(Upload.Form("CountryEnNm"))))
	CountryEnNmShort = HtmlSpecialChars(fInject(trim(Upload.Form("CountryEnNmShort"))))   	
	CIDX = crypt.DecryptStringENC(fInject(trim(Upload.Form("CIDX"))))
	valType = fInject(trim(Upload.Form("valType")))	
	Del_CountryFlagYN = fInject(trim(Upload.Form("Del_CountryFlagYN")))
	
	SET CountryFlag = Upload.Form("CountryFlag")
	
   	'========================================================================================
   	'파일업로드
   	'========================================================================================
   	SUB CHK_UPLOAD_PROC(valFileName)
	 
		ExtensionType = CountryFlag.FileType	'파일확장자

		'파일 확장자 체크
		IF LCase(ExtensionType) = "jpeg" Or LCase(ExtensionType) = "jpg" Or LCase(ExtensionType) = "gif" Or LCase(ExtensionType) = "png" Then 				
		 	
			CountryFlag.SaveAs FilePath&valFileName&"_flag."&ExtensionType, True 	'이미지 업로드(파일명 생성)
			upFileName = CountryFlag.ShortSaveName									'저장된 업로드 파일명
   
		Else
			response.Write "FALSE|33"
			response.End()
		End IF 	
		
   	END SUB
   	'========================================================================================
   
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		SELECT CASE valType
			
			CASE "DEL"
			
				IF CIDX <> "" Then
														 
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblCountryInfo] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND CountryIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then					
					
						'기존 업로드된 파일이 존재하면 삭제
						IF FSO.FileExists(FilePath & LRs("CountryFlag")) Then FSO.DeleteFile(FilePath & LRs("CountryFlag"))						

						LSQL =  "DELETE [KoreaBadminton].[dbo].[tblCountryInfo] WHERE CountryIDX = '" & CIDX & "'"
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
						LRs.Close
					SET LRs = Nothing																	   
						
				Else
					response.Write "FALSE|200"
					response.End()
				End IF
				
				
			CASE "MOD"
		
				IF CIDX <> "" Then
					
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblCountryInfo] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND CountryIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						IF CountryFlag <> "" Then
	
							'기존 업로드된 파일이 존재하면 삭제
							IF FSO.FileExists(FilePath & LRs("CountryFlag")) Then FSO.DeleteFile(FilePath & LRs("CountryFlag"))						
   
							CALL CHK_UPLOAD_PROC(LRs("ct_serial"))	
	
						End IF

						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblCountryInfo] " 
						LSQL =  LSQL & " SET CountryGb = '" & CountryGb & "'"
						LSQL =  LSQL & "	,CountryNm = '" & CountryNm & "'"
						LSQL =  LSQL & "	,CountryEnNm = '" & CountryEnNm & "'"
						LSQL =  LSQL & "	,CountryEnNmShort = '" & CountryEnNmShort & "'"
																						  
																						  
						'이미지 업로드 할 경우
						IF upFileName <> "" Then 
							LSQL =  LSQL & " ,CountryFlag = '" & upFileName & "'"
						Else

							'업로드된 이미지 삭제 체크박스 체크시 삭제처리
							IF Del_CountryFlagYN = "Y" Then

								LSQL =  LSQL & " ,CountryFlag = ''"
								
								'기존 업로드된 파일이 존재하면 삭제
								IF FSO.FileExists(FilePath & LRs("CountryFlag")) Then FSO.DeleteFile(FilePath & LRs("CountryFlag"))
								
							End IF
							
						End IF	
						
						LSQL =  LSQL & "	,EditDate = GETDATE()"
						LSQL =  LSQL & " WHERE CountryIDX = '" & CIDX & "'"
						
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

				LSQL =  "		 SELECT MAX(ct_serial)"
				LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblCountryInfo]" 
				LSQL =  LSQL & " WHERE DelYN = 'N'" 
				SET LRs = DBCon.Execute(LSQL)
				
				'업로드 이미지 파일명 생성문자
				ct_serial = LRs(0) + 1
				
				'이미지 업로드
				IF CountryFlag <> "" Then CALL CHK_UPLOAD_PROC(ct_serial)					
				
				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblCountryInfo] (" 
				LSQL =  LSQL & "	ct_serial "	
				LSQL =  LSQL & "	,CountryGb "  
				LSQL =  LSQL & "	,CountryNm " 
				LSQL =  LSQL & "	,CountryEnNm " 										
				LSQL =  LSQL & "	,CountryEnNmShort " 
				LSQL =  LSQL & "	,CountryFlag"  
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,WriteDate "  					
				LSQL =  LSQL & "	,EditDate "				
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & ct_serial & "'" 			
				LSQL =  LSQL & "	,'" & CountryGb & "'" 
				LSQL =  LSQL & "	,'" & CountryNm & "'" 
				LSQL =  LSQL & "	,'" & CountryEnNm & "'" 
				LSQL =  LSQL & "	,'" & CountryEnNmShort & "'" 
				LSQL =  LSQL & "	,'" & upFileName & "'" 			
				LSQL =  LSQL & "	,'N'" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,GETDATE()" 				
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