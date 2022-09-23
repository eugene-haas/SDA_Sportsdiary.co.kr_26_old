
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;">

		<%If l_tryoutgroupno > 0 Then '오전과 오후다 헛갈리지 말자%>
		<%If ari =  0 or prejoo <> l_tryoutgroupno Then%>
		<td  rowspan="<%=Rcnt2(1, l_tryoutgroupno-1)%>" style="vertical-align:middle;"><%=l_finalgamedate%>(오후)</td>
		<td  rowspan="<%=Rcnt2(1, l_tryoutgroupno-1)%><%'=raneCnt%>" style="vertical-align:middle;"><%If l_gunpm = "1" then%>예선<%else%>결승<%End if%> <%=l_tryoutgroupno%>
		
		<br><%=l_gameno2%>_<%=l_joono2%>
		</td>
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


  