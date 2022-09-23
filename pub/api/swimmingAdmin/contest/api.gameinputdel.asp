<%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "IDX") = "ok" then
		e_idx = oJSONoutput.IDX
	End if

	Set db = new clsDBHelper

	Sql = "update  sd_gameTitle Set   DelYN = 'Y' where GameTitleIDX = " & e_idx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


