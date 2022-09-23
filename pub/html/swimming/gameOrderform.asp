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
						<label>시작날짜 시간 설정</label>
						<div class="row" >
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

									<div class="input-group date">
									  <div class="input-group-addon">
										<i class="fa fa-calendar"></i>
									  </div>
									  <%'날짜가 설정되면 상태가 계속 유지 될수 있도록 해두자.%>
									  <input type="text" class="form-control pull-right" id="sdate" value="<%If last_gamedate = "" then%><%If games <> "" then%><%=games%><%else%><%=Replace(Date(),"-","/")%><%End if%><%else%><%=last_gamedate%><%End if%>">
									</div>
										

								  </div>
							</div>




						</div>
				  </div>

				  <div class="form-group"><%'tr%>

						<label>설정된 날짜 / 오전 / 오후 시작</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

										<input type="hidden"  id="mk_g4" value="<%=e_ampm%>"><!-- am, pm -->
										<a href="#" class="btn btn-success btn-flat" id="gn3" onclick="mx.setGubun('am');" accesskey="i">오전</a>
										<a href="#" class="btn btn-default btn-flat" id="gn4" onclick="mx.setGubun('pm');" accesskey="r">오후</a>


								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

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
													End if

													%><option value="<%=tm_idx%>" <%If tm_selectflag = "Y" then%>selected <%End if%>><%= tm_gamedate &" 오전: " &  tm_am & " 오후: " &tm_pm %></option><%
												Next 
											End if
									%>
									</select>


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

									  <!-- time Picker -->
									  <div class="bootstrap-timepicker">
										<div class="form-group">
										  <div class="input-group">
											<div class="input-group-addon"><i class="fa fa-clock-o"></i></div>
											<input type="text" class="form-control timepicker" id="amtm" value="<%If e_tm = "" then%><%else%><%=e_tm%><%End if%>">
										  </div>
										</div>
									  </div>	

								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">


									  <!-- time Picker -->
									  <div class="bootstrap-timepicker">
										<div class="form-group">
										  <div class="input-group">
											<div class="input-group-addon"><i class="fa fa-clock-o"></i></div>
											<input type="text" class="form-control timepicker" id="pmtm" value="<%If e_tm = "" then%><%else%><%=e_tm%><%End if%>">
										  </div>
										</div>
									  </div>	


								  </div>
							</div>
						</div>
				  </div>



			

				  <div class="form-group">


						<label>부서-세부종목</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

									<select id="mk_g3" class="form-control">
										<option value="" >개별</option>
									<%
											If IsArray(cr) Then 
												For ari = LBound(cr, 2) To UBound(cr, 2)

													k_cdc = cr(0, ari) 'idx
													k_cdcnm = cr(1, ari)
													k_cnt = cr(2,ari)

													%><option value="<%=k_cdc%>"><%= k_cdcnm%> (<%=k_cnt%>부)</option><%
												Next 
											End if
									%>
									</select>


								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

									<select id="mk_g1" class="form-control">
										<option value="" >전체</option>
									<%
											If IsArray(fr) Then 
												For ari = LBound(fr, 2) To UBound(fr, 2)
													astr = ""
													l_idx = fr(0, ari) 'idx
													l_tidx = fr(1, ari)
													l_gbidx= fr(2, ari)
													l_Sexno= fr(3, ari)
													l_ITgubun= fr(4, ari)
													l_CDA= fr(5, ari)
													l_CDANM= fr(6, ari)
													l_CDB= fr(7, ari)
													l_CDBNM= fr(8, ari)
													l_CDC= fr(9, ari)
													l_CDCNM= fr(10, ari)
													l_levelno= fr(11, ari)

													l_attcnt= fr(12, ari)
													l_gubunam =fr(13, ari)
													l_gubunpm =fr(14, ari)

													Select Case l_gubunam
													Case "1" : astr = "-예"
													Case "3" : astr = "-결"
													End Select 
													Select Case l_gubunpm
													Case "1" : astr = astr & "예"
													Case "3" : astr = astr & "결"
													End Select 

													If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) Then '??
														find_gbidx = l_gbidx
														find_cdc = l_CDC  '기준 배영200m
													End if

													%>
													<option value="<%=l_idx%>" <%If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) then%>selected <%End if%> 
													
													<%
													If astr <> "" then
													Select Case  astr
													Case "-예" :	Response.write "style=""background:orange"""
													Case "-결" :	Response.write "style=""background:#94D8F6"""
													Case Else : 	Response.write "style=""background:yellow"""
													End Select 
													End If
													%>
													>
													<%= l_CDA&l_CDBNM&" " & l_CDCNM& "&nbsp;&nbsp;("&l_attcnt&")명"%>
													<%=astr%>
													</option>
													<%
												Next 
											End if
									%>
									</select>




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
										<a href="#" class="btn btn-primary" id="setampm" onclick="mx.setAMPM(<%=tidx%>);" accesskey="i">오전/오후 등록</a>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

								  </div>
							</div>
						</div>

				  </div>



				  <div class="form-group">
						<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

										<input type="hidden"  id="mk_g2" value="<%=e_gubun%>"><!-- 1,3 -->
										<a href="#" class="btn btn-success btn-flat" id="gn1" onclick="mx.setGubun(1);" accesskey="i">예선</a>
										<a href="#" class="btn btn-default btn-flat" id="gn2" onclick="mx.setGubun(3);" accesskey="r">결승</a>

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



				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(<%=tidx%>);" accesskey="i">등록<span>(I)</span></a>
										<!-- <a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a> -->
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm(<%=tidx%>);" accesskey="r">현재날짜 설정 초기화<span>(R)</span></a>

								  </div>
							</div>
						</div>
				  </div>

            </div>




</div>