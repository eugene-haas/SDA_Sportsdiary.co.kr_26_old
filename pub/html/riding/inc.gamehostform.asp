		<%
		If e_idx <> "" then
			%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
		End If
		%>
					<label class="control-label col-sm-1">명칭</label>
					<div class="col-sm-4">
						<input type="text" id="hostname" value="<%=hostname%>" class="form-control">
					</div>
