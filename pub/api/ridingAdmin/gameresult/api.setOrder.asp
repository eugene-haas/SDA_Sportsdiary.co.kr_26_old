<%
'#############################################
'리그순위변경
'#############################################
	
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx = oJSONoutput.MIDX
	End If

	If hasown(oJSONoutput, "ORDERNO") = "ok" Then 
		orderno = oJSONoutput.ORDERNO
	End If

	
	Set db = new clsDBHelper 

	SQL = "update SD_tennisMember Set total_order = '"&orderno&"'   where gameMemberidx = " &  midx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing


%>