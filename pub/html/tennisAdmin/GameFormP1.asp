
					<th scope="row">선수등록</th>
					<td id="sel_VersusGb">
					<input type="hidden" id="p1idx" value="<%=p1idx%>">
					<input type="text" id="p1name" value="<%=p1name%>" width="150px;">

					<select name="p1sex" id="p1sex" style="width:50px;margin-top:-9px" >
					<option value="Man"  <%If p1sex = "Man" then%>selected<%End if%>>남</option>
					<option value="WoMan"  <%If p1sex = "WoMan" then%>selected<%End if%>>여</option>
					</select>
					<input type="text"  id="p1_birth"  maxlength="8" placeholder="ex)19880725" width="100px;" value="<%=p1birth%>" >
					<select  id="p1grade" style="width:50px;margin-top:-9px" >
					<option value="A"  <%If p1grade = "A" then%>selected<%End if%>>A</option>
					<option value="B"  <%If p1grade = "B" then%>selected<%End if%>>B</option>
					<option value="C"  <%If p1grade = "C" then%>selected<%End if%>>C</option>
					<option value="D"  <%If p1grade = "D" then%>selected<%End if%>>D</option>
					<option value="E"  <%If p1grade = "E" then%>selected<%End if%>>E</option>
					<option value="F"  <%If p1grade = "F" then%>selected<%End if%>>F</option>
					</select>

					<input type="text" id="p1phone" style="width:150px;" value="<%=p1phone%>" placeholder="ex)010-0000-0000" >
					<select  id="p1team1" style="width:120px;margin-top:-9px" >
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
