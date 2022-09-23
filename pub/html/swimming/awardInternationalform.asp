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
						<label>구분</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
											<select id="F1_0" class="form-control">

											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>>국제</option>

											</select>
								  </div>
							</div>
						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
						<label>개최년도</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
											<select id="F1_1" class="form-control">
											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>>전체</option>
											<%For fny =year(date) To year(date)-4 Step -1%>
											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1_0) then%>selected<%End if%>><%=fny%></option>
											<%Next%>
											</select>
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
									<a href="javascript:px.goSubmit( {'F1':[0,1,2,3,4,5,6],'F2':['','','','','','',''],'F3':[3,4,5]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									&nbsp;
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
								
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
								
							  </div>
						</div>
					</div>
				  </div>

            </div>




</div>