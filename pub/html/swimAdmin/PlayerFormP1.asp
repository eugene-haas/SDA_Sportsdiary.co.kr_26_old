


				<div id="sel_VersusGb">

					<input type="hidden" id = "t_memberidx">
					<input type="hidden" id = "t_userid">
					<input type="hidden" id="p1idx" value="<%=p1idx%>">

					<div class="form-group">

						<label for="p1name" class="control-label col-sm-1">선수등록</label>
						<div class="col-sm-2">
							<input type="text" id="p1name" value="<%=p1name%>" class="form-control" placeholder="선수명" readonly onmousedown="mx.findMember()"><!-- 팝업창으로 처리하자 -->
						</div>

						<div class="col-sm-2">
							<input type="text"  id="p1_birth"  maxlength="8" class="form-control" placeholder="ex)19880725" value="<%=p1birth%>" readonly>
						</div>

						<div class="col-sm-1">
							<input type="text"  id="p1sex" class="form-control" placeholder="성별" value="<%=p1sex%>" readonly disabled>
						</div>

						<div class="col-sm-2">
							<input type="text" id="p1phone" class="form-control" value="<%=p1phone%>" placeholder="ex)01000000000"  readonly>
						</div>

						<div class="col-sm-2">

							<select id="boo" class="form-control">
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

						</div>

						<div class="col-sm-2">
							<select id="p1grade" class="form-control">
								<option value="1.0"  <%If p1grade = "1.0" then%>selected<%End if%>>1.0</option>
								<option value="1.5"  <%If p1grade = "1.5" then%>selected<%End if%>>1.5</option>
								<option value="2.0"  <%If p1grade = "2.0" then%>selected<%End if%>>2.0</option>
								<option value="2.5"  <%If p1grade = "2.5" then%>selected<%End if%>>2.5</option>
								<option value="3.0"  <%If p1grade = "3.0" then%>selected<%End if%>>3.0</option>
							</select>
							<input type="hidden" id="p1grade" value="F">
						</div>

					</div>




					<!-- <select  id="boo" style="width:100px;margin-top:-9px" >
					<option value="개나리부"  <%If belongBoo = "개나리부" then%>selected<%End if%>>개나리부</option>
					<option value="국화부"  <%If belongBoo = "국화부" then%>selected<%End if%>>국화부</option>
					<option value="신인부"  <%If belongBoo = "신인부" then%>selected<%End if%>>신인부</option>
					<option value="오픈부"  <%If belongBoo = "오픈부" then%>selected<%End if%>>오픈부</option>
					<option value="베테랑부"  <%If belongBoo = "베테랑부" then%>selected<%End if%>>베테랑부</option>
					</select> -->


					<div class="form-group">

						<label class="control-label col-sm-1">1팀</label>
						<div class="col-sm-2">
							<input type="text" id="p1team" value ="<%=p1t1%>" class="form-control">
							<input type="hidden" id="hiddenP1TeamNm" value ="<%=p1t1%>">
							<input type="hidden" id="hiddenP1Team" value ="<%=team%>">
						</div>

						<label class="control-label col-sm-1">2팀</label>
						<div class="col-sm-2">
							<input type="text" id="p2team" value ="<%=p1t2%>" class="form-control">
							<input type="hidden" id="hiddenP2TeamNm" value ="<%=p1t2%>">
							<input type="hidden" id="hiddenP2Team" value ="<%=team2%>">
						</div>


					</div>
				</div>
