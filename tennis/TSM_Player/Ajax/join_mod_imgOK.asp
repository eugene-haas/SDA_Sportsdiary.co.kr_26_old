<!--#include file="../Library/ajax_config.asp"-->
<%
	'=======================================================================================
	'회원프로필 이미지 수정 페이지
	'=======================================================================================
	
	dim FSO, Upload
	dim UploadPath
	dim upFileName1 
	dim ExtensionType1
	dim ChkSQL, upSQL,  CRs
	
	SET FSO = CreateObject("Scripting.FileSystemObject") 
	'업로드경로
	UploadPath =  server.mappath("\")&"\M_Player\Upload\"
	
	'Tab Upload 4.5 업로드 컴포넌트를 생성합니다.
	SET Upload = Server.CreateObject("TABSUpload4.Upload")
		Upload.CodePage = 65001
'		Upload.MaxBytesToAbort = 5 * 1024 * 1024	'Max 5MBytes
		Upload.Start UploadPath, False
	
	dim b_upFile, MemberIDX, PlayerIDX
	
	SET b_upFile     = Upload.Form("b_upFile")
	SET MemberIDX    = Upload.Form("MemberIDX")
	SET PlayerIDX    = Upload.Form("PlayerIDX")
	

	'파일확장자
	ExtensionType1 = b_upFile.FileType	
	
	
	IF b_upFile <> "" Then 
		'파일 확장자 체크
		If LCase(ExtensionType1) = "jpg" Or LCase(ExtensionType1) = "gif" Or LCase(ExtensionType1) = "png" Or LCase(ExtensionType1) = "bmp" Then 
			
			'이미지 업로드
			Upload.Save UploadPath, False
			
			
			'저장된업로드 파일명
			upFileName1 = b_upFile.ShortSaveName
			
			Response.Cookies(SportsGb).Domain = ".sportsdiary.co.kr"
			Response.Cookies(SportsGb).path = "/"	
					
			
			'해당아이디 정보조회
			ChkSQL = " SELECT * " &_ 
					 " FROM SD_tennis.dbo.tblMember " &_	
					 " WHERE DelYN = 'N'" &_					
					 "		and MemberIDX = '"&MemberIDX&"'"

			SET CRs = Dbcon.Execute(ChkSQL)
			IF Not(CRs.eof or CRs.bof) Then

				'기존 업로드된 파일이 존재하면 삭제
				IF FSO.FileExists(UploadPath&CRs("PhotoPath")) Then 
					FSO.DeleteFile(UploadPath&CRs("PhotoPath"))

					'회원프로필 쿠키삭제
					Response.Cookies(SportsGb)("PhotoPath") = ""	 
				End IF
				
				'이미지정보 업데이트
				upSQL = " UPDATE SD_tennis.dbo.tblMember " &_
						" SET PhotoPath = '"&"../upload/"&upFileName1&"'" &_
						" WHERE MemberIDX = "&MemberIDX
				
				Dbcon.Execute(upSQL)				
				
				response.Write "TRUE|../upload/"&upFileName1
				
				'회원프로필 이미지 쿠키세팅
				Response.Cookies(SportsGb)("PhotoPath") = encode("../upload/"&upFileName1, 0)  			
				
			Else
				response.Write "FALSE|3"
				response.End	
			End IF
			
				CRs.Close
			SET CRs = Nothing
			 
			DBClose()			
			
		Else
			response.Write "FALSE|1"
			response.End
		End If 
	Else
		response.Write "FALSE|2"
		response.End
	End If 
	
%>
