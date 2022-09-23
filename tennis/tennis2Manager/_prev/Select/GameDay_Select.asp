<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))

	LSQL = "SELECT"
	LSQL = LSQL&" GameS"
	LSQL = LSQL&" ,GameE"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblGameTitle"
	LSQL = LSQL&" WHERE SportsGb='" & Request.Cookies("SportsGb") & "'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" AND GameTitleIDX='" & code & "'"



	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()
	
	If Not (LRs.Eof Or LRs.Bof) Then 
		strGameS = LRs("GameS")
		strGameE = LRs("GameE")
	End If 

	selData = "<select name='"&attname&"' id='"&attname&"'>"
	selData = selData&"<option value=''>==선택==</option>"	

	

	If strGameS <> "" And strGameE <> "" Then
		Do Until FormatDateTime(strGameS,2) > FormatDateTime(strGameE,2) 
			selData = selData&"<option value='" & strGameS & "'>" & strGameS & "</option>"	

			strGameS = DateAdd("d", 1,strGameS)
		Loop
	End If
				



	selData = selData&"</select>"

	Response.Write selData

%>