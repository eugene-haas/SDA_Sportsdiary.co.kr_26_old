


<%
If ci = "" Then
ci = 1 
End if
list_no = (intPageSize * (intPageNum-1)) + ci
'############################
%>

		<tr id="titlelist_<%=idx%>" style="text-align:center;">
			<td>NO</td>
			<td>2019</td>
			<td style="text-align:left;"><span><%=GameTitleName%></span></td></td>
			<td>2019</td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=Replace(GameS,"-",".")%>~<%=Replace(GameE,"-",".")%></span></td>
			<td class="danger">진행중</td>
			<td><%=gamearea%></td><!-- 전체,모바일,홈페이지 -->
			<td>전문,생활</td>
			<td><a href="javascript:mn.setBtnState('btn1_426',426,'N',0)" class="btn btn-fix-sm btn-primary" id="btn1_426">조회</a></td>

			<!-- 
			<td ><span><a href="javascript:mx.golevel(<%=idx%>,'<%=GameTitleName%>')" class="btn btn-primary">관리</a></span></td>
			<td><span><a href="javascript:px.goSubmit({'IDX':<%=idx%>,'TITLE':'<%=GameTitleName%>'},'schoolcheck.asp')" class="btn btn-primary">확인서</a></span></td>
			 -->
		</tr>

<%
'############################
ci = ci + 1%>