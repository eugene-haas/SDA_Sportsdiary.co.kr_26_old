<%
If e_idx <> "" then
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%

	SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2 and delYN = 'N'  and sexno = '"&e_Sex&"'"
Else
	SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2 and delYN = 'N'  and sexno = '1' "
End If
	Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Call rsdrow(rss)
	If Not rsb.EOF Then
	arrRSB = rsb.GetRows()
	End If

SQL = "select code,codeNm from tblCode where delyn='N' and gubun = 4   " 
Set rsc = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rss)
If Not rsc.EOF Then
arrRS = rsc.GetRows()
End If


'#########
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
		'종목상세
		If e_gubun = "I" then
			SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&e_CDA&"' and  orderby < 100 order by orderby"
		Else
			SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&e_CDA&"' and orderby >= 100  order by orderby"
		End if
		Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rss.EOF Then
			fcd = rss.GetRows()
		End If
	Else
		SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = 'D2' and orderby < 100  order by  orderby"
		Set rsa = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rsa.EOF Then
			fcd = rsa.GetRows()
		End If
	End if


'	SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2 and delYN = 'N'  and sexno = '1'"
'	Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	'Call rsdrow(rss)
'	If Not rsb.EOF Then
'	arrRSB = rsb.GetRows()
'	End If
%>


<%
			'If USER_IP = "118.33.86.240" Then
			'Response.write aa
			'Response.end
			'End if
