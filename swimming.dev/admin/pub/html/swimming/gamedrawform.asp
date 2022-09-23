<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	End If

	chktable = " ,(select max(gubun) from sd_gameMember where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N'   and tryoutsortno > 0 ) as gubun " '대신표

	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N' ) as attcnt " '신청수
	fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " & attcnt & chktable
	strSort = "  ORDER BY CDA, itgubun,cdc,Sexno , cdb desc"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' "

	SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		fr = rss.GetRows()
	End If
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>대회종목<%'=idx%></label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">




									<select id="mk_g0" class="form-control"  onchange="px.goSubmit({'IDX':$('#mk_g0').val()},'gamedraw.asp')">
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
													l_gubun= fr(13, ari)

													If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) Then
														find_gbidx = l_gbidx
														find_cdc = l_CDC  '기준 배영200m
													End if

													%><option value="<%=l_idx%>" <%If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) then%>selected<%End if%>   <%If l_gubun > 0 then%> style="background:orange"<%End if%>><%'=l_idx%> <%=l_CDANM&" " & l_CDBNM&" " & l_CDCNM& "&nbsp;&nbsp;("&l_attcnt&")"%><%If l_ITgubun = "I" then%>명<%else%>팀<%End if%></option><%
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
						<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<button type="button" class="btn btn-block btn-success  btn-flat" onmousedown="mx.gameList(<%=tidx%>,'<%=find_gbidx%>','<%=find_cdc%>')">기준기록조회</button>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<button type="button" class="btn btn-block btn-success  btn-flat"  onmousedown="mx.gameBestList(<%=tidx%>,'<%=find_gbidx%>','<%=find_cdc%>')">기록조회(신기록)</button>
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
								  <div class="form-group">
									<button type="button" class="btn btn-block btn-danger  btn-flat"   onmousedown="mx.gameExlList(<%=tidx%>,'<%=find_gbidx%>','<%=find_cdc%>')"><i class="fa fa-fw fa-file-excel-o"></i>랭킹엑셀다운로드</button> 
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

										
										
										
									<%
									Select Case startstr 
									Case  "예선경기" 
									%>
										<a href="#" class="btn  btn-warning btn-flat"  id="gn4" onclick="mx.setRane(<%=tidx%>,<%=gbidx%>,1);" style="margin-right:-10px;"><i class="fa fa-fw fa-check-square-o"></i>예선시작레인배정</a>
										<a href="#" class="btn btn-default btn-flat" id="gn3" onclick="mx.setRane(<%=tidx%>,<%=gbidx%>,3);" style="margin-left:0px;""><i class="fa fa-fw fa-square-o"></i>결승시작레인배정</a>&nbsp;&nbsp;
									<%
									Case "결승경기"
									%>
										<a href="#" class="btn btn-default btn-flat"  id="gn4" onclick="mx.setRane(<%=tidx%>,<%=gbidx%>,1);" style="margin-right:-10px;"><i class="fa fa-fw fa-check-square-o"></i>예선레인배정</a>
										<a href="#" class="btn  btn-warning btn-flat" id="gn3" onclick="mx.setRane(<%=tidx%>,<%=gbidx%>,3);"  style="margin-left:0px;"><i class="fa fa-fw fa-check-square-o" ></i>결승레인배정</a>
									<%
									Case ""
									%>
										<a href="#" class="btn  btn-default btn-flat"  id="gn4" onclick="mx.setRane(<%=tidx%>,<%=gbidx%>,1);" style="margin-right:-10px;"><i class="fa fa-fw fa-square-o"></i>예선시작레인배정</a>
										<a href="#" class="btn btn-default btn-flat" id="gn3" onclick="mx.setRane(<%=tidx%>,<%=gbidx%>,3);" style="margin-left:0px;"><i class="fa fa-fw fa-square-o"></i>결승시작레인배정</a>&nbsp;&nbsp;

									<%			
									End select
									%>										
										

<!-- 										<a href="#" class="btn  btn-warning btn-flat" style="margin-left:0px;" id="gn4" onclick="alert('현제설정이 예선경기 입니다.');" accesskey="r"><i class="fa fa-fw fa-check-square-o"></i>예선시작레인배정</a> -->
<!-- 										<a href="#" class="btn btn-default btn-flat" id="gn3" onclick="mx.setStart(<%=tidx%>,'<%=find_gbidx%>','<%=find_cdc%>','3');" style="margin-right:-10px;"><i class="fa fa-fw fa-check-square-o"></i>결승시작레인배정</a>&nbsp;&nbsp; -->
										
										
										
<!-- 										<a href="javascript:mx.setRane(<%=tidx%>,<%=gbidx%>);" class="btn btn-primary" id="btnsave"  style="margin-right:10px;">레인배정</a> -->
										<!-- <a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm();" accesskey="e">대진저장</a> -->








								  </div>
							</div>
						</div>
				  </div>
            </div>




</div>