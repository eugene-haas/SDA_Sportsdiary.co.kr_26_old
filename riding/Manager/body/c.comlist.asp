<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 10
	strTableName = " tblSimpleBoard "
	strFieldName = "SEQ,CATE,TITLE,FILE_PATH,FILE_NAME,VIEWYN,TOPDATE,REGDATE,DELYN "

	strSort = "  order by seq desc"
	strSortR = "  order by seq"

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and CATE = '5'  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			F1_0 = F2(0)
			F1_2 = F2(1)

			If F1_2 = "" then
				strWhere = " DelYN = 'N' and CATE = '5' "	
			Else
				strWhere = " DelYN = 'N' and CATE = '5'  and TITLE Like '%"&F1_2&"%' "	
			End if

		End if
	End if




	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If



'REQ파일에서 파일 구분자로 사용
SENDPRE = "comlist_"
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content" >
			<div class="page_title"><h1>경영공시</h1></div>
			<div class="info_serch form-horizontal" id="gameinput_area"><!-- s: 폼 -->
			  <!-- s -->
						<%
							If e_idx <> "" then
								%><input type="hidden" name="e_id" id="e_idx" value="<%=e_idx%>"><%
							End If
						%>
						<div class="form-group">
							<label class="col-sm-1 control-label">구분</label>
							<div class="col-sm-2">
								<select id="mk_g0" class="form-control">
								  <option value="5" <%If CStr(e_CATE) = "5" then%>selected<%End if%>>경영공시</option>
							  </select>
							</div>

							<label class="col-sm-1 control-label">제목</label>
							<div class="col-sm-2">
								<input type="text" id="mk_g1" class="form-control" placeholder="제목" value="<%=e_title%>" >
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
							<label class="col-sm-1 control-label">구분</label>
							<div class="col-sm-2">
								<div class="input-group">
								<select id="F1_0" class="form-control">
								  <option value="" <%If CStr(F1_0) = "" then%>selected<%End if%>>전체</option>
								  <option value="5" <%If CStr(F1_0) = "5" then%>selected<%End if%>>경영공시</option>
							  </select>
							  </div>
							</div>

							<div class="col-sm-2">
								<input type="text" id="F1_1" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1],'F2':['',''],'F3':[]} , '<%=pagename%>');}" value="<%=F1_2%>">
							</div>

							<a href="javascript:px.goSubmit( {'F1':[0,1],'F2':['',''],'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
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
								<th>구분</th>
								<th>제목</th>
								<th>등록일</th>
								<th>파일</th>
								<th>노출여부</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
				
				l_seq = arrR(0, ari)
				l_cate = arrR(1, ari)
				l_title = arrR(2, ari)
				l_FILE_PATH = arrR(3, ari)
				l_FILE_NAME = isnulldefault(arrR(4, ari),"")
				l_VIEWYN = arrR(5, ari)
				l_TOPDATE = arrR(6, ari)
				l_REGDATE = arrR(7, ari)
				%>

				<%
				If ci = "" Then
				ci = 1 
				End if
				list_no = (intPageSize * (intPageNum-1)) + ci
				'############################
				%>
				<tr id="titlelist_<%=l_seq%>">
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%'=l_seq%><%=l_seq%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%=l_cate%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><span><%=l_title%></span></td>
					<td onclick="mx.input_edit(<%=l_seq%>,'<%=SENDPRE%>')"><%=l_regdate%></td>
					<td>
					<%If l_FILE_NAME = "" then%>
					<a href="javascript:mx.fileuploadPop(1,<%=l_seq%>,'<%=SENDPRE%>')" class="btn btn-default">파일업로드</a>
					<%else%>
					<a href="javascript:mx.fileuploadPop(1,<%=l_seq%>,'<%=SENDPRE%>')" class="btn btn-primary"><%=l_FILE_NAME%></a>
					<%End if%>
					</span></td>
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
