<!--#include virtual="/Manager/Library/config.asp"-->
<%
	element = fInject(Request("element"))
	attname = fInject(Request("attname"))
	code    = fInject(Request("code"))


selData = "<select name='"&attname&"' id='"&attname&"' onChange='chk_LevelGb();' >"
selData = selData&"<option value='' selected>==선택==</option>"				
selData = selData&"<option value='Man' >남자</option>"	
selData = selData&"<option value='WoMan' >여자</option>"	
selData = selData&"</select>"

Response.Write selData

%>