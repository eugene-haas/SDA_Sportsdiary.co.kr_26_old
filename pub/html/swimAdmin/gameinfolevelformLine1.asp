


					<div id="sel_GroupGameGb" class="form-group">
						<label class="control-label col-sm-1">구분/요강선택</label>
						<div class="col-sm-2">
							<select id="GroupGameGb" onchange="mx.find1()" class="form-control">
								<option value="">==선택==</option>
								<option value="tn001001" <%If fstr="tn001001" then%>selected<%End if%>>개인전</option>
							</select>
						</div>

						<%If fstr <> "" then%>
						<div class="col-sm-2">
							<select id="TeamGb" onchange="mx.find2()" class="form-control">
								<option value="">==선택==</option>
								<%
								If IsArray(arrRS) Then
									For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

										sex = arrRS(0, ar)
										PTeamGb = arrRS(1, ar)
										PTeamGbNm = arrRS(2, ar)
										TeamGb = arrRS(3, ar)
										TeamGbNm = arrRS(4, ar)
										EnterType = arrRS(5, ar)

									%>
											<option value="<%=TeamGb%>" <%If fstr2 = TeamGb then%>selected<%End if%>><%=TeamGbNm%></option>
									<%
									i = i + 1
									Next
								End if
								%>
								<option value="insert">[추가생성]</option>
							</select>
						</div>
						<%End if%>

						<%If fstr2 <> "" Then%>
						<div class="col-sm-2">
							<select id="LevelGb" onchange="mx.SelectLevelGb()" class="form-control">
								<option value="">==선택==</option>
									<%
									If IsArray(arrRS2) Then
										For ar = LBound(arrRS2, 2) To UBound(arrRS2, 2)
											Level = arrRS2(0, ar)
											LevelNm = arrRS2(1, ar)
											Orderby = arrRS2(2, ar)
										%>
												<option value="<%=Level%>" <%If CStr(Level) = flevel then%>selected<%End if%>><%=LevelNm%></option>
										<%
										i = i + 1
										Next
									End if
									%>
									<option value="insert">[추가생성]</option>
							</select>

							<input type="hidden" id="transsmy"   value="0" >
						</div>
						<%End if%>
					</div>

					<div id="sel_TeamGb">
						<div class="form-group">

							<label class="control-label col-sm-1">마감팀수</label>
							<div class="col-sm-2">
								<div class="input-group">
									<input type="number" id="entrycnt" class="form-control text-right" value="<%=entrycnt%>">
									<span class="input-group-addon">팀</span>
								</div>
							</div>
							<input type="hidden"  id="StartSC"  value="0">

						</div>

						<div class="form-group">
							<label class="control-label col-sm-1">참가비/기금</label>
							<div class="col-sm-2">
								<input type="number" id="fee"  class="form-control" value="<%If fee = "" then%>0<%else%><%=fee%><%End if%>" min="0" max="1000000">
							</div>
							<div class="col-sm-2">
								<input type="number" id="fund" class="form-control" value="<%If fund = "" then%>0<%else%><%=fund%><%End if%>" min="0" max="1000000">
							</div>

						</div>

					</div>







					<!-- <th scope="row">구분/요강선택</th> -->
						<!-- <td id="sel_GroupGameGb">
						<select id="GroupGameGb" onchange="mx.find1()" style="width:80px">
						<option value="">==선택==</option>
						<option value="tn001001" <%If fstr="tn001001" then%>selected<%End if%>>개인전</option>
						</select> -->
						<!-- <option value="tn001002" <%If fstr="tn001002" then%>selected<%End if%>>단체전</option> -->

						<!-- <%If fstr <> "" then%>
							<select id="TeamGb" onchange="mx.find2()" style="width:90px;">
							<option value="">==선택==</option>
								<%
								If IsArray(arrRS) Then
									For ar = LBound(arrRS, 2) To UBound(arrRS, 2)

										sex = arrRS(0, ar)
										PTeamGb = arrRS(1, ar)
										PTeamGbNm = arrRS(2, ar)
										TeamGb = arrRS(3, ar)
										TeamGbNm = arrRS(4, ar)
										EnterType = arrRS(5, ar)

									%>
											<option value="<%=TeamGb%>" <%If fstr2 = TeamGb then%>selected<%End if%>><%=TeamGbNm%></option>
									<%
									i = i + 1
									Next
								End if
								%>
								<option value="insert">[추가생성]</option>
							</select>
						<%End if%> -->

						<!-- <%If fstr2 <> "" Then%>
						<select id="LevelGb" style="width:90px;"  onchange="mx.SelectLevelGb()">
							<option value="">==선택==</option>
								<%
								If IsArray(arrRS2) Then
									For ar = LBound(arrRS2, 2) To UBound(arrRS2, 2)
										Level = arrRS2(0, ar)
										LevelNm = arrRS2(1, ar)
										Orderby = arrRS2(2, ar)
									%>
											<option value="<%=Level%>" <%If CStr(Level) = flevel then%>selected<%End if%>><%=LevelNm%></option>
									<%
									i = i + 1
									Next
								End if
								%>
								<option value="insert">[추가생성]</option>
						</select> -->

						<!-- <label class="switch" style="margin-bottom:-8px;" title="선택상태 변경요강, 풀면 일반요강"> -->
						<!-- <input type="checkbox" id="transsmy"   value="1" <%If chk1= "Y" then%>checked<%End if%> > --><!-- 변형요강 -->
						<!-- <input type="hidden" id="transsmy"   value="0" > -->
						<!-- <span class="slider round"></span>
						</label> -->

						<!-- <%End if%>
					</td> -->

					<!-- <th scope="row">마감팀수</th>
					<td id="sel_TeamGb">
					<input type="number" id="entrycnt" style="width:75px;height:30px;margin-bottom:0px;text-align:right;" value="<%=entrycnt%>">팀
					<input type="hidden"  id="StartSC"  value="0">
					</td> -->

					<!-- <th scope="row">참가비/기금 -->
						<!-- 시작점수 --><!-- 신청/수정/삭제 --><!-- 코트/예선/본선 -->
					<!-- </th> -->
					<!-- <td>
					<input type="number" id="fee" style="width:75px;height:30px;margin-bottom:0px;text-align:right;" value="<%If fee = "" then%>0<%else%><%=fee%><%End if%>" min="0" max="1000000">
					<input type="number" id="fund" style="width:75px;height:30px;margin-bottom:0px;text-align:right;" value="<%If fund = "" then%>0<%else%><%=fund%><%End if%>" min="0" max="1000000">
					</td> -->
