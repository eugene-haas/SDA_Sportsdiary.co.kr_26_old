<!--#include file="../Library/ajax_config.asp"-->
<%
	'=========================================================================================
	'아이디 찾기 페이지
	'=========================================================================================
	dim UserPhone 	: UserPhone = fInject(Trim(Request("UserPhone")))
	dim UserName	: UserName  = fInject(Trim(Request("UserName")))
	
	dim CSQL, CRs
	
	If UserPhone = "" Or UserName = "" Then 
		Response.Write "FALSE|200"
		Response.End
	Else

		CSQL = 	"		SELECT UserID " 
		CSQL = CSQL & "	FROM [SD_Member].[dbo].[tblMember] " 
		CSQL = CSQL & "	WHERE DelYN = 'N'" 
		CSQL = CSQL & "		AND UserName = '"&UserName&"'" 
		CSQL = CSQL & " 	AND Replace(UserPhone,'-','') = '"&UserPhone&"'"
		
		SET CRs = DBCon3.Execute(CSQL)

		IF Not(CRs.Eof Or CRs.Bof) Then 
			Response.Write "TRUE|"&StringToHex(CRs("UserID"))
		Else
			Response.Write "FALSE|99"
			Response.End
		End If 
		
			CRs.Close
		SET CRs = Nothing
		
		DBClose3()
		
	End If 
%>