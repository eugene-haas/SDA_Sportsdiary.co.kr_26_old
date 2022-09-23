<%
'대회 주최/주관
'	SQL = "Select hostname,gubun from tblGameHost where DelYN = 'N' order by gubun asc"
'	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rss.EOF Then
'	arrRS = rss.GetRows()
'	End If

	'대회그룹/등급
'	SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_gameTitleCode where  DelYN = 'N' "
'	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rss.EOF Then
'	arrRSG = rss.GetRows()
'	End If

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
						<label>종목</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

									<select id="F1" class="form-control"><!-- onchange="mx.setTeamGb() -->
										<option value="D2" <%If F1 = "" Or F1 = "D2" then%>selected<%End if%>>경영</option>
										<option value="E2" <%If F1 = "E2" then%>selected<%End if%>>다이빙/수구</option>
										<option value="F2" <%If F1 = "F2" then%>selected<%End if%>>아티스틱스위밍</option>
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
											<select id="F2" class="form-control">
											<%For fny =year(date)+1 To year(date)-3 Step -1%>
											<option value="<%=fny%>" <%If (F2 = "" And fny = year(date)) Or CStr(fny) = CStr(F2) then%>selected<%End if%>><%=fny%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
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
									<a href="javascript:px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
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