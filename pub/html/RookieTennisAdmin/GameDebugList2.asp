	<tr class="gametitle"   id="titlelist_<%=pidx%>" <%If rsdata(6) = 1 then%>style="background:yellow;"<%End if%>>
		<%
			For i = 0 To Rs.Fields.Count - 1
				Response.write "<td>" & rsdata(i)   & "</td>"
			Next
		%>
	</tr>