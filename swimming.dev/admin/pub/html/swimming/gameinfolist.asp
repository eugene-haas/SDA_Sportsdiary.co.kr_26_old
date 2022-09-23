<%
If ci = "" Then
ci = 1 
End if
list_no = (intPageSize * (intPageNum-1)) + ci
'############################
%>

		<tr id="titlelist_<%=l_idx%>" style="text-align:center;">
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=list_no%></span></td>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_gubun%></span></td>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_titleCode%></span></td>
			<td onclick="mx.input_edit(<%=l_idx%>)" style="text-align:left;"><span><%=l_GameTitleName%></span></td>
			
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_GameS%><%=l_GameE%></span></td>

			<%If 	l_checkatte < now() then%>	
			<td onclick="mx.input_edit(<%=l_idx%>)" class="bg-gray"><span><%=l_atts%><%=l_atte%></span></td>
			<%else%>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_atts%><%=l_atte%></span></td>
			<%End if%>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_GameArea%></span></td>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_kgame%></span></td>

			<td>
			<span>
				<%'홈페이지 모바일 신청 대진 확인서%>
				<a href="javascript:mx.setBtnState('btn1_<%=l_idx%>',<%=l_idx%>,'ViewState')" id="btn1_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_ViewState = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
				<a href="javascript:mx.setBtnState('btn2_<%=l_idx%>',<%=l_idx%>,'ViewStateM')" id="btn2_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_ViewStateM = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
				<a href="javascript:mx.setBtnState('btn3_<%=l_idx%>',<%=l_idx%>,'ViewYN')" id="btn3_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_ViewYN = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
				<a href="javascript:mx.setBtnState('btn4_<%=l_idx%>',<%=l_idx%>,'MatchYN')" id="btn4_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_MatchYN = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
				<a href="javascript:mx.setBtnState('btn5_<%=l_idx%>',<%=l_idx%>,'stateNo')" id="btn5_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_stateNo = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
			</span>			
			</td>

			<!-- <td ><span><a href="javascript:mx.golevel(<%=l_idx%>,'<%=l_GameTitleName%>')" class="btn btn-primary">관리</a></span></td> -->
		  <%If CDbl(ADGRADE) > 700 Then%>
			<td><span><a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'TITLE':'<%=l_GameTitleName%>'},'attmemberlist.asp')" class="btn bg-green">참가정보</a></span></td>
		  <%End if%>
			<td><span><a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'TITLE':'<%=l_GameTitleName%>','KYN':'<%=l_kgame%>'},'contestlevel.asp?idx=<%=l_idx%>')" class="btn btn-primary">관리</a></span></td>

			<td><span><a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'TITLE':'<%=l_GameTitleName%>'},'schoolcheck.asp')" class="btn btn-primary">확인서</a></span></td>
			<td><span><a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'TITLE':'<%=l_GameTitleName%>'},'gameorder.asp')" class="btn btn-primary">경기순서</a></span></td>
		</tr>
<%ci = ci + 1%>
