<%
If e_idx <> "" then
	PAGE_ENTERTYPE = e_EnterType
	%><input type="hidden" id="e_idx" value="<%=e_idx%>"><%
End if
%>
<input type= "hidden" id="mk_g0" value="F2">

<div class="row">
            <div class="col-md-6"><%'td%>
			  
				  <div class="form-group"><%'tr%>
						<label>난이도종목/하위카테고리</label>

						
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">

<%
'피겨 3개 솔로,듀엣,팀
'테크니컬 3개

'피겨 4라운드
'외 1라운드씩
%>

									<select id="mk_g1" class="form-control">
										<%'피켜 4라운드, 프리 1라운드%>
										<option value="" <%If  e_title = "" then%>selected<%End if%>>선택</option>
										<option value="01" <%If  e_title = "솔로(Solo)" then%>selected<%End if%>>솔로(Solo)</option>
										<option value="02" <%If  e_title = "듀엣(Duet)" then%>selected<%End if%>>듀엣(Duet)</option>
										<option value="03" <%If  e_title = "팀(Team)" then%>selected<%End if%>>팀(Team)</option>

										<%'테크니컬 1라운드, 프리 1라운드%>										
										<option value="04" <%If  e_title = "테크니컬 솔로" then%>selected<%End if%>>테크니컬 솔로</option>
										<option value="06" <%If  e_title = "테크니컬 듀엣" then%>selected<%End if%>>테크니컬 듀엣</option>
										<option value="12" <%If  e_title = "테크니컬 팀" then%>selected<%End if%>>테크니컬 팀</option>

										<%'동호인 프리만 1개 한다.%>
										<option value="05" <%If  e_title = "프리 솔로" then%>selected<%End if%>>프리 솔로</option>
										<option value="07" <%If  e_title = "프리 듀엣" then%>selected<%End if%>>프리 듀엣</option>
										<option value="11" <%If  e_title = "프리 팀" then%>selected<%End if%>>프리 팀</option>



<!-- 										<option value="08" <%If  e_title = "피겨(Figures)" then%>selected<%End if%>>피겨(Figures)</option> -->
<!-- 										<option value="09" <%If  e_title = "솔로(솔로/듀엣)" then%>selected<%End if%>>솔로(솔로/듀엣)</option> -->
<!-- 										<option value="10" <%If  e_title = "솔로(팀)" then%>selected<%End if%>>솔로(팀)</option> -->

