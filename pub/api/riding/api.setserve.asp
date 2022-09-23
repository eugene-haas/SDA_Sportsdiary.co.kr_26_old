<%
	idx = oJSONoutput.SCIDX
	secondserve = oJSONoutput.SERVE
	reciveno = oJSONoutput.RECIVE
	gameno =  oJSONoutput.GAMENO

	'#################################
	Set db = new clsDBHelper

	strTableName = " sd_TennisResult "
	strWhere = "  where  resultIDX = " & idx
	If gameno = "1" Then
	SQL = "UPDATE " & strTableName &" Set  startserve = " & secondserve & " ,startrecive = " &  reciveno  &  strWhere
	Else
	SQL = "UPDATE " & strTableName &" Set  secondserve = " & secondserve & ", secondrecive = " & reciveno & strWhere
	End If
	
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
	db.Dispose
	Set db = Nothing
%>