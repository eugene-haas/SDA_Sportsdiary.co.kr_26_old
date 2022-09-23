<%
	'#################################
	' 기본 0 저장1 수정 2 코트상태를 변경
	'#################################

	idx = oJSONoutput.SCIDX

	'#################################
	Set db = new clsDBHelper

	strTableName = " sd_TennisResult "
	strWhere = "  where  resultIDX = " & idx
	SQL = "UPDATE " & strTableName &" Set  courtmode=2 " & strWhere
	Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", "0" )
	'Call oJSONoutput.Set("SCIDX", idx )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 