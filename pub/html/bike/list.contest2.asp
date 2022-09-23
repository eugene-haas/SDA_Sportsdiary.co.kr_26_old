
			<tr style="cursor:pointer" id="titlelist_<%=b_idx%>">
				<td><%=b_idx%></td>
				<td class="date" onclick="mx.input_edit(<%=b_idx%>)"><span><%=b_GameS%>~<%=b_GameE%></span></td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><span><%=b_sido%></span></td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><span><%=b_title%></span></td>
				<td>
                    <div class="toggle toggle-sm">
                        <input type="checkbox" id="attins_<%=b_idx%>" name="small-setting" onclick="mx.attCheck(<%=b_idx%>,1,'<%=cfg%>')" value="Y" <%If chk2= "Y" then%>checked<%End if%> />
                        <label for="attins_<%=b_idx%>">small</label>
                    </div>
                    <div class="toggle toggle-sm">
                        <input type="checkbox" id="attedit_<%=b_idx%>" name="small-setting" onclick="mx.attCheck(<%=b_idx%>,2,'<%=cfg%>')" value="Y" <%If chk3= "Y" then%>checked<%End if%> />
                        <label for="attedit_<%=b_idx%>">small</label>
                    </div>
                    <div class="toggle toggle-sm">
                        <input type="checkbox" id="attdel_<%=b_idx%>" name="small-setting" onclick="mx.attCheck(<%=b_idx%>,3,'<%=cfg%>')" value="Y" <%If chk4= "Y" then%>checked<%End if%> />
                        <label for="attdel_<%=b_idx%>">small</label>
                    </div>
				</td>
				<td><a href="javascript:mx.go(<%=b_idx%> , './contestlevel2.asp' )"  class="white-btn" >부(경기유형)관리</a></td>
				<td><a href="javascript:mx.editor(<%=b_idx%>,'<%=b_title%>')" class="white-btn" >대회요강</a></td>
			</tr>
