<!--#include file="../dev/dist/config.asp"-->
<%
	'==============================================================================================
	'선수정보 수정
   	'==============================================================================================
	Check_AdminLogin()
	
	dim UserID 			: UserID 		= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))	
	
	dim FSO, Upload, UploadPath, upFileName, ExtensionType, Photo
	dim LSQL, LRs, CSQL, CRs													 
	dim txtSQL 
	 
	SET FSO = CreateObject("Scripting.FileSystemObject") 
	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
'		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start global_filepath, False  

	dim CIDX      		: CIDX      	= crypt.DecryptStringENC(fInject(Upload.Form("CIDX"))) 
	dim Nationality 	: Nationality 	= fInject(Upload.Form("Nationality"))
	dim UserEnName 		: UserEnName 	= HtmlSpecialChars(fInject(trim(Upload.Form("UserEnName"))))
	dim UserPhone 		: UserPhone 	= fInject(Upload.Form("UserPhone"))
   	dim UserEmail 		: UserEmail 	= fInject(Upload.Form("UserEmail"))
   	dim ZipCode 		: ZipCode		= fInject(Upload.Form("ZipCode"))
	dim Address 		: Address		= HtmlSpecialChars(fInject(trim(Upload.Form("Address"))))
	dim AddressDtl 		: AddressDtl	= HtmlSpecialChars(fInject(trim(Upload.Form("AddressDtl"))))
	dim EnterType		: EnterType		= fInject(Upload.Form("EnterType"))
	dim PlayerType		: PlayerType	= fInject(Upload.Form("PlayerType"))
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

	dim Del_PhotoYN 	: Del_PhotoYN	= fInject(Upload.Form("Del_PhotoYN"))

   	SET Photo = Upload.Form("Photo")

	UploadPath =  global_filepath&"Player\"&EnterType&"\" 				'업로드경로(/FileDown/Player/E/)

   	LSQL = "		SELECT * "
	LSQL = LSQL & "	FROM [KoreaBadminton].[dbo].[tblMemberHistory]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND MemberHistoryIDX = '"&CIDX&"'"

   	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof OR LRs.Bof) Then
   
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
											   
		'이미지업로드할 경우
		IF upFileName <> "" Then 
			txtSQL = " ,Photo = '" & upFileName & "'"

			'기존 업로드된 파일이 존재하면 삭제
			IF FSO.FileExists(UploadPath&LRs("Photo")) Then 
				FSO.DeleteFile(UploadPath&LRs("Photo"))
			End IF	
		Else
			'업로드된 이미지 삭제 체크박스 체크시 삭제처리
			IF Del_PhotoYN = "Y" Then
				txtSQL = " ,Photo = ''"

				'기존 업로드된 파일이 존재하면 삭제
				IF FSO.FileExists(UploadPath&LRs("Photo")) Then 
					FSO.DeleteFile(UploadPath&LRs("Photo"))
				End IF		
			End IF
		End IF	

	
		LSQL = "		UPDATE [KoreaBadminton].[dbo].[tblMember]" 
		LSQL = LSQL & "	SET UserEnName = '"&UserEnName&"'"
		LSQL = LSQL & "		,UserCnName = '"&UserCnName&"'"
		LSQL = LSQL & "		,UserPhone = '"&UserPhone&"'"
		LSQL = LSQL & "		,Email = '"&UserEmail&"'"
		LSQL = LSQL & "		,Nationality = '"&Nationality&"'" 
		LSQL = LSQL & "		,Address = '"&Address&"'" 
		LSQL = LSQL & "		,AddressDtl = '"&AddressDtl&"'" 
		LSQL = LSQL & "		,ZipCode = '"&ZipCode&"'" 
		LSQL = LSQL & "		,PlayerType = '"&PlayerType&"'" 
		LSQL = LSQL & "		,BWFCode = '"&BWFCode&"'" & txtSQL 'txtSQL: 이미지 업로드처리	
		LSQL = LSQL & "		,EditDate = GetDate() "
		LSQL = LSQL & "	WHERE DelYN = 'N' AND MemberIDX = '"&LRs("MemberIDX")&"'"
	
		DBCon.Execute(LSQL)	
		ErrorNum = ErrorNum + DBCon.Errors.Count	

			
		LSQL = "		UPDATE [KoreaBadminton].[dbo].[tblMemberHistory]" 
		LSQL = LSQL & "	SET UserEnName = '"&UserEnName&"'"
		LSQL = LSQL & "		,UserCnName = '"&UserCnName&"'"
		LSQL = LSQL & "		,UserPhone = '"&UserPhone&"'"
		LSQL = LSQL & "		,Email = '"&UserEmail&"'" 
		LSQL = LSQL & "		,Nationality = '"&Nationality&"'" 
		LSQL = LSQL & "		,Address = '"&Address&"'" 
		LSQL = LSQL & "		,AddressDtl = '"&AddressDtl&"'" 
		LSQL = LSQL & "		,ZipCode = '"&ZipCode&"'" 
		LSQL = LSQL & "		,PlayerType = '"&PlayerType&"'" 
		LSQL = LSQL & "		,BWFCode = '"&BWFCode&"'"&txtSQL 'txtSQL: 이미지 업로드처리	
		LSQL = LSQL & "		,EditDate = GetDate() "
		LSQL = LSQL & "	WHERE DelYN = 'N' AND MemberHistoryIDX = '"&CIDX&"'"
	
		DBCon.Execute(LSQL)	
		ErrorNum = ErrorNum + DBCon.Errors.Count

		LSQL = " 		IF EXISTS("
        LSQL = LSQL & "     		SELECT *"
		LSQL = LSQL & "				FROM [KoreaBadminton].[dbo].[tblMemberDtl]"
		LSQL = LSQL & "				WHERE MemberIDX = '"&LRs("MemberIDX")&"'"
		LSQL = LSQL & "	 		)"
		LSQL = LSQL & "		BEGIN"
		LSQL = LSQL & "			UPDATE [KoreaBadminton].[dbo].[tblMemberDtl]" 
		LSQL = LSQL & "			SET Paddress = '"&Paddress&"'"
		LSQL = LSQL & "				,OfficeTel = '"&OfficeTel&"'"
		LSQL = LSQL & "				,BloodType = '"&BloodType&"'"
		LSQL = LSQL & "				,Mheight = '"&Mheight&"'" 
		LSQL = LSQL & "				,Mweight = '"&Mweight&"'"
		LSQL = LSQL & "				,Leyesight = '"&Leyesight&"'"
		LSQL = LSQL & "				,Reyesight = '"&Reyesight&"'"
		LSQL = LSQL & "				,Specialty = '"&Specialty&"'"
		LSQL = LSQL & "				,Mnote = '"&Mnote&"'"
		LSQL = LSQL & "				,EditDate = GetDate() " 
		LSQL = LSQL & "			WHERE MemberIDX = '"&LRs("MemberIDX")&"'"
		LSQL = LSQL & "		END"
		LSQL = LSQL & "	ELSE"
		LSQL = LSQL & "		BEGIN"
		LSQL = LSQL & "			INSERT INTO [KoreaBadminton].[dbo].[tblMemberDtl](" 
		LSQL = LSQL & "				MemberIDX"
		LSQL = LSQL & "				,Paddress"
		LSQL = LSQL & "				,OfficeTel"
		LSQL = LSQL & "				,BloodType"
		LSQL = LSQL & "				,Mheight"
		LSQL = LSQL & "				,Mweight"
		LSQL = LSQL & "				,Leyesight"
		LSQL = LSQL & "				,Reyesight"
		LSQL = LSQL & "				,Specialty"
		LSQL = LSQL & "				,Mnote"
		LSQL = LSQL & "			)VALUES("
		LSQL = LSQL & "				'"&LRs("MemberIDX")&"'"
		LSQL = LSQL & "				,'"&Paddress&"'"
		LSQL = LSQL & "				,'"&OfficeTel&"'"
		LSQL = LSQL & "				,'"&BloodType&"'"
		LSQL = LSQL & "				,'"&Mheight&"'" 
		LSQL = LSQL & "				,'"&Mweight&"'"
		LSQL = LSQL & "				,'"&Leyesight&"'"
		LSQL = LSQL & "				,'"&Reyesight&"'"
		LSQL = LSQL & "				,'"&Specialty&"'"
		LSQL = LSQL & "				,'"&Mnote&"'"
		LSQL = LSQL & "			)"
		LSQL = LSQL & "   	END"

		DBCon.Execute(LSQL)
		ErrorNum = ErrorNum + DBCon.Errors.Count

		IF ErrorNum > 0 Then
			DBCon.RollbackTrans()				
			Response.Write "FALSE|66"				
		Else					
			DBCon.CommitTrans()				
			Response.Write "TRUE|90"			
		End IF
	Else
		response.Write "FALSE|99"
		response.End()
	End IF
		LRs.Close
	SET LRs = Nothing
			
	
%>