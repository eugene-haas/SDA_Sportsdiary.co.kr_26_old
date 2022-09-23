<%
	'request 처리##############
	idx = oJSONoutput.IDX
	contents = oJSONoutput.CONTENTS
	contents = chkStrRpl(contents, "") 
	contents = htmlEncode(contents)
	'request 처리##############

	Set db = new clsDBHelper

	SQL = "update tblRGameLevel Set bigo = '"&contents&"' where RGameLevelIdx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing
%>