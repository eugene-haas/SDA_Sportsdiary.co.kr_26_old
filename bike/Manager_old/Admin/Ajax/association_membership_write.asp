<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'임원관리 
	'==============================================================================================
	Check_AdminLogin()
	 
	dim Upload, FSO
	dim upFileName1 
	dim ExtensionType1	
	dim AssoCode, CateSuccessiveIDX, CateOfficersIDX, UserName, UserBirth, UserCompanyNm, UserCompanyLevel, ViewYN, ImgProfile
	dim valType, CIDX
	dim LSQL, LRs		
	
	dim UserID 	: UserID = crypt.DecryptStringENC(Request.Cookies(global_HP)("UserID"))	
	
	SET FSO = CreateObject("Scripting.FileSystemObject") 	
		
	'Tab Upload 4.5 업로드 컴포넌트를 생성합니다.
	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
'		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start global_filepath_temp, False

	AssoCode 			= fInject(trim(Upload.Form("AssoCode")))
	CateSuccessiveIDX 	= fInject(trim(Upload.Form("CateSuccessiveIDX")))
	CateOfficersIDX 	= fInject(trim(Upload.Form("CateOfficersIDX")))
	UserName 			= HtmlSpecialChars(fInject(trim(Upload.Form("UserName"))))
   	UserBirth 			= fInject(trim(Upload.Form("UserBirth")))
	UserCompanyNm 		= HtmlSpecialChars(fInject(trim(Upload.Form("UserCompanyNm"))))
	UserCompanyLevel 	= HtmlSpecialChars(fInject(trim(Upload.Form("UserCompanyLevel"))))
	ViewYN 				= fInject(trim(Upload.Form("ViewYN")))
	CIDX 				= crypt.DecryptStringENC(fInject(trim(Upload.Form("CIDX"))))
	valType				= fInject(trim(Upload.Form("valType")))	
	Del_ImgProfile 		= fInject(trim(Upload.Form("Del_ImgProfile")))	
	SET ImgProfile 		= Upload.Form("ImgProfile")

	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		IF ImgProfile <> "" Then 			
			ExtensionType1 = ImgProfile.FileType	'파일확장자
		
			'파일 확장자 체크
			IF LCase(ExtensionType1) = "jpeg" Or LCase(ExtensionType1) = "jpg" Or LCase(ExtensionType1) = "gif" Or LCase(ExtensionType1) = "png" Or LCase(ExtensionType1) = "bmp" Then 		
				Upload.Save global_filepath_temp, False		'이미지 업로드
				upFileName1 = ImgProfile.ShortSaveName		'저장된업로드 파일명
			Else
				response.Write "FALSE|33"
				response.End()
			End IF 	
		End IF

		
		SELECT CASE valType
			'정보삭제
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblAssoOfficers]" 
					LSQL =  LSQL & " SET DelYN = 'Y'"
					LSQL =  LSQL & "	,ModDate = GETDATE()"
					LSQL =  LSQL & "	,ModId = '" & UserID & "'"
					LSQL =  LSQL & " WHERE AssoOfficersIDX = '" & CIDX & "'"
					
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
				
			'정보수정	
			CASE "MOD"
		
				IF CIDX <> "" Then
				
					LSQL =  "		 SELECT * "
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblAssoOfficers] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND AssoOfficersIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblAssoOfficers] " 
						LSQL =  LSQL & " SET AssoCode = '" & AssoCode & "'"
						LSQL =  LSQL & "	,CateSuccessiveIDX = '" & CateSuccessiveIDX & "'"
						LSQL =  LSQL & "	,CateOfficersIDX = '" & CateOfficersIDX & "'"
						LSQL =  LSQL & "	,UserName = '" & UserName & "'"
						LSQL =  LSQL & "	,UserBirth = '" & UserBirth & "'"
						LSQL =  LSQL & "	,UserCompanyNm = '" & UserCompanyNm & "'"
						LSQL =  LSQL & "	,UserCompanyLevel = '" & UserCompanyLevel & "'"
						LSQL =  LSQL & "	,ViewYN = '" & ViewYN & "'"
						
						'이미지업로드할 경우
						IF upFileName1 <> "" Then 
							LSQL =  LSQL & " ,ImgProfile = '" & upFileName1 & "'"
							
							'기존 업로드된 파일이 존재하면 삭제
							IF FSO.FileExists(global_filepath_temp & LRs("ImgProfile")) Then 
								FSO.DeleteFile(global_filepath_temp & LRs("ImgProfile"))
							End IF							
						Else
							'업로드된 이미지 삭제 체크박스 체크시 삭제처리
							IF Del_ImgProfile = "Y" Then
								LSQL =  LSQL & " ,ImgProfile = ''"
								
								'기존 업로드된 파일이 존재하면 삭제
								IF FSO.FileExists(global_filepath_temp & LRs("ImgProfile")) Then 
									FSO.DeleteFile(global_filepath_temp & LRs("ImgProfile"))
								End IF		
							End IF							
						End IF	
						
						LSQL =  LSQL & "	,ModDate = GETDATE()"
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE AssoOfficersIDX = '" & CIDX & "'"
						
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
				
			'신규등록	
			CASE "SAVE"
				
				LSQL =  "		 INSERT INTO [KoreaBadminton].[dbo].[tblAssoOfficers] (" 
				LSQL =  LSQL & "	AssoCode "  
				LSQL =  LSQL & "	,CateSuccessiveIDX " 
				LSQL =  LSQL & "	,CateOfficersIDX " 										
				LSQL =  LSQL & "	,UserName " 
				LSQL =  LSQL & "	,UserBirth " 
				LSQL =  LSQL & "	,UserCompanyNm " 
				LSQL =  LSQL & "	,UserCompanyLevel " 
				LSQL =  LSQL & "	,ViewYN " 
				LSQL =  LSQL & "	,ImgProfile"  
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,InsDate "  					
				LSQL =  LSQL & "	,ModDate "  					
				LSQL =  LSQL & "	,InsId "  					
				LSQL =  LSQL & "	,ModId "  					
				LSQL =  LSQL & " )VALUES( " 
				LSQL =  LSQL & "	'" & AssoCode & "'" 
				LSQL =  LSQL & "	,'" & CateSuccessiveIDX & "'" 
				LSQL =  LSQL & "	,'" & CateOfficersIDX & "'" 
				LSQL =  LSQL & "	,'" & UserName & "'" 
				LSQL =  LSQL & "	,'" & UserBirth & "'" 
				LSQL =  LSQL & "	,'" & UserCompanyNm & "'" 
				LSQL =  LSQL & "	,'" & UserCompanyLevel & "'" 			
				LSQL =  LSQL & "	,'" & ViewYN & "'" 			
				LSQL =  LSQL & "	,'" & upFileName1 & "'" 			
				LSQL =  LSQL & "	,'N'" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,'" & UserID & "'" 
				LSQL =  LSQL & "	,'" & UserID & "'" 
				LSQL =  LSQL & " )"				
				
'				response.write LSQL

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

	DBClose()
%>