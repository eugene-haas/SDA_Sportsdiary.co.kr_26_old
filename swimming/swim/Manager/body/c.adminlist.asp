<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################

	'Constr = B_ConStr
	TN = "tblAdminMember"

	Set db = new clsDBHelper

	'필드명들
'	SQL = "Select   c.name, c.xusertype, o.xtype  from sysobjects as o INNER JOIN syscolumns as c ON o.id = c.id Where o.xtype = 'u' and o.name = '"&TN&"' "
'	Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
'	If Not rs.EOF Then
'		arr = rs.GetRows()
'	End if

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
			<div class="page_title"><h1>계정관리</h1></div>


			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
					<div id="ul_1" class="form-horizontal">
						<div class="form-group">
							<%
							jsonstr = JSON.stringify(oJSONoutput)
							%>
							<div class="col-sm-2">
								<select id="F1" class="form-control">
									<option value="UserID" <%If F1 = "UserID" then%>selected<%End if%>>아이디</option>
									<option value="adminname"  <%If F1 = "adminname" then%>selected<%End if%>>이름</option>
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
				<!-- <div class="list_btn">
					<a href="#" class="" style="color:black;display:inline-block;width:200px;">계좌 사용량 : <%=vacUseCount%> / 45000</a>
					<a href="#" class="blue_btn" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
					<a href="#" class="blue_btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
					<a href="#" class="pink_btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
				</div> -->
			<!-- e: 리스트 버튼 -->

			<!-- s: 테이블 리스트 -->
				<div class="table-responsive">
					<table cellspacing="0" cellpadding="0" class="table table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>아이디</th>
								<th>이름</th>
								<th>작성일</th>
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
											<td><span><%=Left(rs("writedate"),10)%></span></td>
											<td><span><a href="javascript:mn.setBtnState('btn1_<%=rs(0)%>',<%=rs(0)%>,'<%= rs("USEYN") %>',10)" class="btn btn-fix-sm btn-warning" <%If rs("USEYN")="Y" then%>"<%End If%> id="btn1_<%=rs(0)%>"><%=rs("USEYN")%></a></span></td>
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
					'Call userPaginglink (intTotalPage, 10, PN, "px.goPN" )
				%>
			</nav>
			<!-- e: 더보기 버튼 -->

		</div>
		<!-- s: 콘텐츠 끝 -->
