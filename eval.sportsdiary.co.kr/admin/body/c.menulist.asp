<!-- #include virtual = "/api/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/api/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################
	'필드명들



	'##############################
	'여러개 사이트코드 사용시 
	'##############################
		if F3 <> "" then
				session("scode") = F3
				sitecode = F3
		end if
		
		session_scode = session("scode")

		if session_scode = "" then
				sitecode = "EVAL1"
		else
			sitecode = session_scode
		end if
	'##############################	



	TN = "tbladminmenulist as a "
	IDXFIELDNM = "AdminMenuListIDX"
	intPageSize = 10
	block_size = 10
	intPageNum = PN
	strTableName = TN
	strFieldName = " AdminMenuListIDX,RoleDepth,RoleDetail,RoleDetailNm,RoleDetailGroup1,RoleDetailGroup1Nm,RoleDetailGroup2,"
	strFieldName = strFieldName &" RoleDetailGroup2Nm,Link,PopupYN,UseYN,DelYN,WriteDate,WriteID,ModDate,ModID,Authority,displayorder1,displayorder2,displayorder3 " 
	strFieldName = strFieldName &", (select ImgLink from tblAdminMenuList where delyn= 'N' and sitecode= a.sitecode and RoleDepth = 1 and RoleDetailGroup1 = a.RoleDetailGroup1) as ImgLink "
	'IMGLINK 1댑스를 찾아서 넣어준다.

	strSortR = "  order by displayorder1 desc, displayorder2 desc, displayorder3 desc, AdminMenuListIDX desc"
	strSort = "  order by displayorder1, displayorder2, displayorder3, AdminMenuListIDX"

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



%>
<%'View ####################################################################################################%>

		<div class="box box-primary">
			
			<div class="box-header with-border">
				<h3 class="box-title"></h3>
				<div class="box-tools pull-right">
					<button type="button" class="btn btn-box-tool" data-widget="collapse"><i class="fa fa-minus"></i></button>
				</div>
			</div>

				<div class="box-body">
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
											<input type="text" maxlength="20" class="form-control"  id="F2"  onkeydown='if(event.keyCode == 13){px.goSubmit({"F1":$("#F1").val(),"F2":$("#F2").val()},"<%=pagename%>")}' value="<%=F2%>">
											<div class="input-group-btn">
												<a href='javascript:px.goSubmit({"F1":$("#F1").val(),"F2":$("#F2").val()},"<%=pagename%>")' class="btn btn-default">검색</a>
											</div>
										</div>
									</div>
									<div class="col-sm-1">
										<a href="javascript:mn.writePop('modalS',1)"  class="btn btn-primary">메뉴등록</a>&nbsp;
									</div>

								</div>
							</div>
						</div>
				</div>

        <!-- <div class="box-footer"></div> -->
      </div>





      <div class="row">

			<div class="col-xs-12">
          


<div class="form-group" >
		<%if sitecode = "EVAL1" then%>
		<a href="javascript:px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':'EVAL1'},'<%=pagename%>')" class="btn btn-primary">관리자메뉴</a>
		<a href="javascript:px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':'EVAL2'},'<%=pagename%>')" class="btn btn-default">평가결과메뉴</a>
		<%else%>
		<a href="javascript:px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':'EVAL1'},'<%=pagename%>')" class="btn btn-default">관리자메뉴</a>
		<a href="javascript:px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val(),'F3':'EVAL2'},'<%=pagename%>')" class="btn btn-primary">평가결과메뉴</a>							
		<%end if%>
</div>

					
					<div class="box">
            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
                <tr>
									<th>번호</th>
									<th>대메뉴</th>
									<th>중메뉴</th>
									<th>소메뉴</th>
									<th>경로</th>
									<th>1.메뉴이미지</th>									
									<th>작성일</th>
									<th>사용</th>
									<th>새창</th>									
									<th>등급</th>
										<%If Cookies_AUTH = "A" Then '최고등급이라면 삭제 가능%>
											<th>삭제</th>
										<%End if%>
                </tr>
                </thead>
                <tbody id="tblbody">
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
										c_displayorder1 = rs("displayorder1")
										c_displayorder2 = rs("displayorder2")
										c_displayorder3 = rs("displayorder3")
										c_imglink = rs("imglink")
										%>
												<tr id="line1_<%=seq%>" style="text-align:center;">
													<td><span><%=c_AdminMenuListIDX%></span></td>
													<td>
													<span>
														<%=c_RoleDetailGroup1Nm%>
													</span>
													</td>

													<td>
													<span>
														<%=c_RoleDetailGroup2Nm%>
													</span>
													</td>

													<td>
													<span>
														<input type='text' id="mu3_<%=seq%>" value="<%=c_RoleDetailNm%>" class="form-control" onchange="mn.setTXT('mu3_<%=seq%>',<%=seq%>,this.value,1)">
														<input id="sort3_<%=seq%>" value="<%=c_displayorder3%>" class="form-control" 
														style="width:50px;" onkeyup="this.value=this.value.replace(/[^0-9]/g,'');mn.changeOrder(<%=seq%>,$(this).prop('defaultValue'),$(this).val())">
													</span>
													</td>

													<td>
													<span>
													<input type='text' id="txt1_<%=seq%>" value="<%=c_link%>" class="form-control" onchange="mn.setTXT('txt1_<%=seq%>',<%=seq%>,this.value,0)">
													</span>
													</td>

													<td>
													<span>
													<input type='text' id="imglink_<%=seq%>" value="<%=c_imglink%>" class="form-control"  onchange="mn.setTXT('imglink_<%=seq%>',<%=seq%>,this.value,5)">
													</span>
													</td>
													<td><span><%=Left(c_WriteDate,10)%></span></td>
													<td><span><a href="javascript:mn.setBtnState('btn2_<%=seq%>',<%=seq%>,'<%= c_UseYN %>',1)" <%If c_UseYN="Y" then%> class="btn btn-fix-sm btn-primary"<%Else%>class="btn btn-fix-sm btn-warning"<%End If%> id="btn2_<%=seq%>"><%=c_UseYN%></a></span></td>
													<td><span><a href="javascript:mn.setBtnState('btn1_<%=seq%>',<%=seq%>,'<%= c_PopupYN %>',0)"  <%If c_PopupYN="Y" then%> class="btn btn-fix-sm btn-primary"<%Else%>class="btn btn-fix-sm btn-warning"<%End If%>  id="btn1_<%=seq%>"><%=c_PopupYN%></a></span></td>																										
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
          </div>

        </div>

      </div>


		<nav>
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
			%>
		</nav>

