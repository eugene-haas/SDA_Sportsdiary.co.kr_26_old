<%
If sgg_loopcnt = "" Then
	sgg_loopcnt = 0
End if
%>

<div class="form-group">
			<label class="control-label col-sm-1">루프갯수</label>
			<div class="col-sm-2">
					<select id="g_loopcnt" class="form-control" onchange="mx.showLoop(<%=select_f_ridx%>,$(this))">
						<option value="">==선택==</option>
						<option value="1" <%If sgg_loopcnt = "1" then%>selected<%End if%>>1</option>
						<option value="2" <%If sgg_loopcnt = "2" then%>selected<%End if%>>2</option>
						<option value="3" <%If sgg_loopcnt = "3" then%>selected<%End if%>>3</option>
					</select>
			</div>


			<label class="control-label col-sm-1">출발시간</label>

			<div class="col-sm-2">
				<div class="input-group date">
					<input type="text" class="form-control" id="g_stm" value="<%=sgg_stm%>"  onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
					<span class="input-group-addon">
					<span class="glyphicon glyphicon-time"></span>
					</span>
			  </div>
			</div>			
			
			<!-- <div class="col-sm-2">
				<input type="text" id="g_stm" placeholder="출발시간" value="<%=sgg_stm%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="4" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
			</div> -->

			<label class="control-label col-sm-1">의무휴시간</label>
			<div class="col-sm-2">
				<input type="text" id="g_resttm" placeholder="의무휴식" value="<%=sgg_resttm%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="4" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
			</div>
</div>


<div class="form-group" style="width:100%;height:20px;">&nbsp;</div>

<%If sgg_loopcnt <> "" then%>
<div id = "loop1" <%If CDbl(sgg_loopcnt) > 0 then%><%else%>style="display:none;"<%End if%>>
			<label class="control-label col-sm-1">1 Loop</label>
			<div class="col-sm-2">
				<input type="text" id="g_staytime1" placeholder="stay time" value="<%=sgg_staytime1%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="2" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
				<input type="text" id="g_bpm1" placeholder="BPM" value="<%=sgg_bpm1%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="2" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
			</div>
</div>

<div id = "loop2"  <%If CDbl(sgg_loopcnt) > 1 then%><%else%>style="display:none;"<%End if%>>
			<label class="control-label col-sm-1">2 Loop</label>
			<div class="col-sm-2">
				<input type="text" id="g_staytime2" placeholder="stay time" value="<%=sgg_staytime2%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="2" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
				<input type="text" id="g_bpm2" placeholder="BPM" value="<%=sgg_bpm2%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="2" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
			</div>
</div>

<div id = "loop3"  <%If CDbl(sgg_loopcnt) > 2 then%><%else%>style="display:none;"<%End if%>>
			<label class="control-label col-sm-1">3 Loop</label>
			<div class="col-sm-2">
				<input type="text" id="g_staytime3" placeholder="stay time" value="<%=sgg_staytime3%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="2" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
				<input type="text" id="g_bpm3" placeholder="BPM" value="<%=sgg_bpm3%>" class="form-control" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="2" onblur="mx.setGiGoo(<%=select_f_ridx%>,$(this))">
			</div>
</div>
<%End if%>


