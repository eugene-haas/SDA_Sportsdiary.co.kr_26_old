<%
'#############################################

'»èÁ¦

'#############################################
	'request
	idx = oJSONoutput.IDX
	Set db = new clsDBHelper

	strSql = "update  sd_bikeLevel Set DelYN = 'Y' where levelIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>
