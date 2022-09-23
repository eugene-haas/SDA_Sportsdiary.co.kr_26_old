<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 10
	strTableName = " tblTotalBoard "
	strFieldName = "SEQ,TITLE,REGNAME,left(convert(varchar, REGDATE,121),11) REGDATE,VISIT,DelYN "

	strSort = "  order by seq desc"
	strSortR = "  order by seq"

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and CATE = '0'  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			F1_0 = F2(0)
			F1_2 = F2(1)

			If F1_2 = "" then
				strWhere = " DelYN = 'N' and CATE = '0' "	
			Else
				strWhere = " DelYN = 'N' and CATE = '0'  and TITLE Like '%"&F1_2&"%' "	
			End if

		End if
	End if

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	If Not rs.EOF Then
		arrR = rs.GetRows()
	End If

%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content" >
			<div class="page_title"><h1>이미지관리</h1></div>
			<div class="info_serch">
				<!-- s -->
					<div class="form-horizontal">

						<div class="form-group">
							<label class="col-sm-1 control-label">제목</label>
							<div class="col-sm-4">
								<input type="hidden" id="F1_0" value="">
								<input type="text" id="F1_1" class="form-control"  onkeydown="if(event.keyCode == 13){px.goSubmit( {'F1':[0,1],'F2':['',''],'F3':[]} , '<%=pagename%>');}" value="<%=F1_2%>">
							</div>

							<a href="javascript:px.goSubmit( {'F1':[0,1],'F2':['',''],'F3':[]} , '<%=pagename%>');" class="btn btn-primary">검색</a>
						</div>
					</div>

				<!-- e -->
			</div>
			<hr />

  <!-- s: 리스트 버튼 -->
  <div class="btn-toolbar" role="toolbar" aria-label="btns">
    <div class="btn-group flr">
      <a href="javascript:location.href='./homephotoWrite.asp'" id="gdmake" class="btn btn-primary">등록</a><!-- mx.makeGoods() -->
    </div>
  </div>
  <!-- e: 리스트 버튼 -->

		  <div class="btn-toolbar" role="toolbar" aria-label="btns"></div>

			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>No.</th>
								<th>제목</th>
								<th>작성자</th>
								<th>등록일</th>
								<th>조회수</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
			<%
			If IsArray(arrR) Then 
				For ari = LBound(arrR, 2) To UBound(arrR, 2)
				
				l_seq = arrR(0, ari)
				l_title = arrR(1, ari)
				l_REGNAME = arrR(2, ari)
				l_REGDATE = arrR(3, ari)
				l_VISIT = arrR(4, ari)
				%>

				<%
				If ci = "" Then
				ci = 1 
				End if
				list_no = (intPageSize * (intPageNum-1)) + ci
				'############################
				%>
				<tr id="titlelist_<%=l_seq%>">
					<td onclick="photoListGo('<%=l_seq%>','<%=intPageNum%>')" style="cursor:pointer;"><span><%'=l_seq%><%=l_seq%></span></td>
					<td onclick="photoListGo('<%=l_seq%>','<%=intPageNum%>')" style="cursor:pointer;"><span><%=l_title%></span></td>
					<td onclick="photoListGo('<%=l_seq%>','<%=intPageNum%>')" style="cursor:pointer;"><span><%=l_REGNAME%></span></td>
					<td onclick="photoListGo('<%=l_seq%>','<%=intPageNum%>')" style="cursor:pointer;"><%=l_REGDATE%></td>
					<td onclick="photoListGo('<%=l_seq%>','<%=intPageNum%>')" style="cursor:pointer;"><%=l_VISIT%></td>
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

		<script type="text/javascript">
		  function photoListGo(seq,page){
			location.href = "./homephotoView.asp?page="+page+"&seq="+seq;
		  }
		</script>