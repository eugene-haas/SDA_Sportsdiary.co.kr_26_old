<%
'#############################################
'승급자 전체 초기화
'#############################################
	'request
'	If hasown(oJSONoutput, "PIDX") = "ok" then
'		pidx = oJSONoutput.PIDX
'	Else
'		Response.end
'	End If

	Set db = new clsDBHelper

	'올해 이전것만 초기화
	SQL = "update tblPlayer Set dblrnk = 'N' where levelup < " & year(date)
	Call db.execSQLRs(SQL , null, ConStr)

	db.Dispose
	Set db = Nothing

	Call oJSONoutput.Set("result", 3102 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>