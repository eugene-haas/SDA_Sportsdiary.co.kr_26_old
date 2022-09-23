	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;">
		<td>
			<%If ari = 0 then%>
			<button disabled class="btn btn-default btn-xs">▲</button>
			<%else%>
			<button onclick="mx.changeOrder(<%=l_idx%>,1,'AM')" class="btn btn-default btn-xs">▲</button>
			<%End if%>

			<%If ari = lastno then%>
			<button disabled class="btn btn-default btn-xs">▼</button> 
			<%else%>
			<button onclick="mx.changeOrder(<%=l_idx%>,2,'AM')" class="btn btn-default btn-xs">▼</button> 
			<%End if%>

		</td>

		<td>
		<input type="text" id="ga1_<%=l_idx%>" onblur="mx.setGameno(<%=l_idx%>,this.value,'type1')" value="<%=l_gameno%>" style="width:100px;">_
		<input type="text" id="ga2_<%=l_idx%>" onblur="mx.setJoono(<%=l_idx%>,this.value,'type1')" value="<%=l_joono%>" style="width:30px;">
		<%'="_"&l_joono%><%'=l_tryoutgamestarttime%></td>

<!-- 		<td><%=l_gameno&"_"&l_joono%><%'=l_tryoutgamestarttime%></td> -->
		<td><%=l_CDBNM%></td>
		<td><%=l_CDCNM%></td>
		<td><%=gubunstr%></td>
	</tr>

