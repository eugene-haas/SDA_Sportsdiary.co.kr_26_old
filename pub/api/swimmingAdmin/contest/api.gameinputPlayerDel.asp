<%
'#############################################

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 'level idx 
		idx = oJSONoutput.IDX
	End If
	
	Set db = new clsDBHelper


	
	
	strSql = "update  tblGameRequest Set   DelYN = 'Y' where RequestIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

	strSql = "update  sd_gameMember Set   DelYN = 'Y' where RequestIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>



