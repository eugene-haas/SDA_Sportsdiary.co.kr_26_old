  <tr  style="text-align:center;">
	<td><%=ari+1%></td>
	<td><%=g_kskey%></td>
	<td><%=g_username%></td>
	<td><%=g_teamnm%></td>
	<td><%=g_userClass%></td>
	<td><%=g_titlename%></td>
	<td><%=g_roundstr%></td>
	<td><%If g_gameResult <> "" then%><%Call SetRC(g_gameResult)%><%End if%></td>
  </tr>
