<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	UserID = fInject(Request("UserID"))

	If UserID = "" Then 
		Response.Write "false"
		Response.End 
	End If 

	CSQL = "SELECT Count(*) AS Cnt FROM Sportsdiary.dbo.tblUserInfo WHERE UserID='"&UserID&"'"

	Set CRs = Dbcon.Execute(CSQL)

	If CRs("Cnt") > 0 Then 
		Response.Write "same"
		Response.End
	Else
		Response.Write "true"
		Response.End
	End If 
%>