
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;">

		<%If l_tryoutgroupno > 0 then%>
		<%If ari =  0 or prejoo <> l_tryoutgroupno Then%>
		<!-- <td  rowspan="<%=Rcnt(1, l_tryoutgroupno-1)%><%'=raneCnt%>" style="vertical-align:middle;"><%If l_startType = "1" then%>예선<%else%>결승<%End if%>  <%=l_tryoutgroupno%></td> -->
		<td  rowspan="<%=Rcnt(1, l_tryoutgroupno-1)%><%'=raneCnt%>" style="vertical-align:middle;"><%=l_tryoutgroupno%></td>
		<%End if%>
		<%else%>
		<td>&nbsp;</td>
		<%End if%>

			<%If l_tryoutgroupno > 0 then%>
			<td><%=l_tryoutsortNo%></td>
			<%else%>

			<%End if%>
		</td>
		<td><%=l_username%></td>
		<td><%=l_sidonm%></td>
		<td><%=l_teamnm%></td>
		<td><%=l_userClass%></td>
	</tr>
<%
prejoo = l_tryoutgroupno
%>


  