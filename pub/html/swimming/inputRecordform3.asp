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
						<label>아티스틱 검색</label>
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
										<option value="01" <%If  F2 = "01" then%>selected<%End if%>>솔로(Solo)</option>
										<option value="02" <%If  F2 = "02" then%>selected<%End if%>>듀엣(Duet)</option>
										<option value="03" <%If  F2 = "03" then%>selected<%End if%>>팀(Team)</option>
										<option value="04" <%If  F2 = "04" then%>selected<%End if%>>테크니컬 솔로</option>
										<option value="05" <%If  F2 = "05" then%>selected<%End if%>>프리 솔로</option>
										<option value="06" <%If  F2 = "06" then%>selected<%End if%>>테크니컬 듀엣</option>
										<option value="07" <%If  F2 = "07" then%>selected<%End if%>>프리 듀엣</option>
										<option value="08" <%If  F2 = "08" then%>selected<%End if%>>피겨(Figures)</option>
										<option value="09" <%If  F2 = "09" then%>selected<%End if%>>솔로(솔로/듀엣)</option>
										<option value="10" <%If  F2 = "10" then%>selected<%End if%>>솔로(팀)</option>
										<option value="11" <%If  F2 = "11" then%>selected<%End if%>>프리 팀</option>
										<option value="12" <%If  F2 = "12" then%>selected<%End if%>>테크니컬 팀</option>
										<option value="13" <%If  F2 = "13" then%>selected<%End if%>>프리 콤비네이션</option>
									</select>







								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<a href="javascript:px.goSubmit( {'TIDX':<%=tidx%>,'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , 'inputRecord3.asp');" class="btn btn-primary">검색</a>
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
										<a href="javascript:mx.setGameDate( $('#gamedate').val(), '<%=tidx%>','A');" class="btn btn-primary">대회날짜 등록</a>
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