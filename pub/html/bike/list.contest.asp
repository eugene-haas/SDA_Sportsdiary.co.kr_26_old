
			<tr style="cursor:pointer" id="titlelist_<%=b_idx%>">
				<td><%=b_idx%></td>
				<td class="date" onclick="mx.input_edit(<%=b_idx%>)"><%=b_GameS%>~<%=b_GameE%></td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><%=b_sido%></td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><%=b_title%></td>
				<td class="name">
				

      <label class="switch" style="margin-bottom:-8px;" title="신청 (사용자 참가신청)" onclick="mx.attCheck(<%=b_idx%>,1,'<%=cfg%>')">
      <input type="checkbox" id="attins_<%=b_idx%>"  value="Y" <%If chk2= "Y" then%>checked<%End if%>>
      <span class="slider round"></span>
      </label>
      <label class="switch" style="margin-bottom:-8px;" title="수정 (사용자 참가신청)" onclick="mx.attCheck(<%=b_idx%>,2,'<%=cfg%>')">
      <input type="checkbox" id="attedit_<%=b_idx%>"  value="Y" <%If chk3= "Y" then%>checked<%End if%>>
      <span class="slider round"></span>
      </label>
      <label class="switch" style="margin-bottom:-8px;" title="삭제 (사용자 참가신청)" onclick="mx.attCheck(<%=b_idx%>,3,'<%=cfg%>')">
      <input type="checkbox" id="attdel_<%=b_idx%>"  value="Y" <%If chk4= "Y" then%>checked<%End if%>>
      <span class="slider round"></span>
      </label>
				

				</td>
				<td class="g_btn green_btn2"><a href="javascript:mx.go(<%=b_idx%> , './contestlevel.asp' )">부(경기유형)관리</a></td>
				<td class="g_btn green_btn1"><a href="javascript:mx.editor(<%=b_idx%>,'<%=b_title%>')">대회요강</a></td>


			</tr>

