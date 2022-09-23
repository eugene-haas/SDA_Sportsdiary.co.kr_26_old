<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>


		<div class="form-group">
			<label class="col-sm-1 control-label">제목</label>
			<div class="col-sm-2" style="width:90%;">
				<input type="text" id="mk_g0" placeholder="작업내용을 적어주세요" value="<%=e_tbl%>" class="form-control" style="width:80%;">
			</div> 
		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">대상테이블</label>
			<div class="col-sm-2" style="width:90%;">
				<input type="text" id="mk_g1" placeholder="SD_riding.dbo.tablename" value="<%=e_tbl%>" class="form-control" style="width:80%;">
			</div> 
		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">대상필드명</label>
			<div class="col-sm-2" style="width:90%;">
				<input type="text" id="mk_g2" placeholder="id^pwd^name..." value="<%=e_fld%>" class="form-control">
			</div> 
		</div>

		<div class="form-group">
			<label class="col-sm-1 control-label">입력데이터</label>
			<div class="col-sm-2" style="width:90%;">
				<textarea id="mk_g3" placeholder="내용을 '^' '엔터' 로 구분해서 넣어주세요. 1000라인씩 입력" value="<%=e_val%>" class="form-control" style="height:200px;"></textarea>
			</div> 
		</div>





		<div class="btn-group flr" role="group" aria-label="...">
			<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">저장<span>(I)</span></a>
			<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
			<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
		</div>





