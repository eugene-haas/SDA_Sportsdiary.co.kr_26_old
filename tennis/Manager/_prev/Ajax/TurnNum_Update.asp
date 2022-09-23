<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	PlayerResultIDX = fInject(Request("PlayerResultIDX"))
	TurnNum = Trim(fInject(Request("TurnNum")))


	If PlayerResultIDX<> "" Then 
		USQL = "Update Sportsdiary.dbo.tblPlayerResult SET TurnNum='"&TurnNum&"' WHERE PlayerResultIDX='"&PlayerResultIDX&"'"
		Dbcon.Execute(USQL)
		Response.Write "true"
	Else
		Response.Write "false"
	End If 
%>