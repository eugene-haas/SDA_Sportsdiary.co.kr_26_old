

	<%If CDbl(ADGRADE) > 500 then%>

		<tr id="titlelist_<%=idx%>">
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=idx%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span class="red_font"><%=titleGrade%></span> <span><%=title%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=sdate%>~<%=edate%></span></td>
			<td onclick="mx.input_edit(<%=idx%>)"><span><%=viewYN%><%=ViewState%> : <%=MatchYN%></span></td>


<%If ddddddddddd = "계좌정보막음" then%>
			<%If vacReturnYN = "Y" then%>
			<td><span><a href="#" class="btn btn-primary">정리완료</a></span></td>
			
			<%ElseIf Cdate(edate) + 90 > date()  then%>
			<td><span><a href="javascript:alert('대회 종료일로부터 90일뒤에 계좌 초기화가 가능 합니다.')"  class="btn btn-primary">종료일+90</a></span></td>

			<%else%>
			<td><span><a href="javascript:mx.vaccreset(<%=idx%>,'<%=title%>')" class="btn btn-primary">계좌반환</a></span></td>
			<%End if%>
<%End if%>


			<td>
				<span><a href="javascript:mx.golevel(<%=idx%>,'<%=title%>')" class="btn btn-primary">부(경기유형)관리</a></span>
				<span><a href="javascript:mx.goboo(<%=idx%>,'<%=title%>')" class="btn btn-primary">단체별</a></span>
			</td>

			<td><span><a href="javascript:mx.editor(<%=idx%>,'<%=title%>')" class="btn btn-primary">대회요강</a></span></td>

			<td>
				<select id="gameyear_<%=idx%>" class="form-control">
				<%For y = year(date) To year(date) -3 Step - 1%>
				<option value="<%=y%>"><%=y%>년</option>
				<%next%>
				</select>
				<a href="javascript:mx.rnkList($('#gameyear_<%=idx%>').val(),<%=titleCode%>,<%=idx%>)" class="btn btn-primary">랭킹반영</a>
			
			</td>			
		</tr>

	<%else%>
		<tr id="titlelist_<%=idx%>" onmousedown="mx.golevel(<%=idx%>,'<%=title%>')">
			<td class="number" onclick="mx.input_edit(<%=idx%>)"><span><%=idx%></span></td>
			<td class="name" onclick="mx.input_edit(<%=idx%>)"><span class="red_font"><%=titleGrade%></span> <span><%=title%></span></td>
			<td class="date" onclick="mx.input_edit(<%=idx%>)"><span><%=sdate%>~<%=edate%></span></td>
		</tr>
	<%End if%>

