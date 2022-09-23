<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################




	'필드명들
	TN = "tbladminmenulist"
	'SQL = "Select   c.name, c.xusertype, o.xtype  from sysobjects as o INNER JOIN syscolumns as c ON o.id = c.id Where o.xtype = 'u' and o.name = '"&TN&"' "
	'Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)
	'Call rsdrow(rs)
	'Response.end
	'If Not rs.EOF Then
	'	arr = rs.GetRows()
	'End if

	IDXFIELDNM = "AdminMenuListIDX"
	intPageSize = 10
	intPageNum = PN
	strTableName = TN
	strFieldName = " AdminMenuListIDX,RoleDepth,RoleDetail,RoleDetailNm,RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,RoleDetailGroup2Nm,Link,PopupYN,UseYN,DelYN,WriteDate,WriteID,ModDate,ModID,Authority "

	strSort = "  order by AdminMenuListIDX desc"
	strSortR = "  order by AdminMenuListIDX asc"

	If F1 <> "" And F2 <> "" Then
		Select Case F1
		Case "1" : findfield = "RoleDetailGroup1Nm"
		Case "2" : findfield = "RoleDetailGroup2Nm"
		Case "3" : findfield = "RoleDetailNm"
	End Select

		If findfield = "" Then
			strWhere = " DelYN = 'N' and RoleDepth = 3 and sitecode= '"&sitecode&"' "
		else
			strWhere =  " " & findfield & " like '%" & F2 & "%' and DelYN = 'N' and RoleDepth = 3  and sitecode= '"&sitecode&"'  "
		End if
	else
		strWhere = " DelYN = 'N' and RoleDepth = 3  and sitecode= '"&sitecode&"' "
	End if

	Set rs = GetBBSSelectRS( B_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

   ' SQL = "EXEC AdminMenu_S '" & pagename & "','" & block_size & "','" & block_size & "','" & iType & "','" & iSearchCol & "','" & iSearchText & "','" & iLoginID & "','','','','',''"
	'Set rs = db.ExecSQLReturnRS(SQL , null, B_ConStr)

'Call rsdrow(rs)


%>
<%'View ####################################################################################################%>

		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>메뉴관리</h1></div>


			<!-- s: 정보 검색 -->
			<div class="info_serch" id="gameinput_area">
				<div id="ul_1" class="form-horizontal">
					<div class="form-group">
						<%
						jsonstr = JSON.stringify(oJSONoutput)
						%>
						<div class="col-sm-2">
							<select id="F1" class="form-control">
								<option value="1" <%If F1 = "1" then%>selected<%End if%>>대메뉴</option>
								<option value="2"  <%If F1 = "2" then%>selected<%End if%>>중메뉴</option>
								<option value="3"  <%If F1 = "3" then%>selected<%End if%>>소메뉴</option>
							</select>
						</div>
						<div class="col-sm-3">
							<div class="input-group">
								<input type="text" maxlength="20" class="form-control"  id="F2"  onkeydown='if(event.keyCode == 13){px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())}' value="<%=F2%>">
								<div class="input-group-btn">
									<a href='javascript:px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())' class="btn btn-default">검색</a>
								</div>
							</div>
						</div>
						<div class="col-sm-1">
							<a href="javascript:mn.writePop('modalS',1)" href="tablehelp.asp" class="btn btn-primary">메뉴등록</a>&nbsp;
						</div>

					</div>
				</div>
			</div>
			<!-- e: 정보 검색 -->

			<hr />
			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
							<th>번호</th>
							<th>대메뉴</th>
							<th>중메뉴</th>
							<th>소메뉴</th>
							<th>경로</th>
							<th>작성일</th>
							<th>생성자</th>
							<th>팝업</th>
							<th>사용</th>
							<th>등급</th>
								<%If Cookies_AUTH = "A" Then '최고등급이라면 삭제 가능%>
									<th>삭제</th>
								<%End if%>
						</tr>
					</thead>
					<tbody id="contest">

      						<%
      						Do Until rs.eof

							c_AdminMenuListIDX = rs("AdminMenuListIDX")
							seq = c_AdminMenuListIDX
							c_RoleDepth = rs("RoleDepth") '3
							c_RoleDetail = rs("RoleDetail")
							c_RoleDetailNm = rs("RoleDetailNm")
							c_RoleDetailGroup1 = rs("RoleDetailGroup1") '첫번째그룹
							c_RoleDetailGroup1Nm = rs("RoleDetailGroup1Nm") '첫번째 그룹명
							c_RoleDetailGroup2 = rs("RoleDetailGroup2")
							c_RoleDetailGroup2Nm = rs("RoleDetailGroup2Nm")
							c_Link = rs("Link")
							c_PopupYN = rs("PopupYN")
							c_UseYN = rs("UseYN")
							c_DelYN = rs("DelYN")
							c_WriteDate = rs("WriteDate")
							c_WriteID = rs("WriteID")
							c_ModDate = rs("ModDate")
							c_ModID = rs("ModID")
							c_Authority = rs("Authority")
							%>
									<tr id="line1_<%=seq%>">
										<td><span><%=c_AdminMenuListIDX%></span></td>
										<td><span><%=c_RoleDetailGroup1Nm%></span></td>
										<td><span><%=c_RoleDetailGroup2Nm%></span></td>
										<td><span><input type='text' id="txt2_<%=seq%>" value="<%=c_RoleDetailNm%>" class="form-control" onchange="mn.setTXT('txt2_<%=seq%>',<%=seq%>,this.value,1)"></span></td>
										<td><span><input type='text' id="txt1_<%=seq%>" value="<%=c_link%>" class="form-control" onchange="mn.setTXT('txt1_<%=seq%>',<%=seq%>,this.value,0)"></span></td>
										<td><span><%=Left(c_WriteDate,10)%></span></td>
										<td><span><%=c_WriteID%></span></td>
										<td><span><a href="javascript:mn.setBtnState('btn1_<%=seq%>',<%=seq%>,'<%= c_PopupYN %>',0)"  <%If c_PopupYN="Y" then%> class="btn btn-fix-sm btn-primary"<%Else%>class="btn btn-fix-sm btn-warning"<%End If%>  id="btn1_<%=seq%>"><%=c_PopupYN%></a></span></td>
										<td><span><a href="javascript:mn.setBtnState('btn2_<%=seq%>',<%=seq%>,'<%= c_UseYN %>',1)" <%If c_UseYN="Y" then%> class="btn btn-fix-sm btn-primary"<%Else%>class="btn btn-fix-sm btn-warning"<%End If%> id="btn2_<%=seq%>"><%=c_UseYN%></a></span></td>
										<td><span><%=c_Authority%></span></td>
										<%If Cookies_AUTH = "A" Then '최고등급이라면 삭제 가능%>
										<td><span><a href="javascript:mn.delLine('line1_<%=seq%>',<%=seq%>,1)" class="btn btn-danger">삭제</a></span></td>
										<%End if%>
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
