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
					<ul id="ul_1">
						<li>
						<%
						jsonstr = JSON.stringify(oJSONoutput)
						%>
						<select id="F1" class="sl_search" style="margin-right:3px;"> 
							<option value="UserID" <%If F1 = "UserID" then%>selected<%End if%>>아이디</option>
							<option value="adminname"  <%If F1 = "adminname" then%>selected<%End if%>>이름</option>
						</select>
						<input type="text" maxlength="20" id="F2" class="in_txt" onkeydown='if(event.keyCode == 13){px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())}' value="<%=F2%>">
						<a  href='javascript:px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())' class="search_btn"  style="margin-right:3px;">검색</a>
						<a href="javascript:mn.writePop('modalS',2)" class="search_btn">어드민등록</a>&nbsp;
						</li>
					</ul>
				</div>
			<!-- e: 정보 검색 -->

			<!-- s: 리스트 버튼 -->
				<!-- <div class="list_btn">
					<a href="#" class="" style="color:black;display:inline-block;width:200px;">계좌 사용량 : <%=vacUseCount%> / 45000</a>
					<a href="#" class="blue_btn" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
					<a href="#" class="blue_btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
					<a href="#" class="pink_btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
				</div> -->
			<!-- e: 리스트 버튼 -->



			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tr>
   							<th style="width:20%;">번호</th><th style="width:10%;">아이디</th><th>이름</th><th style="width:20%;">작성일</th><th style="width:20%;">사용유무</th><th style="width:20%;">수정</th>
							<!-- <th>번호</th><th>대회명</th><th>기간</th><th>노출</th><th>계좌정리<br/></th><th>상세</th><th>요강</th><th>랭킹반영</th> -->
						</tr>
						<tbody id="contest">
        						<%
        						Do Until rs.eof
								%>
										<tr>
											<td class="date"><span><%=rs(0)%></span></td>
											<td class="name"><span><%=rs("UserID")%></span></td>
											<td class="name"><%=rs("adminname")%><span></span></td>
											<td><%=Left(rs("writedate"),10)%></td>

											<td class="g_btn green_btn1">
											<a href="javascript:mn.setBtnState('btn1_<%=rs(0)%>',<%=rs(0)%>,'<%= rs("USEYN") %>',10)" class="name_btn" <%If rs("USEYN")="Y" then%>style="background-color:#FF7F27;"<%End If%> id="btn1_<%=rs(0)%>"><%=rs("USEYN")%></a>
											</td>

											<td class="g_btn green_btn1"><a href="javascript:mn.writePop('modalS',2, <%=rs(0)%>)" class="name_btn">등급[<%=rs("Authority")%>] 수정 </a></td>
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
			<div class="paging">
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT (intTotalPage, 10, PN, "px.goPN", jsonstr )
					'Call userPaginglink (intTotalPage, 10, PN, "px.goPN" )
				%>
			</div>
			<!-- e: 더보기 버튼 -->		

		</div>
		<!-- s: 콘텐츠 끝 -->


