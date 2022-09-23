<!--#include file="../dev/dist/config.asp"-->
<%
	'심판구분
	dim attname	: attname    = fInject(Request("attname"))
	dim code	: code   	 = fInject(Request("code")) 
	
	dim LSQL, LRs
	dim selData
	
	selData = "<select name='"&attname&"' id='"&attname&"'>"	 
	selData = selData & "<option value=''>심판구분</option>"	
	
	LSQL = "		SELECT PubCode "
	LSQL = LSQL & " 	,PubName "
	LSQL = LSQL & " FROM [koreabadminton].[dbo].[tblPubCode]"
	LSQL = LSQL & " WHERE DelYN = 'N'"
	LSQL = LSQL & " 	AND PPubCode = 'REFEREE'"
	LSQL = LSQL & " ORDER BY OrderBy"
	
	SET LRs = DBCon.Execute(LSQL)
	IF Not(LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			
			selData = selData & "<option value='"&LRs("PubCode")&"' "
			
			IF code <> "" AND code = LRs("PubCode") Then selData = selData & " selected "
			
			selData = selData & ">"&LRs("PubName")&"</option>"	

			LRs.MoveNext
		Loop 
	End If 

		LRs.Close
	SET LRs = Nothing
	
	selData = selData & "</select>"	
																   
	Response.Write selData

	DBClose()

%>