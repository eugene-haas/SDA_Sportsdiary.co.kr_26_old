		<tr id="titlelist_<%=idx%>">
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=idx%></span></td>
			
			<td onclick="mx.input_edit(<%=idx%>)"><%=rullyear%></td>

			<td onclick="mx.input_edit(<%=idx%>)" <%If pteamgbnm = "개인" then%>style="color:orange"<%End if%>><span><%=pteamgbnm%></td>

			<td><span><a class="btn btn btn-<%If pteamgbnm = "개인" then%>success<%else%>warning<%End if%>"><%=teamgbnm%></a></span></td>

			<td><span><a class="btn btn btn-<%If pteamgbnm = "개인" then%>success<%else%>warning<%End if%>"><%=levelnm%></a></span></td>

			<td  onclick="mx.input_edit(<%=idx%>)"><span><%=classnm%></span></td>
			<td  onclick="mx.input_edit(<%=idx%>)"><span><%=classhelp%></span></td>

			<td>
			<%If pteamgbnm = "개인" then%>
			<a href="javascript:mx.setPoint(<%=idx%>);" class="btn btn-default btnpoint">포인트 관리</a>
			<%End if%>
			</td>
		</tr>




