<!--#include file="../dev/dist/config.asp"-->
<%	
	'=====================================================================
	'È¸¿øÅ»Åð
	'=====================================================================
	Check_AdminLogin()
		
	dim UserID	: UserID 	= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))
	dim CIDX	: CIDX 		= crypt.DecryptStringENC(fInject(Request("CIDX")))
	

	dim LRs, LSQL, CSQL
	dim RE_DATA
		
	IF CIDX = "" OR UserID = "" Then 
		RE_DATA = "FALSE|200"
	ELSE
		
		LSQL =   " 		SELECT * " 
		LSQL = LSQL & " FROM [KoreaBadminton].[dbo].[tblMembershipOnline]" 
		LSQL = LSQL & " WHERE DelYN = 'N'" 
		LSQL = LSQL & "		AND MembershipIDX = '"&CIDX&"' "
		
		SET LRs = DBCon.Execute(LSQL)
		IF LRs.eof OR LRs.bof THEN
			RE_DATA = "FALSE|99"
		Else	
			
			CSQL = " 		UPDATE [KoreaBadminton].[dbo].[tblMembershipOnline] "
			CSQL = CSQL & " SET DelYN = 'Y' " 
			CSQL = CSQL & "		,WithdrawYN = 'Y' "
			CSQL = CSQL & "		,WithdrawDt = GETDATE() "
			CSQL = CSQL & "		,ModId = '"&UserID&"' "
			CSQL = CSQL & "		,ModDate = GETDATE() "
			CSQL = CSQL & " WHERE MembershipIDX = '"&CIDX&"' "
			
			DBCon.Execute(CSQL)	

			IF DBCon.Errors.Count > 0 Then
				RE_DATA = "FALSE|66"
			Else
				RE_DATA = "TRUE|"
			End IF
		
		END IF	

			LRs.Close
		SET LRs = Nothing	
		
		DBClose()
	
	End IF
	
	response.Write RE_DATA

%>	
     