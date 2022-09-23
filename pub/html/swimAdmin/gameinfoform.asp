<%If idx <> "" then%>
	<input type="hidden" id="idx" value="<%=idx%>">
<%End if%>


					<div class="form-group">

						<label class="col-sm-1 control-label">대회명</label>
						<div class="col-sm-2">
							<input type="text" name="GameTitleName" id="GameTitleName" class="form-control" placeholder="대회명을 입력해주세요." value="<%=GameTitleName%>" >
						</div>

						<label class="col-sm-1 control-label">그룹/등급</label>
						<div class="col-sm-2">
							<select  id="code_grade" class="form-control">
								<option value="">==선택==</option>
									<%	'titleCode,titleGrade,hostTitle
									If IsArray(arrRSG) Then
										For ar = LBound(arrRSG, 2) To UBound(arrRSG, 2)
											g_titleCode = arrRSG(0, ar)
											g_titleGrade = arrRSG(1, ar)
											g_hostTitle = arrRSG(2, ar)
											Select Case g_titleGrade
											Case "1" : t_titleGrade = "SA"
											Case "2" : t_titleGrade = "GA"
											Case "3" : t_titleGrade = "A"
											Case "4" : t_titleGrade = "B"
											Case "5" : t_titleGrade = "C"
											Case "6" : t_titleGrade = "단체전"
											Case "7" : t_titleGrade = "E"
											Case "8" : t_titleGrade = "비노출"
											End Select

											%><option value="<%=g_titleCode%>_<%=g_titleGrade%>"  <%If g_titleCode = titlecode then%>selected<%End if%>><%=g_hostTitle%>[<%=t_titleGrade%>]</option><%
										Next
									End if
									%>
							</select>
						</div>


						<label class="col-sm-1 control-label">주최/장소</label>
						<div class="col-sm-2">
							<div class="input-group">


								<select id="HostCode" class="form-control form-control-half">
									<option value="">==선택==</option>
									<%
									If IsArray(arrRS) Then
										For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
											h_hostname = arrRS(0, ar)
											%><option value="<%=h_hostname%>" <%If h_hostname = hostname then%>selected<%End if%>><%=h_hostname%></option><%
										Next
									End if
									%>
								</select>
								<input type="text" id="GameArea" class="form-control form-control-half" placeholder="경기장소를 입력해주세요." value="<%=GameArea%>" >
								
							</div>
						</div>

						<label class="col-sm-1 control-label">대회구분</label>
						<div class="col-sm-2">
							<select id="entertype" class="form-control">
								<option value="A" <%If EnterType ="A" then%>selected<%End if%>> SD</option>
							</select>
							<!-- <option value="E" <%If EnterType ="E" then%>selected<%End if%>>엘리트</option> -->
						</div>

					</div>

					<div class="form-group">

						<label class="col-sm-1 control-label">시작일</label>
						<div class="col-sm-2">
							<input type="text" id="GameS" value="<%=GameS%>" class="form-control">
						</div>

						<label class="col-sm-1 control-label">종료일</label>
						<div class="col-sm-2">
							<input type="text" id="GameE"  value="<%=GameE%>"  class="form-control">
						</div>

						<label class="col-sm-1 control-label">참가신청노출</label>
						<div class="col-sm-2">
							<select id="ViewYN" class="form-control">
								<option value="N" <%If ViewYN ="N" then%>selected<%End if%>>미노출</option>
								<option value="Y" <%If ViewYN ="Y" then%>selected<%End if%>>노출</option>
							</select>
						</div>

						<label class="col-sm-1 control-label">대회달력노출</label>
						<div class="col-sm-2">
							<select  id="ViewState" class="form-control">
								<option value="N" <%If ViewState ="N" then%>selected<%End if%>>미노출</option>
								<option value="Y" <%If ViewState ="Y" then%>selected<%End if%>>노출</option>
							</select>
						</div>

					</div>

					<div class="form-group">

						<label class="col-sm-1 control-label">대진표노출</label>
						<div class="col-sm-2">
							<select  id="MatchYN"  class="form-control">
								<option value="0" <%If MatchYN ="0" then%>selected<%End if%>>미노출 --0</option>
								<option value="3" <%If MatchYN ="3" then%>selected<%End if%>>예선노출--1</option>
								<option value="4" <%If MatchYN ="4" then%>selected<%End if%>>예선마감--2</option>
								<option value="5" <%If MatchYN ="5" then%>selected<%End if%>>본선노출--3</option>
								<option value="6" <%If MatchYN ="6" then%>selected<%End if%>>본선마감--4</option>
								<option value="7" <%If MatchYN ="7" then%>selected<%End if%>>결과노출--5</option>
								<!-- <option value="999" <%If MatchYN ="999" then%>selected<%End if%> style="color:red;">대회종료 - 데이터보호</option> -->
							</select>
						</div>

						<label class="col-sm-1 control-label">사은품</label>
						<div class="col-sm-2">
							<select  id="bigo" class="form-control">
							  <option value="">=상품명=</option>
								  <%
								  If IsArray(arrG) Then
									  For ar = LBound(arrG, 2) To UBound(arrG, 2)
										  gpnm = arrG(0, ar)
										  %><option value="<%=gpnm%>" <%If gpnm = gameprize then%>selected<%End if%>><%=gpnm%></option><%
									  i = i + 1
									  Next
								  End if
								  %>
							</select>
						</div>

						<label class="col-sm-1 control-label">참가신청체크</label>
						<div class="col-sm-2">
								<select  id="chkrange"  class="form-control">
									<option value="0" <%If chkrange ="0" then%>selected<%End if%>>대회전체</option>
									<option value="1" <%If chkrange ="1" then%>selected<%End if%>>부별체크</option>
								</select>
							</div>

					</div>

        <div class="btn-group flr" role="group" aria-label="...">
					<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
					<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
					<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
        </div>





			<div style="display:none">
				<table>
				<th scope="row">접수시작일</th>
				<td>
					<div class="ymd-list">
						<span id="sel_GameRcvSMonth"><input type="text" id="GameRcvS" value="<%=date%>"></span>
						<!-- <span id="sel_GameRcvSMonth"><input type="text" id="GameRcvS" value="<%=GameRcvDateS%>"></span> -->
					</div>
				</td>
				<th scope="row">접수종료일</th>
				<td>
					<div class="ymd-list">
						<span id="sel_GameRcvEYear"><input type="text" id="GameRcvE"  value="<%=date%>"></span>
						<!-- <span id="sel_GameRcvEYear"><input type="text" id="GameRcvE"  value="<%=GameRcvDateE%>"></span> -->
				</div></td>
				<th scope="row">타이/듀스</th>
				<td>
					<select id="tie">
						<option value="5" selected>5점</option>
					</select>
					<select id="deuce">
						<option value="1" selected>노에드</option>
					</select>

				<!-- 언젠가 쓸꺼같다 지우지 말자  -->
				<!-- <select id="tie" style="width:40%;">
					<option value="5" <%If tie ="5" then%>selected<%End if%>>5점</option>
					<option value="6" <%If tie ="6" then%>selected<%End if%>>6점</option>
				</select>
				<select id="deuce"  style="width:40%;">
					<option value="1" <%If duc ="1" then%>selected<%End if%>>노에드</option>
					<option value="0" <%If duc ="0" then%>selected<%End if%>>듀스</option>
					<option value="2" <%If duc ="2" then%>selected<%End if%>>원듀스노에드</option>
				</select> -->
				</td>
				</table>
			</div>
