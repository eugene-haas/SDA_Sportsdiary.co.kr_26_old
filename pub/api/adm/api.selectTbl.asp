<%
'#############################################
'쿼리생성
'#############################################


Set db = new clsDBHelper

	'request
	If hasown(oJSONoutput, "tblnm" ) = "ok" then
		tblnm =  oJSONoutput.tblnm
	End If


	SQL = "select top 1 * from " & tblnm
	Set rsData = db.ExecSQLReturnRS(SQL , null, ConStr)

	i = 0
	For each field in rsData.Fields
		If i = 0 Then
			 FN = field.Name
			 'Exit For
		 End If
		 If i = 0 then
			 f_str = field.Name
		 Else
			 f_str = f_str & "," & field.Name
		 End if
	i = i + 1
	next

	querystr = "Select " & f_str & " from " & tblnm

	Call oJSONoutput.Set("Q",  querystr )
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

db.Dispose
Set db = Nothing
%>
