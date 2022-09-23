<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>구분/체전</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

									<select id="mk_g15" class="form-control" onchange="mx.setBea()">
										<option value="01" <%If e_GameType = "01" then%>selected<%End if%>>정부명칭대회</option>
										<option value="02"  <%If e_GameType = "02" then%>selected<%End if%>>기타승인대회</option>
										<option value="09" <%If e_GameType = "09" then%>selected<%End if%>>국제</option>
									</select>									
									
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group" id="bea">
									
									<select id="mk_g0" class="form-control">
										<%Select Case e_GameType%>
										<%Case "","01"%>
											<option value="01" <%If e_gubun = "" Or e_gubun = "01" then%>selected<%End if%>>대통령배</option>
											<option value="02" <%If e_gubun = "02" then%>selected<%End if%>>총리배</option>
											<option value="03" <%If  e_gubun = "03" then%>selected<%End if%>>장관배</option>
										<%Case "02"%>
											<option value="04" <%If  e_gubun = "04" then%>selected<%End if%>>대한체육회장배</option>
											<option value="09" <%If  e_gubun = "09" then%>selected<%End if%>>기타</option>
										<%Case "03"%>
											<option value="11" <%If  e_gubun = "11" then%>selected<%End if%>>올림픽</option>
											<option value="12" <%If  e_gubun = "12" then%>selected<%End if%>>아시아경기대회</option>
											<option value="19" <%If  e_gubun = "19" then%>selected<%End if%>>기타(국제)</option>
										<%End Select%>
										
										<!-- <option value="K" <%If e_gubun = "" Or e_gubun = "K" then%>selected<%End if%>>국내</option>
										<option value="F" <%If e_gubun = "F" then%>selected<%End if%>>국제</option> -->
									</select>


								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>대회명</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<input type="text" name="mk_g7" id="mk_g7" class="form-control" placeholder="대회명을 입력해주세요." value="<%=e_GameTitleName%>" >
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>대회기간</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">

									<div class="form-group">
										<div class="input-group">
										<div class="input-group-addon">
										<i class="fa fa-calendar"></i>
										</div>
										<input type="text" class="form-control pull-right" id="mk_g13" value="<%=e_GameS%><%=e_GameE%>">
										</div>
									</div>

							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>팀당 2명 이내 제한/참가가능 종목수</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

										<%If e_teamLimit = "" then%><%e_teamLimit = "N"%><%End if%>
										<input type="hidden" id="mk_g21" value="<%=e_teamLimit%>">

										<button  style="margin-right:-10px;" id="b1" type="button" class="btn btn-<%If e_teamLimit = "Y" then%>primary<%else%>default<%End if%>"  onclick="$('#mk_g21').val('Y');$(this).attr('class','btn btn-primary');$('#b2').attr('class','btn btn-default');">ON</button>										

										<button type="button" id="b2" class="btn btn-<%If e_teamLimit = "N" then%>primary<%else%>default<%End if%>"  onclick="$('#mk_g21').val('N');$(this).attr('class','btn btn-primary');$('#b1').attr('class','btn btn-default');">OFF</button>

								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g22" class="form-control" >
										<option value="20" <%If CStr(e_attgameCnt) = "20" then%>selected<%End if%>>제한없음</option>
										<%For i = 0 To 5%>
										<option value="<%=i%>" <%If CStr(e_attgameCnt) = CStr(i) then%>selected<%End if%>><%=i%></option>
										<%Next%>
									</select>
								  </div>
							</div>
						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
						<label>장소</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<input type="text" id="mk_g2" placeholder="경기장소를 입력해주세요." value="<%=e_GameArea%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>대회요강URL</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<input type="text" id="mk_g8" placeholder="대회요강 주소를 입력해주십시오" value="<%=e_summaryURL%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>신청기간</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">

									<div class="form-group">
										<div class="input-group">
											<div class="input-group-addon">
											<i class="fa fa-clock-o"></i>
											</div>
											<input type="text" class="form-control pull-right" id="mk_g14" value="<%=e_atts%><%=e_atte%>">
										</div>
									</div>

							</div>
						</div>
				  </div>		
				  
				  <div class="form-group">
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
								  </div>
							</div>
						</div>
				  </div>
			
			</div>





            <div class="col-md-6">
				  <div class="form-group">
					<label>주최/주관</label>
					<div class="row">
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
								<input type="text" id="mk_g3" placeholder="주최 입력" value="<%=e_hostname%>" class="form-control">
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
								<input type="text" id="mk_g4" placeholder="주관 입력" value="<%=e_subjectnm%>" class="form-control">
							  </div>
						</div>
					</div>
				  </div>

				  <%
				  gamesccodearr = array("01","02","03","04","11","12","13")
				  gamescalearr = array("300명이하","700명이하"	,"1000명이상","2000명이상","50개팀이하","50~100개팀","100개팀이상")%>
				  <div class="form-group">
					<label>대회규모/사용레인</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g9" class="form-control">
										<%For i = 0 To ubound(gamescalearr)%>
										<option value="<%=gamesccodearr(i)%>"  <%If e_gameSize = gamescalearr(i) then%>selected<%End if%>><%=gamescalearr(i)%></option>
										<%next%>
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g10" class="form-control" >
										<%For i = 8 To 10%>
										<option value="<%=i%>" <%If CStr(e_ranecnt) = CStr(i) then%>selected<%End if%>><%=i%></option>
										<%next%>
									</select>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>체전/구분</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g1" class="form-control" >
										<option value="N" <%If e_kgame = "" Or e_kgame = "N" then%>selected<%End if%>>비체전</option>
										<option value="G" <%If e_kgame = "G" then%>selected<%End if%>>전국체전</option>
										<option value="Y" <%If e_kgame = "Y" then%>selected<%End if%>>소년체전</option>
										<option value="W" <%If e_kgame = "W" then%>selected<%End if%>>동계체전</option>
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g16" class="form-control" >
										<option value="01" <%If e_EnterType = "01" then%>selected<%End if%>>전문체육</option>
										<option value="02" <%If e_EnterType = "02" then%>selected<%End if%>>생활체육</option>
										<option value="03" <%If e_EnterType = "03" then%>selected<%End if%>>통합</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

								  </div>
							</div>
						</div>
				  </div>


            </div>

            <div class="col-md-6">
				  <div class="form-group">
					<label>후원/협찬</label>
					<div class="row">
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
								<input type="text" id="mk_g5" placeholder="후원 입력" value="<%=e_afternm%>" class="form-control">
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
								<input type="text" id="mk_g6" placeholder="협찬 입력" value="<%=e_sponnm%>" class="form-control">
							  </div>
						</div>
					</div>
				  </div>

				  <div class="form-group">
					<label>

					<%
					SQL = "select titlecode ,max(titlename) from tblrecord group by titlecode "
					Set rx = db.ExecSQLReturnRS(SQL , null, ConStr)
					%>
					<a href="javascript:mx.gameCodeWindow('<%
					Do Until rx.eof
							Response.write rx(0) & " : " & rx(1) & "<br>"
					rx.movenext
					Loop
					Response.write "<span style=\'color:red\'>생활체육: LIFE + 001 번부터 시작<br>"
					%>')" class="btn btn-default">대회코드</a>/참가비</label>
					
					
