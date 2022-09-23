<%
If e_idx <> "" then
	PAGE_ENTERTYPE = e_EnterType
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
Else
	'아마추어용 선수번호를 만들자..
	If PAGE_ENTERTYPE = "A" Then

		SQL = "select max(kskey) from tblPlayer  where entertype='A'  "
		Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
		If isNull(rss(0)) = true Then
			e_ksportsno = "AP0000000001"
		Else
			tno = CDbl(Mid(rss(0), 3)) + 1
			e_ksportsno = "AP"
			For z = 1 To 10 - Len(tno)
				e_ksportsno = e_ksportsno & "0"
			Next 
			e_ksportsno = e_ksportsno & tno
		End If

	End if

End If

SQL = "Select sido,sidonm from tblSidoInfo where DelYN = 'N' "
Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

If Not rss.EOF Then
arrRS = rss.GetRows()
End If


SQL = " select cd_boo,cd_booNM from tblteamgbinfo where cd_type = 2  and delYN = 'N'  "
Set rsb = db.ExecSQLReturnRS(SQL , null, ConStr)

'Call rsdrow(rss)
If Not rsb.EOF Then
arrRSB = rsb.GetRows()
End If




If PAGE_ENTERTYPE = "" Then
	PAGE_ENTERTYPE = "E"
End if
%>
<input type="hidden" id="entertype" value="<%=PAGE_ENTERTYPE%>">

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>선수번호/등록</label>
						<div class="row">

							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g0" placeholder="선수번호" value="<%=e_ksportsno%>" class="form-control" <%If e_idx <> "" Or PAGE_ENTERTYPE = "A" then%>readonly<%End if%>>
								  </div>
							</div>


							
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<%If PAGE_ENTERTYPE = "A" then%>
										<input type="hidden" id="mk_g1"  value="<%=e_ksportsnoS%>" >
										<input type="text" id="nowyear" placeholder="등록년도" value="<%=e_nowyear%>" class="form-control" >
										<%else%>
										<input type="text" id="mk_g1" placeholder="최초등록번호" value="<%=e_ksportsnoS%>" class="form-control" <%If e_idx <> "" then%>readonly<%End if%>>
										<%End if%>
								  </div>
							</div>

						</div>
				  </div>

				  <div class="form-group">
					<label>국가/시도</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g7" placeholder="국적입력" value="<%=e_nation%>" class="form-control">
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g8" class="form-control" >
									<%
										If IsArray(arrRS) Then 
											For ari = LBound(arrRS, 2) To UBound(arrRS, 2)
												l_sido = arrRS(0, ari)
												l_sidonm = arrRs(1,ari)
												%><option value="<%=l_sido%>" <%If CStr(isNulldefault(e_sido,"")) = CStr(isNulldefault(l_sido,"")) then%>selected<%End if%>><%=l_sidonm%></option><%
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
						<label>한글/한문</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g2" placeholder="이름" value="<%=e_UserName%>" class="form-control">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g3" placeholder="한문이름" value="<%=e_userNameCn%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>종목/종별</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g9" class="form-control">
										<option value="D2" <%If e_CDA = "D2" then%>selected<%End if%>>경영</option>
										<option value="E2" <%If e_CDA = "E2" then%>selected<%End if%>>다이빙/수구</option>
										<option value="F2" <%If e_CDA = "F2" then%>selected<%End if%>>아티스틱스위밍</option>
									</select>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<select id="mk_g10" class="form-control" >
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

				  
			</div>





            <div class="col-md-6">
				  <div class="form-group">
					<label>영문명/생년월일</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g4" placeholder="영문이름" value="<%=e_userNameEn%>" class="form-control">
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
									<input type="text" id="mk_g5" placeholder="생년월일" value="<%=e_Birthday%>" class="form-control">
								  </div>
							</div>
						</div>
				  </div>

				  <div class="form-group">
					<label>소속(학년)/팀코드</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<div class="input-group">
											<input type="text" id="mk_g11" placeholder="소속 명" value="<%=e_teamnm%>" class="form-control" >   <!--onclick="mx.getTeamFind('<%=PAGE_ENTERTYPE%>','')"-->
											
											<div class="input-group-addon" style="padding:0px;">
												<select id="mk_g12"  style="height:32px;">
													<option value="1" >1</option>
													<option value="2">2</option>
													<option value="3">3</option>
													<option value="4">4</option>
													<option value="5">5</option>
													<option value="6">6</option>
												</select>
											</div>
										</div>
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g13" placeholder="소속코드" value="<%=e_team%>" class="form-control" readonly>
								  </div>
							</div>
						</div>
				  </div>

            </div>

            <div class="col-md-6">
				  <div class="form-group">
					<label>성별</label>
					<div class="row">
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
									<select id="mk_g6" class="form-control" >
										<option value="1" <%If e_Sex = "1" then%>selected<%End if%>>남자</option>
										<option value="2" <%If e_Sex = "2" then%>selected<%End if%>>여자</option>
									</select>
							  </div>
						</div>
						<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
							  <div class="form-group">
								&nbsp;
							  </div>
						</div>
					</div>
				  </div>

				  <div class="form-group">
					<label>&nbsp;</label>
						<div class="row">
							<div class="col-md-6" style="width:100%;">
								  <div class="form-group" style="text-align:right;">

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(14);" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(14);" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
						</div>
				  </div>



            </div>




</div>