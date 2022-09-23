<%
'#############################################

'#############################################
	'request
idx = oJSONoutput.IDX

Set db = new clsDBHelper

	tablename = " K_gameVideoInfo "
	SQL = "update "&tablename&" Set   DelYN = 'Y' where gameVideoIDX = " & idx
	Call db.execSQLRs(SQL, null, ConStr)

db.Dispose
Set db = Nothing
%>
<!-- #include virtual = "/pub/html/ksports/gamelist.asp" -->