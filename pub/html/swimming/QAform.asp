<%
If e_idx <> "" then
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
End If

SQL = "Select sido,sidonm from tblSidoInfo where DelYN = 'N' "
Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rss.EOF Then
arrRS = rss.GetRows()
End If


SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2  and delYN = 'N'  "
Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rss)
If Not rsb.EOF Then
arrRSB = rsb.GetRows()
End If


%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  


				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
								  </div>
							</div>
						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
								  </div>
							</div>
						</div>
				  </div>

				  
			</div>





            <div class="col-md-6">

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<div class="input-group">
										</div>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
								  </div>
							</div>
						</div>
				  </div>

            </div>

            <div class="col-md-6">

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(14);" accesskey="i">REQ등록<span>(I)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>



            </div>




</div>