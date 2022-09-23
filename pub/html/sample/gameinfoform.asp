<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
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

				  </div>

				  <div class="form-group">

				  </div>


            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">

				  <div class="form-group">
					<label>선택</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="mk_g1" class="form-control" >
										<option value="N" <%If e_kgame = "" Or e_kgame = "N" then%>selected<%End if%>>T4</option>
										<option value="G" <%If e_kgame = "G" then%>selected<%End if%>>전국체전</option>
										<option value="Y" <%If e_kgame = "Y" then%>selected<%End if%>>소년체전</option>
										<option value="W" <%If e_kgame = "W" then%>selected<%End if%>>동계체전</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">

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
					<label>구분</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="mk_g1" class="form-control" >
										<option value="N" <%If e_kgame = "" Or e_kgame = "N" then%>selected<%End if%>>생활체육</option>
										<option value="G" <%If e_kgame = "G" then%>selected<%End if%>>전문체육</option>
										<option value="Y" <%If e_kgame = "Y" then%>selected<%End if%>>소년체전</option>
										<option value="W" <%If e_kgame = "W" then%>selected<%End if%>>동계체전</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">

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

				  </div>

				  <div class="form-group">

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