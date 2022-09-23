<!--#include file="../Library/ajax_config.asp"-->
<%
	'=======================================================================================
	'회원 선수증 이미지 삭제 페이지
	'=======================================================================================
	Check_Login()
	
	dim MemberIDX : MemberIDX 	= decode(Request.Cookies("MemberIDX"), 0)
	
	dim FSO, UploadPath
	dim CSQL, upSQL, CRs 
	
	'업로드경로
	UploadPath =  server.mappath("\")&"\TM_Player\"
  	
	SET FSO = CreateObject("Scripting.FileSystemObject") 	

	If MemberIDX = "" Then 
		response.Write "FALSE|3"
		Response.End
	Else
		'해당아이디 정보조회
		CSQL = " 		SELECT ISNULL(PhotoPlayerID, '') PhotoPlayerID "  
		CSQL = CSQL & " FROM [Sportsdiary].[dbo].[tblMember] " 	
		CSQL = CSQL & " WHERE DelYN = 'N'" 					
		CSQL = CSQL & "		AND MemberIDX = '"&MemberIDX&"'"

		SET CRs = Dbcon.Execute(CSQL)
		IF Not(CRs.eof or CRs.bof) Then
			
			IF CRs("PhotoPlayerID")<> "" Then
				'파일이 존재하면 삭제
				IF FSO.FileExists(UploadPath & mid(CRs("PhotoPlayerID"), 4, len(CRs("PhotoPlayerID")))) Then 
					FSO.DeleteFile(UploadPath & mid(CRs("PhotoPlayerID"), 4, len(CRs("PhotoPlayerID")))) 
					
					'회원프로필 쿠키삭제 후 기본이미지 쿠키세팅
					Response.Cookies("PhotoPlayerID") = encode(ImgDefault, 0)
				End IF
				
				'이미지정보 업데이트
				upSQL = "		  UPDATE [Sportsdiary].[dbo].[tblMember] " 
				upSQL = upSQL & " SET PhotoPlayerID = NULL" 
				upSQL = upSQL & "	,WriteDate = GetDate() "
				upSQL = upSQL & " WHERE MemberIDX = "&MemberIDX
				
				Dbcon.Execute(upSQL)
				
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
		
		DBClose()
		
	End If 
	
%>
