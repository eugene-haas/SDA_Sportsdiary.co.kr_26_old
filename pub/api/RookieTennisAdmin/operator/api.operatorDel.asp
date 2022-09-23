<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper
	tablename = " tblGameManager "
	strSql = "update "&tablename&" Set   DelYN = 'Y' where idx = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>


<!-- #include virtual = "/pub/html/RookietennisAdmin/operator/inc.operatorform.asp" --> 