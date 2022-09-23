<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))
	code    = fInject(Request("code"))


selData = "<select name='"&attname&"' id='"&attname&"'>"
selData = selData&"<option value=''>월</option>"				
For i = 1 To 12
	If CStr(AddZero(i)) = CStr(code) Then 
		selData = selData&"<option value='"&AddZero(i)&"' selected>"&AddZero(i)&"</option>"	
	Else
		selData = selData&"<option value='"&AddZero(i)&"' >"&AddZero(i)&"</option>"	
	End If 
Next

selData = selData&"</select>"

Response.Write selData

%>