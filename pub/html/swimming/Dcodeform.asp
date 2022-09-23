<%
If e_idx <> "" then
	PAGE_ENTERTYPE = e_EnterType
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
End if
%>
<input type= "hidden" id="mk_g0" value="E2">

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>명칭/코드</label>

						
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">



									<select id="mk_g1" class="form-control">
										<option value="" <%If  e_title = "" then%>selected<%End if%>>선택</option>
										<option value="21" <%If  e_title = "플렛포옴다이빙" then%>selected<%End if%>>플렛포옴다이빙</option>
										<option value="22" <%If  e_title = "스프링보오드1M" then%>selected<%End if%>>스프링보오드1M</option>
										<option value="23" <%If  e_title = "스프링보오드3M" then%>selected<%End if%>>스프링보오드3M</option>
										<option value="24" <%If  e_title = "싱크로다이빙3M" then%>selected<%End if%>>싱크로다이빙3M</option>
										<option value="25" <%If  e_title = "싱크로다이빙10M" then%>selected<%End if%>>싱크로다이빙10M</option>
										<option value="26" <%If  e_title = "스프링다이빙" then%>selected<%End if%>>스프링다이빙</option>
									</select>



<!-- 								  <div class="form-group"> -->
<!-- 										<input type="text" id="mk_g1" placeholder="명칭" value="<%=e_title%>" class="form-control" > -->
<!-- 								  </div> -->


							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g6" placeholder="코드" value="<%=e_codename%>" class="form-control" >
								  </div>
							</div>
						</div>

				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
					<label>다이브번호/높이</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g2" placeholder="다이브번호" value="<%=e_code1%>" class="form-control" >
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g3" placeholder="높이" value="<%=e_code2%>" class="form-control" >
								  </div>
							</div>
						</div>
				  </div>
				  
			</div>

            <div class="col-md-6">
				  <div class="form-group">
					<label>자세/난이율</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g4" placeholder="자세" value="<%=e_code3%>" class="form-control" >
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g5" placeholder="난이율" value="<%=e_code4%>" class="form-control" >
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