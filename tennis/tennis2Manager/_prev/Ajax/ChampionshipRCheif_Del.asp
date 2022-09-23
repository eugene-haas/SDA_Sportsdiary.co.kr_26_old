<!--#include virtual="/Manager_Wres/Library/ajax_config.asp"-->
<%
RCheifIDX = fInject(request("RCheifIDX"))


if trim(RCheifIDX) = "" then
	response.end
end if



ChkLevel = ""




DSQL = " UPDATE SportsDiary.dbo.tblRCheif " 
DSQL = DSQL & "  SET DELYN = 'Y'"
DSQL = DSQL & " WHERE DelYN = 'N'"
DSQL = DSQL & " AND RCheifIDX = '" & RCheifIDX & "'"

Dbcon.Execute(DSQL)

Dbclose()

response.write "TRUE"
response.end
%>