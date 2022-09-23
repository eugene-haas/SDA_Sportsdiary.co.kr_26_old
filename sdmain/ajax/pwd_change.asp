<!--#include file="../Library/ajax_config.asp"-->
<%
	'=============================================================================
	'비밀번호 변경 페이지
	'=============================================================================
	Check_Login()
	
	dim SD_MemberIDX 	: SD_MemberIDX 	= decode(Request.Cookies("SD")("MemberIDX"), 0)

  dim SD_UID 	: SD_UID 	= Request.Cookies("SD")("UserID")

  'dim SD_MemberIDXTEST 	: SD_MemberIDXTEST 	= decode("3233323939", 0)

	dim nowpass 		: nowpass 		= fInject(trim(Request("nowpass")))
	dim change_pass 	: change_pass  	= fInject(trim(Request("change_pass")))
	
	dim LSQL, LRs, CSQL
		
	IF SD_MemberIDX = "" Or nowpass = "" Or change_pass = "" Then 
		Response.Write "FALSE|200"
		Response.End
	Else
      '  On Error Resume Next
			
		DBcon.BeginTrans() 
        DBcon3.BeginTrans()  
		
		LSQL = "		SELECT UserID, UserPass " 
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember] " 
		LSQL = LSQL & " WHERE DelYN = 'N'" 
		LSQL = LSQL & "		AND UserID = '"&SD_UID&"' " 
		'LSQL = LSQL & "		AND UserPass = '"&nowpass&"' "
	    'LSQL = LSQL & "		AND TEST = '"&SD_UID&"' "
	    LSQL = LSQL & "		AND PWDCOMPARE('"&nowpass&"', PassEnc) = 1 "

    'response.Write LSQL
				 
		SET LRs = DBCon3.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			
			IF change_pass = nowpass Then
				Response.Write "FALSE|33"
                response.end                                                        
			Else
				CSQL = "		UPDATE [SD_Member].[dbo].[tblMember] " 			
				CSQL = CSQL & " SET UserPass = '"&change_pass&"' " 
				CSQL = CSQL & "     ,UserPassGb = '' "
				CSQL = CSQL & "     ,PassEnc = PWDENCRYPT('"&change_pass&"') "
				CSQL = CSQL & "		WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND MemberIDX = '"&SD_MemberIDX&"' "

        'response.Write CSQL
	      'response.End			

				DBCon3.Execute(CSQL)
				ErrorNum = ErrorNum + DBCon3.Errors.Count	
                                                                   
				'유도의 경우 회원정보 업데이트합니다.
                '[SportsDiary].[dbo].[tblMember]
                 
				IF MemberIDX <> "" Then
					CSQL = "		UPDATE [SportsDiary].[dbo].[tblMember] " 			
					CSQL = CSQL & " SET UserPass = '"&change_pass&"' " 
					CSQL = CSQL & " WHERE DelYN = 'N' "
					CSQL = CSQL & "		AND SD_UserID = '"&LRs("UserID")&"' "				
					
					DBCon.Execute(CSQL)
                    ErrorNum = ErrorNum + DBCon.Errors.Count	                                                                                                             
				End IF
                                                                                                             
                IF ErrorNum > 0 Then
                    IF MemberIDX <> "" Then DBCon.RollbackTrans()				
					DBCon3.RollbackTrans()		
                    Response.Write "FALSE|66"				
                Else
                    IF MemberIDX <> "" Then DBCon.CommitTrans()
                    DBCon3.CommitTrans()	
                    
                    '비밀번호 변경시 임시비밀번호 구분값 쿠키값은 초기화합니다.                                                                       
                    response.Cookies("SD").Domain 			= ".sportsdiary.co.kr"
			        response.Cookies("SD").path 			= "/"
                    response.Cookies("SD")("UserPassGb")    = ""   '임시비밀번호 구분값 NULL SET
      
                    response.Write "TRUE|" 				
      
                End IF
									
				
			End IF
			
		Else
			Response.Write "FALSE|99"
		End IF		
			LRs.Close
		SET LRs = Nothing
		
		DBClose3()
           
	
	End IF

%>	