<%If gamesinpass = True And Left(singistr,2) = "대회" then%>

<%else%>
	<tr class="gametitle" id="titlelist_<%=l_gameMemberIDX%>"  style="text-align:center;">
			<td><%=ari + 1%></td>
			<td><%=l_cdanm%></td>
			<td><%=l_cdbnm%></td>
			<td><%=l_cdcnm%></td>
			<td><%=l_username%></td>
			<td><%=l_teamnm%></td>
			<td><%=l_sidonm%></td>
			<td><%=sinround%></td>
			<td><%=singistr%></td>
			<td><%Call SetRC(singi)%></td>
			<td><%Call SetRC(singipre)%><%'=l_startType%></td>
			<td>

			<%
			'sinround = "결승"
			'singistr = "대회신기록"	
			'savefld = "2"
			%>

			<div class="btn-group">
				  <button type="button" class="btn <%If l_rc1 = "Y" then%>btn-success<%else%>btn-default<%end if%>" id= "okon1_<%=l_gameMemberIDX%>" onclick="mx.setRCOK('<%=l_gameMemberIDX%>','1','on', '<%=sinround%>','<%=singistr%>','<%=savefld%>','<%=singi%>','<%=l_PlayerIDX%>')">On</button>
				  <button type="button" class="btn <%If l_rc1 = "Y" then%>btn-default<%else%>bg-gray<%end if%>" id= "okoff1_<%=l_gameMemberIDX%>" onclick="mx.setRCOK('<%=l_gameMemberIDX%>', '1','off', '<%=sinround%>','<%=singistr%>','<%=savefld%>','<%=singi%>','<%=l_PlayerIDX%>')">Off</button>
			</div>
			
			</td>
			<td>
			<div class="btn-group">
				  <button type="button" class="btn <%If l_rc2 = "Y" then%>btn-success<%else%>btn-default<%end if%>" id= "okon2_<%=l_gameMemberIDX%>" onclick="mx.setRCOK('<%=l_gameMemberIDX%>','2','on', '<%=sinround%>','<%=singistr%>','<%=savefld%>','<%=singi%>','<%=l_PlayerIDX%>')">On</button>
				  <button type="button" class="btn <%If l_rc2 = "Y" then%>btn-default<%else%>bg-gray<%end if%>"id= "okoff2_<%=l_gameMemberIDX%>" onclick="mx.setRCOK('<%=l_gameMemberIDX%>','2','off', '<%=sinround%>','<%=singistr%>','<%=savefld%>','<%=singi%>','<%=l_PlayerIDX%>')">Off</button>
			</div>			
			</td>
	</tr>
<%End if%>

