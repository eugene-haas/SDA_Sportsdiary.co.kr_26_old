<!--#include file="../Library/ajax_config.asp"-->
<%
'	Check_Login()
	
	dim element : element 	= fInject(Request("element"))
	dim attname : attname 	= fInject(Request("attname"))	
	dim UserID 	: UserID 	= decode(request.Cookies("UserID"), 0)
	
'	UserID = "coach1"
	
	dim LSQL, LRs
	dim selData		'Select Box
	
	LSQL =  " SELECT UserName "
	LSQL =  LSQL & " FROM [Sportsdiary].[dbo].[tblSvcNotice] "
	LSQL =  LSQL & " WHERE DelYN = 'N'  "
	LSQL =  LSQL & " 	AND [ViewTp] = 'A' "
	LSQL =  LSQL & " 	AND [BRPubCode] = 'BR01'  "
	LSQL =  LSQL & " GROUP BY UserName  "		
	LSQL =  LSQL & " ORDER BY UserName ASC " 	
	
'	response.Write "LSQL="&LSQL&"<br>"
	
	selData = "<select name='"&attname&"' id='"&attname&"' >"
	selData = selData & "<option value=''>작성자 선택</option>"		

	SET LRs = Dbcon.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			selData = selData & "<option value='"&LRs("UserName")&"'>"&LRs("UserName")&"</option>"	
			LRs.MoveNext
		Loop 
	End If 
	
	selData = selData & "</select>"
	
		LRs.Close
	SET LRs = Nothing
	
	Dbclose()
	
	Response.Write selData

%>