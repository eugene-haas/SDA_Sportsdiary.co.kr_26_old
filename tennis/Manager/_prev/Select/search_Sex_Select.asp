
<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))
	code    = fInject(Request("code"))


selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_level(this.value)'>"
selData = selData&"<option value='' selected>선택</option>"				
If code = "Man" Then 
	selData = selData&"<option value='Man' selected>남자</option>"	
	selData = selData&"<option value='WoMan' >여자</option>"	
ElseIf code = "WoMan" Then 
	selData = selData&"<option value='Man' >남자</option>"	
	selData = selData&"<option value='WoMan' selected>여자</option>"	
Else 
	selData = selData&"<option value='Man'>남자</option>"	
	selData = selData&"<option value='WoMan' >여자</option>"	
End If 

selData = selData&"</select>"

Response.Write selData

%>