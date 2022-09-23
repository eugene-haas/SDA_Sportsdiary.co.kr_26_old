<%

	'request
	'log_idx = oJSONoutput.PLAYERIDX
	'log_operation = oJSONoutput.OPERATION
	'log_tableName = oJSONoutput.AREA
	'log_fieldName = oJSONoutput.FIELDNAME
	'log_oldvalue = oJSONoutput.OLDVALUE
	'log_newValue  = oJSONoutput.NEWVALUE

	'include Code
	'Set db = new clsDBHelper
	field = " tableIdx, adminName, operation, tableName, fieldName, oldValue, newValue "
	strSql = "Insert INTO tblUpdateLog ("& field &") VALUES "
	strSql = strSql & "(" & log_idx 
	strSql = strSql & ",'" & log_adminName & "'"
	strSql = strSql & ",'" & log_operation & "'"
	strSql = strSql & ",'" & log_tableName & "'"
	strSql = strSql & ",'" & log_fieldName & "'"
	strSql = strSql & ",'" & log_oldvalue & "'"
	strSql = strSql & ",'" & log_newValue & "')"
	Call db.execSQLRs(strSql , null, ConStr)
	'strjson = JSON.stringify(oJSONoutput)
	'Response.Write strjson

	'db.Dispose
	'Set db = Nothing
%>