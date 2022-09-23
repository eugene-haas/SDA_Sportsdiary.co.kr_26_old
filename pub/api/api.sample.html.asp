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
%>

<table width="100">
<tr>
	<td>A + B = </td>
</tr>
<tr>
	<td><%=sum%> 입니다.</td>
</tr>
</table>