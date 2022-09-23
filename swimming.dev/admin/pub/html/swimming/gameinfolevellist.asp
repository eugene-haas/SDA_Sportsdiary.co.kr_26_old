  <tr class="gametitle_<%=l_tidx%>"   id="titlelist_<%=l_idx%>"  style="text-align:center;">
	<td><%=ari+1%></td>
	<td><%If l_ITgubun = "I" then%>개인<%else%>단체<%End if%></td>



<%If l_attcnt = 0 then%>
	<td  onclick="mx.input_edit(<%=l_idx%>)"><%=l_CDBNM%></td>
	<td  onclick="mx.input_edit(<%=l_idx%>)"><%=l_CDCNM%></td>
<%else%>
	<td  onclick="alert('출전선수가 있어서 수정이 불가합니다.<%=l_attcnt%>')"><%=l_CDBNM%></td>
	<td  onclick="alert('출전선수가 있어서 수정이 불가합니다.')"><%=l_CDCNM%></td>
<%End if%>

	<td>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'contestplayer.asp')" class="btn btn-default"><%If l_ITgubun = "I" then%>출전선수관리<%else%>출전팀관리<%End if%> (<%=l_attcnt%>)</a>
	</td>

	<td>
		  <%If l_CDCNM = "수구" Then '수구%>

		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'gamedraw2.asp')" class="btn <%If l_gubun > 0 then%>bg-gray<%else%>btn-danger<%End if%>"><i class="fa fa-fw fa-sitemap"></i><%If l_gubun > 0 then%>추첨완료<%else%>대진표추첨<%End if%></a>
		  
		  <%else%>

		  <%If l_gubun > 0 then%>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'gamedraw.asp')" class="btn bg-gray"><i class="fa fa-fw fa-sitemap"></i> 추첨완료</a>
		  <%else%>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'gamedraw.asp')" class="btn btn-danger"><i class="fa fa-fw fa-sitemap"></i> 대진표추첨</a>
		  <%End if%>
		  
		  <%End if%>
	</td>

	<td>
		  <a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'GB':'<%=l_gbidx%>','TGB':'<%=l_tidx%>','LNM':'<%=title & " - " &  l_CDANM & " " & l_CDBNM & " " & l_CDCNM%>'},'starttable.asp')" class="btn btn-primary"><i class="fa fa-fw fa-sitemap"></i> 대진표</a>
	</td>

	<td>
		  <a href="javascript:mx.del_frm(<%=l_idx%>)" class="btn btn-danger">삭제</a>
	</td>

  </tr>