<!-- 										<option value="13" <%If  e_title = "프리 콤비네이션" then%>selected<%End if%>>프리 콤비네이션</option> -->
									</select>

							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">

									<select id="mk_g6" class="form-control">
										<option value="-" <%If  e_title = "-" then%>selected<%End if%>>피겨,테크니컬 외 종목</option>
										<option value="테크니컬 고등부" <%If  e_title = "테크니컬 고등부" then%>selected<%End if%>>테크니컬 고등부</option>
										<option value="테크니컬  대학부" <%If  e_title = "테크니컬  대학부" then%>selected<%End if%>>테크니컬  대학부</option>
										<option value="테크니컬 일반부" <%If  e_title = "테크니컬 일반부" then%>selected<%End if%>>테크니컬 일반부</option>
										
										
										
										<option value="유년 규정종목1" <%If  e_title = "유년 규정종목1" then%>selected<%End if%>>유년 규정종목1</option>
										<option value="유년 규정종목2" <%If  e_title = "유년 규정종목2" then%>selected<%End if%>>유년 규정종목2</option>
										<option value="유년 지정종목 그룹1-3" <%If  e_title = "유년 지정종목 그룹1-3" then%>selected<%End if%>>유년 지정종목 그룹1-3</option>	
										<option value="유년 지정종목 그룹1-4" <%If  e_title = "유년 지정종목 그룹1-4" then%>selected<%End if%>>유년 지정종목 그룹1-4</option>	
										<option value="유년 지정종목 그룹2-3" <%If  e_title = "유년 지정종목 그룹2-3" then%>selected<%End if%>>유년 지정종목 그룹2-3</option>	
										<option value="유년 지정종목 그룹2-4" <%If  e_title = "유년 지정종목 그룹2-4" then%>selected<%End if%>>유년 지정종목 그룹2-4</option>	
										<option value="유년 지정종목 그룹3-3" <%If  e_title = "유년 지정종목 그룹3-3" then%>selected<%End if%>>유년 지정종목 그룹3-3</option>	
										<option value="유년 지정종목 그룹3-4" <%If  e_title = "유년 지정종목 그룹3-4" then%>selected<%End if%>>유년 지정종목 그룹3-4</option>	
										<option value="초등 규정종목1" <%If  e_title = "초등 규정종목1" then%>selected<%End if%>>초등 규정종목1</option>  	
										<option value="초등 규정종목2" <%If  e_title = "초등 규정종목2" then%>selected<%End if%>>초등 규정종목2</option>  	
										<option value="초등 지정종목 그룹1-3" <%If  e_title = "초등 지정종목 그룹1-3" then%>selected<%End if%>>초등 지정종목 그룹1-3</option>
										<option value="초등 지정종목 그룹1-4" <%If  e_title = "초등 지정종목 그룹1-4" then%>selected<%End if%>>초등 지정종목 그룹1-4</option>
										<option value="초등 지정종목 그룹2-3" <%If  e_title = "초등 지정종목 그룹2-3" then%>selected<%End if%>>초등 지정종목 그룹2-3</option>
										<option value="초등 지정종목 그룹2-4" <%If  e_title = "초등 지정종목 그룹2-4" then%>selected<%End if%>>초등 지정종목 그룹2-4</option>
										<option value="초등 지정종목 그룹3-3" <%If  e_title = "초등 지정종목 그룹3-3" then%>selected<%End if%>>초등 지정종목 그룹3-3</option>
										<option value="초등 지정종목 그룹3-4" <%If  e_title = "초등 지정종목 그룹3-4" then%>selected<%End if%>>초등 지정종목 그룹3-4</option>
										<option value="중등 규정종목1" <%If  e_title = "중등 규정종목1" then%>selected<%End if%>>중등 규정종목1</option>
										<option value="중등 규정종목2" <%If  e_title = "중등 규정종목2" then%>selected<%End if%>>중등 규정종목2</option>
										<option value="중등 지정종목 그룹1-3" <%If  e_title = "중등 지정종목 그룹1-3" then%>selected<%End if%>>중등 지정종목 그룹1-3</option>
										<option value="중등 지정종목 그룹1-4" <%If  e_title = "중등 지정종목 그룹1-4" then%>selected<%End if%>>중등 지정종목 그룹1-4</option>
										<option value="중등 지정종목 그룹2-3" <%If  e_title = "중등 지정종목 그룹2-3" then%>selected<%End if%>>중등 지정종목 그룹2-3</option>
										<option value="중등 지정종목 그룹2-4" <%If  e_title = "중등 지정종목 그룹2-4" then%>selected<%End if%>>중등 지정종목 그룹2-4</option>
										<option value="중등 지정종목 그룹3-3" <%If  e_title = "중등 지정종목 그룹3-3" then%>selected<%End if%>>중등 지정종목 그룹3-3</option>
										<option value="중등 지정종목 그룹3-4" <%If  e_title = "중등 지정종목 그룹3-4" then%>selected<%End if%>>중등 지정종목 그룹3-4</option>
									</select>

								  </div>
							</div>
						</div>

				  </div>

            </div><%'#####################################################################################가로 한줄%>

            <div class="col-md-6">
				  <div class="form-group">
					<label>난이도번호/난이도명</label>
						<div class="row">
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g2" placeholder="난이도번호" value="<%=e_code1%>" class="form-control" >
								  </div>
							</div>
							<div class="col-md-6" style="width:47%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="text" id="mk_g3" placeholder="난이도명" value="<%=e_code2%>" class="form-control" >
								  </div>
							</div>
						</div>
				  </div>
				  
			</div>

            <div class="col-md-6">
				  <div class="form-group">
					<label>난이도</label>
						<div class="row">
							<div class="col-md-6" style="width:97%;padding-left:10px;padding-right:0px;">
								  <div class="form-group">
										<input type="hidden" id="mk_g4"  value="-" ><!--빈값 안씀-->
										<input type="text" id="mk_g5" placeholder="난이도" value="<%=e_code4%>" class="form-control" >
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

										<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm(7);" accesskey="i">등록<span>(I)</span></a>
										<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm(7);" accesskey="e">수정<span>(E)</span></a>
										<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>


								  </div>
							</div>
							
					</div>
				  </div>


            </div>




</div>