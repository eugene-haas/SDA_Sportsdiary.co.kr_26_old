		<input type="hidden" id="idx" value="<%=updateidx%>" />
		<input type="hidden" id="TitleIDX" value="<%=idx%>" />

		<table class="navi-tp-table">
			<caption>대회정보관리 신청관리</caption>
			<colgroup>
				<col width="64px"><col width="*"><col width="64px"><col width="*"><col width="94px"><col width="*"><col width="94px"><col width="*">
			</colgroup>

			<tbody>
				<tr>
					<th scope="row">대회명</th>
					<td colspan="2"><%=title%>&nbsp;&nbsp;<%=teamnm%> (<%=levelnm%>) &nbsp;&nbsp;신청인 : </span id="applyid">운영자</span></td>
				</tr>
				<tr>
					<th scope="row">&nbsp;</th>
					<td colspan="2">이름 / 성별 / 생년월일 / 등급 / 핸드폰/소속팀1/소속팀2 </td>
				</tr>
					<th scope="row">선수1</th>
					<td id="sel_VersusGb">
					<input type="text" id="p1name" value="<%=p1name%>" width="150px;">

					<select name="p1sex" id="p1sex" style="width:50px;margin-top:-9px">
					<option value="Man"  <%If p1sex = "Man" then%>selected<%End if%>>남</option>
					<option value="WoMan"  <%If p1sex = "WoMan" then%>selected<%End if%>>여</option>
					</select>
					<input type="text"  id="p1_birth"  maxlength="8" placeholder="ex)19880725" width="100px;" value="<%=p1birth%>">
					<select  id="p1grade" style="width:50px;margin-top:-9px">
					<option value="A"  <%If p1grade = "A" then%>selected<%End if%>>A</option>
					<option value="B"  <%If p1grade = "B" then%>selected<%End if%>>B</option>
					<option value="C"  <%If p1grade = "C" then%>selected<%End if%>>C</option>
					<option value="D"  <%If p1grade = "D" then%>selected<%End if%>>D</option>
					<option value="E"  <%If p1grade = "E" then%>selected<%End if%>>E</option>
					<option value="F"  <%If p1grade = "F" then%>selected<%End if%>>F</option>
					</select>

					<input type="text" id="p1phone" style="width:150px;" value="<%=p1phone%>" placeholder="ex)010-0000-0000">
					<select  id="p1team1" style="width:120px;margin-top:-9px">
						<option value="">==선택==</option>
						<%
						If IsArray(arrRS) Then
							For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

								f_team = arrRS(0, ar) 
								f_TeamNm = arrRS(1, ar)
								%><option value="<%=f_team%>"  <%If f_TeamNm = p1t1 then%>selected<%End if%>><%=f_TeamNm%></option><%
							Next
						End if
						%>
					</select>

					<select  id="p1team2" style="width:120px;margin-top:-9px">
						<option value="">==선택==</option>
						<%
						If IsArray(arrRS) Then
							For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

								f_team = arrRS(0, ar) 
								f_TeamNm = arrRS(1, ar)
								%><option value="<%=f_team%>"  <%If f_TeamNm = p1t2 then%>selected<%End if%>><%=f_TeamNm%></option><%
							Next
						End if
						%>
					</select>
					</td>
					<th scope="row">&nbsp;</th>
					<td>&nbsp;</td>
				</tr>


				<%If Left(levelno,3) = "201" Or  Left(levelno,3) = "202"  then%>
				</tr>
					<th scope="row">파트너</th>
					<td id="sel_VersusGb">
					<input type="text" id="p2name" value="<%=p2name%>" width="150px;">
					
					<select name="p2sex" id="p2sex" style="width:50px;margin-top:-9px">
					<option value="Man"  <%If p2sex = "Man" then%>selected<%End if%>>남</option>
					<option value="WoMan"  <%If p2sex = "WoMan" then%>selected<%End if%>>여</option>
					</select>
					<input type="text"  id="p2_birth"  maxlength="8" placeholder="ex)19880725" width="100px;"  value="<%=p2birth%>">
					<select  id="p2grade" style="width:50px;margin-top:-9px">
					<option value="A"  <%If p2grade = "A" then%>selected<%End if%>>A</option>
					<option value="B"  <%If p2grade = "B" then%>selected<%End if%>>B</option>
					<option value="C"  <%If p2grade = "C" then%>selected<%End if%>>C</option>
					<option value="D"  <%If p2grade = "D" then%>selected<%End if%>>D</option>
					<option value="E"  <%If p2grade = "E" then%>selected<%End if%>>E</option>
					<option value="F"  <%If p2grade = "F" then%>selected<%End if%>>F</option>
					</select>

					<input type="text" id="p2phone" style="width:150px;" value="<%=p2phone%>" placeholder="ex)010-0000-0000">

					<select  id="p2team1" style="width:120px;margin-top:-9px">
						<option value="">==선택==</option>
						<%
						If IsArray(arrRS) Then
							For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

								f_team = arrRS(0, ar) 
								f_TeamNm = arrRS(1, ar)
								%><option value="<%=f_team%>"  <%If f_TeamNm = p2t1 then%>selected<%End if%>><%=f_TeamNm%></option><%
							Next
						End if
						%>
					</select>

					<select  id="p2team2" style="width:120px;margin-top:-9px">
						<option value="">==선택==</option>
						<%
						If IsArray(arrRS) Then
							For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 

								f_team = arrRS(0, ar) 
								f_TeamNm = arrRS(1, ar)
								%><option value="<%=f_team%>"  <%If f_TeamNm = p2t2 then%>selected<%End if%>><%=f_TeamNm%></option><%
							Next
						End if
						%>
					</select>
					
					</td>
					<th scope="row">&nbsp;</th>
					<td>&nbsp;</td>
				</tr>
				<%End if%>


			</tbody>
		</table>