<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################
	Set db = new clsDBHelper

	If PN = "" Then
		PN = 1
	End if

	tid = 1
	intPageSize = 20
	block_size = 10
	intPageNum = PN
	strTableName = "tblBoard"
	strFieldName = " seq,tid,uid,ip,title,contents,readnum,writeday,num,ref,re_step,re_level,filename,pubshow,topshow,bestshow "

	strSort = "  order by seq desc"
	strSortR = "  order by seq "

	If F1 <> "" And F2 <> "" Then
		strWhere =  " tid = 1 and delYN = 'N' and " & F1 & " like '%" & F2 & "%'  "
	else
		strWhere = " tid = " & tid
	End if

	Set rs = GetBBSSelectRS( B_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	if rs.eof Then
		arrRS = ""
	Else
		Set rsdic = Server.CreateObject("Scripting.Dictionary") '필드명으로 찾기
		For i = 0 To Rs.Fields.Count - 1
			rsdic.Add LCase(Rs.Fields(i).name), i
		Next
		arrRS = rs.getrows()
	end if
	set rs = Nothing
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>공유게시판</h1></div>

			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
					<div id="ul_1" class="form-horizontal">
						<div class="form-group">
							<%
							jsonstr = JSON.stringify(oJSONoutput)
							%>
							<div class="col-sm-2">
								<select id="F1" class="form-control">
									<option value="UserID" <%If F1 = "UserID" then%>selected<%End if%>>제목</option>
									<option value="adminname"  <%If F1 = "adminname" then%>selected<%End if%>>본문</option>
								</select>
							</div>

							<div class="col-sm-3">
								<div class="input-group">
									<input type="text" maxlength="20" id="F2" class="form-control" onkeydown='if(event.keyCode == 13){px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())}' value="<%=F2%>">
									<div class="input-group-btn">
										<a  href='javascript:px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())' class="btn btn-default">검색</a>
									</div>
								</div>
							</div>
							<div class="col-sm-1">
								<a href="javascript:mn.writePop('modalS',2)" class="btn btn-primary">어드민등록</a>
							</div>

						</div>
					</div>
				</div>
			<!-- e: 정보 검색 -->

			<hr />

			<!-- s: 리스트 버튼 -->
				<div class="btn-toolbar" role="toolbar" aria-label="btns">
						<div class="btn-group flr">
							<a href="javascript:mx.editor(0,<%=tid%>,<%=PN%>)" id="gdmake" class="btn btn-primary" accesskey="i">등록<span>(I)</span></a>
							<a href="javascript:mx.update_frm();" id="gdmake" class="btn btn-primary" accesskey="e">수정<span>(E)</span></a>
							<a href="javascript:mx.del_frm();" id="gdmake" class="btn btn-danger" accesskey="r">삭제<span>(R)</span></a>
						</div>
				</div>
			<!-- e: 리스트 버튼 -->

			<!-- s: 테이블 리스트 -->
				<div class="table-responsive">
					<table cellspacing="0" cellpadding="0" class="table table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>아이디</th>
								<th>제목</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody id="contest">
						<%
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
							num = arrRS(rsdic.Item("num"), ar)
							seq = arrRS(rsdic.Item("seq"), ar)
							uid = arrRS(rsdic.Item("uid"), ar)
							title = arrRS(rsdic.Item("title"), ar)
							contents = htmlDecode(arrRS(rsdic.Item("contents"), ar))
							writeday = arrRS(rsdic.Item("writeday"), ar)
						%>
										<tr onclick="mx.input_edit(<%=num%>,'<%=f_enc(seq)%>',<%=tid%>,<%=pn%>)" id="titlelist_<%=num%>">
											<td><span><%=seq%></span></td>
											<td><span><%=uid%></span></td>
											<td><span><%=title%></span></td>
											<td><span><%=Left(writeday,10)%></span></td>
										</tr>
						<%
						Next
						Set rsdic = Nothing
						%>
						</tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->



			<!-- s: 더보기 버튼 -->
			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>
			<!-- e: 더보기 버튼 -->
		</div>
		<!-- s: 콘텐츠 끝 -->