
					<th scope="row">선수등록</th>
					<td id="sel_VersusGb">
					<input type="hidden" id="p1idx" value="<%=p1idx%>">
					<input type="text" id="p1name" value="<%=p1name%>" width="150px;">


					<select  id="boo" style="width:100px;margin-top:-9px" >
					<option value="개나리부"  <%If belongBoo = "개나리부" then%>selected<%End if%>>개나리부</option>
					<option value="국화부"  <%If belongBoo = "국화부" then%>selected<%End if%>>국화부</option>
					<option value="신인부"  <%If belongBoo = "신인부" then%>selected<%End if%>>신인부</option>
					<option value="오픈부"  <%If belongBoo = "오픈부" then%>selected<%End if%>>오픈부</option>
					<option value="베테랑부"  <%If belongBoo = "베테랑부" then%>selected<%End if%>>베테랑부</option>
					</select>

					<select name="p1sex" id="p1sex" style="width:50px;margin-top:-9px" >
					<option value="Man"  <%If p1sex = "Man" then%>selected<%End if%>>남</option>
					<option value="WoMan"  <%If p1sex = "WoMan" then%>selected<%End if%>>여</option>
					</select>
					<input type="text"  id="p1_birth"  maxlength="8" placeholder="ex)19880725" style="width:100px;" value="<%=p1birth%>" >

					<!-- <select  id="p1grade" style="width:50px;margin-top:-9px" >
					<option value="A"  <%If p1grade = "A" then%>selected<%End if%>>A</option>
					<option value="B"  <%If p1grade = "B" then%>selected<%End if%>>B</option>
					<option value="C"  <%If p1grade = "C" then%>selected<%End if%>>C</option>
					<option value="D"  <%If p1grade = "D" then%>selected<%End if%>>D</option>
					<option value="E"  <%If p1grade = "E" then%>selected<%End if%>>E</option>
					<option value="F"  <%If p1grade = "F" then%>selected<%End if%>>F</option>
					</select> -->
					<input type="hidden" id="p1grade" value="F">

					<input type="text" id="p1phone" style="width:150px;" value="<%=p1phone%>" placeholder="ex)01000000000" >

					1팀
					<input type="text" id="p1team" style="width:150px;" width="150px;" value ="<%=p1t1%>">
					<input type="hidden" id="hiddenP1TeamNm" style="width:150px;" width="150px;" value ="<%=p1t1%>">
					<input type="hidden" id="hiddenP1Team" style="width:150px;" width="150px;" value ="<%=team%>">

					2팀
					<input type="text" id="p2team" style="width:150px;" width="150px;" value ="<%=p1t2%>">
					<input type="hidden" id="hiddenP2TeamNm" style="width:150px;" width="150px;" value ="<%=p1t2%>">
					<input type="hidden" id="hiddenP2Team" style="width:150px;" width="150px;" value ="<%=team2%>">
					
					<!-- </td>
					<th scope="row">오픈부랭킹저장</th>
					<td>

					<select  id="openboo" style="width:100px;margin-top:-9px" >
					<option value="개나리부"  <%If openboornk = "개나리부" then%>selected<%End if%>>개나리부</option>
					<option value="국화부"  <%If openboornk = "국화부" then%>selected<%End if%>>국화부</option>
					<option value="신인부"  <%If openboornk = "신인부" then%>selected<%End if%>>신인부</option>
					<option value="오픈부"  <%If openboornk = "오픈부" then%>selected<%End if%>>오픈부</option>
					<option value="베테랑부"  <%If openboornk = "베테랑부" then%>selected<%End if%>>베테랑부</option>
					</select>					
					
					</td>
 -->