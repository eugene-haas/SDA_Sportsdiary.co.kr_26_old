<%
'#############################################

'삭제

'#############################################
	'request
	idx = oJSONoutput.IDX
	Set db = new clsDBHelper

	strSql = "update  K_gameinfo Set   DelYN = 'Y' where GIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

  db.Dispose
  Set db = Nothing
%>
<!-- #include virtual = "/pub/html/ksports/inputform.asp" -->
