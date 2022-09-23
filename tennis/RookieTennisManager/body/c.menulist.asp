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
				<div class="search_top" id="gameinput_area">
					<ul id="ul_1">
						<li>
						<%
						jsonstr = JSON.stringify(oJSONoutput)
						%>
						<select id="F1" class="sl_search" style="margin-right:3px;">
							<option value="1" <%If F1 = "1" then%>selected<%End if%>>대메뉴</option>
							<option value="2"  <%If F1 = "2" then%>selected<%End if%>>중메뉴</option>
							<option value="3"  <%If F1 = "3" then%>selected<%End if%>>소메뉴</option>
						</select>
						<input type="text" maxlength="20" class="in_txt"  id="F2"  onkeydown='if(event.keyCode == 13){px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())}' value="<%=F2%>">
						<a href='javascript:px.goSearch(<%=jsonstr%>,1,$("#F1").val(), $("#F2").val())' class="search_btn">검색</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

						<a href="javascript:mn.writePop('modalS',1)" href="tablehelp.asp" class="search_btn">메뉴등록</a>&nbsp;
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
    							<th style="width:50px;">번호</th><th style="width:10%;">대메뉴</th><th style="width:10%;">중메뉴</th><th style="width:10%;">소메뉴</th><th style="width:20%;">경로</th>
								<th style="width:10%;">작성일</th><th style="width:80px;">생성자</th><th style="width:30px;">팝업</th><th style="width:80px;">사용</th>
								<th style="width:40px;">등급</th>
								<%If Cookies_AUTH = "A" Then '최고등급이라면 삭제 가능%>
									<th style="width:80px;">삭제</th>
								<%End if%>
						</tr>
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
											<td class="name"><span><%=c_RoleDetailGroup1Nm%></span></td>
											<td class="name"><%=c_RoleDetailGroup2Nm%><span></span></td>
											<td><input type='text' id="txt2_<%=seq%>" value="<%=c_RoleDetailNm%>" style="width:95%;height:30px;" onchange="mn.setTXT('txt2_<%=seq%>',<%=seq%>,this.value,1)"></td>
											<td><input type='text' id="txt1_<%=seq%>" value="<%=c_link%>" style="width:95%;height:30px;" onchange="mn.setTXT('txt1_<%=seq%>',<%=seq%>,this.value,0)"></td>
											<td class="date"><%=Left(c_WriteDate,10)%></td>
											<td><%=c_WriteID%></td>
											<td class="g_btn green_btn1">
											<a href="javascript:mn.setBtnState('btn1_<%=seq%>',<%=seq%>,'<%= c_PopupYN %>',0)"  class="name_btn"  <%If c_PopupYN="Y" then%>style="background-color:#FF7F27;"<%End If%>  id="btn1_<%=seq%>"><%=c_PopupYN%></a>
											</td>
											<td class="g_btn green_btn1">
											<a href="javascript:mn.setBtnState('btn2_<%=seq%>',<%=seq%>,'<%= c_UseYN %>',1)" class="name_btn" <%If c_UseYN="Y" then%>style="background-color:#FF7F27;"<%End If%> id="btn2_<%=seq%>"><%=c_UseYN%></a>
											</td>
											<td><%=c_Authority%></td>
											<%If Cookies_AUTH = "A" Then '최고등급이라면 삭제 가능%>
											<td>
												<a href="javascript:mn.delLine('line1_<%=seq%>',<%=seq%>,1)" class="red-btn">삭제</a>
											</td>
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