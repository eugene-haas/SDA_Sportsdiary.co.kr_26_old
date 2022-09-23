


<%
If ci = "" Then
ci = 1 
End if
list_no = (intPageSize * (intPageNum-1)) + ci
'############################
%>

		<tr id="titlelist_<%=l_idx%>" style="text-align:center;">
			<td><%=list_no%></td>
			<td><%=Left(l_GameS,4)%></td>
			<td style="text-align:left;"><%=l_GameTitleName%></td></td>
			<td><%=l_atts%>~<%=l_atte%></td>

<%
'l_chkdates = CDate(rs(13))
'l_chkdatee = CDate(rs(14))
%>

			<%If l_chkdatee > now() then%>	
			<td >진행전</td>
			<%ElseIf  l_chkdates >= now() And l_chkdatee <= now() then%>
			<td class="danger">진행중</td>
			<%else%>
			<td class="bg-gray">종료</td>
			<%End if%>
			
			<td><%=l_attcnt%></td>
			<td><span>
			<%If l_exlfile = "" then%>
			<a href="javascript:mx.fileupload(<%=l_idx%>)" class="btn btn-primary">업로드</a></span>
			<%else%>
			<a href="javascript:mx.fileupload(<%=l_idx%>)" class="btn bg-gray"><%=LCase(Mid(l_exlfile, InStrRev(l_exlfile, "/") + 1))%></a></span>
			<%End if%>
			</td>
			<td>
			<%If l_setbase > 0 then%>
				  <a  class="btn bg-gray">설정완료</a>
			<%else%>
				  <a href="javascript:mx.insertTemp(<%=l_idx%>)" class="btn btn-primary">기본설정</a>
			<%End if%>
			</td>			
			<td>
			<%If l_setmember > 0 then%>				 
				  <a  class="btn bg-gray">넣기 완료</a>
			<%else%>
				  <a href="javascript:mx.insertRequest(<%=l_idx%>)" class="btn btn-primary">참가신청넣기</a>
			<%End if%>
			</td>			
			<td>
				  <%If l_chkdatee > now() then%>
				  <a href="javascript:mx.resetData(<%=l_idx%>)" class="btn btn-danger">삭제</a>
				  <%else%>
					<a  class="btn btn-danger" disabled>삭제</a><!-- href="javascript:alert('종료되어 삭제하실수 없습니다.')" -->
				  <%End if%>
			</td>			

		</tr>

<%ci = ci + 1%>
