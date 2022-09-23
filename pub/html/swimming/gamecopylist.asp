  <tr class="gametitle_<%=l_tidx%>"   id="titlelist_<%=l_idx%>"  style="text-align:center;">
	<td><%=ari+1%></td>
	<td><%=l_gamecode%></td>
	<td><%=l_gametitlename%></td>
	<td>(<%=l_gcnt%>)</td>
	<td><%=l_games%>~<%=l_gameE%></td>
	<td><%=l_gamearea%></td>
	<td><%=l_kgame%></td>
	<td><%If l_gubun = "K" then%>국내<%else%>국제<%End if%></td>

	<td>
		  <%If l_gcnt = "0" then%>
		  <a href="javascript:alert('생성된 부서가 없는 대회입니다.')" class="btn btn-primary"><i class="fa fa-fw fa-sitemap"></i>복사</a>
		  <%else%>
		  <a href="javascript:mx.copyGame(<%=tidx%>,<%=l_idx%>)" class="btn btn-primary"><i class="fa fa-fw fa-sitemap"></i>복사</a>
		  <%End if%>
	</td>

  </tr>