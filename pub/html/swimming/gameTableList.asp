
	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;">

		<%If l_tryoutgroupno > 0 Then 'roundno 를 처리해서 넣었다 헛갈리지 말자%>
		<%If ari =  0 or prejoo <> l_tryoutgroupno Then%>
		<td  rowspan="<%=Rcnt(1, l_tryoutgroupno-1)%>" style="vertical-align:middle;"><%=l_tryoutgamedate%>(오전)</td>
		<td  rowspan="<%=Rcnt(1, l_tryoutgroupno-1)%><%'=raneCnt%>" style="vertical-align:middle;"><%If l_gunam = "1" then%>예선<%else%>결승<%End if%> <%=l_tryoutgroupno%>
		
		<br><%=l_gameno%>_<%=l_joono%>
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


  