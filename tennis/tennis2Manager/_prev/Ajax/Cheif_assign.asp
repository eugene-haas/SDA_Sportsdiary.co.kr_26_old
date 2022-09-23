<!--#include virtual="/Manager_Wres/Library/ajax_config.asp"-->
<%
GameTitleIDX = fInject(request("GameTitleIDX"))
GameDay = fInject(request("GameDay"))

if trim(GameTitleIDX) = "" Or trim(GameDay) = "" then
	response.end
end if


DSQL = " dbo.UPDATE_tblPlayerResult_Cheif_Wres_Level_SE '" & GameTitleIDX & "', '" & GameDay & "'" 

Dbcon.Execute(DSQL)

Dbclose()

response.write "TRUE"
response.end
%>