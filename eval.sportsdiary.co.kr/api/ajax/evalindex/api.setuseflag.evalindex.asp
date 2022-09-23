<%
'#############################################
'상태변경
'#############################################
	'request
	tidx = oJSONoutput.get("TIDX") 'EvalTableIDX
		
	Set db = new clsDBHelper
	
	SQL = " Update tblEvalTable Set usekey = 0 where usekey = 1 "
	SQL = SQL &  " Update tblEvalTable Set usekey = 1 where EvalTableIDX = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)
	

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>