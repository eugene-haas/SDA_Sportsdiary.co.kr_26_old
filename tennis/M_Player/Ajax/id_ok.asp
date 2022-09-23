<!--#include file="../Library/ajax_config.asp"-->
<%
	'=========================================================================================
	'아이디 찾기 페이지
	'=========================================================================================
	dim UserPhone 	: UserPhone = Trim(Replace(fInject(Request("UserPhone")),"-",""))
	dim UserName	: UserName  = fInject(Request("UserName"))
	
	dim CSQL, CRs
	
	If UserPhone = "" Or UserName = "" Then 
		Response.Write "FALSE"
		Response.End
	Else

		CSQL = 	"		SELECT UserID " 
		CSQL = CSQL & "	FROM [SportsDiary].[dbo].[tblMember] " 
		CSQL = CSQL & "	WHERE DelYN = 'N'" 
		CSQL = CSQL & "		AND SportsType = '"&SportsGb&"'" 
		CSQL = CSQL & "		AND UserName = '"&UserName&"'" 
		CSQL = CSQL & " 	AND Replace(UserPhone,'-','') = '"&UserPhone&"'"
		
		SET CRs = Dbcon.Execute(CSQL)

		If Not(CRs.Eof Or CRs.Bof) Then 
			Response.Write "TRUE|"&StringToHex(CRs("UserID"))
		Else
			Response.Write "FALSE|"
			Response.End
		End If 
		
			CRs.Close
		SET CRs = Nothing
		
		DBClose()
		
	End If 
%>