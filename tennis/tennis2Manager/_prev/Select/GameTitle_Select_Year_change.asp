<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element      = fInject(Request("element"))
	attname      = fInject(Request("attname"))	
	GameYear = fInject(Request("code"))

	If GameYear = "" Then 
		GameTitleIDX = 0
	End If 


	LSQL = "SELECT "
	LSQL = LSQL&" GameYear"
	LSQL = LSQL&",GameTitleIDX"
	LSQL = LSQL&",GameTitleName"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblGameTitle "
	LSQL = LSQL&" WHERE DelYN='N'" 
	LSQL = LSQL&" AND SportsGb='"&Request.Cookies("SportsGb")&"'"
	If GameYear <> "" Then 
		LSQL = LSQL&" AND GameYear='"&GameYear&"'"
	End If 
	LSQL = LSQL&" ORDER BY GameTitleName ASC"
'Response.Write LSQL
'Response.End

	Set LRs = Dbcon.Execute(LSQL)
	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_GroupGameGb(this.value)'>"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If CDbl(LRs("GameTitleIDX")) = CDbl(GameTitleIDX) Then 
				selData = selData&"<option value='"&LRs("GameTitleIDX")&"' selected>"&LRs("GameTitleName")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("GameTitleIDX")&"' >"&LRs("GameTitleName")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>