<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################


'  max=100
'  min=1
'  Randomize
'  response.write(Int((max-min+1)*Rnd+min)) & "--"
' response.write PN

	intPageNum = PN
	intPageSize = 20
	strTableName = " tblReferee as a "

	strFieldName = " seq,CDA,CDC,name,sex,userphone,grade,team,teamnm,delyn,writeday "

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



pageYN = getPageState( "MN0601", "심판관리" ,Cookies_aIDX , db)
%>


<%'View ####################################################################################################%>
      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>"> <!-- collapsed-box -->

		<div class="box-header with-border">
		  <h3 class="box-title">심판관리</h3>
			  <div class="box-tools pull-right">
				<button type="button" class="btn btn-box-tool" data-widget="collapse"  onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0601'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
			  </div>
        </div>

	    <input type= "hidden" id="mk_g0" value="E2">
		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/refereeform.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>

	  </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <div class="box-header" style="text-align:right;padding-right:20px;">


							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="F1" class="form-control">
											<option value="name" <%If F1 = "name" then%>selected<%End if%>>이름</option>
											<option value="TeamNm" <%If F1 = "TeamNm" then%>selected<%End if%>>소속명</option>
										</select>
								  </div>
							</div>




						<div class="row" >
							<div class="col-md-6" style="width:40%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">
										 <input type="text" id="F2" placeholder="검색어를 입력해주세요" value="<%=F2%>" class="form-control" onkeydown="if(event.keyCode == 13){px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'dreferee.asp')}">
										<div class="input-group-addon" onmousedown="px.goSubmit({'F1':$('#F1').val(),'F2':$('#F2').val()},'dreferee.asp')">
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
								<th>심판번호</th>
								<th>이름</th>
								<th>성별</th>
								<th>핸드폰</th>
								<th>등급</th>
								<th>소속</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle mailbox-messages">


					<%'##################################
						If IsArray(arrR) = true Then

							For ari = LBound(arrR, 2) To UBound(arrR, 2)
								'seq,CDA,CDC,name,sex,userphone,grade,team,teamnm,delyn,writeday
								l_seq = arrR(0, ari)
								l_cda = arrR(1, ari)
								l_cdc = arrR(2, ari)
								l_name = arrR(3, ari)
								l_sex = arrR(4, ari)
								l_userphone = arrR(5, ari)
								l_grade = arrR(6, ari)
								l_team = arrR(7, ari)
								l_teamnm = arrR(8, ari)
							%>
								<tr class="gametitle" id="titlelist_<%=l_seq%>"  style="text-align:center;" onclick="mx.input_edit(<%=l_seq%>)">
										<td><%=l_seq%></td>
										<td><%=l_name%></td>
										<td><%=l_sex%></td>
										<td><%=l_userphone%></td>
										<td><%=l_grade%></td>
										<td><%=l_teamnm%></td>
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
