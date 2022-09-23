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
											<select id="F1" class="form-control" onchange="px.goSubmit( {'F1':$('#F1').val(),'F2':'','F3':[]} , '<%=pagename%>');">
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
											<select id="F2" class="form-control" onchange="px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , '<%=pagename%>');">
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
								  <%If user_ip="112.187.195.132" then%><a href="/excelimsiattlist.asp?tidx=<%=F2%>" class="btn btn-default" target="_blank">설정명단엑셀</a><%End if%>
<!-- 									<a href="javascript:px.goSubmit( {'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a> -->
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<a href="https://iniweb.inicis.com/security/login.do" target="_blank" class="btn btn-danger">이니시스결제취소가기</a>
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