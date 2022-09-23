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
			  
				  <div class="form-group">

						<label>년도</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
											<select id="F1" class="form-control" onchange="px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':$('#F3').val()} , '<%=pagename%>');">
											<%For fny =year(date)+1 To year(date)-3 Step -1%>
											<option value="<%=fny%>" <%If CStr(fny) = CStr(F1) then%>selected<%End if%>><%=fny%>&nbsp;</option>
											<%Next%>
											</select>
								  </div>
							</div>
						</div>

				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">

						<label>대회명</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
											<select id="F2" class="form-control" onchange="px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':$('#F3').val()} , '<%=pagename%>');">
											<%
											If IsArray(grs) Then 
												For a = LBound(grs, 2) To UBound(grs, 2)
													t_gidx = grs(0, a)
													t_gtitle = grs(1, a)
											%><option value="<%=t_gidx%>" <%If CStr(t_gidx) = CStr(F2) then%>selected<%End if%>><%=t_gtitle%></option><%
											Next
											End if
											%>

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
											<select id="F3" class="form-control" onchange="px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':$('#F3').val()} , '<%=pagename%>');">
												<option value="" <%If f3="" then%>selected<%End if%>>전체</option>
												<option value="Y" <%If f3="Y" then%>selected<%End if%>>초등부</option>
												<option value="Z" <%If f3="Z" then%>selected<%End if%>>중학부</option>
												<option value="7" <%If f3="7" then%>selected<%End if%>>고등부</option>
												<option value="8" <%If f3="8" then%>selected<%End if%>>대학부</option>
												<option value="9" <%If f3="9" then%>selected<%End if%>>일반부</option>
											</select>


<!-- 												<option value="0" <%If f3="0" then%>selected<%End if%>>전체</option> -->
<!-- 												<option value="1" <%If f3="1" then%>selected<%End if%>>초등학교</option> -->
<!-- 												<option value="2" <%If f3="2" then%>selected<%End if%>>중학교</option> -->
<!-- 												<option value="3" <%If f3="3" then%>selected<%End if%>>고등학교</option> -->
<!-- 												<option value="4" <%If f3="4" then%>selected<%End if%>>대학교</option> -->
<!-- 												<option value="5" <%If f3="5" then%>selected<%End if%>>기타</option> -->

							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
<!-- 									<a href="https://iniweb.inicis.com/security/login.do" target="_blank" class="btn btn-danger">이니시스결제취소가기</a> -->
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