	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>">
		<td onclick="mx.input_edit(<%=idx%>)"><%=idx%></td>
		<td onclick="mx.input_edit(<%=idx%>)"><%=hostname%></td>
		<td onclick="mx.input_edit(<%=idx%>)"><%If hgubun = "1" then%>주최<%else%>주관<%End if%></td>
		<!-- <td onclick="mx.input_edit(<%=idx%>)"><%=makegamecnt%></td> -->
		<td onclick="mx.input_edit(<%=idx%>)"><%=writeday%></td>
	</tr>