<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper
	tablename = " tblGameHost "
	strSql = "update "&tablename&" Set   DelYN = 'Y' where idx = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>

<th scope="row">대회주최</th>
<!-- #include virtual = "/pub/html/RookietennisAdmin/inc.gamehostform.asp" --> 