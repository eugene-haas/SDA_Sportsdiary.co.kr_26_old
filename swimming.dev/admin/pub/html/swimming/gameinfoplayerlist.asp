

<%If f_itgubun = "T" then%>
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
		<td><%=no%></td>
		<td><%=l_CDBNM%></td>
		<td><%=l_CDCNM%></td>
		<td><%=l_P1_UserName%></td>
		<td><%=l_P1_TeamNm%></td>
		<td><%=l_sidonm%></td>


		<td><a href="#" class="btn btn-primary"  onclick="mx.playerList(<%=l_idx%>)">선수목록</a></td>
		<td><a href="#" class="btn btn-danger"  onclick="mx.del_frm(<%=l_idx%>);">신청취소</a></td>
	</tr>
<%else%>
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
		<td><%=no%></td>
		<td><%=l_CDBNM%></td>
		<td><%=l_CDCNM%></td>
		<td><%=l_P1_UserName%></td>
		<td><%=l_P1_TeamNm%></td>
		<td><%=l_P1_UserClass%></td>

		<td><%=l_attcnt%></td>

		<td><%=P1_ksportsno%></td>
		<td><a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm(<%=l_idx%>);">신청취소</a></td>
	</tr>
<%End if%>
