<!--#include virtual="/M_Player/Library/ajax_config.asp"-->
<%
	Dim str : str = Request.Form("str")
	
	Response.Cookies("PhotoPath")  	= encode(Server.HTMLEncode("/M_Player/upload/../upload/" & str), 0)
%>