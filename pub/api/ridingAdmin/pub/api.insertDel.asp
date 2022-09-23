<%
'#############################################

'#############################################
	'request
	idx = oJSONoutput.IDX

	Set db = new clsDBHelper
	tablename = " tblInsertData "
	strSql = "update "&tablename&" Set   DelYN = 'Y' where idx = " & idx
	Call db.execSQLRs(strSQL , null, B_ConStr)

	e_idx = ""
	hostname = ""
  db.Dispose
  Set db = Nothing
%>


<!-- #include virtual = "/pub/html/riding/common/html.dataInsertForm.asp" --> 