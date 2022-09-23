<%
'#############################################


'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper

	'strSql = "update  sd_TennisRPoint_log set titleIDX = titleIDX + 1000000000  where idx = " & idx
	'Call db.execSQLRs(strSQL , null, ConStr)
	Sql = "delete sd_TennisRPoint_log where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)



	  db.Dispose
	  Set db = Nothing
%>