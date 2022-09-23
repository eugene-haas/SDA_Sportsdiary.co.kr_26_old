<%
	attcnt = " ,(select count(*) from tblGameRequest where gametitleIDx = "&tidx&" and gbidx = a.gbidx  and delYN = 'N' ) as attcnt " '신청수
	fld =  " RGameLevelidx,GameTitleIDX,GbIDX,Sexno,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,levelno " & attcnt
	strSort = "  ORDER BY writedate Desc"
	strWhere = " a.GameTitleIDX = "&tidx&" and a.DelYN = 'N' and cdc = '31' "

	SQL = "Select " & fld & " from tblRGameLevel as a where " & strWhere & strSort
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		fr = rss.GetRows()
	End If
%>


<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>대회명</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="mk_g0" class="form-control"  onchange="px.goSubmit({'IDX':$('#mk_g0').val()},'inputRecord4.asp')">
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

													%><option value="<%=l_idx%>" <%If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) then%>selected<%End if%>><%=l_CDANM&" " & l_CDBNM&" " & l_CDCNM& "&nbsp;&nbsp;("&l_attcnt&")팀"%></option><%
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
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;"><%'=resultopenAMYN%>
								  <button class = "btn <%If resultopenAMYN = "Y" then%>bg-yellow<%else%>btn-default<%End if%>" type="button" style="margin-right:60px;" onclick="mx.setAppShow('appyn_sg',<%=idx%>,'am','')" id ="appyn_sg">APP노출</button>
								  <!-- <div class="form-group">
									<select id="mk_g1" class="form-control" >
										<option value="N" <%If e_gametype = "" Or e_gametype = "N" then%>selected<%End if%>>토너먼트</option>
										<option value="Y" <%If e_gametype = "Y" then%>selected<%End if%>>리그</option>
									</select>
								  </div> -->
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<!-- <select id="mk_g2" class="form-control">
										<option value="1" <%If e_roundno = "" Or e_roundno = "1" then%>selected<%End if%>>결승</option>
										<option value="2" <%If e_roundno = "2" then%>selected<%End if%>>준결승</option>
										<option value="3" <%If e_roundno = "3" then%>selected<%End if%>>준준결승</option>
										<option value="4" <%If e_roundno = "4" then%>selected<%End if%>>준준준결승</option>
										<option value="5" <%If e_roundno = "5" then%>selected<%End if%>>준준준준결승</option>
										<option value="6" <%If e_roundno = "6" then%>selected<%End if%>>준준준준준결승</option>
									</select> -->
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
									<!-- <a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm();" accesskey="i">조회</a> -->
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
									&nbsp;
								  </div>
							</div>
						</div>
				  </div>
            </div>




</div>