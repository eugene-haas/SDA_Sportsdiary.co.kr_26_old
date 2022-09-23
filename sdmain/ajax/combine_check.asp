<!--#include file="../Library/ajax_config.asp"-->
<%
	'===================================================================================
	'회원가입 유무 체크페이지
	'===================================================================================
	dim UserName 	: UserName   	= fInject(trim(Request("UserName")))
	dim UserBirth 	: UserBirth 	= fInject(trim(Request("UserBirth")))

	dim LSQL, LRs
	dim chk_User
					
	IF UserName = "" OR UserBirth = "" Then 	
		Response.Write "FALSE|200"
		Response.End
	Else 
		'회원DB
		LSQL =  " 		SELECT ISNULL(COUNT(*), 0) cnt " 
		LSQL = LSQL & " FROM [SD_Member].[dbo].[tblMember]"
		LSQL = LSQL & " WHERE DelYN = 'N'" 
		LSQL = LSQL & "		AND UserName = '"&UserName&"' " 
		LSQL = LSQL & "		AND Birthday = '"&UserBirth&"' " 
		
		SET LRs = DBCon3.Execute(LSQL)
		IF LRs(0) > 0 Then 
			
			'통합ID 설정 유무체크			
			'chk_User = CHK_JOINUS(UserName, UserBirth)
			
			'Response.Write "TRUE|"&chk_User&"|"&UserName&"|"&encode(UserBirth, 0)

			Response.Write "TRUE|"&LRs(0)&"|"&UserName&"|"&encode(UserBirth, 0)

			Response.End		
		ELSE
			Response.Write "FALSE|99"
			Response.End		
		END IF

			LRs.Close
		SET LRs = Nothing
		
		DBClose3()
	
	End IF 

	
%>