<%
Function makeConStr(ByVal DB_NAME)
	Dim DB_IP,DB_ID,DB_PW,ConStr
	DB_IP	= "49.247.9.88\SQLExpress,1433"
	Select Case DB_NAME
	Case "KoreaBadminton" 
		DB_ID	= "Korbm"
		DB_PW	= "qoemalsxjs" 
	Case Else
		DB_ID	= "sportsdiary"
		DB_PW	= "dnlemfkdls715)@*@" 
	End Select 
	ConStr = "Provider=SQLOLEDB.1;Persist Security Info=True;User ID="&DB_ID&";Password="&DB_PW&";Initial Catalog="&DB_NAME&";Data Source=" & DB_IP & ";"

	makeConStr =	ConStr
End Function
%>