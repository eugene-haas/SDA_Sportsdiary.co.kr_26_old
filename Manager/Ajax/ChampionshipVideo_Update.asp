<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	seq             = fInject(Request("seq"))
	seturl          = fInject(Request("seturl"))
	
	If trim(seq) = "" Then 
		Response.End
	End If 

	UpSQL = " Update SportsDiary.dbo.tblRGameResult"
	UpSQL = UpSQL&" SET MediaLink ='"& trim(seturl) &"'"	
	UpSQL = UpSQL&" WHERE DelYN = 'N' "
	UpSQL = UpSQL&" AND RGameResultIDX ='"&seq&"' "

	Dbcon.Execute(UpSQL)
	Dbclose()
	
	Response.Write "TRUE"
	Response.End
%>

