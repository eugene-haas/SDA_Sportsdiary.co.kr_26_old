<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If

	If e_gubun = "" Then
		e_gubun = 1
		e_ampm = "am"
	End if
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  


				  <div class="form-group">
						<label>경기일자</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

									<div class="input-group date">
									  <div class="input-group-addon">
										<i class="fa fa-calendar"></i>
									  </div>
									  <%'날짜가 설정되면 상태가 계속 유지 될수 있도록 해두자.%>
									
									<select id="mk_g0" class="form-control"  onchange="mx.setSelectFlag(<%=tidx%>)">
									<%
											If IsArray(tmarr) Then 
												For ari = LBound(tmarr, 2) To UBound(tmarr, 2)

													tm_idx = tmarr(0, ari) 'idx
													tm_gamedate= tmarr(1, ari)
													tm_am= tmarr(2, ari)
													tm_pm= tmarr(3, ari)
													tm_selectflag= tmarr(4, ari)

													If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) Then
														find_gbidx = l_gbidx
														find_cdc = l_CDC  '기준 배영200m
													End If
													
													If tm_selectflag = "Y"  Then
														select_gamedate = tm_gamedate
													End if

													%><option value="<%=tm_idx%>" <%If tm_selectflag = "Y" then%>selected<%End if%>><%= tm_gamedate%></option><%
												Next 
											End if
									%>
									</select>

									</div>
										

								  </div>
							</div>




						</div>
				  </div>


            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
 			  

				  <div class="form-group">
						<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">


								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

								  </div>
							</div>
						</div>
				  </div>
			

			</div>


            <div class="col-md-6">
				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

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
								  <div class="form-group">
										&nbsp;
								  </div>
							</div>
						</div>
				  </div>

            </div>




</div>