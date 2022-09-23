
<input type="hidden" id="EvalTableIDX" value="<%=EvalTableIDX%>">
<input type="hidden" id="e_idx" value="<%=e_idx%>">

<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<label>종목단체</label>
				<div class="row">
					<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
						<div class="form-group">

											<select id="mk_g0" class="form-control">
												<option value="" <%If e_EvalgroupCD = "" then%>selected<%End if%>>==평가군==</option>
														<%
															If IsArray(arrRSP) Then 
																For ari = LBound(arrRSP, 2) To UBound(arrRSP, 2)
																	l_kindnm = arrRSP(2, ari) 
																	l_codecd = arrRSP(3, ari)
																	l_codenm = arrRSP(4,ari)
																	if l_kindnm = "평가군" then
																	%><option value="<%=l_codecd%>" <%If CStr(e_EvalgroupCD) = CStr(l_codecd) then%>selected<%End if%>><%=l_codenm%></option><%
																	end if
																Next
															End if
														%>
											</select>

						</div>
					</div>
					<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							<div class="form-group">
											<select id="mk_g1" class="form-control">
												<option value="" <%If e_MemberGroupCD = "" then%>selected<%End if%>>==회원군==</option>
														<%
															If IsArray(arrRSP) Then 
																For ari = LBound(arrRSP, 2) To UBound(arrRSP, 2)
																	l_kindnm = arrRSP(2, ari) 
																	l_codecd = arrRSP(3, ari)
																	l_codenm = arrRSP(4,ari)
																	if l_kindnm = "회원군" then
																	%><option value="<%=l_codecd%>" <%If CStr(e_MemberGroupCD) = CStr(l_codecd) then%>selected<%End if%>><%=l_codenm%></option><%
																	end if
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
				<label>종목단체</label>
					<div class="row">
						<div class="col-md-6" style="width:100%;padding-left:10px;padding-right:0px;">
								<div class="form-group">
										<input type="text" id="mk_g2" placeholder="종목단체" value="<%=e_associationnm%>" class="form-control">
								</div>
						</div>
					</div>
				</div>
		</div>

		<div class="col-md-6">
		</div>

		<div class="col-md-6">
				<div class="form-group">
				<label>&nbsp;</label>
					<div class="row">
						<div class="col-md-6" style="width:100%;">
								<div class="form-group" style="text-align:right;">
									<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(3);" accesskey="i">등록<span>(I)</span></a>
									<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(3);" accesskey="e">수정<span>(E)</span></a>
									<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
								</div>
						</div>
					</div>
				</div>
		</div>

</div>




