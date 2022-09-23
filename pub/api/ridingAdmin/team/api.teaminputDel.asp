<%
'#############################################

'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" Then 'level idx 
		idx = oJSONoutput.IDX
	End If
	
	Set db = new clsDBHelper
	

	strSql = "update  tblTeamInfo Set   DelYN = 'Y' where TeamIDX = " & idx
	Call db.execSQLRs(strSQL , null, ConStr)

	strSql = "update  tblWebRegLog Set   DelYN = 'Y' where gubun = 3 and  regseq = '" & idx & "'"
	Call db.execSQLRs(strSQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>



