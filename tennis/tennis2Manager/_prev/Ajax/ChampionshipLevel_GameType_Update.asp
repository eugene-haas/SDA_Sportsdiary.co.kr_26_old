<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
	RGameLevelIDX = fInject(Request("RGameLevelIDX"))
	GameType     = fInject(Request("GameType")) 



If RGameLevelIDX = "" Or Gametype = "" Then 
	Response.End
End If 

	UpSQL = "Update SportsDiary.dbo.tblRGameLevel SET GameType ='"&GameType&"' WHERE RGameLevelIDX='"&RGameLevelIDX&"'"

	Dbcon.Execute(UpSQL)

	Dbclose()

	Response.Write "TRUE"
%>