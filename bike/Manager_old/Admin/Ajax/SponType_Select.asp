<!--#include file="../dev/dist/config.asp"-->
<%
	dim element : element 	= fInject(Request("element"))
	dim attname : attname 	= fInject(Request("attname"))	
   	dim code	: code 		= fInject(Request("code"))	
	
	dim LSQL, LRs
	dim selData		'Select Box
	
	LSQL =  " 		 SELECT PubCode, PubName "
	LSQL =  LSQL & " FROM [KoreaBadminton].[dbo].[tblPubcode]"
	LSQL =  LSQL & " WHERE DelYN = 'N'"
	LSQL =  LSQL & " 	AND PPubCode = 'SPON'"									  
	LSQL =  LSQL & " ORDER BY OrderBy" 	
	
'	response.Write "LSQL="&LSQL&"<br>"
	
	selData = "<select name='"&attname&"' id='"&attname&"' class=""title_select"">"
	selData = selData & "<option value=''>:: 후원사 구분 선택 ::</option>"		

	SET LRs = DBCon.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
   			IF code <> "" and code = LRs("PubCode") Then
   				selData = selData & "<option value='"&LRs("PubCode")&"' selected>"&LRs("PubName")&"</option>"	
   			Else   			
   				selData = selData & "<option value='"&LRs("PubCode")&"'>"&LRs("PubName")&"</option>"		
			End IF

			LRs.MoveNext
		Loop 
	End If 
	
	selData = selData & "</select>"
	
		LRs.Close
	SET LRs = Nothing
	
	DBClose()
	
	Response.Write selData

%>