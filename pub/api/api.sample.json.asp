<%
	If hasown(oJSONoutput, "SEQ") = "ok" then
		seq =  oJSONoutput.SEQ
	End If

	If hasown(oJSONoutput, "A") = "ok" then
		a =  oJSONoutput.A
	End If
	If hasown(oJSONoutput, "B") = "ok" then
		b =  oJSONoutput.B
	End If

	sum = CDbl(a) + CDbl(b)

	Call oJSONoutput.Set("sum", sum )
	Call oJSONoutput.Set("result", "0" )
	strjson = JSON.stringify(oJSONoutput)
	Response.Write strjson
%>