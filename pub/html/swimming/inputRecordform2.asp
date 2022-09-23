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
						<label>다이빙 검색</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

									<div class="input-group date">
									  <div class="input-group-addon">
										<i class="fa  fa-user"></i>
									  </div>
										<select id="F1" class="form-control">
												<option value="" <%If  F1 = "" then%>selected<%End if%>>전체</option>
												<option value="1" <%If  F1 = "1" then%>selected<%End if%>>남자</option>
												<option value="2" <%If F1 = "2" then%>selected<%End if%>>여자</option>
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
								  <div class="form-group" id = "cdcnmlist">
									<select id="F2" class="form-control">
										<option value="" <%If  F2 = "" then%>selected<%End if%>>전체</option>
										<option value="21" <%If  F2 = "21" then%>selected<%End if%>>플렛포옴다이빙</option>
										<option value="22" <%If  F2 = "22" then%>selected<%End if%>>스프링보오드1M</option>
										<option value="23" <%If  F2 = "23" then%>selected<%End if%>>스프링보오드3M</option>
										<option value="24" <%If  F2 = "24" then%>selected<%End if%>>싱크로다이빙3M</option>
										<option value="25" <%If  F2 = "25" then%>selected<%End if%>>싱크로다이빙10M</option>
										<option value="26" <%If  F2 = "26" then%>selected<%End if%>>스프링다이빙</option>
									</select>

								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<a href="javascript:px.goSubmit( {'TIDX':<%=tidx%>,'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , 'inputRecord2.asp');" class="btn btn-primary">검색</a>
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
										<input type="text" id="gamedate" placeholder="대회날짜"  class="form-control" value="<%=gamedate%>">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<a href="javascript:mx.setGameDate( $('#gamedate').val(), '<%=tidx%>','D');" class="btn btn-primary">대회날짜 등록</a>
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