<!--  					<a href="javascript:alert('  -->
<!-- 					<% -->
<!-- '					SQL = "select titlecode ,max(titlename) from tblrecord group by titlecode " -->
<!-- '					Set rx = db.ExecSQLReturnRS(SQL , null, ConStr) -->
<!-- ' -->
<!-- '					Do Until rx.eof -->
<!-- '						Response.write rx(0) & " : " & rx(1) & "\n" -->
<!-- '					rx.movenext -->
<!-- '					loop -->
<!-- 					%> -->
<!-- 					 -->
<!-- 					')" class="btn btn-default">대회코드</a>/참가비</label> -->
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g11" placeholder="대회코드" value="<%=e_titlecode%>" class="form-control">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g12" placeholder="참가비" value="<%=e_attmoney%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9]/g,'');">
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>신청방식</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

									<label class="control-label"><input type="checkbox" id="mk_g17"  value="Y" <%If e_attTypeA = "Y" then%>checked<%End if%>>&nbsp;개인</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="mk_g18"  value="Y"  <%If e_attTypeB = "Y" then%>checked<%End if%>>&nbsp;팀</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="mk_g19"  value="Y"  <%If e_attTypeC = "Y" then%>checked<%End if%>>&nbsp;시도신청</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="mk_g20"  value="Y"  <%If e_attTypeD = "Y" then%>checked<%End if%>>&nbsp;시도승인</label>

								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>

            </div>




</div>