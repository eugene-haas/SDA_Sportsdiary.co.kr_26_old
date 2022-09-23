<!--#include file="../Library/ajax_config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))

	LSQL = " 	  	SELECT PubCode"
	LSQL = LSQL & " 	,AreaName"
	LSQL = LSQL & " FROM [SportsDiary].[dbo].[tblAssArea]"
	LSQL = LSQL & " WHERE DelYN='N'"
	LSQL = LSQL & " 	AND SportsGb='"&SportsGb&"'"
	LSQL = LSQL & " 	AND NOT(Sido = 18)"
	LSQL = LSQL & " ORDER BY OrderBy ASC"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"'>"
selData = selData&"<option value=''>지역선택</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("PubCode") Then 
				selData = selData&"<option value='"&LRs("PubCode")&"' selected>"&LRs("AreaName")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("PubCode")&"' >"&LRs("AreaName")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>