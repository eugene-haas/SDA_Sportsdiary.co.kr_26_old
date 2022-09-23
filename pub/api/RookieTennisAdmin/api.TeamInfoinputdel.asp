<%
	TeamIDX = oJSONoutput.TeamIDX
	Set db = new clsDBHelper

	'strSql = "update  tblTeamInfo Set   DelYN = 'Y' where TeamIDX = " & TeamIDX
	strSql = "delete from  tblTeamInfo  where TeamIDX = " & TeamIDX
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>

<!-- #include virtual = "/pub/html/RookietennisAdmin/Teaminfoform.asp" -->
