<!--#include file="../dev/dist/config.asp"-->
<%
	'===========================================================================================
	'회원정보 수정페이지
	'===========================================================================================
	dim MemberIDX	 	: MemberIDX 		= crypt.DecryptStringENC(fInject(request("CIDX")))      
	dim UserPhone 		: UserPhone 		= fInject(Request("UserPhone"))
    dim UserEnName 		: UserEnName   		= HtmlSpecialChars(fInject(trim(Request("UserEnName")))) 
	dim UserEmail 		: UserEmail 		= HtmlSpecialChars(fInject(trim(Request("UserEmail"))))
	dim Address 		: Address 			= HtmlSpecialChars(fInject(Request("Address")))
	dim AddressDtl 	    : AddressDtl 		= HtmlSpecialChars(fInject(trim(Request("AddressDtl"))))
	dim ZipCode 		: ZipCode 			= fInject(Request("ZipCode"))	
	
	dim LSQL, LRs, JRs, JSQL
	dim ErrorNum
     
	IF MemberIDX = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
        On Error Resume Next
     
        DBCon.BeginTrans()		
        DBCon8.BeginTrans()		

		'tblMember 가입내역 조회		
		LSQL = "		SELECT UserID "
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember] "
		LSQL = LSQL & " WHERE DelYN = 'N'"		
		LSQL = LSQL & " 	AND MemberIDX = '"&MemberIDX&"' "
		
		SET LRs = DBCon8.Execute(LSQL)	
		IF LRs.eof or LRs.bof Then
			response.Write "FALSE|99"
			response.End()
		Else			

			'[SportsDiary].[dbo].[tblMember]
            JSQL = "		SELECT COUNT(*) cnt "
            JSQL = JSQL & " FROM [Sportsdiary].[dbo].[tblMember] "
            JSQL = JSQL & " WHERE DelYN = 'N'"		
            JSQL = JSQL & " 	AND SD_UserID = '"&LRs("UserID")&"' "
                                                                   
            SET JRs = DBCon8.Execute(JSQL)	
            IF JRs(0) > 0 Then
                                                                   
                LSQL = "		UPDATE [Sportsdiary].[dbo].[tblMember] " 
                LSQL = LSQL & " SET UserEnName = '"&UserEnName&"'" 
                LSQL = LSQL & "		,UserPhone = '"&UserPhone&"'" 
                LSQL = LSQL & "		,Email = '"&UserEmail&"'"  
                LSQL = LSQL & "		,Address = '"&Address&"'" 
                LSQL = LSQL & "		,AddressDtl = '"&AddressDtl&"'" 
                LSQL = LSQL & "		,ZipCode = '"&ZipCode&"'" 
                LSQL = LSQL & "		,WriteDate = GETDATE() "  					
                LSQL = LSQL & " WHERE DelYN = 'N' AND SD_UserID = '"&LRs("UserID")&"' " 			

                DBCon.Execute(LSQL)	
			    ErrorNum = ErrorNum + DBCon.Errors.Count
                                                                  
			End IF
                JRs.Close
            SET JRs = Nothing

			'[SD_Member].[dbo].[tblMember]
			LSQL = "		UPDATE [SD_Member].[dbo].[tblMember] " 
			LSQL = LSQL & " SET UserEnName = '" & UserEnName & "'" 
			LSQL = LSQL & "		,UserPhone = '" & UserPhone & "'" 
			LSQL = LSQL & "		,Email = '" & UserEmail & "'"  
			LSQL = LSQL & "		,Address = '" & Address & "'" 
			LSQL = LSQL & "		,AddressDtl = '" & AddressDtl & "'" 
			LSQL = LSQL & "		,ZipCode = '" & ZipCode & "'" 
			LSQL = LSQL & "		,ModDate = GETDATE() "  					
			LSQL = LSQL & " WHERE MemberIDX = '" & MemberIDX & "' " 			
			
			DBCon8.Execute(LSQL)	
			ErrorNum = ErrorNum + DBCon8.Errors.Count

            IF ErrorNum > 0 Then			    	 
                DBCon.RollbackTrans()
                DBCon8.RollbackTrans()
				Response.Write "FALSE|66"				
			Else				   	 
                DBCon.CommitTrans()
                DBCon8.CommitTrans()
				Response.Write "TRUE|"
			End IF			
			
		End IF
			LRs.Close
		SET LRs = Nothing
    
		DBClose()
		DBClose8()
		
	End IF

%>