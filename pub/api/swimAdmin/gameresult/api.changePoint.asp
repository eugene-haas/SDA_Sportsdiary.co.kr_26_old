<%
'#############################################


'#############################################
	'request
	idx = oJSONoutput.IDX
	point = oJSONoutput.POINT
	Set db = new clsDBHelper

	SQL = "Select getpoint from sd_TennisRPoint_log  where idx = " & idx & " and getpoint = " & point
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)		

	If rs.eof then
		strSql = "update  sd_TennisRPoint_log set getpoint = "&point&"  where idx = " & idx
		Call db.execSQLRs(strSQL , null, ConStr)
	Else
		Call oJSONoutput.Set("result", "1003" ) '동일값보냄
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson
		Response.End
	End if

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>
