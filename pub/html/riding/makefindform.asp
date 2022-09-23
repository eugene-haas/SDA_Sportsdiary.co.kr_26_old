				<%'=request("p")%>
				<div class="form-horizontal">

					<div class="form-group">
						<label class="col-sm-1 control-label">사용년도</label>
						<div class="col-sm-2">

							<select id="fnd_y" class="form-control">

							  <%For fny = year(date) To minyear Step - 1%>
								<option value="<%=fny%>" <%If CStr(F2)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
							  <%Next%>

						  </select>
						</div>

						<a href="javascript:px.goSubmit( {'F1':'useyear','F2':$('#fnd_y').val()} , '<%=pagename%>');" class="btn btn-primary">검색</a>
					</div>
				</div>

