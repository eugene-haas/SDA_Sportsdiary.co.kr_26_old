<!-- #include virtual = "/api/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/api/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################

	'평가 진행 중 (없다면 MAX값) EvalTableIDX  동시진행은 안된다..
	SQL = "Select top 1 EvalTableIDX,evaltitle + cast(yearOrder as varchar) from tblEvalTable where delkey = 0 and usekey = 1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	if rs.eof then
		SQL = "Select top 1 EvalTableIDX,evaltitle + cast(yearOrder as varchar) from tblEvalTable where delkey = 0"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		if rs.eof then
				EvalTableIDX = 0
				'수정중인 항목
				edit_title = "대상이 없습니다. 관리자에게 문의하여 주십시오."
		else
		EvalTableIDX = rs(0)
		'수정중인 항목
		edit_title = rs(1)
		end if
	else
		EvalTableIDX = rs(0)
		'수정중인 항목
		edit_title = rs(1)
	end if


	intPageNum = PN
	intPageSize = 20
	strTableName = " tblAssociation as a inner join  tblAssociation_sub as b on a.AssociationIDX = b.AssociationIDX and b.delkey = 0  "
	strFieldName = " b.AssociationIDX as idx,b.AssociationNm,b.association_subIDX,b.evalgroupnm,b.membergroupnm,b.regyear,b.regdate "

	strSort = "  order by idx desc"
	strSortR = "  order by idx "


	'search
	if F1 = "" then
		F1 = 0
	end if
	If chkBlank(F2) Then
		if F1 > 0 then
		strWhere = " a.Delkey = 0  and b.EvalTableIDX = " & EvalTableIDX & " and b.EvalGroupCD = "&F1&" "		
		else
		strWhere = " a.Delkey = 0  and b.EvalTableIDX = " & EvalTableIDX
		end if
	Else
		if F1 > 0 then
			strWhere = " a.Delkey = 0 and b.EvalTableIDX = " & EvalTableIDX & " and b.EvalGroupCD = "&F1&" and b.AssociationNm like '%"& F2 &"%' "
		else
			strWhere = " a.Delkey = 0 and b.EvalTableIDX = " & EvalTableIDX & " and b.AssociationNm like '%"& F2 &"%' "
		end if
	End if





	if Cdbl(EvalTableIDX) > 0 then '지표 항목이 없다면 지표부터 만들도록 유도

		'그룹항목 회원종류수
		SQL = "select EvalGroupNm,MemberGroupNm,count(*) as cnt  from tblAssociation_sub where delkey = 0 and evaltableidx = "&EvalTableIDX&" group by EvalGroupNm,MemberGroupNm order by 1 asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		If Not rs.EOF Then
			arrG = rs.GetRows()
			
			For arg = LBound(arrG, 2) To UBound(arrG, 2)
				c_gnm	= arrG(0, arg)
				c_mnm	= arrG(1, arg)
				c_cnt	= arrG(2, arg)								
				gpstr = gpstr & c_gnm & "("&c_mnm&") : " & c_cnt & "\n"
			next

		End If
		'그룹항목 회원종류수

		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10

		If Not rs.EOF Then
			arrR = rs.GetRows()
		End If
	end if


	'공통코드
	SQL = "select pubcodeidx,kindcd,kindnm,codecd,codenm from tblPubCode where delkey = 0"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	If Not rs.EOF Then
		arrRSP = rs.GetRows()
	End If
	Set rs = nothing


PAGE_ENTERTYPE = "A"
pageYN = getPageState( "MN0103", "협회관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
        <div class="box-header with-border">
          <h3 class="box-title"><%=menustr(1)%></h3> <span style="color:orange;">평가지표 설정(적용)된 항목에 대해서 추가 편집됩니다. </span>
					
					<a href="/admin/evalindex.asp" class="btn btn-success">평가지표대상 : No.<%=EvalTableIDX%>&nbsp;&nbsp;&nbsp; 제목<%=edit_title%></a>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0103'},'/admin/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

				<div class="box-body" id="gameinput_area">
						<%if Cdbl(EvalTableIDX) > 0 then %>
						<!-- #include virtual = "/admin/inc/form.sportslog.asp" -->
						<%end if%>
				</div>
			</div>


      <div class="row">

				<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">

							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
									<div class="form-group">
											<select id="F1" class="form-control" onchange="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'<%=pagename%>')">
												<option value="0" <%If F1 = "0" then%>selected<%End if%>>전체</option>
														<%
															If IsArray(arrRSP) Then 
																For ari = LBound(arrRSP, 2) To UBound(arrRSP, 2)
																	l_kindnm = arrRSP(2, ari) 
																	l_codecd = arrRSP(3, ari)
																	l_codenm = arrRSP(4,ari)
																	if l_kindnm = "평가군" and l_codecd > 0 then
																	%><option value="<%=l_codecd%>" <%If CStr(F1) = CStr(l_codecd) then%>selected<%End if%>><%=l_codenm%></option><%
																	end if
																Next
															End if
														%>
											</select>
									</div>
							</div>

							<div class="row" >
								<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
									<div class="form-group">
										<div class="input-group date">
												<input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'<%=pagename%>')}">
											<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'<%=pagename%>')">
												<i class="fa fa-fw fa-search"></i>
											</div>
										</div>
									</div>
								</div>

								<div class="col-md" style="padding-right:20px;padding-right:0px;text-align:right;">
									<div class="form-group">
										<a href="javascript:alert('<%=gpstr%>')" class="btn btn-danger">총:<%=intTotalCnt%></a>
									</div>
								</div>
							</div>
						</div>
            
						<!-- /.box-header -->
						<div class="box-body">
							<table id="swtable" class="table table-bordered table-hover" >
								<thead class="bg-light-blue-active color-palette">
												<tr>
														<th>NO</th>
														<th>평가군</th>
														<th>회원군</th>
														<th>종목단체명</th>
														<th>등록일</th>
												</tr>
								</thead>
								<tbody id="contest"  class="gametitle mailbox-messages">
										
										<%
											If IsArray(arrR) Then
												If Cdbl(intPageNum) = 1 Then
													no = 1
												Else
													no = ((intPageNum-1) * intPageSize) + 1
												End if
												
												For ari = LBound(arrR, 2) To UBound(arrR, 2)
													l_idx						 			= arrR(0, ari)
													l_AssociationNm 			= arrR(1, ari)
													l_association_subIDX 	= arrR(2, ari)
													l_evalgroupnm 				= arrR(3, ari)
													l_membergroupnm 			= arrR(4, ari)
													l_regyear 						= arrR(5, ari)
													l_regdate 						= arrR(6, ari)
													%>
													<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_idx%>)">
															<td><%=l_idx%></td>
															<td><%=l_evalgroupnm%></td>
															<td><%=l_membergroupnm%></td>
															<td><%=l_AssociationNm%></td>
															<td><%=left(l_regdate,10)%></td>
													</tr>
													<%
												no = no + 1
												Next
											else
													%>
													<tr class="gametitle"  style="text-align:center;">
															<td colspan="5">평가지표를 먼저 생성한 이후 사용으로 누르신 후에 이용하실수 있습니다.</td>
													</tr>													
													<%											
											End if
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
