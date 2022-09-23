<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 10
	strTableName = " tblPlayer_korea "
	strFieldName = " seq,ksportsno,regyear,UserName,engname,team,teamnm,Sex,ProfileIMG,Profile,DelYN,WriteDate,birthday,playeridx,teamgbnm,viewyn "

	strSort = "  order by seq desc"
	strSortR = "  order by seq"

	'search




	If chkBlank(F2) Then
		F2_0 = year(date)

		strWhere = " DelYN = 'N' and  regyear = '"&F2_0&"' "	
	Else
		If InStr(F2, ",") > 0  Then
			F2 = Split(F2, ",")
		End If

		If IsArray(F2) Then
			F2_0 = F2(0)
			F2_1 = F2(1)
			F2_2 = F2(2)


			If F2_1 <> "" Then
				sexfindstr = " and sex = '"&F2_1&"' "
			End if
			If F2_2 = "" Then
			strWhere = " DelYN = 'N' and regyear = '"&F2_0&"'  "&sexfindstr 	
			else
			strWhere = " DelYN = 'N' and regyear = '"&F2_0&"'  "&sexfindstr&"  and username  Like '%"&F2_2&"%' "	
			End if


		End if
	End if






	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

'Call getrowsdrow(arrr)


'REQ파일에서 파일 구분자로 사용
SENDPRE = "kor_"
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content" >
			<div class="page_title"><h1>국가대표소개</h1></div>
			<div class="info_serch form-horizontal" id="gameinput_area"><!-- s: 폼 -->
			  <!-- s -->
						<div class="form-group">
							<label class="col-sm-1 control-label">년도</label>
							<div class="col-sm-2">
								<select id="mk_g0" class="form-control">
								  <%For i = year(date) To 2019 Step -1 %>
								  <option value="<%=i%>" ><%=i%></option>
								  <%next%>
							  </select>
							</div>

							<label class="col-sm-1 control-label">선수명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="선수명" >
								<input type="hidden" id="mk_g2" value="0">
							</div>

							<label class="col-sm-1 control-label">영문명</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g3" class="form-control" placeholder="영문명" >
								</select>
							</div>
							<label class="col-sm-1 control-label">소속</label>
							<div class="col-sm-2">
								<input type="hidden" id="mk_g4" value="0">
								<input type="text" id="mk_g5" class="form-control" placeholder="소속" >
								</select>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-1 control-label">체육인번호</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g6" class="form-control" placeholder="체육인번호">
							</div>

							<label class="col-sm-1 control-label">성별</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g7" class="form-control" placeholder="성별" >
							</div>

							<label class="col-sm-1 control-label">생년월일</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g8" class="form-control" placeholder="생년월일" >
								</select>
							</div>
							<label class="col-sm-1 control-label">종목</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g9" class="form-control" placeholder="종목" >
								</select>
							</div>
						</div>


						<div class="btn-group flr" role="group" aria-label="...">
							<a href="#" class="btn btn-primary" id="btnsave" onclick="mx.input_frm('<%=SENDPRE%>');" accesskey="i">등록<span>(I)</span></a>
							<a href="#" class="btn btn-primary" id="btnupdate" onclick="mx.update_frm('<%=SENDPRE%>');" accesskey="e">수정<span>(E)</span></a>
							<a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm('<%=SENDPRE%>');" accesskey="r">삭제<span>(R)</span></a>
						</div>
			  <!-- e -->
			</div>


			<div class="info_serch">
				<!-- s -->
					<div class="form-horizontal">

						<div class="form-group">
							<label class="col-sm-1 control-label">년도/성별</label>
							<div class="col-sm-2">
								<div class="input-group" style="float:left;">
								<select id="F2_0" class="form-control">
								  <%For i = year(date) To 2019 Step -1%>
								  <option value="<%=i%>"  <%If Cstr(i) = Cstr(F2_0) then%>selected<%End if%>><%=i%></option>
								  <%next%>
							  </select>
							  </div>

							  <div class="input-group" style="float:left;">
								<select id="F2_1" class="form-control">
								  <option value="" <%If CStr(F2_1) = "" then%>selected<%End if%>>전체</option>
								  <option value="M" <%If CStr(F2_1) = "M" then%>selected<%End if%>>남</option>
								  <option value="W" <%If CStr(F2_1) = "W" then%>selected<%End if%>>여</option>
							  </select>
							  </div>							

							
							</div>
							<label class="col-sm-1 control-label">선수명</label>
							<div class="col-sm-2">
								<input type="text" id="F2_2" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1,2],'F2':[$('#F2_0').val(),$('#F2_1').val(),$('#F2_2').val()],'F3':[]} , '<%=pagename%>');}" value="<%=F1_2%>">
							</div>

							<a href="javascript:px.goSubmit( {'F1':[0,1,2],'F2':[$('#F2_0').val(),$('#F2_1').val(),$('#F2_2').val()],'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
						</div>
					</div>

				<!-- e -->
			</div>

			<hr />
		  <div class="btn-toolbar" role="toolbar" aria-label="btns"></div>



			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>No.</th>
								<th>이름</th>
								<th>성별</th>
								<th>생년월일</th>
								<th>소속</th>
								<th>종목</th>
								<th>사진</th>
								<th>프로필등록</th>
								<th>노출여부</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)

				l_seq= arrR(0, ari)
				l_ksportsno= arrR(1, ari)
				l_regyear= arrR(2, ari)
				l_UserName= arrR(3, ari)
				l_engname= arrR(4, ari)
				l_team= arrR(5, ari)
				l_teamnm= arrR(6, ari)
				l_Sex= arrR(7, ari)
				l_ProfileIMG= arrR(8, ari)
				l_Profile= arrR(9, ari)
				l_DelYN= arrR(10, ari)
				l_WriteDate= arrR(11, ari)
				l_birthday= arrR(12, ari)
				l_playeridx= arrR(13, ari)
				l_teamgbnm = arrR(14, ari)
				l_VIEWYN = arrR(15,ari)
				%>

				<%
				If ci = "" Then
				ci = 1 
				End if
				list_no = (intPageSize * (intPageNum-1)) + ci
				'############################
				%>
				<tr id="titlelist_<%=l_seq%>">
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%=l_seq%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%=l_UserName%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%=l_Sex%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_birthday%></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_teamnm%></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_teamgbnm%></td>
					
					<td>
					<span>
					<%If l_FILE_NAME = "" then%>
					<a href="javascript:mx.fileuploadPop(2,<%=l_seq%>,'<%=SENDPRE%>')" class="btn btn-default">파일업로드</a>
					<%else%>
					<a href="javascript:mx.fileuploadPop(2,<%=l_seq%>,'<%=SENDPRE%>')" class="btn btn-primary"><%=l_FILE_NAME%></a>
					<%End if%>
					</span>
					</td>

					<td>
					<a href="javascript:mx.editor(<%=l_seq%>,'<%=l_UserName%>','<%=SENDPRE%>')" class="btn btn-primary">프로필등록</a>					
					</td>
					
					<td>
						<label class="switch" title="노출여부" >
						<input type="checkbox" id="tbl_<%=l_seq%>"  value="<%=l_VIEWYN%>" <%If l_VIEWYN= "Y" then%>checked<%End if%> onclick="mx.setBtnState('tbl_<%=l_seq%>',<%=l_seq%>,2,'<%=SENDPRE%>')">
						<span class="slider round"></span>
						</label>			
					</td>
				</tr>

				<%
				'############################
				ci = ci + 1
				Next
				End if
				%>


					</tbody>
				</table>
			</div>
			<!-- e: 테이블 리스트 -->

			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>
		</div>
		<!-- s: 콘텐츠 끝 -->
