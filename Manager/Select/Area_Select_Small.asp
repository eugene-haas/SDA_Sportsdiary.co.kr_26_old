<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))

	LSQL = "SELECT"
	LSQL = LSQL&" Sido"
	LSQL = LSQL&" ,SidoNm"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblSidoInfo"
	LSQL = LSQL&" WHERE DelYN='N'"
	LSQL = LSQL&" AND SportsGb='judo'"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"' class='select-small'>"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("Sido") Then 
				selData = selData&"<option value='"&LRs("Sido")&"' selected>"&LRs("SidoNm")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("Sido")&"' >"&LRs("SidoNm")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>