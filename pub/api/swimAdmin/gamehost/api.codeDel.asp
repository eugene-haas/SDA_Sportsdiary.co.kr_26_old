<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper
	tablename = " sd_TennisTitleCode "
	strSql = "update "&tablename&" Set   DelYN = 'Y' where idx = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>


<!-- #include virtual = "/pub/html/swimAdmin/gamehost/inc.codeform.asp" --> 