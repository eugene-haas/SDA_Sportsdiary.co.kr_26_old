				
					<div class="form-group" >
						<div class="col-sm-2" style="padding:5px;margin:0">
							<div class="input-group">
									<div class="col-md-6" style="width:50%;padding-left:2px;padding-right:0px;">

											<select id="F1_0" class="form-control">
											<%For fny =year(date) To year(date)-4 Step -1%>
											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>>경기일자</option>
											<%Next%>
											</select>
									</div>

									<div class="col-md-6" style="width:50%;padding-left:2px;padding-right:0px;">

											<select id="F1_1" class="form-control">
											<option value="">경기장소</option>							  
											<%For fnm = 1 To 12%>
											<option value="<%=fnm%>" <%If (F1_1 = "" and CStr(fnm) = month(date)) Or (F1_1 <> "" and CStr(fnm) = Cstr(F1_1))    then%>selected<%End if%>>경기장소</option>
											<%Next%>
											</select>

									</div>
							</div>
						</div>

						<div class="col-sm-2" style="padding:5px;">
							<div class="input-group">
									<div class="col-md-6" style="width:50%;padding-left:2px;padding-right:0px;">

											<select id="F1_0" class="form-control">
											<%For fny =year(date) To year(date)-4 Step -1%>
											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>>코트선택</option>
											<%Next%>
											</select>
									</div>

									<div class="col-md-6" style="width:50%;padding-left:2px;padding-right:0px;">

											<select id="F1_1" class="form-control">
											<option value="">경기유형</option>							  
											<%For fnm = 1 To 12%>
											<option value="<%=fnm%>" <%If (F1_1 = "" and CStr(fnm) = month(date)) Or (F1_1 <> "" and CStr(fnm) = Cstr(F1_1))    then%>selected<%End if%>>경기장소</option>
											<%Next%>
											</select>

									</div>
							</div>
						</div>

						<div class="col-sm-2" style="padding:5px;">
							<div class="input-group">
									<div class="col-md-6" style="width:50%;padding-left:2px;padding-right:0px;">

											<select id="F1_0" class="form-control">
											<%For fny =year(date) To year(date)-4 Step -1%>
											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>>경기구분</option>
											<%Next%>
											</select>
									</div>

									<div class="col-md-6" style="width:50%;padding-left:2px;padding-right:0px;">

										<input type="text" id="F1_4" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1,2,3,4],'F2':['','','','',''],'F3':[]} , '<%=pagename%>');}" placeholder="이름 검색">

									</div>
							</div>



						
						</div>





							<a href="javascript:px.goSubmit( {'F1':[0,1,2,3,4],'F2':['','','','',''],'F3':[]} , '<%=pagename%>');" class="btn btn-primary" style="margin-top:5px;">검색</a>

					</div>

