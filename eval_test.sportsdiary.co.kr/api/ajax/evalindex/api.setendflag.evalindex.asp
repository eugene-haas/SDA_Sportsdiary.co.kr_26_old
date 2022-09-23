<%
'#############################################
'수정불가 상태변경
'#############################################
	'request
	tidx = oJSONoutput.get("TIDX") 'EvalTableIDX
		
	Set db = new clsDBHelper
	
	SQL = " Update tblEvalTable Set "
	SQL = SQL & " EditMode = case when EditMode= 1 then 0 else 1 end "
	SQL = SQL & " where EvalTableIDX = " & tidx
	Call db.execSQLRs(SQL , null, ConStr)
	

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

  db.Dispose
  Set db = Nothing
%>