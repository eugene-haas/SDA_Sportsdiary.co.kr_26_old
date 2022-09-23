<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################


	intPageNum = PN
	intPageSize = 20
	strTableName = " tblGameCode as a "

	strFieldName = " seq,CDA,CDC,title,CODE1,CODE2,CODE3,CODE4,writeday,codename "

	strSort = "  order by seq desc"
	strSortR = "  order by seq "

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  and CDA = 'E2' " '다이빙
	Else
		strWhere = " DelYN = 'N' and CDA = 'E2' and "&F1&" like '%"& F2 &"%' "
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

  If Not rs.EOF Then
		arrR = rs.GetRows()
  End If



pageYN = getPageState( "CD0101", "코드관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->

		<div class="box-header with-border">
		  <h3 class="box-title">코드관리</h3>
			  <div class="box-tools pull-right">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'CD0101'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
			  </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/Dcodeform.asp" -->
			<!-- e: 등록 화면 -->
        </div>

	  </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">


							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="codename" <%If F1 = "codename" then%>selected<%End if%>>코드명</option>
											<option value="code1" <%If F1 = "code1" then%>selected<%End if%>>다이브번호</option>
										</select>
								  </div>
							</div>




						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'dcodemanager.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'dcodemanager.asp')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>


								  </div>
							</div>
						</div>

			</div>
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">
						<tr>
								<th>명칭</th>
								<th>코드</th>
								<th>난이율</th>
								<th>다이브번호</th>
								<th>높이</th>
								<th>자세</th>

						</tr>
					</thead>
					<tbody id="contest"  class="gametitle mailbox-messages">
					<%'##################################
						If IsArray(arrR) = true Then

							For ari = LBound(arrR, 2) To UBound(arrR, 2)
								'seq,CDA,CDC,title,CODE1,CODE2,CODE3,CODE4,writeday 
								l_seq = arrR(0, ari)
								l_cda = arrR(1, ari)
								l_cdc = arrR(2, ari)
								l_title = arrR(3, ari)
								l_code1 = arrR(4, ari)
								l_code2 = arrR(5, ari)
								l_code3 = arrR(6, ari)
								l_code4 = arrR(7, ari)
								l_codename = arrR(9,ari)
							%>
								<tr class="gametitle" id="titlelist_<%=l_seq%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_seq%>)">
										<td><%=l_title%></td>
										<td><%=l_codename%></td>
										<td><%=l_code4%></td>
										<td><%=l_code1%></td>
										<td><%=l_code2%></td>
										<td><%=l_code3%></td>
								</tr>
							<%
							no = no + 1
							pre_gameno = r_a2
							Next
						End if
					'##################################%>
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
