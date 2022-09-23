<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'선수등록
   	'==============================================================================================
	Check_AdminLogin()
	
	dim UserID 			: UserID 		= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))	
	
   	dim MemberIDX
	dim FSO, Upload, UploadPath, upFileName, ExtensionType, Photo
	 
	SET FSO = CreateObject("Scripting.FileSystemObject") 
	
	UploadPath =  global_filepath&"\Player\E\" 				'업로드경로(/FileDown/Player/E/)
	
   	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
'		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start UploadPath, False
   
   
   	dim Nationality		: Nationality	= fInject(Upload.Form("Nationality"))
   	dim PlayerType 		: PlayerType	= fInject(Upload.Form("PlayerType"))
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
	dim BWFCode			: BWFCode		= HtmlSpecialChars(fInject(trim(Upload.Form("BWFCode"))))
   	dim RegYear			: RegYear		= fInject(Upload.Form("RegYear"))

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
   	
   	LSQL = "		SELECT COUNT(*) "
	LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblMemberHistory]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND RegYear = '"&RegYear&"'"
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
		LSQL = LSQL & "	INSERT INTO [KoreaBadminton].[dbo].[tblMember] (" 
		LSQL = LSQL & "		UserName " 
		LSQL = LSQL & "		,UserEnName " 
		LSQL = LSQL & "		,UserCnName "
		LSQL = LSQL & "		,UserPhone " 
		LSQL = LSQL & "		,Birthday " 
		LSQL = LSQL & "		,Sex " 
		LSQL = LSQL & "		,Email"
		LSQL = LSQL & "		,Nationality " 		
		LSQL = LSQL & "		,Address"  
		LSQL = LSQL & "		,AddressDtl"
		LSQL = LSQL & "		,ZipCode"
		LSQL = LSQL & "		,DelYN "
		LSQL = LSQL & "		,PlayerType"  
		LSQL = LSQL & "		,BWFCode"
		LSQL = LSQL & "		,EnterType"
		LSQL = LSQL & "		,Photo"
		LSQL = LSQL & "		,Team"  
		LSQL = LSQL & "		,RegTp"
		LSQL = LSQL & "		,RegGubun"
		LSQL = LSQL & "		,NowRegYN"		
		LSQL = LSQL & "		,WriteDate "
		LSQL = LSQL & "		,EditDate "
		LSQL = LSQL & "	) VALUES( " 
		LSQL = LSQL & "		'" & UserName & "'" 
		LSQL = LSQL & "		,'" & UserEnName & "'"
		LSQL = LSQL & "		,'" & UserCnName & "'" 
		LSQL = LSQL & "		,'" & UserPhone & "'" 
		LSQL = LSQL & "		,'" & Birthday & "'" 
		LSQL = LSQL & "		,'" & Sex & "'" 
		LSQL = LSQL & "		,'" & UserEmail & "'" 
		LSQL = LSQL & "		,'" & Nationality & "'" 		
		LSQL = LSQL & "		,'" & Address & "'" 			
		LSQL = LSQL & "		,'" & AddressDtl & "'" 
		LSQL = LSQL & "		,'" & ZipCode & "'"
		LSQL = LSQL & "		,'N'"
		LSQL = LSQL & "		,'" & PlayerType & "'" 		'선수구분[B0080001:내국인 | B0080002:외국인]
		LSQL = LSQL & "		,'" & BWFCode & "'" 			
		LSQL = LSQL & "		,'E'" 
		LSQL = LSQL & "		,'" & upFileName & "'" 			
   		LSQL = LSQL & "		,'" & Team & "'" 
		LSQL = LSQL & "		,'A'" 	
		LSQL = LSQL & "		,'F'" 	
   		LSQL = LSQL & "		,'N'" 						'체육회 DB외 등록은 N처리		 	
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "	)"
		LSQL = LSQL & " SELECT @@IDENTITY"

		SET CRs = DBCon.Execute(LSQL)	
		ErrorNum = ErrorNum + DBCon.Errors.Count

		IF Not(CRs.Eof OR CRs.Bof) Then
			MemberIDX = CRs(0)
		End IF
			CRs.Close
		SET CRs = Nothing

		LSQL = "		INSERT INTO [KoreaBadminton].[dbo].[tblMemberHistory] (" 
		LSQL = LSQL & "		MemberIDX " 
		LSQL = LSQL & "		,UserName " 
		LSQL = LSQL & "		,UserEnName "
		LSQL = LSQL & "		,UserCnName " 
		LSQL = LSQL & "		,UserPhone " 
		LSQL = LSQL & "		,Birthday "
		LSQL = LSQL & "		,Sex "
		LSQL = LSQL & "		,Email"
		LSQL = LSQL & "		,Nationality " 
		LSQL = LSQL & "		,Address"  
		LSQL = LSQL & "		,AddressDtl"
		LSQL = LSQL & "		,ZipCode"
		LSQL = LSQL & "		,DelYN "		
		LSQL = LSQL & "		,PlayerType"
		LSQL = LSQL & "		,BWFCode"
		LSQL = LSQL & "		,EnterType"
		LSQL = LSQL & "		,Team"
		LSQL = LSQL & "		,Photo"		
		LSQL = LSQL & "		,RegYear"
		LSQL = LSQL & "		,NowRegYN"
		LSQL = LSQL & "		,WriteDate "
		LSQL = LSQL & "		,EditDate "
		LSQL = LSQL & "	) VALUES( " 		
		LSQL = LSQL & "		'" & MemberIDX & "'" 
		LSQL = LSQL & "		,'" & UserName & "'" 	
		LSQL = LSQL & "		,'" & UserEnName & "'" 
		LSQL = LSQL & "		,'" & UserCnName & "'" 
		LSQL = LSQL & "		,'" & UserPhone & "'" 
		LSQL = LSQL & "		,'" & Birthday & "'" 
		LSQL = LSQL & "		,'" & Sex & "'" 
		LSQL = LSQL & "		,'" & UserEmail & "'" 
		LSQL = LSQL & "		,'" & Nationality & "'"
		LSQL = LSQL & "		,'" & Address & "'" 			
		LSQL = LSQL & "		,'" & AddressDtl & "'" 
		LSQL = LSQL & "		,'" & ZipCode & "'"
		LSQL = LSQL & "		,'N'"				
		LSQL = LSQL & "		,'" & PlayerType & "'" 		'선수구분[B0080001:내국인 | B0080002:외국인]
		LSQL = LSQL & "		,'" & BWFCode & "'"
		LSQL = LSQL & "		,'E'" 		
   		LSQL = LSQL & "		,'" & Team & "'" 
		LSQL = LSQL & "		,'" & upFileName & "'"
		LSQL = LSQL & "		,'" & RegYear & "'" 
   		LSQL = LSQL & "		,'N'" 						'체육회 DB외 등록은 N처리		
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "		,GETDATE()" 
		LSQL = LSQL & "	)"

		DBCon.Execute(LSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count	

		LSQL = "		INSERT INTO [KoreaBadminton].[dbo].[tblMemberDtl](" 
		LSQL = LSQL & "		MemberIDX"
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
		LSQL = LSQL & "		'"& MemberIDX &"'"
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