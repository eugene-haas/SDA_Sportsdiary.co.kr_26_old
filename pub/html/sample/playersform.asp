<%
If e_idx <> "" then
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
End If

SQL = "Select sido,sidonm from tblSidoInfo where DelYN = 'N' "
Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rss.EOF Then
arrRS = rss.GetRows()
End If


SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2  and delYN = 'N'  "
Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rss)
If Not rsb.EOF Then
arrRSB = rsb.GetRows()
End If


%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>등록년도/선수코드</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g0" placeholder="등록년도" value="<%=e_ksportsno%>" class="form-control" <%If e_idx <> "" then%>readonly<%End if%>>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g1" placeholder="선수코드" value="<%=e_ksportsnoS%>" class="form-control" <%If e_idx <> "" then%>readonly<%End if%>>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>시도/시군구</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g8" class="form-control" >
									<%
										If IsArray(arrRS) Then 
											For ari = LBound(arrRS, 2) To UBound(arrRS, 2)
												l_sido = arrRS(0, ari)
												l_sidonm = arrRs(1,ari)
												%><option value="<%=l_sido%>" <%If CStr(e_sido) = CStr(l_sido) then%>selected<%End if%>><%=l_sidonm%></option><%
											Next
										End if
									%>
									</select>

								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g8" class="form-control" >
												<option >마포구</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
						<label>이름/생년월일</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g2" placeholder="이름" value="<%=e_UserName%>" class="form-control">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g5" placeholder="생년월일" value="<%=e_Birthday%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>핸드폰번호</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g9" class="form-control">
										<option value="D2" <%If e_CDA = "D2" then%>selected<%End if%>>010</option>
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g1" placeholder="00000000" value="<%=e_ksportsnoS%>" class="form-control" >
								  </div>
							</div>
						</div>
				  </div>

				  
			</div>





            <div class="col-md-6">
				  <div class="form-group">
					<label>소속(학년)/팀코드</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<div class="input-group">
											<input type="text" id="mk_g11" placeholder="소속 명" value="<%=e_teamnm%>" class="form-control">
											
											<div class="input-group-addon" style="padding:0px;">
												<select id="mk_g12"  style="height:32px;">
													<option value="1" >1</option>
													<option value="2">2</option>
													<option value="3">3</option>
													<option value="4">4</option>
													<option value="5">5</option>
													<option value="6">6</option>
												</select>
											</div>
										</div>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g13" placeholder="소속코드" value="<%=e_team%>" class="form-control" readonly>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<div class="input-group">


										</div>
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
					<label>성별</label>
					<div class="row">
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<select id="mk_g6" class="form-control" >
										<option value="1" <%If e_Sex = "1" then%>selected<%End if%>>남자</option>
										<option value="2" <%If e_Sex = "2" then%>selected<%End if%>>여자</option>
									</select>
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
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

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(14);" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(14);" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>



            </div>




</div>