					<th scope="row">선수등록</th>
					<td id="sel_VersusGb">
					<input type="hidden" id = "t_memberidx">
					<input type="hidden" id = "t_userid">
					<input type="hidden" id="p1idx" value="<%=p1idx%>">
					<input type="text" id="p1name" value="<%=p1name%>" width="150px;" placeholder="선수명"  readonly onmousedown="mx.findMember()"><!-- 팝업창으로 처리하자 -->

					<input type="text"  id="p1_birth"  maxlength="8" placeholder="ex)19880725" style="width:100px;" value="<%=p1birth%>" readonly>
					<select id="p1sex"style="width:50px;margin-top:-10px;">
							<option value="Man" <%If LCase(p1sex) = "man" then%>selected<%End if%>>남</option>
							<option value="WoMan" <%If LCase(p1sex) = "woman" then%>selected<%End if%>>여</option>
					</select>


					<input type="text" id="p1phone" style="width:150px;" value="<%=p1phone%>" placeholder="ex)01000000000"  readonly>



					<select id="boo"style="width:100px;margin-top:-9px">
						<option value="">==선택==</option>
							<%			
							If IsArray(arrBoo) Then
								For ar = LBound(arrBoo, 2) To UBound(arrBoo, 2) 

									sex = arrBoo(0, ar) 
									PTeamGb = arrBoo(1, ar)
									PTeamGbNm = arrBoo(2, ar)
									TeamGb = arrBoo(3, ar)
									TeamGbNm = arrBoo(4, ar)
									EnterType = arrBoo(5, ar)
								
								%>
										<option value="<%=TeamGb%>" <%If belongBoo = TeamGbNm then%>selected<%End if%>><%=TeamGbNm%></option>
								<%
								i = i + 1
								Next
							End if					
							%>
					</select>


					<!-- <select  id="boo" style="width:100px;margin-top:-9px" >
					<option value="개나리부"  <%If belongBoo = "개나리부" then%>selected<%End if%>>개나리부</option>
					<option value="국화부"  <%If belongBoo = "국화부" then%>selected<%End if%>>국화부</option>
					<option value="신인부"  <%If belongBoo = "신인부" then%>selected<%End if%>>신인부</option>
					<option value="오픈부"  <%If belongBoo = "오픈부" then%>selected<%End if%>>오픈부</option>
					<option value="베테랑부"  <%If belongBoo = "베테랑부" then%>selected<%End if%>>베테랑부</option>
					</select> -->

					<input type="text" id="startyynmm" value="<%=gamestartyymm%>" placeholder="구력입력 년도 4자리 월 2자리" style="width:100px;">

					<select  id="p1grade" style="width:80px;margin-top:-9px" >
					<option value="1.0"  <%If p1grade = "1.0" then%>selected<%End if%>>1.0</option>
					<option value="1.5"  <%If p1grade = "1.5" then%>selected<%End if%>>1.5</option>
					<option value="2.0"  <%If p1grade = "2.0" then%>selected<%End if%>>2.0</option>
					<option value="2.5"  <%If p1grade = "2.5" then%>selected<%End if%>>2.5</option>
					<option value="3.0"  <%If p1grade = "3.0" then%>selected<%End if%>>3.0</option>
					</select>
					<input type="hidden" id="p1grade" value="F">



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