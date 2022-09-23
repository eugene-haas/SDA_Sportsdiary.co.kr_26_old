<%
'request
	pidx = oJSONoutput.Get("PIDX")
	c1 = oJSONoutput.Get("C1")
	c2 = oJSONoutput.Get("C2")
	c3 = oJSONoutput.Get("C3")
	C4 = oJSONoutput.Get("C4")

	Set db = new clsDBHelper


		SQL = "update tblPlayer set ctemp1 = '"&c1&"', ctemp2 = '"&c2&"', ctemp3 = '"&c3&"', ctemp4 = '"&c4&"'  where playeridx =  " & pidx
		Call db.execSQLRs(SQL , null, ConStr)



	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson


	db.Dispose
	Set db = Nothing
%>

