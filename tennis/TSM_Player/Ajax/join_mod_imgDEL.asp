<!--#include file="../Library/ajax_config.asp"-->
<%
	'=======================================================================================
	'회원프로필 이미지 삭제 페이지
	'=======================================================================================
	Check_Login()
	
	MemberIDX = COOKIE_MEMBER_IDX()
	
	dim FSO, UploadPath
	dim CSQL, upSQL, CRs 
	
	'업로드경로
	UploadPath =  server.mappath("\")&"\M_Player\"
  	
	SET FSO = CreateObject("Scripting.FileSystemObject") 	

	IF MemberIDX = "" Then 
		response.Write "FALSE|3"
		Response.End
	Else
		'해당아이디 정보조회
		CSQL = " 		SELECT ISNULL(PhotoPath, '') PhotoPath "  
		CSQL = CSQL & " FROM [SD_tennis].[dbo].[tblMember] " 	
		CSQL = CSQL & " WHERE DelYN = 'N'" 					
		CSQL = CSQL & "		AND MemberIDX = '"&MemberIDX&"'"

		SET CRs = DBCon3.Execute(CSQL)
		IF Not(CRs.eof or CRs.bof) Then
			
			IF CRs("PhotoPath")<> "" Then
				'파일이 존재하면 삭제
				IF FSO.FileExists(UploadPath & mid(CRs("PhotoPath"), 4, len(CRs("PhotoPath")))) Then 
					FSO.DeleteFile(UploadPath & mid(CRs("PhotoPath"), 4, len(CRs("PhotoPath")))) 
					
					'회원프로필 쿠키삭제 후 기본이미지 쿠키세팅
					Response.Cookies(SportsGb)("PhotoPath") = encode(ImgDefault, 0)
				End IF
				
				'이미지정보 업데이트
				upSQL = "		  UPDATE [SD_tennis].[dbo].[tblMember] " 
				upSQL = upSQL & " SET PhotoPath = NULL" 
				upSQL = upSQL & " WHERE MemberIDX = '"&MemberIDX&"'"
				
				DBCon3.Execute(upSQL)
				
				response.Write "TRUE|"
			Else	
				response.Write "FALSE|1"
				Response.End	
			End IF
		Else
			response.Write "FALSE|2"
			Response.End	
		End IF
			CRs.Close
		SET CRs = Nothing
		
		DBClose3()
		
	End IF 
	
%>
