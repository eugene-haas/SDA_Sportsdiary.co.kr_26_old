<%If idx = "55" Then '테스트 항목%>

	<%If USER_IP = "118.33.86.240" then%>
		
		<%If CDbl(ADGRADE) > 500 then%>
			<tr style="cursor:pointer" id="titlelist_<%=idx%>">
				<td  onclick="mx.input_edit(<%=idx%>)"><%=idx%></td>
				<td  onclick="mx.input_edit(<%=idx%>)" style="text-align:left;padding-left:10px;"><span class="red_font"><%=titleGrade%></span> <%=title%></td>
				<td  onclick="mx.input_edit(<%=idx%>)" style="color:#A43A1D;"><%=sdate%>~<%=edate%></td>
				<!-- <td  onclick="mx.input_edit(<%=idx%>)"><%=rcvs%>~<%=rcve%></td> -->
				<td  onclick="mx.input_edit(<%=idx%>)"><%=viewYN%><%=ViewState%> : <%=MatchYN%></td>


			<%If USER_IP = "118.33.86.240" then%>
				<%If Cdate(edate) < Date() +30 then%>
				<td class="g_btn green_btn1"><a href="javascript:alert('대회 종료일로부터 30일뒤에 계좌 초기화가 가능 합니다.')" style="background:orange;">종료일+30</a></td>
				<%else%>
				<td class="g_btn green_btn1"><a href="javascript:mx.vaccreset(<%=idx%>,'<%=title%>')">계좌반환</a></td>
				<%End if%>
			<%End if%>
					<td class="g_btn green_btn2"><a href="javascript:mx.golevel(<%=idx%>,'<%=title%>')">부(경기유형)관리</a></td>
					<td class="g_btn green_btn1"><a href="javascript:mx.editor(<%=idx%>,'<%=title%>')">대회요강</a></td>
				</tr>
		<%else%>
			<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=idx%>" onmousedown="mx.golevel(<%=idx%>,'<%=title%>')"  style="background:#BAD6FA;">
				<td  ><%=idx%></td>
				<td   style="text-align:left;padding-left:10px;"><span class="red_font"><%=titleGrade%></span> <%=title%></td>
				<td   style="color:#A43A1D;"><%=sdate%>~<%=edate%></td>
			</tr>
		<%End if%>

	<%End if%>




<%else%>

	<%If CDbl(ADGRADE) > 500 then%>

		<tr id="titlelist_<%=idx%>">
			<td class="number" onclick="mx.input_edit(<%=idx%>)"><span><%=idx%></span></td>
			<td class="name" onclick="mx.input_edit(<%=idx%>)"><span class="red_font"><%=titleGrade%></span> <span><%=title%></span></td>
			<td class="date" onclick="mx.input_edit(<%=idx%>)"><span><%=sdate%>~<%=edate%></span></td>

			
			
			<td class="Exposure" ><span><%=viewYN%><%=ViewState%> : <%=MatchYN%>
			</span>
<%'If USER_IP = "118.33.86.240" Then%>
          <a href="javascript:mx.turnShow(<%=idx%>)" id="btn" class="btn" style="width:30px;<%If tnshow = "N" then%>background:orange;<%End if%>">본선대진표:<%=tnshow%></a>
<%'End if%>			
			</td>


			<%If vacReturnYN = "Y" then%>
			<td class="g_btn green_btn1"><a href="#" style="background:gray;">정리완료</a></td>
			
			<%ElseIf Cdate(edate) + 90 > date()  then%>
			<td class="g_btn green_btn1"><a href="javascript:alert('대회 종료일로부터 90일뒤에 계좌 초기화가 가능 합니다.')" style="background:orange;">종료일+90</a></td>

			<%else%>
			<td class="g_btn green_btn1"><a href="javascript:mx.vaccreset(<%=idx%>,'<%=title%>')">계좌반환</a></td>
			<%End if%>


			<td class="g_btn green_btn2"><a href="javascript:mx.golevel(<%=idx%>,'<%=title%>')">부(경기유형)관리</a></td>
			<td class="g_btn green_btn1"><a href="javascript:mx.editor(<%=idx%>,'<%=title%>')">대회요강</a></td>

			<td class="g_btn green_btn1">
				<select id="gameyear_<%=idx%>" style="width:100px;">
				<%For y = year(date) To year(date) -3 Step - 1%>
				<option value="<%=y%>"><%=y%>년</option>
				<%next%>
				</select>
				<a href="javascript:mx.rnkList($('#gameyear_<%=idx%>').val(),<%=titleCode%>,<%=idx%>)">랭킹반영</a>
			
			</td>			
		</tr>

	<%else%>
		<tr id="titlelist_<%=idx%>" onmousedown="mx.golevel(<%=idx%>,'<%=title%>')">
			<td class="number" onclick="mx.input_edit(<%=idx%>)"><span><%=idx%></span></td>
			<td class="name" onclick="mx.input_edit(<%=idx%>)"><span class="red_font"><%=titleGrade%></span> <span><%=title%></span></td>
			<td class="date" onclick="mx.input_edit(<%=idx%>)"><span><%=sdate%>~<%=edate%></span></td>
		</tr>
	<%End if%>

<%End if%>