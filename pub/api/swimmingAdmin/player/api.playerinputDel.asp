<%
'#############################################

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 'level idx 
		idx = oJSONoutput.IDX
	End If
	
	Set db = new clsDBHelper
	

	strSql = "update  tblPlayer Set   DelYN = 'Y' where Playeridx = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>



