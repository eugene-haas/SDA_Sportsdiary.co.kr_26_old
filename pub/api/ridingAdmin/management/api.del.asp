<%
'#############################################

'순서항목추가.

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		idx= oJSONoutput.IDX
	End If

	Set db = new clsDBHelper 

	SQL = "Update tblTeamGbInfoDetail Set delYN = 'Y' where idx = " & idx
	Call db.execSQLRs(SQL , null, ConStr)



  	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
