<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>
	
<div class="form-horizontal">
	<div class="form-group">
		<div class="col-sm-1"><label class="control-label">사용년도</label></div>
		<div class="col-sm-2">
				<select id="F1_0" class="form-control">
				  <%For fny = year(date) To minyear Step - 1%>
					<option value="<%=fny%>" <%If CStr(F2_0)= CStr(fny) then%>selected<%End if%>><%=fny%></option>
				  <%Next%>
			  </select>
		</div>
		<div>
		<a href="javascript:px.goSubmit( {'F1':[0,1] , 'F2':[$('#F1_0').val(),0],'F3':[]} , 'jgstandard.asp')" class="btn btn-primary" id="btnsave"  accesskey="i">조회</a>
		</div>
	</div>
</div>