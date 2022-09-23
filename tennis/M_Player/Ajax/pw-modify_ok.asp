<!--#include file="../Library/ajax_config.asp"-->
<%
	'=============================================================================
	'비밀번호 변경 페이지
	'=============================================================================
	Check_Login()
	
	dim UserID 		: UserID 		= decode(Request.Cookies("UserID"), 0)
	dim EnterType 	: EnterType 	= Request.Cookies("EnterType")
	
	dim nowpass 	: nowpass 		= fInject(Request("nowpass"))
	dim change_pass : change_pass  	= fInject(Request("change_pass"))
	
	dim LSQL, LRs, CSQL
		
	If UserID = "" Or nowpass = "" Or change_pass = "" Then 
		Response.Write "FALSE|1"
		Response.End
	Else
		
		LSQL =   "		SELECT UserPass " 
		LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblMember] " 
		LSQL = LSQL & " WHERE DelYN = 'N'" 
		LSQL = LSQL & "		AND UserID = '"&UserID&"' " 
		LSQL = LSQL & "		AND UserPass = '"&nowpass&"' "
				 
		SET LRs = Dbcon.Execute(LSQL)
		IF Not(LRs.Eof Or LRs.Bof) Then 
			
			IF change_pass = nowpass Then
				Response.Write "FALSE|2"
			Else
				CSQL = 	"		UPDATE [SportsDiary].[dbo].[tblMember] " 			
				CSQL = CSQL & " SET UserPass = '"&change_pass&"' " 
				CSQL = CSQL & " WHERE DelYN = 'N' "
				CSQL = CSQL & "		AND SportsType = '"&SportsGb&"' "
				CSQL = CSQL & "		AND EnterType = '"&EnterType&"' "
				CSQL = CSQL & "		AND UserID = '"&UserID&"' "
				
'				response.Write CSQL
'				response.End()
						
				Dbcon.Execute(CSQL)
				
				Response.Write "TRUE|"
			End IF
				
		Else
			Response.Write "FALSE|3"
		End IF
		
			LRs.Close
		SET LRs = Nothing
		
		DBClose()
	
	End IF

%>	