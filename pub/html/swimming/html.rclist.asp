
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
			<td><%=l_idx%></td>
			<td><%=l_titleCode%></td>
			<td><%=l_titlename%></td>
			<td><%=l_gamearea%></td>
			<td><%=l_gameDate%></td>
			<td><%=l_UserName%></td>
			<td><%=l_TeamNm%>[<%=l_userClass%>]</td>
			<td><%=Left(l_gameResult,2) &":"& mid(l_gameResult,3,2) &"."& mid(l_gameResult,5,2)%></td>
			<td><%=l_gameOrder%></td>
			<td><%=setRCStr(l_rctype)%></td>
			<td><%=l_CDANM%></td>
			<td><%=l_CDBNM%></td>
			<td><%=l_CDCNM%></td>
	</tr>

