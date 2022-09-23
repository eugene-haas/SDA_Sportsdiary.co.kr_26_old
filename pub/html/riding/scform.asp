<%
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	%><input type="hidden" id="e_gubun" value="<%=e_gubun%>"><%
%>

		<div class="form-group">

			<label class="col-sm-1 control-label">순서/위치</label>
			<div class="col-sm-2">
				<div class="input-group">
					<input type="number" id="mk_g0" placeholder="순서번호" value="" class="form-control form-control-half" onclick="if (this.value==''){alert('리스트를 먼저 선택해주세요.');}" readonly>
					<select id="mk_g1" class="form-control form-control-half" >
						<option value="U" <%If e_pos = "U" then%>selected<%End if%>>위에추가</option>
						<option value="D" <%If e_pos = "D" then%>selected<%End if%>>아래추가</option>
					</select>
				</div>
			</div> 

			<%
			'sd_tennisMember  >>>> gubun 0 순서설정전 1(순서설정완료 : 비체전인경우) 100 '공지사항 이름은 sc playeridx = 0 순서번호는 ? a.tryoutsortno,a.tryoutgroupno 1번위라면 0 100부터 
			%>
			<label class="control-label col-sm-1">시간</label>
			<div class="col-sm-2">
				<div class='input-group date' id='GameTimeWrap1'>
					<input type='text' class="form-control" id="mk_g2" value="<%=e_noticestart%>"/>
					<span class="input-group-addon">
					<span class="glyphicon glyphicon-time"></span>
					</span>
			  </div>
			</div>
			<div class="col-sm-2" style="width:40px;">~</div>
			<div class="col-sm-2">
				<div class='input-group date' id='GameTimeWrap2'>
					<input type='text' class="form-control" id="mk_g3" value="<%=e_noticeend%>"/>
					<span class="input-group-addon">
					<span class="glyphicon glyphicon-time"></span>
					</span>
			  </div>
			</div>

		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">일정명칭</label>
			<div class="col-sm-2" style="width:77%;">
				<input type="text" id="mk_g4" placeholder=" ※'[','{'예약어사용불가※  일정내용을 입력해 주세요." value="<%=e_noticetitle%>" class="form-control">
			</div>
		</div>





		<!-- 출전순서가 먼저 진행된 다음에 사용할수 있어야한다.   수정과 삭제는 공지만 사용할수 있다. -->
		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">일정추가<span>(I)</span></a>
			<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frmSC();" accesskey="e">수정<span>(E)</span></a>
			<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frmSC();" accesskey="r">삭제<span>(R)</span></a>
		</div>