%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>대회코드/대회명</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g0" placeholder="대회코드" value="<%=e_titleCode%>" class="form-control"> <!-- onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"> -->
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g1" placeholder="대회명" value="<%=e_titlename%>" class="form-control" >
								  </div>
							</div>
						</div>
				  </div>


				  <div class="form-group"><%'tr%>
						<label>기록구분/종목</label>
						<div class="row">

							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g9" class="form-control" onchange="mx.setTeamGb()">
									<%
										If IsArray(arrRS) Then 
											For ari = LBound(arrRS, 2) To UBound(arrRS, 2)
												l_RCD = arrRS(0, ari)
												l_RCDNM = arrRS(1,ari)
												%><option value="<%=l_RCD%>" <%If e_rctype = l_RCD then%>selected<%End if%>><%=l_RCDNM%></option><%
											Next
										End if
									%>
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g10" class="form-control" onchange="mx.setTeamGb()">
										<option value="D2" <%If e_CDA = "" Or e_CDA = "D2" then%>selected<%End if%>>경영</option>
										<option value="E2" <%If e_CDA = "E2" then%>selected<%End if%>>다이빙/수구</option>
										<option value="F2" <%If e_CDA = "F2" then%>selected<%End if%>>아티스틱스위밍</option>
									</select>
								  </div>
							</div>
						</div>

				  </div>



				  <div class="form-group">
				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
						<label>수립장소/수립일</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g2" placeholder="장소" value="<%=e_gamearea%>" class="form-control">
								  </div>
							</div>

							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<div class="input-group date">
										<div class="input-group-addon">
										<i class="fa fa-calendar"></i>
										</div>
										<input type="text" class="form-control pull-right" id="mk_g3" value="<%=e_gameDate%>" placeholder="수립일">  <!-- onchange="mx.dateChange(this.value)">  -->
										</div>									
								  </div>
							</div>


						</div>
				  </div>



				  <div class="form-group">
						<label>개인/단체, 성별</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g11" class="form-control" onchange="mx.setPGtype()">
										<option value="I" <%If e_gubun = "" Or e_ITgubun = "I" then%>selected<%End if%>>개인</option>
										<option value="T" <%If e_gubun = "T" then%>selected<%End if%>>단체</option>
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g12" class="form-control" onchange="mx.setBoo()">
										<option value="1" <%If e_Sex = "" Or e_Sex = "1" then%>selected<%End if%>>남자</option>
										<option value="2" <%If e_Sex = "2" then%>selected<%End if%>>여자</option>
										<option value="3" <%If e_Sex = "3" then%>selected<%End if%>>혼성</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>


				  <div class="form-group">
				  </div>

				  
			</div>





            <div class="col-md-6">
				  <div class="form-group">
					<label>이름/소속(학년)</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="hidden" id="mk_g15" value="<%=e_kskey%>" ><!-- 체육회키  -->
									<input type="hidden" id="mk_g16" value="<%=e_team%>" ><!-- 팀키  -->
									<input type="hidden" id="mk_g17" value="<%=e_playerIDX%>" ><!-- 선수키  -->

									<!--<input type="hidden" id="mk_g18" value="<%=e_sex%>" > 성별  -->
									<input type="hidden" id="mk_g18" value="<%=e_sido%>" ><!-- 시도  -->
									<input type="hidden" id="mk_g19" value="<%=e_sidocode%>" ><!-- 시도코드  -->

									<input type="text" id="mk_g4" placeholder="이름" value="<%=e_UserName%>" class="form-control">

									<%'단체###########################%>
									<div id="teammember" <%If e_gubun = "T" then%><%else%>style="display:none;"<%End if%>>
									<input type="hidden" id="kskey2" value="<%=e_kskey2%>" ><!-- 체육회키  -->
									<input type="hidden" id="kskey3" value="<%=e_kskey3%>" ><!-- 체육회키  -->
									<input type="hidden" id="kskey4" value="<%=e_kskey4%>" ><!-- 체육회키  -->
									<input type="hidden" id="pidx2" value="<%=e_pidx2%>" ><!-- 선수키  -->
									<input type="hidden" id="pidx3" value="<%=e_pidx3%>" ><!-- 선수키  -->
									<input type="hidden" id="pidx4" value="<%=e_pidx4%>" ><!-- 선수키  -->
									<input type="text" id="unm2" placeholder="이름" value="<%=e_UserName2%>" class="form-control">
									<input type="text" id="unm3" placeholder="이름" value="<%=e_UserName3%>" class="form-control">
									<input type="text" id="unm4" placeholder="이름" value="<%=e_UserName4%>" class="form-control">
									</div>
									<%'단체###########################%>
								  
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

										<div class="input-group">
											<input type="text" id="mk_g5" placeholder="소속 명" value="<%=e_teamnm%>" class="form-control">
											<div class="input-group-addon" style="padding:0px;">
												<select id="mk_g6"  style="height:32px;">
													<option value="" <%If e_userClass = "" then%>selected<%End if%>>-</option>
													<option value="1" <%If e_userClass = "1" then%>selected<%End if%>>1</option>
													<option value="2" <%If e_userClass = "2" then%>selected<%End if%>>2</option>
													<option value="3" <%If e_userClass = "3" then%>selected<%End if%>>3</option>
													<option value="4" <%If e_userClass = "4" then%>selected<%End if%>>4</option>
													<option value="5" <%If e_userClass = "5" then%>selected<%End if%>>5</option>
													<option value="6" <%If e_userClass = "6" then%>selected<%End if%>>6</option>
												</select>
											</div>
										</div>

								  </div>
							</div>
						</div>
				  </div>



				  <div class="form-group">
					<label>부서선택</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" id="boo">
									<select id="mk_g13" class="form-control">
									<option value="" >--</option>
									<%
										If IsArray(arrRSB) Then 
											For ari = LBound(arrRSB, 2) To UBound(arrRSB, 2)
												l_CDB = arrRSB(0, ari)
												l_CDBNM = arrRSB(1,ari)
												%><option value="<%=l_CDB%>" <%If e_CDB = l_CDB then%>selected<%End if%>><%=l_CDBNM%></option><%
											Next
										End if
									%>
									</select>

								  </div>
							</div>
						</div>
				  </div>


				  <div class="form-group">
				  </div>

            </div>

           
			
			<div class="col-md-6">
				  <div class="form-group">
					<label>기록(00:00.00:숫자만입력)/순위</label>
					<div class="row">


						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<input type="text" id="mk_g7" placeholder="기록 6자리숫자" value="<%=e_gameResult%>" class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9:.]/g,'');"  maxlength="8">
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<input type="text" id="mk_g8" placeholder="순위" value="<%=e_gameOrder%>" class="form-control"  onKeyup="this.value=this.value.replace(/[^0-9]/g,'');"  maxlength="3">
							  </div>
						</div>
					</div>
				  </div>


				  <div class="form-group">
					<label>세부종목</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" id="boodetail">
									<select id="mk_g14" class="form-control">
										<%
											If IsArray(fcd) Then 
												fldcnt =  UBound(fcd, 2)
												For ari = LBound(fcd, 2) To UBound(fcd, 2)
													%><option value="<%=fcd(0, ari)%>" <%If e_CDC = fcd(0, ari) then%>selected<%End if%>><%=fcd(1, ari)%></option><%
												Next 
											End if
										%>
									</select>
								  </div>
							</div>
						</div>
				  </div>


				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(20);" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(20);" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>



            </div>




</div>