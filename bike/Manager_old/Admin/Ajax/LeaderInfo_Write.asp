<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'지도자등록 
   	'NowRegYN 체육회 DB외 등록은 N 처리
   	'/Main_HP/LeaderInfo_Write.asp
   	'==============================================================================================
	Check_AdminLogin()
	
	dim UserID 			: UserID 		= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))	
	
   	dim LeaderIDX
	dim FSO, Upload, UploadPath, upFileName, ExtensionType, Photo
	 
	SET FSO = CreateObject("Scripting.FileSystemObject") 
	
	UploadPath =  global_filepath&"\Leader\" 				'업로드경로(/FileDown/Leader/)
	
   	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
'		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start UploadPath, False
   
   
   	dim LeaderType		: LeaderType	= fInject(Upload.Form("LeaderType"))
   	dim LeaderTypeSub 	: LeaderTypeSub = fInject(Upload.Form("LeaderTypeSub"))
   	dim UserName 		: UserName 		= HtmlSpecialChars(fInject(trim(Upload.Form("UserName"))))
	dim UserEnName 		: UserEnName 	= HtmlSpecialChars(fInject(trim(Upload.Form("UserEnName"))))
	dim Sex 			: Sex 			= fInject(Upload.Form("Sex"))
	dim Birthday 		: Birthday 		= fInject(Upload.Form("Birthday"))
   	dim UserPhone 		: UserPhone 	= fInject(Upload.Form("UserPhone"))
   	dim UserEmail 		: UserEmail 	= fInject(Upload.Form("UserEmail"))
   	dim ZipCode 		: ZipCode		= fInject(Upload.Form("ZipCode"))
	dim Address 		: Address		= HtmlSpecialChars(fInject(trim(Upload.Form("Address"))))
	dim AddressDtl 		: AddressDtl	= HtmlSpecialChars(fInject(trim(Upload.Form("AddressDtl"))))
	dim Team 			: Team			= fInject(Upload.Form("Team"))		   	
   	dim RegYear			: RegYear		= fInject(Upload.Form("RegYear"))

	dim BWFCode			: BWFCode		= HtmlSpecialChars(fInject(trim(Upload.Form("BWFCode"))))
	dim UserCnName		: UserCnName	= HtmlSpecialChars(fInject(trim(Upload.Form("UserCnName"))))
	dim Paddress		: Paddress		= HtmlSpecialChars(fInject(trim(Upload.Form("Paddress"))))
	dim OfficeTel		: OfficeTel		= fInject(trim(Upload.Form("OfficeTel")))
	dim BloodType		: BloodType		= fInject(trim(Upload.Form("BloodType")))
	dim Mheight			: Mheight		= fInject(trim(Upload.Form("Mheight")))
	dim Mweight			: Mweight		= fInject(trim(Upload.Form("Mweight")))
	dim Leyesight		: Leyesight		= fInject(trim(Upload.Form("Leyesight")))
	dim Reyesight		: Reyesight		= fInject(trim(Upload.Form("Reyesight")))
	dim Specialty		: Specialty		= HtmlSpecialChars(fInject(trim(Upload.Form("Specialty"))))
	dim Mnote			: Mnote			= HtmlSpecialChars(fInject(trim(Upload.Form("Mnote"))))
   
   	
   	SET Photo = Upload.Form("Photo")
   
   	IF RegYear = "" Then RegYear = Year(Date())
   
   	dim LeaderTypeNm 
   
	SELECT CASE LeaderType
	 	CASE "2"	: LeaderTypeNm = "감독" : LeaderTypeSub = ""
	 	CASE "3"	: LeaderTypeNm = "코치"
	END SELECT
   
   	
   	LSQL = "		SELECT COUNT(*) "
	LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblLeaderInfoHistory]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND RegistYear = '"&RegYear&"'"
	LSQL = LSQL & " 	AND UserName = '"&UserName&"'"
	LSQL = LSQL & " 	AND Replace(Birthday, '-', '') = '"&Birthday&"'"
	LSQL = LSQL & "		AND Sex = '" & Sex & "'"
	
	SET LRs = DBCon.Execute(LSQL)
	IF LRs(0) > 0 Then 
		response.Write "FALSE|99"
		response.End()
	Else
		On Error Resume Next
			
		DBCon.BeginTrans()
		
		IF Photo <> "" Then			
			ExtensionType = Photo.FileType	'파일확장자

			'파일 확장자 체크
			IF LCase(ExtensionType) = "jpeg" Or LCase(ExtensionType) = "jpg" Or LCase(ExtensionType) = "gif" Or LCase(ExtensionType) = "png" Or LCase(ExtensionType) = "bmp" Then 

				Upload.Save UploadPath, False			'이미지 업로드
				upFileName = Photo.ShortSaveName		'저장된업로드 파일명
			Else
				response.Write "FALSE|33"
				response.End()
			End IF 	
		End IF
											   
		LSQL = "		SET NOCOUNT ON "
		LSQL = LSQL & "	INSERT INTO [KoreaBadminton].[dbo].[tblLeaderInfo] (" 
		LSQL = LSQL & "		UserName " 
		LSQL = LSQL & "		,UserEnName " 										
		LSQL = LSQL & "		,UserPhone " 
		LSQL = LSQL & "		,Birthday " 
		LSQL = LSQL & "		,Sex " 
		LSQL = LSQL & "		,Email"  
		LSQL = LSQL & "		,Photo" 											   
		LSQL = LSQL & "		,Team"  
		LSQL = LSQL & "		,ZipCode"  
		LSQL = LSQL & "		,Address"  
		LSQL = LSQL & "		,AddressDtl"  
		LSQL = LSQL & "		,LeaderType" 
		LSQL = LSQL & "		,LeaderTypeNm" 
		LSQL = LSQL & "		,LeaderTypeSub" 
		LSQL = LSQL & "		,RegistYear" 	
		LSQL = LSQL & "		,NowRegYN"											   
		LSQL = LSQL & "		,DelYN "  					
		LSQL = LSQL & "		,WriteDate "  					
		LSQL = LSQL & "		,InsDate "
		LSQL = LSQL & "		,ModDate "
		LSQL = LSQL & "		,InsID "  					
		LSQL = LSQL & "		,ModID "  					
		LSQL = LSQL & "	) VALUES( " 
		LSQL = LSQL & "		'" & UserName & "'" 
		LSQL = LSQL & "		,'" & UserEnName & "'" 
		LSQL = LSQL & "		,'" & UserPhone & "'" 
		LSQL = LSQL & "		,'" & Birthday & "'" 
		LSQL = LSQL & "		,'" & Sex & "'" 
		LSQL = LSQL & "		,'" & UserEmail & "'" 
		LSQL = LSQL & "		,'" & upFileName & "'" 			
		LSQL = LSQL & "		,'" & Team & "'" 
		LSQL = LSQL & "		,'" & ZipCode & "'" 			
		LSQL = LSQL & "		,'" & Address & "'" 			
		LSQL = LSQL & "		,'" & AddressDtl & "'" 			
		LSQL = LSQL & "		,'" & LeaderType & "'" 			
		LSQL = LSQL & "		,'" & LeaderTypeNm & "'" 			
		LSQL = LSQL & "		,'" & LeaderTypeSub & "'" 			
		LSQL = LSQL & "		,'" & RegYear & "'" 	
		LSQL = LSQL & "		,'N'" 						'체육회 DB외 등록은 N처리
		LSQL = LSQL & "		,'N'" 	
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,'" & UserID & "'" 			
		LSQL = LSQL & "		,'" & UserID & "'" 			
		LSQL = LSQL & "	)"
		LSQL = LSQL & " SELECT @@IDENTITY"
								
		SET CRs = DBCon.Execute(LSQL)	
		ErrorNum = ErrorNum + DBCon.Errors.Count	
		IF Not(CRs.Eof OR CRs.Bof) Then
			LeaderIDX = CRs(0)
		End IF
			CRs.Close
		SET CRs = Nothing
											 
											 
		LSQL = "		INSERT INTO [KoreaBadminton].[dbo].[tblLeaderInfoHistory] (" 
		LSQL = LSQL & "		LeaderIDX " 
		LSQL = LSQL & "		,UserName " 	
		LSQL = LSQL & "		,UserEnName " 										
		LSQL = LSQL & "		,UserPhone " 
		LSQL = LSQL & "		,Birthday " 
		LSQL = LSQL & "		,Sex " 
		LSQL = LSQL & "		,Email"  
		LSQL = LSQL & "		,Photo" 											   
		LSQL = LSQL & "		,Team"  
		LSQL = LSQL & "		,ZipCode"  
		LSQL = LSQL & "		,Address"  
		LSQL = LSQL & "		,AddressDtl"  
		LSQL = LSQL & "		,LeaderType" 
		LSQL = LSQL & "		,LeaderTypeNm" 
		LSQL = LSQL & "		,LeaderTypeSub" 
		LSQL = LSQL & "		,RegistYear"
		LSQL = LSQL & "		,NowRegYN"											   
		LSQL = LSQL & "		,DelYN "  					
		LSQL = LSQL & "		,WriteDate "  					
		LSQL = LSQL & "		,InsDate "
		LSQL = LSQL & "		,ModDate "
		LSQL = LSQL & "		,InsID "  					
		LSQL = LSQL & "		,ModID "  					
		LSQL = LSQL & "	) VALUES( " 
		LSQL = LSQL & "		'" & LeaderIDX & "'" 
		LSQL = LSQL & "		,'" & UserName & "'" 
		LSQL = LSQL & "		,'" & UserEnName & "'" 
		LSQL = LSQL & "		,'" & UserPhone & "'" 
		LSQL = LSQL & "		,'" & Birthday & "'" 
		LSQL = LSQL & "		,'" & Sex & "'" 
		LSQL = LSQL & "		,'" & UserEmail & "'" 
		LSQL = LSQL & "		,'" & upFileName & "'" 			
		LSQL = LSQL & "		,'" & Team & "'" 
		LSQL = LSQL & "		,'" & ZipCode & "'" 			
		LSQL = LSQL & "		,'" & Address & "'" 			
		LSQL = LSQL & "		,'" & AddressDtl & "'" 			
		LSQL = LSQL & "		,'" & LeaderType & "'" 			
		LSQL = LSQL & "		,'" & LeaderTypeNm & "'" 			
		LSQL = LSQL & "		,'" & LeaderTypeSub & "'" 	
		LSQL = LSQL & "		,'" & RegYear & "'" 
		LSQL = LSQL & "		,'N'" 							'체육회 DB외 등록은 N처리
		LSQL = LSQL & "		,'N'" 	
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,'" & UserID & "'" 			
		LSQL = LSQL & "		,'" & UserID & "'" 			
		LSQL = LSQL & "	)"

		DBCon.Execute(LSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count

		LSQL = "		INSERT INTO [KoreaBadminton].[dbo].[tblLeaderInfoDtl](" 
		LSQL = LSQL & "		LeaderIDX"
		LSQL = LSQL & "		,UserCnName"
		LSQL = LSQL & "		,BWFCode"
		LSQL = LSQL & "		,Paddress"
		LSQL = LSQL & "		,OfficeTel"
		LSQL = LSQL & "		,BloodType"
		LSQL = LSQL & "		,Mheight"
		LSQL = LSQL & "		,Mweight"
		LSQL = LSQL & "		,Leyesight"
		LSQL = LSQL & "		,Reyesight"
		LSQL = LSQL & "		,Specialty"
		LSQL = LSQL & "		,Mnote"
		LSQL = LSQL & "	)VALUES("
		LSQL = LSQL & "		'"& LeaderIDX &"'"
		LSQL = LSQL & "		,'" & UserCnName & "'" 
		LSQL = LSQL & "		,'" & BWFCode & "'" 
		LSQL = LSQL & "		,'"&Paddress&"'"
		LSQL = LSQL & "		,'"&OfficeTel&"'"
		LSQL = LSQL & "		,'"&BloodType&"'"
		LSQL = LSQL & "		,'"&Mheight&"'" 
		LSQL = LSQL & "		,'"&Mweight&"'"
		LSQL = LSQL & "		,'"&Leyesight&"'"
		LSQL = LSQL & "		,'"&Reyesight&"'"
		LSQL = LSQL & "		,'"&Specialty&"'"
		LSQL = LSQL & "		,'"&Mnote&"'"
		LSQL = LSQL & "	)"

		DBCon.Execute(LSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count

		IF ErrorNum > 0 Then
			DBCon.RollbackTrans()				
			Response.Write "FALSE|66"				
		Else					
			DBCon.CommitTrans()				
			Response.Write "TRUE|90"			
		End IF

	End IF
		LRs.Close
	SET LRs = Nothing
%>