  <tr class="gametitle_<%=l_idx%>"   id="titlelist_<%=l_idx%>"  style="text-align:center;">
	<td><input type="checkbox" name="chk_game" value="<%=l_idx%>"></td>
	<td><%=ari+1%></td>
	<td><%=l_gamecode%></td>
	<td><%=l_gametitlename%><!-- :<%=l_cdbnm%> <%=l_cdcnm%> --></td>
	<td><%=l_games%>~<%=l_gameE%></td>
	<td><%=l_gamearea%></td>
	<td><%=l_kgame%></td>
	<td><%If l_gubun = "01" Or l_gubun="02" then%>국내<%else%>국제<%End if%></td>
  </tr>

