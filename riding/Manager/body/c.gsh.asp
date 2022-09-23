<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 10


	strTableName = " tblTotalBoard as a "
	strFieldName = " SEQ,CATE,TITLE,CONTENTS,REGDATE,MODDATE,REGID,REGNAME,VISIT,viewyn,(select top 1 FILENAME from tblTotalBoard_File b where a.SEQ = b.TotalBoard_SEQ and b.delyn = 'N') as photo,url,target,sdate,edate,place,attsdate,attedate,  syear,smonth,hostname,subjectnm "

	strSort = "  order by seq desc"
	strSortR = "  order by seq"

	'search
	If chkBlank(F2) Then
		strWhere = " a.DelYN = 'N' and  a.cate = 55 "	
	Else
		strWhere = " a.DelYN = 'N' and  a.cate = 55 and a.title Like '%"&F2&"%' "	
	End if



	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

'Call getrowsdrow(arrr)

'REQ파일에서 파일 구분자로 사용
SENDPRE = "shortcourse_"
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content" >
			<div class="page_title"><h1>강습회생성</h1></div>
			<div class="info_serch form-horizontal" id="gameinput_area"><!-- s: 폼 -->
			  <!-- s -->
						<div class="form-group">
							<label class="col-sm-1 control-label">제목</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g0" class="form-control" placeholder="제목" value="<%=e_title%>" >
							</div>

							<label class="col-sm-1 control-label">장소</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="장소" value="<%=e_place%>" >
							</div>
							<label class="col-sm-1 control-label">주최/주관</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g2" class="form-control" placeholder="주최" value="<%=e_hostname%>" >
							</div>
							<label class="col-sm-1 control-label">후원</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g3" class="form-control" placeholder="후원" value="<%=e_subjectnm%>" >
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
							<label class="col-sm-1 control-label">참가시작</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g6"  value="<%=e_GameE%>"  class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
									<span class="input-group-addon">
										<span class="glyphicon glyphicon-calendar"></span>
									</span>
								</div>				
							</div>
							<label class="col-sm-1 control-label">참가종료</label>
							<div class="col-sm-2">
								<div class='input-group date'>
									<input type="text" id="mk_g7"  value="<%=e_GameE%>"  class="form-control"  onkeyup="this.value=this.value.replace(/[^0-9]-/g,'');">
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
								<th>장소</th>
								<th>시작일</th>
								<th>종료일</th>
								<th>첨부파일</th>
								<th>신청목록</th>
								<th>노출여부</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
				l_SEQ = arrR(0, ari)
				l_CETE = arrR(1, ari)
				l_TITLE = arrR(2, ari)
				l_CONTENTS = arrR(3, ari)
				l_REGDATE = arrR(4, ari)
				l_MODDE = arrR(5, ari)
				l_REGID = arrR(6, ari)
				l_REGNE = arrR(7, ari)
				l_VISIT = arrR(8, ari)
				l_VIEWYN = arrR(9,ari)
				l_FILENAME = isnulldefault(arrR(10, ari),"")
				l_URL = arrR(11,ari)
				l_target = arrR(12,ari)

				l_sdate = arrR(13,ari)
				l_edate = arrR(14,ari)
				l_place = arrR(15,ari)

				l_attsdate = arrR(16,ari)
				l_attedate = arrR(17,ari)
				l_syear = arrR(18,ari)
				l_smonth = arrR(19,ari)
				l_hostname = arrR(20,ari)
				l_subjectnm = arrR(21,ari)
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
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%=l_place%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_sdate%></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_edate%></td>

					<td>
					<%If l_FILENAME = "" then%>
					<a href="javascript:mx.fileuploadPop(1,<%=l_seq%>,'<%=SENDPRE%>')" class="btn btn-default">파일업로드</a>
					<%else%>
					<a href="javascript:mx.fileuploadPop(1,<%=l_seq%>,'<%=SENDPRE%>')" class="btn btn-primary"><%=LCase(Mid(l_FILENAME, InStrRev(l_FILENAME, "/") + 1))%></a>
					<%End if%>
					</span>
					</td>
					<!-- <td>
					<a href="javascript:mx.editor(<%=l_seq%>,'<%=l_UserName%>','<%=SENDPRE%>')" class="btn btn-primary">팝업내용등록</a>					
					</td> -->
					
					<td>
					<a href="javascript:mx.Pop(1,<%=l_seq%>,'<%=SENDPRE%>')" class="btn btn-default">신청목록</a>
					</span>
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
