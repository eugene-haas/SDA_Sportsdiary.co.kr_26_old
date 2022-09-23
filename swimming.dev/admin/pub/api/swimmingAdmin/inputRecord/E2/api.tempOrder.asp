<%
'#############################################
'경기순서변경
'#############################################

	'request
	tidx = oJSONoutput.Get("TIDX")
	lidx = oJSONoutput.Get("LIDX")
	orderno = oJSONoutput.Get("ORDERNO")
	preorderno = oJSONoutput.Get("PREORDERNO")
	cda = oJSONoutput.Get("CDA")

	Set db = new clsDBHelper
	
	SQL = "Update tblRGameLevel Set gameno_temp =  '"& orderno &"' where  RGameLevelidx = " & lidx
	Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>