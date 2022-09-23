<%
'#############################################
'리그순위변경
'#############################################
	
	'request
	If hasown(oJSONoutput, "LIDX") = "ok" Then 
		lidx = oJSONoutput.LIDX
	End If

	If hasown(oJSONoutput, "FID") = "ok" Then 
		fldnm = oJSONoutput.FID
	End If


	If hasown(oJSONoutput, "VAL") = "ok" Then 
		setval = oJSONoutput.VAL
	End If


	Set db = new clsDBHelper 

	SQL = "update tblRGameLevel Set "&fldnm&" = '"&setval&"'   where RGameLevelidx = " &  lidx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing


%>