<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	PlayerResultIDX = fInject(Request("PlayerResultIDX"))
	CheifIDX        = fInject(Request("CheifIDX"))

	USQL = "Update SportsDiary.dbo.tblPlayerResult "
	USQL = USQL&" Set CheifSub2='"&CheifIDX&"'"
	USQL = USQL&" WHERE PlayerResultIDX='"&PlayerResultIDX&"'"
	
	Dbcon.Execute(USQL)

	Response.Write "true"
	Response.End
%>