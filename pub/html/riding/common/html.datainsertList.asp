	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>">
		<td onclick="mx.input_edit(<%=idx%>)"><%=idx%></td>
		<td onclick="mx.input_edit(<%=idx%>)"><%=p_1%></td>
		<td onclick="mx.input_edit(<%=idx%>)"><%=p_2%></td>
		<td onclick="mx.input_edit(<%=idx%>)"><%=writeday%></td>
		<td>
		<%If p_6 = "N" then%>
		<a href="javascript:mx.insertData(<%=idx%>)" class="btn btn-primary">데이터저장</a>
		<%else%>
		<a href="javascript:alert('첫번째 데이터와 끝데이터의 인덱스를 찾아서 지우자.')" class="btn btn-danger">데이터삭제</a>
		<%End if%>
		</td>
	</tr>