				<div class="form-horizontal">

					<div class="form-group">
						<label class="col-sm-1 control-label">대회년/월</label>
						<div class="col-sm-2">
							<div class="input-group">
							<select id="F1_0" class="form-control form-control-half">
							  <%For fny =year(date) To year(date)-4 Step -1%>
							  <option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
							  <%Next%>
						  </select>
							<select id="F1_1" class="form-control form-control-half">
							  <option value="">==월선택==</option>							  
							  <%For fnm = 1 To 12%>
							  <option value="<%=fnm%>" <%If (F1_1 = "" and CStr(fnm) = month(date)) Or (F1_1 <> "" and CStr(fnm) = Cstr(F1_1))    then%>selected<%End if%>><%=fnm%></option>
							  <%Next%>
						  </select>
						  </div>
						</div>

						<label class="col-sm-1 control-label">국제구분</label>
						<div class="col-sm-2">
							<select id="F1_2" class="form-control" onchange="mx.searchPlayer(<%=page%>);">
							  <option value="A" <%If CStr(F1_2) = "A" then%>selected<%End if%>>전체</option>
							  <option value="K" <%If CStr(F1_2)= "K" then%>selected<%End if%>>국내</option>
							  <option value="F" <%If CStr(F1_2)= "F" then%>selected<%End if%>>국제</option>
						  </select>
						</div>


						<div class="col-sm-3">
							<div class="input-group">
									<label class="control-label"><input type="checkbox" id="F1_3"  value="Y" <%If CStr(F1_3) = "Y" then%>checked<%End if%>>&nbsp;전문</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="F1_4"  value="Y"  <%If CStr(F1_4) = "Y" then%>checked<%End if%>>&nbsp;생활</label>
									<label class="control-label">&nbsp;<input type="checkbox" id="F1_5"  value="Y"  <%If CStr(F1_5) = "Y" then%>checked<%End if%>>&nbsp;유소년</label>
							</div>
						</div>

						<div class="col-sm-2">
							<input type="text" id="F1_6" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1,2,3,4,5,6],'F2':['','','','','','',''],'F3':[3,4,5]} , '<%=pagename%>');}" value="<%=F1_6%>">
						</div>

						<a href="javascript:px.goSubmit( {'F1':[0,1,2,3,4,5,6],'F2':['','','','','','',''],'F3':[3,4,5]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
					</div>
				</div>

