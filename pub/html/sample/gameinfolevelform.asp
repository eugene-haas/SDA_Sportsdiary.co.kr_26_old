<%
	If e_idx <> "" then
		%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
		'종목상세
		SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = '"&e_CDA&"' "
		Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rss.EOF Then
			fcd = rss.GetRows()
		End If
	Else
		SQL = "Select  teamgb,teamgbnm  from tblTeamGbInfo where DelYN = 'N' AND cd_type = 1 and pteamgb = 'D2' "
		Set rsa = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rsa.EOF Then
			fcd = rsa.GetRows()
		End If
	End if


	SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2 and delYN = 'N'  and sexno = '1'"
	Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)

	'Call rsdrow(rss)
	If Not rsb.EOF Then
	arrRSB = rsb.GetRows()
	End If

%>

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>대회구분</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">
									<select id="mk_g0" class="form-control" onchange="mx.setTeamGb()">
										<option value="D2" <%If e_CDA = "" Or e_CDA = "D2" then%>selected<%End if%>>생활체육</option>
										<option value="E2" <%If e_CDA = "E2" then%>selected<%End if%>>다이빙/수구</option>
										<option value="F2" <%If e_CDA = "F2" then%>selected<%End if%>>아티스틱스위밍</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<!-- <button type="button" class="btn btn-block btn-success  btn-flat" onclick="mx.gameList(<%=tidx%>)">타대회복사</button> -->
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
						<label>종목레벨/경기구분</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g1" class="form-control">
										<option value="I" <%If e_ITgubun = "" Or e_ITgubun = "I" then%>selected<%End if%>>T4</option>
										<option value="T" <%If e_ITgubun = "T" then%>selected<%End if%>>단체</option>
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;" onchange="mx.setBoo()">
								  <div class="form-group">
									<select id="mk_g2" class="form-control" >
										<option value="1" <%If e_Sexno = "" Or e_Sexno = "1" then%>selected<%End if%>>단체전</option>
										<option value="2" <%If e_Sexno = "2" then%>selected<%End if%>>여자</option>
										<option value="3" <%If e_Sexno = "3" then%>selected<%End if%>>혼성</option>
									</select>
								  </div>
							</div>
						</div>
				  </div>

  			  
				  <div class="form-group">
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

								  </div>
							</div>
						</div>
				  </div>
			
			</div>


            <div class="col-md-6">
				  <div class="form-group">
					<label>시군구</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" id="boo">

									<select id="mk_g3" class="form-control">
									<%
										If IsArray(arrRSB) Then 
											For ari = LBound(arrRSB, 2) To UBound(arrRSB, 2)
												l_CDB = arrRSB(0, ari)
												l_CDBNM = arrRSB(1,ari)
												%><option value="<%=l_CDB%>" <%If e_CDB = l_CDB then%>selected<%End if%>>서울 마포구</option><%
											Next
										End if
									%>
									</select>

									<!-- 
									 유년부의 부서가 달라져서 넣었으나 대한 채육회 정보와 틀려서 사용하지 않음 

									<select id="mk_g3" class="form-control">
										<%If KYN = "Y" then%>
										<option value="유년부(4학년이하부)" <%If e_CDBNM = "" Or e_CDBNM = "유년부(4학년이하부)" then%>selected<%End if%>>유년부(4학년이하부)</option>
										<option value="초등부" <%If e_CDBNM = "초등부" then%>selected<%End if%>>초등부</option>
										<option value="중등부" <%If e_CDBNM = "중등부" then%>selected<%End if%>>중등부</option>
										<option value="고등부" <%If e_CDBNM = "고등부" then%>selected<%End if%>>고등부</option>
										<option value="대학부" <%If e_CDBNM = "대학부" then%>selected<%End if%>>대학부</option>
										<option value="일반부" <%If e_CDBNM = "일반부" then%>selected<%End if%>>일반부</option>
										<%else%>
										<option value="유년부(1~4학년)" <%If e_CDBNM = "" Or e_CDBNM = "유년부(1~4학년)" then%>selected<%End if%>>유년부(1~4학년)</option>
										<option value="초등부(1~6학년)" <%If e_CDBNM = "초등부(1~6학년)" then%>selected<%End if%>>초등부(1~6학년)</option>
										<option value="초등부(5~6학년)" <%If e_CDBNM = "초등부(5~6학년)" then%>selected<%End if%>>초등부(5~6학년)</option>
										<option value="중등부" <%If e_CDBNM = "중등부" then%>selected<%End if%>>중등부</option>
										<option value="고등부" <%If e_CDBNM = "고등부" then%>selected<%End if%>>고등부</option>
										<option value="대학부" <%If e_CDBNM = "대학부" then%>selected<%End if%>>대학부</option>
										<option value="일반부" <%If e_CDBNM = "일반부" then%>selected<%End if%>>일반부</option>
										<%End if%>
									</select> -->
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group">

								  </div>
							</div>
						</div>
				  </div>

            </div>

            <div class="col-md-6">
				  <div class="form-group">
					<label>성별</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" id="boodetail">
									<select id="mk_g4" class="form-control">
										<%
											If IsArray(fcd) Then 
												fldcnt =  UBound(fcd, 2)
												For ari = LBound(fcd, 2) To UBound(fcd, 2)
													%><option value="<%=fcd(0, ari)%>" <%If e_CDC = fcd(0, ari) then%>selected<%End if%>>혼합</option><%
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
										<input type="hidden" id="mk_g5" value="<%=tidx%>">
										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(6);" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(6);" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>

            </div>




</div>