<%
'대회 주최/주관
	SQL = "Select hostname,gubun from tblGameHost where DelYN = 'N' order by gubun asc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
	arrRS = rss.GetRows()
	End If

	'대회그룹/등급
	SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_gameTitleCode where  DelYN = 'N' "
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
	arrRSG = rss.GetRows()
	End If

	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If
%>
<style type="text/css">
	.col-md-6{width:25%;}
</style>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>사용자구분</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="mk_g0" class="form-control">
										<option value="K" <%If e_gameNa = "" Or e_gameNa = "K" then%>selected<%End if%>>전체</option>
										<option value="F" <%If e_gameNa = "F" then%>selected<%End if%>>국제</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">

				  <div class="form-group"><%'tr%>
						<label>사용자구분</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="mk_g0" class="form-control">
										<option value="K" <%If e_gameNa = "" Or e_gameNa = "K" then%>selected<%End if%>>전체</option>
										<option value="F" <%If e_gameNa = "F" then%>selected<%End if%>>국제</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>
			  
			</div>





            <div class="col-md-6">
				  <div class="form-group">
						<label>상태</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="mk_g0" class="form-control">
										<option value="K" <%If e_gameNa = "" Or e_gameNa = "K" then%>selected<%End if%>>Y/N</option>
										<option value="F" <%If e_gameNa = "F" then%>selected<%End if%>>국제</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

            </div>


<!-- 
            <div class="col-md-6">
				  <div class="form-group">
					<label>등록년도/창단일</label>
					<div class="row">
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<input type="text" id="mk_g2" placeholder="등록년도" value="2018.11.11" class="form-control">
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<input type="text" id="mk_g2" placeholder="창단일" value="" class="form-control">
							  </div>
						</div>
					</div>
				  </div>

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>

            </div> -->




</div>