<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If



	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N' ) as attcnt " '신청수
	fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " & attcnt
	'strSort = "  ORDER BY CDBSORT, Sexno "
	strSort = "  ORDER BY gameno, gameno2 "
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and cda = '"&cda&"' "

	SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		fr = rss.GetRows()
	End If
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">




									<select id="mk_g0" class="form-control"  onchange="px.goSubmit({'IDX':$('#mk_g0').val()},'gametable.asp')">
									<%
											If IsArray(fr) Then 
												For ari = LBound(fr, 2) To UBound(fr, 2)

													l_idx = fr(0, ari) 'idx
													l_tidx = fr(1, ari)
													l_gbidx= fr(2, ari)
													l_Sexno= fr(3, ari)
													Select Case l_Sexno
													Case "1"
														l_sex = "남자"
													Case "2"
														l_sex = "남자"
													Case "3"
														l_sex = "혼성"
													End Select 

													l_ITgubun= fr(4, ari)
													l_CDA= fr(5, ari)
													l_CDANM= fr(6, ari)
													l_CDB= fr(7, ari)
													l_CDBNM= fr(8, ari)
													l_CDC= fr(9, ari)
													l_CDCNM= fr(10, ari)
													l_levelno= fr(11, ari)

													l_attcnt= fr(12, ari)

													If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) Then
														find_gbidx = l_gbidx
														find_cdc = l_CDC  '기준 배영200m
													End if

													%><option value="<%=l_idx%>" <%If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) then%>selected<%End if%>><%=l_CDANM&" " & l_CDBNM&" " & l_CDCNM& "&nbsp;&nbsp;("&l_attcnt&")명"%></option><%
												Next 
											End if
									%>
									</select>
								  </div>
							</div>
						</div>
				  </div>
            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
						<div class="row">

						</div>
				  </div>
			</div>

            <div class="col-md-6">
				  <div class="form-group">


				  </div>
            </div>

            <div class="col-md-6">
				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

								  </div>
							</div>
						</div>
				  </div>
            </div>




</div>