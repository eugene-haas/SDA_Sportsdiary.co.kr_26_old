				
					<div class="form-group" >
						<label class="col-sm-1 bg-gray btn" style="width:60px;">년월</label>
						
						<div class="col-sm-2">
							<div class="input-group">
									<div class="col-md-6" style="width:50%;padding-left:10px;padding-right:0px;">

											<select id="F1_0" class="form-control">
											<%For fny =year(date) To year(date)-4 Step -1%>
											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>><%=fny%></option>
											<%Next%>
											</select>
									</div>

									<div class="col-md-6" style="width:50%;padding-left:10px;padding-right:0px;">

											<select id="F1_1" class="form-control">
											<option value="">전체</option>							  
											<%For fnm = 1 To 12%>
											<option value="<%=fnm%>" <%If (F1_1 = "" and CStr(fnm) = month(date)) Or (F1_1 <> "" and CStr(fnm) = Cstr(F1_1))    then%>selected<%End if%>><%=fnm%></option>
											<%Next%>
											</select>

									</div>
							</div>
						</div>

						<label class="col-sm-1 bg-gray btn"  style="width:60px;">구분</label>
						<div class="col-sm-2">
							<select id="F1_2" class="form-control" onchange="mx.searchPlayer(<%=page%>);">
							  <option value="A" <%If CStr(F1_2) = "A" then%>selected<%End if%>>전체</option>
							  <option value="01" <%If CStr(F1_2)= "01" then%>selected<%End if%>>정부명칭대회</option>
							  <option value="02" <%If CStr(F1_2)= "02" then%>selected<%End if%>>정부승인대회</option>
							  <option value="09" <%If CStr(F1_2)= "09" then%>selected<%End if%>>기타</option>
						  </select>
						</div>


						<label class="col-sm-1 bg-gray btn"  style="width:60px;">대회</label>
						<div class="col-sm-2" >
								<select id="F1_3" class="form-control" onchange="mx.searchPlayer(<%=page%>);">
								  <%If CDbl(ADGRADE) > 700 Then%>
								  <option value="01" <%If CStr(F1_3)= "01" then%>selected<%End if%>>전문</option>
								  <option value="02" <%If CStr(F1_3)= "02" then%>selected<%End if%>>생활</option>
								  <option value="03" <%If CStr(F1_3) = "03" then%>selected<%End if%>>통합</option>
								  <%else%>
								  <option value="02" <%If CStr(F1_3)= "02" then%>selected<%End if%>>생활</option>
								  <%End if%>
							  </select>

						</div>

						<label class="col-sm-1 bg-gray btn" style="width:60px;">명칭</label>
						<div class="col-sm-2">
							<input type="text" id="F1_4" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1,2,3,4],'F2':['','','','',''],'F3':[]} , '<%=pagename%>');}" value="<%=F1_4%>">
						</div>

						<a href="javascript:px.goSubmit( {'F1':[0,1,2,3,4],'F2':['','','','',''],'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
					</div>

