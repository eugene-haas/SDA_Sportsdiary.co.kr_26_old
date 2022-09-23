<%
	SQL = "Select sido,sidonm from tblSidoInfo where DelYN = 'N' "
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
	arrRS = rss.GetRows()
	End If

	If e_idx <> "" Then
		PAGE_ENTERTYPE = e_EnterType
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
	Else
		
		
		'아아추어와 팀코드 구분 
		If PAGE_ENTERTYPE = "A" Then

			SQL = "select max(team) from tblTeamInfo  where entertype='A'  "
			Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
			If isNull(rss(0)) = true Then
				e_team = "AM00001"
			Else
				tno = CDbl(Mid(rss(0), 3)) + 1
				e_team = "AM"
				For z = 1 To 5 - Len(tno)
					e_team = e_team & "0"
				Next 
				e_team = e_team & tno
			End If

		Else
		
			PAGE_ENTERTYPE = "E"
			SQL = "select max(team) from tblTeamInfo where entertype='E' "
			Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
			If isNull(rss(0)) = true Then
				e_team = "SW00001"
			Else
				tno = CDbl(Mid(rss(0), 3)) + 1
				e_team = "SW"
				For z = 1 To 5 - Len(tno)
					e_team = e_team & "0"
				Next 
				e_team = e_team & tno
			End If

		End if



	End If
%>
			<input type="hidden" id="entertype" value="<%=PAGE_ENTERTYPE%>">

			<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>(구분)소속코드/소속명</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

										<div class="input-group">
											<div class="input-group-addon" style="padding:0px;">
												<select id="mk_g0"  style="height:32px;">
													<%If PAGE_ENTERTYPE = "E" then%><option value="E" <%If e_EnterType = "E" then%>selected<%End if%>>전문</option><%End if%>
													<%If PAGE_ENTERTYPE = "A" then%><option value="A"<%If e_EnterType = "A" then%>selected<%End if%>>생활</option><%End if%>
												</select>
											</div>
											<input type="text" id="mk_g1" placeholder="소속코드" value="<%=e_team%>" class="form-control" readonly><!-- 마지막값 찾아서 찍어주자. -->
										</div>
	
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g2" placeholder="소속명" value="<%=e_teamnm%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>단체장/지도자</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g9" placeholder="단체장" value="<%=e_jangname%>" class="form-control">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g10" placeholder="지도자" value="<%=e_readername%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">

				  <div class="form-group">
					<label>국가/시도</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g3" placeholder="대한민국" value="<%=e_nation%>" class="form-control">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g4" class="form-control" >
									<%
										If IsArray(arrRS) Then 
											For ari = LBound(arrRS, 2) To UBound(arrRS, 2)
												l_sido = arrRS(0, ari)
												l_sidonm = arrRs(1,ari)
												%><option value="<%=l_sido%>" <%If e_sido = l_sido then%>selected<%End if%>><%=l_sidonm%></option><%
											Next
										End if
									%>
									</select>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
						<label>우편번호/주소</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g11" placeholder="우편번호" value="<%=e_ZipCode%>" class="form-control" onfocus="Postcode()">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g12" placeholder="주소" value="<%=e_Address%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>
				  
			</div>


            <div class="col-md-6">
				  <div class="form-group">
					<label>성별/종별</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g5" class="form-control" >
										<option value="1" <%If e_Sexno = "1" then%>selected<%End if%>>남자</option>
										<option value="2" <%If e_Sexno = "2" then%>selected<%End if%>>여자</option>
										<option value="3" <%If e_Sexno = "3" then%>selected<%End if%>>혼성</option>
									</select>
								  </div>
							</div>

							<%
							'코드에 맞추어 수정 21.3.10
							'Y	초등부
							'Z	중학부
							'7	고등부							
							'8	대학부
							'9	일반부
							%>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
									<select id="mk_g6" class="form-control" >
										<option value="Y" <%If e_groupnm = "Y" then%>selected<%End if%>>초등부</option>
										<option value="Z" <%If e_groupnm = "Z" then%>selected<%End if%>>중등부</option>
										<option value="7" <%If e_groupnm = "7" then%>selected<%End if%>>고등부</option>
										<option value="8" <%If e_groupnm = "8" then%>selected<%End if%>>대학부</option>
										<option value="9" <%If e_groupnm = "9" then%>selected<%End if%>>일반부</option>
									</select>
							</div>
						</div>
				  </div>

				  <div class="form-group">
						<label>전화번호/해체일</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<div class="input-group">
										<div class="input-group-addon">
										<i class="fa fa-phone"></i>
										</div>
										<input type="text" id="mk_g13" class="form-control" placeholder="전화번호" value="<%=e_TeamTel%>" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');">
										</div>										
										
										<!-- <input type="text" id="mk_g13" placeholder="전화번호" value="" class="form-control"> -->
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<div class="input-group date">
									<div class="input-group-addon">
									<i class="fa fa-calendar"></i>
									</div>
									<input type="text" class="form-control pull-right" id="mk_g14" placeholder="해체일" value="<%=e_SvcEndDt%>">
									</div>
								  </div>
							</div>
						</div>
				  </div>

            </div>



            <div class="col-md-6">
				  <div class="form-group">
					<label>등록년도/창단일</label>
					<div class="row">
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<div class="input-group date">
									<div class="input-group-addon">
									<i class="fa fa-calendar"></i>
									</div>
									<input type="text" class="form-control pull-right" id="mk_g7" value="<%=e_TeamRegDt%>" placeholder="등록년도" onKeyup="this.value=this.value.replace(/[^0-9,^-]/g,'');" maxlength="4">
									</div>									
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<div class="input-group date">
									<div class="input-group-addon">
									<i class="fa fa-calendar"></i>
									</div>
									<input type="text" class="form-control pull-right" id="mk_g8" placeholder="창단일" value="<%=e_TeamMakeDt%>">
									</div>
							  </div>
						</div>
					</div>
				  </div>

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(15);" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(15);" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>



            </div>
			</div>


