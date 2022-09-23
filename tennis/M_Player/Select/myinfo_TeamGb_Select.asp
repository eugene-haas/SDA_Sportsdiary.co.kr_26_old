<!--#include file="../Library/ajax_config.asp"-->
<%
	
	dim element : element = fInject(Request("element"))
	dim attname : attname = fInject(Request("attname"))	
	dim code 	: code    = fInject(Request("code"))
	
	dim LSQL, LRs
	dim selData
	
	LSQL = "		SELECT PartCode "
	LSQL = LSQL&" 		,PartName "
	LSQL = LSQL&" 	FROM [SportsDiary].[dbo].[tblAssPart] "
	LSQL = LSQL&" 	WHERE DelYN = 'N'"
	LSQL = LSQL&" 		AND SportsGb = '"&SportsGb&"' "
	LSQL = LSQL&" 	Order By OrderBy ASC"
	
	Set LRs = Dbcon.Execute(LSQL)
	If Not (LRs.Eof Or LRs.Bof) Then 
		
		selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_teamcode_CE();'>"
		selData = selData&"<option value=''>소속구분</option>"				

		Do Until LRs.Eof 

			selData = selData&"<option value='"&LRs("PartCode")&"' >"&LRs("PartName")&"</option>"	

			LRs.MoveNext
		Loop 
		
		selData = selData&"</select>"
		
	End If 
	
		LRs.Close
	SET LRs = Nothing
	
	Response.Write selData
	
	Dbclose()
%>