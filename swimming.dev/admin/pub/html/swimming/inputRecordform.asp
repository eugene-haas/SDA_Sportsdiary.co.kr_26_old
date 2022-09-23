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
									
									<select id="F1" class="form-control">
									<%
											If IsArray(tmarr) Then 
												For ari = LBound(tmarr, 2) To UBound(tmarr, 2)

													tm_idx = tmarr(0, ari) 'idx
													tm_gamedate= tmarr(1, ari)
													tm_am= tmarr(2, ari)
													tm_pm= tmarr(3, ari)
													tm_selectflag= tmarr(4, ari)

													%><option value="<%=tm_gamedate%>" <%If start_gamedate = tm_gamedate then%>selected<%End if%>><%= tm_gamedate%></option><%
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
									<select id="F2" class="form-control">
										<option value="am" <%If ampm = "am" then%>selected<%End if%>>오전</option>
										<option value="pm" <%If ampm = "pm" then%>selected<%End if%>>오후</option>
									</select>

								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<a href="javascript:px.goSubmit( {'TIDX':<%=tidx%>,'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , 'inputRecord.asp');" class="btn btn-primary">검색</a>
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
								  <div class="form-group" style="text-align:right;">
										<!-- <a href="javascript:$('#swtable').printThis({importCSS: false,loadCSS: 'http://rhttp://swimming.sportsdiary.co.kr/pub/js/print/print_swim.css',header: '<h1>두번째 대회 진행</h1>'});" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
								  </div>
							</div>
						</div>
				  </div>

            </div>




</div>