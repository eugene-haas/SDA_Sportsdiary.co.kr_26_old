<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################

	'Constr = B_ConStr
	TN = "tblAdminMember"

	Set db = new clsDBHelper

	IDXFIELDNM = "AdminMemberIDX"
	intPageSize = 20
	intPageNum = PN
	strTableName = TN
	strFieldName = " * "

	strSort = "  order by " & IDXFIELDNM & " desc"
	strSortR = "  order by " & IDXFIELDNM

	If F1 <> "" And F2 <> "" Then
		strWhere =  " SiteCode = '"&SiteCode&"' and " & F1 & " like '%" & F2 & "%'  "
	else
		strWhere = " SiteCode = '"&SiteCode&"' "
	End if

	Set rs = GetBBSSelectRS( B_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10
%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1><a href="index.asp" class="btn btn-primary">홈으로</a></h1>  </div>

			<!-- s: 테이블 리스트 -->
				<div class="table-responsive">
					<table cellspacing="0" cellpadding="0" class="table table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>아이디</th>
								<th>이름</th>
								<th>사용유무</th>
								<th>수정</th>
							</tr>
						</thead>
						<tbody id="contest">
        						<%
        						Do Until rs.eof
								%>
										<tr>
											<td><span><%=rs(0)%></span></td>
											<td><span><%=rs("UserID")%></span></td>
											<td><span><%=rs("adminname")%></span></td>
											<td><span><a href="javascript:mn.setBtnState('btn1_<%=rs(0)%>',<%=rs(0)%>,'<%= rs("USEYN") %>',10)" <%If rs("USEYN")="Y" then%>class="btn btn-primary"<%else%>class="btn btn-fix-sm btn-warning"<%End If%> id="btn1_<%=rs(0)%>"><%=rs("USEYN")%></a></span></td>
											<td><span><a href="javascript:mn.writePop('modalS',2, <%=rs(0)%>)" class="btn btn-primary">등급[<%=rs("Authority")%>] 수정 </a></span></td>
										</tr>

								<%
        						rs.movenext
        						Loop
        						Set rs = Nothing
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
