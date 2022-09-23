<%
If e_idx <> "" then
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
End if
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>이름</label>
						<div class="row">

							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g1" placeholder="심판명" value="<%=e_name%>" class="form-control" <%If e_idx <> ""  then%>readonly<%End if%>>
								  </div>
							</div>


							
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<select id="mk_g2" class="form-control" >
											<option value="1" <%If e_Sex = "1" then%>selected<%End if%>>남자</option>
											<option value="2" <%If e_Sex = "2" then%>selected<%End if%>>여자</option>
										</select>
								  </div>
							</div>

						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
					<label>소속(등급)/팀코드</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<div class="input-group">
											<input type="text" id="mk_g3" placeholder="소속 명" value="<%=e_teamnm%>" class="form-control">
											
											<div class="input-group-addon" style="padding:0px;">
												<select id="mk_g4"  style="height:32px;">
													<option value="1" <%If e_grade = "1" then%>selected<%End if%>>1</option>
													<option value="2" <%If e_grade = "2" then%>selected<%End if%>>2</option>
													<option value="3" <%If e_grade = "3" then%>selected<%End if%>>3</option>
													<option value="4" <%If e_grade = "4" then%>selected<%End if%>>4</option>
													<option value="5" <%If e_grade = "5" then%>selected<%End if%>>5</option>
													<option value="6" <%If e_grade = "6" then%>selected<%End if%>>6</option>
												</select>
											</div>
										</div>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g5" placeholder="소속코드" value="<%=e_team%>" class="form-control" readonly>
								  </div>
							</div>
						</div>
				  </div>


				  
			</div>





            <div class="col-md-6">
				  <div class="form-group">
					<label>전화번호</label>
						<div class="row">
							<div class="col-md-6" style="width:97%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="tel" id="mk_g6" name="mk_g6" class="form-control"  pattern="[0-9]{3}-[0-9]{2}-[0-9]{3}" value="<%=e_userphone%>">
								  </div>
							</div>
						</div>
				  </div>



            </div>

            <div class="col-md-6">
				  <div class="form-group">
					<label>&nbsp;</label>
					<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(7);" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(7);" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
							
					</div>
				  </div>


            </div>




</div>