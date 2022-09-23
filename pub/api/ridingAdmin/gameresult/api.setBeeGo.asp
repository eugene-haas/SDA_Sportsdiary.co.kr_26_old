<%
'#############################################
'리그 비고입력
'#############################################
	
	'request
	If hasown(oJSONoutput, "MIDX") = "ok" Then 
		midx = oJSONoutput.MIDX
	End If

	If hasown(oJSONoutput, "BIGO") = "ok" Then 
		beego = oJSONoutput.BIGO
	End If

	
	Set db = new clsDBHelper 

	SQL = "update SD_tennisMember Set bigo = '"&beego&"'   where gameMemberidx = " &  midx
	Call db.execSQLRs(SQL , null, ConStr)

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson

	db.Dispose
	Set db = Nothing


%>