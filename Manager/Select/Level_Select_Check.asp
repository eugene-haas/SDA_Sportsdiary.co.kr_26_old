<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))
	TeamGb  = fInject(Request("TeamGb"))


	LSQL = "SELECT"
	LSQL = LSQL&" Level"
	LSQL = LSQL&" ,LevelNm"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblLevelInfo"
	LSQL = LSQL&" WHERE SportsGb='judo'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" AND TeamGb = '"&TeamGb&"'"
	LSQL = LSQL&" ORDER BY Orderby ASC"	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"'>"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("Level") Then 
				selData = selData&"<option value='"&LRs("Level")&"' selected>"&LRs("LevelNm")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("Level")&"' >"&LRs("LevelNm")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>