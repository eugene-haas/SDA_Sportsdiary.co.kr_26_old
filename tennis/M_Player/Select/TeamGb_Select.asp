<!--#include file="../Library/ajax_config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))

	LSQL = "SELECT"
	LSQL = LSQL&" PubCode"
	LSQL = LSQL&" ,PartName"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblAssPart"
	LSQL = LSQL&" WHERE DelYN='N'"
	LSQL = LSQL&" AND SportsGb='"&SportsGb&"'"
	LSQL = LSQL&" Order By OrderBy ASC"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"'>"
selData = selData&"<option value=''>소속구분</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("PubCode") Then 
				selData = selData&"<option value='"&LRs("PubCode")&"' selected>"&LRs("PartName")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("PubCode")&"' >"&LRs("PartName")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>