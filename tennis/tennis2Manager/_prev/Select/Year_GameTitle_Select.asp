<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))
	code    = fInject(Request("code"))


selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_GameTitle(this.value)'>"
selData = selData&"<option value=''>==선택==</option>"				
For i = (Year(now)+1) To 1901 Step -1
	If CStr(i) = CStr(code) Then 
		selData = selData&"<option value='"&i&"' selected>"&i&"</option>"	
	Else
		selData = selData&"<option value='"&i&"' >"&i&"</option>"	
	End If 
Next

selData = selData&"</select>"

Response.Write selData

%>