<!--#include file="../dev/dist/config.asp"-->
<%
	'====================================================================================
	'회원탈퇴신청 회원리스트 조회
	'====================================================================================
	Check_AdminLogin()
	
	dim UserID		: UserID 		= crypt.DecryptStringENC(fInject(Request.Cookies(global_HP)("UserID")))	 
	dim vallist_CHK : vallist_CHK 	= request("vallist_CHK")
	
	dim i, ErrorNum
	dim str_list_CHK
	
	IF vallist_CHK = "" Then
		response.Write "FALSE|200"
		response.End()
	Else
		
		str_list_CHK = split(vallist_CHK, "|")

		
		For i = 1 To Ubound(str_list_CHK)
		
			IF str_list_CHK(i) <> "" Then
				
				CSQL = " 		UPDATE [KoreaBadminton].[dbo].[tblMembershipOnline] "
				CSQL = CSQL & " SET DelYN = 'Y' " 
				CSQL = CSQL & "		,ModDate = GETDATE() "
				CSQL = CSQL & "		,ModId = '"&UserID&"' "
				CSQL = CSQL & " WHERE UserID = '"&str_list_CHK(i)&"' "
				
				DBCon.Execute(CSQL)	
			
			End IF	
			
		Next 

		response.Write "TRUE|"&i-1
		
	End IF

%>