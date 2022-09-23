<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
		%><input type="hidden" id="e_gno" value="<%=e_gno%>"><%
	End If
%>

	<div id="level_form" class="form-horizontal">
		<!-- #include virtual = "/pub/html/riding/gameinfoLevelFormLine1.asp" -->
	</div>

	<div class="form-horizontal">

		<div class="form-group">
			<label class="control-label col-sm-1">대회일자</label>
			<div class="col-sm-2">
					<div class='input-group date' id='GameDateWrap1'>
						<input type='text' class="form-control" id="mk_g6" value="<%=e_a9%>"/>
						<span class="input-group-addon">
							<span class="glyphicon glyphicon-calendar"></span>
						</span>
					</div>
			</div>
			<div class="col-sm-2">
				<div class='input-group date' id='GameTimeWrap1'>
					<input type='text' class="form-control" id="mk_g7" value="<%=e_a10%>"/>
					<span class="input-group-addon">
					<span class="glyphicon glyphicon-time"></span>
					</span>
			  </div>
			</div>
		</div>


		<div class="form-group">
			<label class="control-label col-sm-1">신청시작일</label>
			<div class="col-sm-2">

					<div class='input-group date' id='GameDateWrap2'>
						<input type='text' class="form-control" id="mk_g8" value="<%=e_a7%>"/>
						<span class="input-group-addon">
							<span class="glyphicon glyphicon-calendar"></span>
						</span>
					</div>

			</div>
			<div class="col-sm-2">
				<div class='input-group date' id='GameTimeWrap2'>
					<input type='text' class="form-control" id="mk_g9" value="<%=e_a7%>"/>
					<span class="input-group-addon">
					<span class="glyphicon glyphicon-time"></span>
					</span>
			  </div>
			</div>


			<label class="control-label col-sm-1">신청종료일</label>
			<div class="col-sm-2">

					<div class='input-group date' id='GameDateWrap3'>
						<input type='text' class="form-control" id="mk_g10" value="<%=e_a8%>"/>
						<span class="input-group-addon">
							<span class="glyphicon glyphicon-calendar"></span>
						</span>
					</div>
			</div>
			<div class="col-sm-2">
				<div class='input-group date' id='GameTimeWrap3'>
					<input type='text' class="form-control" id="mk_g11" value="<%=e_a8%>"/>
					<span class="input-group-addon">
					<span class="glyphicon glyphicon-time"></span>
					</span>
			  </div>
			</div>
		</div>


		<div class="form-group">
			<label class="control-label col-sm-1">부별/금액</label>
			<div class="col-sm-2">
				<div class="input-group">
					<label class="control-label" style="float:left;">&nbsp;<input type="checkbox" id="mk_g12"  value="Y" <%If e_pubcode1 = "1" then%>checked<%End if%>>&nbsp;&nbsp;초등부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input type="number" id="mk_g13" value="<%If e_pubfee1 = "" then%>0<%else%><%=e_pubfee1%><%End if%>" class="form-control form-control-half" placeholder="금액입력" style="width: 79px;">
				</div>
			</div>
			<div class="col-sm-2">
				<div class="input-group">
					<label class="control-label" style="float:left;">&nbsp;<input type="checkbox" id="mk_g14"  value="Y" <%If e_pubcode4 = "4" then%>checked<%End if%>>&nbsp;&nbsp;대학부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input type="number" id="mk_g15" value="<%If e_pubfee4 = "" then%>0<%else%><%=e_pubfee4%><%End if%>" class="form-control form-control-half" placeholder="금액입력" style="width: 79px;">
				</div>
			</div>
		</div>

		<div class="form-group">
			<label class="control-label col-sm-1"></label>
			<div class="col-sm-2">
				<div class="input-group">
					<label class="control-label" style="float:left;">&nbsp;<input type="checkbox" id="mk_g16"  value="Y" <%If e_pubcode2 = "2" then%>checked<%End if%>>&nbsp;&nbsp;중등부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input type="number" id="mk_g17" value="<%If e_pubfee2 = "" then%>0<%else%><%=e_pubfee2%><%End if%>" class="form-control form-control-half" placeholder="금액입력" style="width: 79px;">
				</div>
			</div>
			<div class="col-sm-2">
				<div class="input-group">
					<label class="control-label" style="float:left;">&nbsp;<input type="checkbox" id="mk_g18"  value="Y" <%If e_pubcode5 = "5" then%>checked<%End if%>>&nbsp;&nbsp;일반부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input type="number" id="mk_g19" value="<%If e_pubfee5 = "" then%>0<%else%><%=e_pubfee5%><%End if%>" class="form-control form-control-half" placeholder="금액입력" style="width: 79px;">
				</div>
			</div>
		</div>

		<div class="form-group">
			<label class="control-label col-sm-1"></label>
			<div class="col-sm-2">
				<div class="input-group">
					<label class="control-label" style="float:left;">&nbsp;<input type="checkbox" id="mk_g20"  value="Y" <%If e_pubcode3 = "3" then%>checked<%End if%>>&nbsp;&nbsp;고등부&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
					<input type="number" id="mk_g21" value="<%If e_pubfee3 = "" then%>0<%else%><%=e_pubfee3%><%End if%>" class="form-control form-control-half" placeholder="금액입력" style="width: 79px;">
				</div>
			</div>
			<div class="col-sm-2">
				<div class="input-group">
					<label class="control-label" style="float:left;">&nbsp;<input type="checkbox" id="mk_g22"  value="Y" <%If e_pubcode6 = "6" then%>checked<%End if%>>&nbsp;&nbsp;동호인부&nbsp;</label>
					<input type="number" id="mk_g23" value="<%If e_pubfee6 = "" then%>0<%else%><%=e_pubfee6%><%End if%>" class="form-control form-control-half" placeholder="금액입력" style="width: 79px;">
				</div>
			</div>
		</div>

</div>


      <div class="btn-group pull-right">
        <a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
        <a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
        <a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
      </div>