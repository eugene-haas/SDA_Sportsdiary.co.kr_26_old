<%
	scidx = oJSONoutput.SCIDX '결과테이블 인덱스
	testtype = oJSONoutput.TTYPE

	'#################################
	Set db = new clsDBHelper

	If testtype = "1" then
		strTableName = " sd_TennisResult_record "
		'strWhere = "  where  resultIDX = " & idx
		SQL = "DELETE from  " & strTableName 
		Call db.execSQLRs(SQL , null, ConStr)
		Call oJSONoutput.Set("MSHOW", "0" )
	Else
		strTableName = " sd_TennisResult "
		strWhere = "  where  resultIDX = " & scidx
		SQL = "DELETE from  " & strTableName  & strWhere
		Call db.execSQLRs(SQL , null, ConStr)
		Call oJSONoutput.Set("MSHOW", "1" )
	End if



	Call oJSONoutput.Set("result", "0" )
	'Call oJSONoutput.Set("SCIDX", idx )

	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%> 