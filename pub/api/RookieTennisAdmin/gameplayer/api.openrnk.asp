<%
'#############################################
'오픈부 랭킹저장위치 저장
'#############################################
	'request
	If hasown(oJSONoutput, "PIDX") = "ok" then
		pidx = oJSONoutput.PIDX
	Else
		Response.end
	End If
	If hasown(oJSONoutput, "V") = "ok" then
		setvalue = oJSONoutput.V
	Else
		Response.end
	End If


	Set db = new clsDBHelper

	SQL = "Update tblPlayer set openrnkboo = '"&setvalue&"' where playerIDX = " & pidx
	Call db.execSQLRs(SQL , null, ConStr)


	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 3100 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>