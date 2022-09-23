<%
'#############################################
'
'#############################################
	
	'request
	If hasown(oJSONoutput, "TIDX") = "ok" Then '대상
		tidx = oJSONoutput.Get("TIDX")
	End If
	If hasown(oJSONoutput, "GBIDX") = "ok" Then '대상
		gbidx = oJSONoutput.Get("GBIDX")
	End if	
	cdc = oJSONoutput.Get("CDC")
	starttype = oJSONoutput.Get("STYPE")


	Set db = new clsDBHelper 


	SQL = "update sd_gameMember Set startType = '"&starttype&"'  where GameTitleIDX = "&tidx&" and gbidx = '"&gbidx&"' and cdc= '"&cdc& "'"
	Call db.execSQLRs(SQL , null, ConStr)


	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
	Response.end
%>