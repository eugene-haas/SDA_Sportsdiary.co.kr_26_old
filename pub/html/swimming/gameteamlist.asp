
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
		<td><%=l_idx%></td>
		<td><%=Left(l_TeamRegDt,4)%></td>
		<td><%=l_Team%></td>
		<td><%=l_EnterType%></td>
		<td><%=l_TeamNm%></td>
		<td><%=l_sido%></td>
		<td><%=sexstr%></td>
		<td><%=l_groupnm%></td>
		<td><%=l_jangname%></td>
		<td><%=l_readername%></td>
		<td><%=l_ZipCode%></td>
		<td title = "<%=l_Address%>" style="display: block;overflow: hidden;width:200px;height:57px;text-overflow: ellipsis; white-space: nowrap;text-align:left;"><%=l_Address%></td>
		<td><%=l_TeamTel%></td>
		<td><%=l_TeamMakeDt%></td>
		<td><%=l_SvcEndDt%></td>
		<td><%If l_mcnt = "0" then%>N<%else%>Y<%End if%></td>
	</tr>

