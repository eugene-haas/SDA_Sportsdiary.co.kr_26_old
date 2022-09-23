
					<th scope="row">파트너</th>
					<td id="sel_VersusGb">
					<input type="hidden" id="p2idx" value="<%=p2idx%>">
					<input type="text" id="p2name" value="<%=p2name%>" width="150px;">
					
					<select name="p2sex" id="p2sex" style="width:50px;margin-top:-9px" disabled>
					<option value="Man"  <%If p2sex = "Man" then%>selected<%End if%>>남</option>
					<option value="WoMan"  <%If p2sex = "WoMan" then%>selected<%End if%>>여</option>
					</select>

					<input type="text"  id="p2_birth"  maxlength="8" placeholder="ex)19880725" width="100px;"  value="<%=p2birth%>" disabled>
					<select  id="p2grade" style="width:50px;margin-top:-9px" disabled>
					<option value="A"  <%If p2grade = "A" then%>selected<%End if%>>A</option>
					<option value="B"  <%If p2grade = "B" then%>selected<%End if%>>B</option>
					<option value="C"  <%If p2grade = "C" then%>selected<%End if%>>C</option>
					<option value="D"  <%If p2grade = "D" then%>selected<%End if%>>D</option>
					<option value="E"  <%If p2grade = "E" then%>selected<%End if%>>E</option>
					<option value="F"  <%If p2grade = "F" then%>selected<%End if%>>F</option>
					</select>

					<input type="text" id="p2phone" style="width:150px;" value="<%=p2phone%>" placeholder="ex)010-0000-0000" disabled>

					<select  id="p2team1" style="width:120px;margin-top:-9px" disabled>
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

					<select  id="p2team2" style="width:120px;margin-top:-9px" disabled>
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
					
					<input type="text" id="p2rpoint"  style="width:75px;text-align:right;" value="<%=p2rpoint%>" disabled>
					</td>
					<th scope="row">&nbsp;</th>
					<td>&nbsp;</td>
