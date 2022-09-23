<%
'#############################################
'삭제
'#############################################
	'request
	If hasown(oJSONoutput, "MIDXS") = "ok" then
		midxs = oJSONoutput.Get("MIDXS")
	End if


	Set db = new clsDBHelper

	If midxs <> "" then
	Sql = "update  sd_gameMember_sectionRecord Set   DelYN = 'Y' where gamememberidx in ("&midxs&")  "
	Response.write sql
	Call db.execSQLRs(SQL , null, ConStr)
	End if

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>


