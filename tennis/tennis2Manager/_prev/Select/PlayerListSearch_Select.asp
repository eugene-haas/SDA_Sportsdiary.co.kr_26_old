<!--#include virtual="/Manager/Library/config.asp"-->
<%
	Team          = fInject(Request("team"))
	attname       = fInject(Request("attname"))
	playercode    = fInject(Request("playercode"))
	If playercode = "" Then 
		playercode  = "0"
	End If 


'Response.Write SchIDX&"<br>"
'Response.Write attname&"<br>"
'Response.Write code&"<br>"
'Response.End

	If Team  = "" Then 
		Response.End
	End If 


	LSQL = "SELECT"
	LSQL = LSQL&" PlayerIDX"
	LSQL = LSQL&" ,UserName"
	LSQL = LSQL&" ,PlayerCode"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblPlayer"
	LSQL = LSQL&" WHERE Team = '"&Team&"'"
	LSQL = LSQL&" AND DelYN='N'"
	LSQL = LSQL&" AND SportsGb='"&Request.Cookies("SportsGb")&"'" 
	LSQL = LSQL&" AND NowRegYN='Y'"
	LSQL = LSQL&" Order By UserName"
	'Response.Write LSQL&code
	'Response.End
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"'>"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If CStr(playercode) = CStr(LRs("PlayerIDX")) Then 
				selData = selData&"<option value='"&LRs("PlayerIDX")&"' selected>"&LRs("UserName")&"["&PlayerCode&"]</option>"	
			Else
				selData = selData&"<option value='"&LRs("PlayerIDX")&"' >"&LRs("UserName")&"["&PlayerCode&"]</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData
'Response.End
%>