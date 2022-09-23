<!--#include virtual="/Manager/Library/ajax_config.asp"-->
<%
seq = fInject(request("seq"))


if trim(seq) = "" then
	response.end
end if



ChkLevel = ""




DSQL = " UPDATE SportsDiary.dbo.tblGameTitle " 
DSQL = DSQL & "  SET DELYN = 'Y'"
DSQL = DSQL & " WHERE DelYN = 'N'"
DSQL = DSQL & " AND GameTitleIDX = '" & seq & "'"

Dbcon.Execute(DSQL)

Dbclose()

response.write "TRUE"
response.end
%>