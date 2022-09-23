  <tr class="gametitle_<%=l_tidx%>"   id="titlelist_<%=l_idx%>"  style="text-align:center;">
	<td><%=ari+1%></td>
	<td>단체</td>
	<td  >서울</td>
	<td ><%=goo(n)%></td>

	<td  ><%=l_sex%></td>
	<td>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'contestplayer.asp')" class="btn btn-default"><%If l_ITgubun = "I" then%>출전선수관리<%else%>출전팀관리<%End if%> (<%=l_attcnt%>)팀</a>
	</td>

	<td>


		  <%If l_gubun > 0 then%>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'gamedraw.asp')" class="btn bg-gray"><i class="fa fa-fw fa-sitemap"></i> 추첨완료</a>
		  <%else%>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'gamedraw.asp')" class="btn btn-danger"><i class="fa fa-fw fa-sitemap"></i> 대진표추첨</a>
		  <%End if%>
		  

	</td>

	<td>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'starttable.asp')" class="btn btn-primary"><i class="fa fa-fw fa-sitemap"></i> 대진표</a>
	</td>

  </tr>