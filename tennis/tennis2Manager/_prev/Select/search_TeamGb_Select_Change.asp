<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))	
	code    = fInject(Request("code"))

	LSQL = "SELECT"
	LSQL = LSQL&" PubCode"
	LSQL = LSQL&" ,Pubname"
	LSQL = LSQL&" FROM SportsDiary.dbo.tblPubCode"
	LSQL = LSQL&" WHERE pPubCode='sd011'"
	LSQL = LSQL&" Order By PubName ASC"
	
	Set LRs = Dbcon.Execute(LSQL)

	Dbclose()

selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_TeamGb();'>"
selData = selData&"<option value=''>==선택==</option>"				
	If Not (LRs.Eof Or LRs.Bof) Then 
		Do Until LRs.Eof 
			If code = LRs("PubCode") Then 
				selData = selData&"<option value='"&LRs("PubCode")&"' selected>"&LRs("Pubname")&"</option>"	
			Else
				selData = selData&"<option value='"&LRs("PubCode")&"' >"&LRs("Pubname")&"</option>"	
			End If 

			LRs.MoveNext
		Loop 
	End If 
selData = selData&"</select>"

Response.Write selData

%>

