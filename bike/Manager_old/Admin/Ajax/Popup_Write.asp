<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'팝업관리
	'==============================================================================================
	Check_AdminLogin()
	 
	dim Upload, FSO
	dim upFileName1 
	dim ExtensionType1	
	dim Subject, PWidth, PHeight, PLeft, PTop, PSDate, PEDate
	dim PContents, PDailyUseYN, PUseYN, PZindex, PDailyBgColor, PDailyTxtColor, PBgColor, PBorder, PBorderColor
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
	PWidth = fInject(trim(Upload.Form("PWidth")))
	PHeight = fInject(trim(Upload.Form("PHeight")))
	PLeft = fInject(trim(Upload.Form("PLeft")))
	PTop = fInject(trim(Upload.Form("PTop")))
	PSDate = fInject(trim(Upload.Form("PSDate")))
	PEDate = fInject(trim(Upload.Form("PEDate")	))
	PContents = fInject(trim(Upload.Form("PContents")))
	PContents = Replace(PContents,"'","&#039;")	
	PDailyUseYN = fInject(trim(Upload.Form("PDailyUseYN")))
	PUseYN = fInject(trim(Upload.Form("PUseYN")))
	PZindex = fInject(trim(Upload.Form("PZindex")))
	PDailyBgColor = UCase(fInject(trim(Upload.Form("PDailyBgColor"))))
	PDailyTxtColor = UCase(fInject(trim(Upload.Form("PDailyTxtColor"))))
	PBorder = fInject(trim(Upload.Form("PBorder")))
	PBgColor = fInject(trim(Upload.Form("PBgColor")))
	PBorderColor = UCase(fInject(trim(Upload.Form("PBorderColor"))))
	CIDX = fInject(trim(Upload.Form("CIDX")))
	valType = trim(Upload.Form("valType"))	
	Del_PBackgroundYN = fInject(trim(Upload.Form("Del_PBackgroundYN")))
	
	SET PBackground = Upload.Form("PBackground")
	
	IF valType = "" Then 	
		response.Write "FALSE|200"
		response.End()
	Else
		
		IF PBackground <> "" Then 
			
			ExtensionType1 = PBackground.FileType	'파일확장자
		
			'파일 확장자 체크
			IF LCase(ExtensionType1) = "jpeg" Or LCase(ExtensionType1) = "jpg" Or LCase(ExtensionType1) = "gif" Or LCase(ExtensionType1) = "png" Or LCase(ExtensionType1) = "bmp" Then 
				
				Upload.Save global_filepath_temp, False			'이미지 업로드
				upFileName1 = PBackground.ShortSaveName		'저장된업로드 파일명
			Else
				response.Write "FALSE|33"
				response.End()
			End IF 	
		End IF

		SELECT CASE valType
			
			CASE "DEL"
			
				IF CIDX <> "" Then
					LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblPopupManage]" 
					LSQL =  LSQL & " SET DelYN = 'Y'"
					LSQL =  LSQL & "	,ModDate = GETDATE()"
					LSQL =  LSQL & "	,ModId = '" & UserID & "'"
					LSQL =  LSQL & " WHERE PopIDX = '" & CIDX & "'"
					
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
					LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblPopupManage] " 
					LSQL =  LSQL & " WHERE DelYN = 'N'"
					LSQL =  LSQL & " 	AND PopIDX = '" & CIDX & "'"
					
					SET LRs = DBCon.Execute(LSQL)
					IF Not(LRs.Eof OR LRs.Bof) Then
						
						LSQL =  "		 UPDATE [KoreaBadminton].[dbo].[tblPopupManage] " 
						LSQL =  LSQL & " SET Subject = '" & Subject & "'"
						LSQL =  LSQL & "	,PWidth = '" & PWidth & "'"
						LSQL =  LSQL & "	,PHeight = '" & PHeight & "'"
						LSQL =  LSQL & "	,PLeft = '" & PLeft & "'"
						LSQL =  LSQL & "	,PTop = '" & PTop & "'"
						LSQL =  LSQL & "	,PUseYN = '" & PUseYN & "'"
						LSQL =  LSQL & "	,PDailyUseYN = '" & PDailyUseYN & "'"
						LSQL =  LSQL & "	,SDate = '" & PSDate & "'"
						LSQL =  LSQL & "	,EDate = '" & PEDate & "'"
						
						'이미지업로드할 경우
						IF upFileName1 <> "" Then 
							LSQL =  LSQL & " ,PBackground = '" & upFileName1 & "'"
							
							'기존 업로드된 파일이 존재하면 삭제
							IF FSO.FileExists(global_filepath_temp & LRs("PBackground")) Then 
								FSO.DeleteFile(global_filepath_temp & LRs("PBackground"))
							End IF	
						
						Else
							'업로드된 이미지 삭제 체크박스 체크시 삭제처리
							IF Del_PBackgroundYN = "Y" Then
								LSQL =  LSQL & " ,PBackground = ''"
								
								'기존 업로드된 파일이 존재하면 삭제
								IF FSO.FileExists(global_filepath_temp & LRs("PBackground")) Then 
									FSO.DeleteFile(global_filepath_temp & LRs("PBackground"))
								End IF		
							End IF
							
						End IF	
						
						LSQL =  LSQL & "	,PContents = '" & PContents & "'"
						LSQL =  LSQL & "	,PZindex = '" & PZindex & "'"
						LSQL =  LSQL & "	,PDailyBgColor = '" & PDailyBgColor & "'"
						LSQL =  LSQL & "	,PDailyTxtColor = '" & PDailyTxtColor & "'"	
						LSQL =  LSQL & "	,PBgColor = '" & PBgColor & "'"
						LSQL =  LSQL & "	,PBorder = '" & PBorder & "'"
						LSQL =  LSQL & "	,PBorderColor = '" & PBorderColor & "'"						
						LSQL =  LSQL & "	,ModDate = GETDATE()"
						LSQL =  LSQL & "	,ModId = '" & UserID & "'"
						LSQL =  LSQL & " WHERE PopIDX = '" & CIDX & "'"
						
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
				
				LSQL =  "		INSERT INTO [KoreaBadminton].[dbo].[tblPopupManage] (" 
				LSQL =  LSQL & "	Subject "  
				LSQL =  LSQL & "	,PWidth " 
				LSQL =  LSQL & "	,PHeight " 										
				LSQL =  LSQL & "	,PLeft " 
				LSQL =  LSQL & "	,PTop " 
				LSQL =  LSQL & "	,PUseYN " 
				LSQL =  LSQL & "	,PDailyUseYN "  
				LSQL =  LSQL & "	,SDate " 
				LSQL =  LSQL & "	,EDate "  
				LSQL =  LSQL & "	,PContents "  
				LSQL =  LSQL & "	,PZindex"  
				LSQL =  LSQL & "	,PDailyBgColor"  
				LSQL =  LSQL & "	,PDailyTxtColor" 
				LSQL =  LSQL & "	,PBgColor"  
				LSQL =  LSQL & "	,PBorder"  
				LSQL =  LSQL & "	,PBorderColor"  
				LSQL =  LSQL & "	,PBackground"  
				LSQL =  LSQL & "	,DelYN "  					
				LSQL =  LSQL & "	,InsDate "  					
				LSQL =  LSQL & "	,ModDate "  					
				LSQL =  LSQL & "	,InsId "  					
				LSQL =  LSQL & ") VALUES( " 
				LSQL =  LSQL & "	'" & Subject & "'" 
				LSQL =  LSQL & "	,'" & PWidth & "'" 
				LSQL =  LSQL & "	,'" & PHeight & "'" 
				LSQL =  LSQL & "	,'" & PLeft & "'" 
				LSQL =  LSQL & "	,'" & PTop & "'" 
				LSQL =  LSQL & "	,'" & PUseYN & "'" 
				LSQL =  LSQL & "	,'" & PDailyUseYN & "'" 
				LSQL =  LSQL & "	,'" & PSDate & "'" 			
				LSQL =  LSQL & "	,'" & PEDate & "'" 			
				LSQL =  LSQL & "	,'" & PContents & "'" 			
				LSQL =  LSQL & "	,'" & PZindex & "'" 			
				LSQL =  LSQL & "	,'" & PDailyBgColor & "'" 			
				LSQL =  LSQL & "	,'" & PDailyTxtColor & "'" 			
				LSQL =  LSQL & "	,'" & PBgColor & "'" 			
				LSQL =  LSQL & "	,'" & PBorder & "'" 			
				LSQL =  LSQL & "	,'" & PBorderColor & "'" 			
				LSQL =  LSQL & "	,'" & upFileName1 & "'" 			
				LSQL =  LSQL & "	,'N'" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,GETDATE()" 
				LSQL =  LSQL & "	,'" & UserID & "'" 
				LSQL =  LSQL & ")"				
				
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
%>