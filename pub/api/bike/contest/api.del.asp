<%
'#############################################

'삭제

'#############################################
	'request
	idx = oJSONoutput.IDX
	Set db = new clsDBHelper

	strSql = "update  sd_bikeTitle Set DelYN = 'Y' where titleIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>
