<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	PlayerResultIDX = fInject(Request("PlayerResultIDX"))
	CheifIDX        = fInject(Request("CheifIDX"))

	'PlayerResultIDX = "90574"
	'CheifIDX = "51"

	USQL = "Update SportsDiary.dbo.tblPlayerResult "
	USQL = USQL&" Set CheifMain='"&CheifIDX&"'"
	USQL = USQL&" WHERE PlayerResultIDX='"&PlayerResultIDX&"'"
	
	Dbcon.Execute(USQL)

	Response.Write "true"
	Response.End
%>