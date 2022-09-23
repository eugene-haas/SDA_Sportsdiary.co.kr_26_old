<!-- #include virtual = "/api/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/api/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 20
	strTableName = " tblEvalTable "
	strFieldName = " EvalTableIDX,EvalTitle,YearOrder,EvalCateCnt,EvalSubCateCnt,EvalItemCnt,TotalPoint,Usekey,RegYear,RegDate,Editmode "

	strSort = "  order by EvalTableIDX desc"
	strSortR = "  order by EvalTableIDX "


	'search
	If chkBlank(F1) Then
    F1 = year(date)
  end if
	strWhere = " Delkey = 0 and RegYear = '"& F1 &"' "
	


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If

PAGE_ENTERTYPE = "A"
pageYN = getPageState( "MN0103", "평가지표관리" ,Cookies_aIDX , db)
%>

<%'View ####################################################################################################%>
	<div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->
		<div class="box-header with-border">
			<h3 class="box-title"><%=menustr(1) & " 관리"%></h3>
			<div class="box-tools pull-right">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0103'},'/admin/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
			</div>
		</div>

		<div class="box-body" id="gameinput_area">
				<!-- #include virtual = "/admin/inc/form.evalindex.asp" -->
		</div>
	</div>

  


      <div class="row">

				<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">

							<div class="col-md-6" style="padding-left:20px;padding-right:0px;text-align:left;">
									<div class="form-group">
											<select id="F1" class="form-control" onchange="px.goSubmit({'F1':$('#F1').val()},'<%=pagename%>')">
														<%
																For y = year(date)+1 to year(date) - 3 step -1
																	%><option value="<%=y%>" <%If CStr(F1) = CStr(y) then%>selected<%End if%>><%=y%></option><%
																Next
														%>
											</select>
									</div>
							</div>

							<div class="row" >
								<div class="col-md" style="padding-right:5px;text-align:right;">
									<div class="form-group" >
										<span class="btn btn-default">Total : <%=intTotalCnt%></span>
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
                            <th>제목</th>														
                            <th>범주수</th>
														<th>항목수</th>
														<th>지표수</th>                            
														<th>배점합계</th>
														<th>평가지표 설정</th>
														<th>설정</th>
														<th>설정편집</th>
                            <th>등록일</th>
                            <th>삭제</th>														
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
                          l_idx	  = arrR(0, ari)
                          l_EvalTitle	      = arrR(1, ari)
                          l_YearOrder	      = arrR(2, ari)
                          l_EvalCateCnt	    = arrR(3, ari)
                          l_EvalSubCateCnt	= arrR(4, ari)
                          l_EvalItemCnt   	= arrR(5, ari)
                          l_TotalPoint	    = arrR(6, ari)
                          l_Usekey	        = arrR(7, ari)
                          l_RegYear	        = arrR(8, ari)
                          l_RegDate	        = arrR(9, ari)
                          l_EditMode        = arrR(10, ari)													
													%>
													<tr class="gametitle" id="titlelist_<%=l_idx%>"  style="text-align:center;">
															<td><%=l_idx%></td>
															<td><%=l_EvalTitle%>_<%=l_YearOrder%></td>
															<td><%=l_EvalCateCnt%></td>
															<td><%=l_EvalSubCateCnt%></td>
															<td><%=l_EvalItemCnt%></td>
															<td><%=l_TotalPoint%></td>
                              <td><a href="javascript:px.goSubmit({'EvalTableIDX':<%=l_idx%>,'RegYear':<%=l_RegYear%>},'/admin/evalmaker.asp')" class="btn btn-primary">평가지표설정</a></td>
                              
															<%if l_Usekey = "1" then%>
															<td><a href="javascript:mx.setUseFlag(<%=l_idx%>)" class="btn btn-success"><i class="fa fa-check-square-o"></i>&nbsp;적용</a></td>
															<%else%>
															<td><a href="javascript:mx.setUseFlag(<%=l_idx%>)" class="btn btn-default"><i class="fa fa-square-o"></i>&nbsp;해제</a></td>															
															<%end if%>									


                              
															<%if l_EditMode = "1" then%>
															<td><a href="javascript:mx.setEndFlag(<%=l_idx%>)" class="btn btn-default">설정가능</a></td>
															<%else%>
															<td><a href="javascript:mx.setEndFlag(<%=l_idx%>)" class="btn btn-danger">설정불가</a></td>															
															<%end if%>

                              <td><%=left(l_RegDate,10)%></td>
                              <td><a href="#" class="btn btn-danger" id="btndel" onclick="mx.del_frm(<%=l_idx%>);" accesskey="r">삭제<span>(R)</span></a></td>															
													</tr>
													<%
												no = no + 1
												Next
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
