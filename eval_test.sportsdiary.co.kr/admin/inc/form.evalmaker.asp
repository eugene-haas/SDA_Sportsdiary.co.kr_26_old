<input type="hidden" id="tidx" value="<%=EvalTableIDX%>">
<input type="hidden" id="e_idx" value="<%=e_idx%>">

<div class="row">
		<div class="col-md-6">
			<div class="form-group">
				<label>평가범주/항목</label>
				<div class="row">
					<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
						<div class="form-group" id="mn1">
											<select id="mk_g0" class="form-control" onchange="mx.input_edit('', 1, $(this).val())">
												<%If e_EvalCateCD = "" then%><option value="" selected>= 평가범주 =</option><%End if%>
												<%
												If IsArray(arrP) Then
													For ar = LBound(arrP, 2) To UBound(arrP, 2)
														p_EvalCodeIDX = arrP(0, ar)
														p_EvalCateCD = arrP(1, ar)
														p_EvalCateNm = arrP(2, ar)
														p_EvalSubCateCD = arrP(3, ar)
														p_EvalSubCateNm = arrP(4, ar)
														p_EvalItemCD = arrP(5, ar)
														p_EvalItemNm = arrP(6, ar)
														if Cstr(p_EvalSubCateCD) = "0" then
															%><option value="<%=p_EvalCateCD%>" <%If CStr(p_EvalCateCD) = CStr(e_EvalCateCD) then%>selected<%End if%>><%=p_EvalCateNm%></option><%
														end if
													Next
												End if												
												%>
												<%if Cstr(e_menuno) = "" or e_EvalCateCD = "" then%>
												<option value="insert">[추가생성]</option>
												<%end if%>
										</select>

						</div>
					</div>
	
					<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							<div class="form-group"  id="mn2">
											<select id="mk_g1" class="form-control" onchange="mx.input_edit('', 2, $(this).val())">
												<%If e_menuno = "1" or e_EvalSubCateCD = "" then%>
												<option value="" selected>= 평가항목 =</option>
												<%End if%>
												<%
												If IsArray(arrP) Then
													For ar = LBound(arrP, 2) To UBound(arrP, 2)
														p_EvalCodeIDX = arrP(0, ar)
														p_EvalCateCD = arrP(1, ar)
														p_EvalCateNm = arrP(2, ar)
														p_EvalSubCateCD = arrP(3, ar)
														p_EvalSubCateNm = arrP(4, ar)
														p_EvalItemCD = arrP(5, ar)
														p_EvalItemNm = arrP(6, ar)
														if CStr(p_EvalCateCD) = CStr(e_EvalCateCD) and p_EvalSubCateCD > 0 and  Cstr(p_EvalItemCD) = "0" then
															%><option value="<%=p_EvalSubCateCD%>" 
															<%If e_menuno = "2" and CStr(p_EvalSubCateCD) = CStr(e_EvalSubCateCD) then%>selected<%End if%>
															><%=p_EvalSubCateNm%></option><%
														end if
													Next
												End if												
												%>
												<%if Cstr(e_menuno) = "1" then%>
												<option value="insert">[추가생성]</option>
												<%end if%>
											</select>
							</div>
					</div>
				</div>
			</div>
		</div>

		<div class="col-md-5">
			<div class="form-group">
				<label>평가지표 항목</label>
					<div class="row">
						<div class="col-md-12">
								<div class="form-group"  id="mn3">
											<select id="mk_g2" class="form-control" onchange="mx.input_edit('', 3, $(this).val())">
												<option value="">= 지표명 =</option>
												<%
												If IsArray(arrP) Then
													For ar = LBound(arrP, 2) To UBound(arrP, 2)
														p_EvalCodeIDX = arrP(0, ar)
														p_EvalCateCD = arrP(1, ar)
														p_EvalCateNm = arrP(2, ar)
														p_EvalSubCateCD = arrP(3, ar)
														p_EvalSubCateNm = arrP(4, ar)
														p_EvalItemCD = arrP(5, ar)
														p_EvalItemNm = arrP(6, ar)
														if CStr(p_EvalCateCD) = CStr(e_EvalCateCD) and CStr(p_EvalSubCateCD) = CStr(e_EvalSubCateCD) and p_EvalItemCD > 0 then
															%><option value="<%=p_EvalItemCD%>"><%=p_EvalItemNm%></option><%
														end if
													Next
												End if												
												%>
											<%if Cstr(e_menuno) = "2" then%>													
											<option value="insert">[추가생성]</option>
											<%end if%>
											</select>																				
								</div>
						</div>
					</div>
				</div>
		</div>



		<div class="col-md-4">
				<div class="form-group">
				<label>&nbsp;</label>
					<div class="row">
						<div class="col-md-12">
								<div class="form-group" style="text-align:right;">
									<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(3);" accesskey="i">지표등록<span>(I)</span></a>
									<!--
									<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(3);" accesskey="e">수정<span>(E)</span></a>
									<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
									-->
								</div>
						</div>
					</div>
				</div>
		</div>

</div>




