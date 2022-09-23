	<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;">
		<td>

			<%If ari = 0 then%>
			<button disabled class="btn btn-default btn-xs">▲</button>
			<%else%>
			<button onclick="mx.changeOrder(<%=l_idx%>,1,'PM')" class="btn btn-default btn-xs">▲</button>
			<%End if%>

			<%If ari = lastno then%>
			<button disabled class="btn btn-default btn-xs">▼</button> 
			<%else%>
			<button onclick="mx.changeOrder(<%=l_idx%>,2,'PM')" class="btn btn-default btn-xs">▼</button> 
			<%End if%>

		</td>
		<td>
		<input type="text" id="gp1_<%=l_idx%>" onblur="mx.setGameno(<%=l_idx%>,this.value,'type2')" value="<%=l_gameno2%>" style="width:100px;">
		<input type="text" id="gp2_<%=l_idx%>" onblur="mx.setJoono(<%=l_idx%>,this.value,'type2')" value="<%=l_joono2%>" style="width:30px;">
		<%'="_"&l_joono2%>
		</td>
<!-- 		<td><%=l_gameno2&"_"&l_joono2%></td> -->
		<td><%=l_CDBNM%></td>
		<td><%=l_CDCNM%></td>
		<td><%=gubunstr%></td>
	</tr>


