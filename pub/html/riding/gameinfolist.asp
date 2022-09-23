


<%
If ci = "" Then
ci = 1 
End if
list_no = (intPageSize * (intPageNum-1)) + ci
'############################
%>


		<tr id="titlelist_<%=idx%>">
			<td onclick="mx.input_edit(<%=idx%>)"><span><%'=idx%><%=list_no%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=GameTitleName%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=Replace(GameS,"-",".")%>~<%=Replace(GameE,"-",".")%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=gamearea%></span></td>

			<td>
			<span>
				<label class="switch" title="참가신청" >
				<input type="checkbox" id="att_<%=idx%>"  value="Y" <%If viewYN= "Y" then%>checked<%End if%> onclick="mx.setFlag(<%=idx%>,1)">
				<span class="slider round"></span>
				</label>
				<label class="switch" title="대회달력" >
				<input type="checkbox" id="cal_<%=idx%>"  value="Y" <%If ViewState= "Y" then%>checked<%End if%> onclick="mx.setFlag(<%=idx%>,2)">
				<span class="slider round"></span>
				</label>
				<label class="switch" title="대진표" >
				<input type="checkbox" id="tbl_<%=idx%>"  value="Y" <%If MatchYN= "1" then%>checked<%End if%> onclick="mx.setFlag(<%=idx%>,3)">
				<span class="slider round"></span>
				</label>
			</span>			
			</td>



<%If ekdmadpdhvms = True then%>
			<%If vacReturnYN = "Y" then%>
				<td><span><a href="#" class="btn btn-primary">정리완료</a></span></td>
			
			<%ElseIf Cdate(GameE) + 90 > date()  then%>
				<td><span><a href="javascript:alert('대회 종료일로부터 90일뒤에 계좌 초기화가 가능 합니다.')"  class="btn btn-primary">종료일+90</a></span></td>
			<%else%>
				<td><span><a href="javascript:mx.vaccreset(<%=idx%>,'<%=GameTitleName%>')" class="btn btn-primary">계좌반환</a></span></td>
			<%End if%>
<%End if%>



			<td>
				<span><a href="javascript:mx.golevel(<%=idx%>,'<%=GameTitleName%>')" class="btn btn-primary">세부종목관리</a></span>
				<!-- <span><a href="javascript:mx.goboo(<%=idx%>,'<%=title%>')" class="btn btn-primary">단체별</a></span> -->
			</td>

			<td><span><a href="javascript:mx.editor(<%=idx%>,'<%=GameTitleName%>')" class="btn btn-primary">대회요강</a></span></td>
			<!-- <td><span><a href="javascript:mx.setLimit(<%=idx%>,'<%=GameTitleName%>')" class="btn btn-primary">참가신청제한</a></span></td> -->

		</tr>

<%
'############################
ci = ci + 1%>