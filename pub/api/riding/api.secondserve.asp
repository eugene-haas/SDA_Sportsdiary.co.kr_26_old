<%
	idx = oJSONoutput.SCIDX
	secondserve = oJSONoutput.SERVE2 

	'#################################
	Set db = new clsDBHelper

	strTableName = " sd_TennisResult "
	strWhere = "  where  resultIDX = " & idx
	SQL = "UPDATE " & strTableName &" Set  secondserve = " & secondserve & strWhere
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 