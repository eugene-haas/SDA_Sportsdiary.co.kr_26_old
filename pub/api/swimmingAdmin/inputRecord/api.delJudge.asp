<%
'#############################################
' 등록심판제거
'#############################################
	'request
	cda = oJSONoutput.Get("CDA")
	tidx = oJSONoutput.Get("TIDX")
	idx = oJSONoutput.Get("IDX")

	If isnumeric(idx) = False Then
		Response.end
	End if

	Set db = new clsDBHelper

	SQL = "delete from sd_gameTitle_judge  where seq = "&idx&"  "
	Call db.execSQLRs(SQL , null, ConStr)
	  

	Call oJSONoutput.Set("result", 0 )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>
