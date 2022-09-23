<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))

	LSQL = "SELECT"
	LSQL = LSQL&" TeamGb"
	LSQL = LSQL&" ,TeamGbNm"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblTeamGbInfo"
	LSQL = LSQL&" WHERE SportsGb='"&Request.Cookies("SportsGb")&"'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" Order By EnterType DESC, Orderby ASC"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"'>"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("TeamGb") Then 
				selData = selData&"<option value='"&LRs("TeamGb")&"' selected>"&LRs("TeamGbNm")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("TeamGb")&"' >"&LRs("TeamGbNm")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>