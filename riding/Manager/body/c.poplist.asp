<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 10
	strTableName = " tblPopup "
	strFieldName = " seq,title,url,target,sdate,edate,viewyn "

	strSort = "  order by seq desc"
	strSortR = "  order by seq"

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  "	
	Else
		strWhere = " DelYN = 'N' and title Like '%"&F2&"%' "	
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

'Call getrowsdrow(arrr)

'REQ파일에서 파일 구분자로 사용
SENDPRE = "pop_"
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content" >
			<div class="page_title"><h1>팝업관리</h1></div>
			<div class="info_serch form-horizontal" id="gameinput_area"><!-- s: 폼 -->
			  <!-- s -->
						<div class="form-group">
							<label class="col-sm-1 control-label">제목</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g0" class="form-control" placeholder="제목" value="<%=e_title%>" >
							</div>

							<label class="col-sm-1 control-label">URL</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="URL" value="<%=e_gameURL%>" >
							</div>
							<label class="col-sm-1 control-label">Target</label>
							<div class="col-sm-2">
								<select id="mk_g2" class="form-control">
									<option value="_blank">_blank</a>
									<option value="_blank">_self</a>
								</select>
								<input type="hidden" id="mk_g3" class="form-control" value="N" ><!-- 갯수체울려고 넣은 빈값 -->
							</div>
						</div>

						<div class="form-group">
							<label class="col-sm-1 control-label">시작일</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g4" value="<%=e_GameS%>" class="form-control" onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>
							</div>
							<label class="col-sm-1 control-label">종료일</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g5"  value="<%=e_GameE%>"  class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>				
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
							<label class="col-sm-1 control-label">제목</label>
							<div class="col-sm-2">
								<input type="hidden" id="F1" value="title">
								<input type="text" id="F2" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':#('#F1').val(),'F2':#('#F2').val()} , '<%=pagename%>');}" value="<%=F1_2%>">
							</div>

							<a href="javascript:px.goSubmit( {'F1':#('#F1').val(),'F2':#('#F2').val()} , '<%=pagename%>');" class="btn btn-primary">검색</a>
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
								<th>제목</th>
								<th>대상URL</th>
								<th>시작일</th>
								<th>종료일</th>
								<th>내용</th>
								<th>노출여부</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
				l_seq= arrR(0, ari)
				l_title= arrR(1, ari)
				l_url= arrR(2, ari)
				l_target= arrR(3, ari)
				l_sdate= arrR(4, ari)
				l_edate= arrR(5, ari)
				l_VIEWYN = arrR(6,ari)
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
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%=l_title%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><a href="<%=l_url%>" target="<%=l_target%>"><%=l_url%></a></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_sdate%></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_edate%></td>
					<td>
					<a href="javascript:mx.editor(<%=l_seq%>,'<%=l_UserName%>','<%=SENDPRE%>')" class="btn btn-primary">팝업내용등록</a>					
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
