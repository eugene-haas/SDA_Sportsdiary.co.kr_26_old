				<div class="form-horizontal">

					<div class="form-group">
						<label class="col-sm-1 control-label">대회년/월</label>
						<div class="col-sm-2">
							<select id="F1_0" class="form-control">
							  <%For fny = year(date) To minyear Step - 1%>
								<option value="<%=fny%>" <%If CStr(F2_0)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
							  <%Next%>
						  </select>
						</div>

						<label class="col-sm-1 control-label">대회명</label>
						<div class="col-sm-2">
							<select id="F1_1" class="form-control">
								<%
								If IsArray(arrPub)  Then
									For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
										f_tidx = arrPub(0, ar)
										f_tnm = arrPub(1, ar)
										%><option value="<%=f_tidx%>" <%If CStr(f_tidx) = CStr(F2_1) then%>selected<%End if%>><%=f_tnm%></option><%
									Next
								End if
								%>

							</select>
							<!-- <input type="text" id="F1_6" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1,2,3,4,5,6],'F2':['','','','','','',''],'F3':[3,4,5]} , '<%=pagename%>');}" value="<%=F1_6%>"> -->
						</div>

						<a href="javascript:px.goSubmit( {'F1':[0,1],'F2':['',''],'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
					</div>
				</div>



