


<%
If ci = "" Then
ci = 1 
End if
list_no = (intPageSize * (intPageNum-1)) + ci
'############################
%>

		<tr id="titlelist_<%=idx%>" style="text-align:center;">


			<td onclick="mx.input_edit(<%=idx%>)"><span><%=list_no%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)" style="text-align:left;"><span><%=GameTitleName%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=Replace(GameS,"-",".")%>~<%=Replace(GameE,"-",".")%></span></td>




			<td>
			<span>
				모집중
				<!-- <a href="javascript:mn.setBtnState('btn1_426',426,'N',0)" class="btn btn-fix-sm btn-warning" id="btn1_426">N</a> -->
				<!-- <label class="switch" title="참가신청" >
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
				</label> -->

			</span>			
			</td>
			<td onclick="mx.input_edit(<%=idx%>)"><span>111</span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=gamearea%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span>전문,생활</span></td>
			<td><span><a href="javascript:px.goSubmit({'IDX':<%=idx%>,'TITLE':'<%=GameTitleName%>'},'schoolcheck.asp')" class="btn btn-primary">조회</a></span></td>
		</tr>

<%
'############################
ci = ci + 1%>