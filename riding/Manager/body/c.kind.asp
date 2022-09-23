<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################


	  '등록된 최소년도
	  SQL = "Select min(useYear) from tblTeamGbInfo where delYN = 'N' "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If  isNull(rs(0)) = true then
		  minyear = year(date)
	  Else
		  minyear = rs(0)
	  End if



	  intPageNum = page
	  intPageSize = 20
	  block_size = 10
	  strTableName = " tblTeamGbInfo "
	  strFieldName = "  Teamgbidx,useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp,Orderby,setpointarr "

	  strSort = "  order by orderby asc"
	  strSortR = "  order by orderby desc"

	  'search
	  If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and useyear = '"&year(date)&"' "
	  Else
		strWhere = " DelYN = 'N' and useyear = '"& F2 &"' "
	  End if

	  'Dim intTotalCnt, intTotalPage
	  'Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	  SQL = "Select " & strFieldName & " from " & strTableName & " where " & strWhere &  strSort
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)

	  If Not rs.EOF Then
		arrRS = rs.GetRows()
	  End If



%>
<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>공인승마대회 규정관리 > 종목관리</h1></div>

			<%If CDbl(ADGRADE) > 500 then%>

			
			<!-- s: 정보 검색 -->
			<div class="info_serch">
				<!-- #include virtual = "/pub/html/riding/kindfindform.asp" -->
			</div>
			<!-- e: 정보 검색 -->
			
			
			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">
			  <!-- #include virtual = "/pub/html/riding/kindform.asp" -->
			</div>
			<!-- e: 정보 검색 -->

			<!-- 10.22 update :: wyn -->
			<!-- <div class="btn-point" style="text-align: right;">
				<div class="btn-group" role="group">
					<p>포인트</p>
					<a href="javascript:mx.OndrowPointModal();" class="btn btn-success btnpoint" id="p_majang" onclick="">마장마술</a>
					<a href="javascript:mx.OndrowPointModal();" class="btn btn-success btnpoint" id="p_obstacle" onclick="">장애물</a>
				</div>
			</div> -->
		      <hr />

			<%End if%>

			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>No.</th>
								<th>사용년도</th>
								<th>개인/단체</th>
								<th>종목명</th>
								<th>마종</th>
								<th>Class</th>
								<th>Class안내</th>
								<th>포인트</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<tr id="fc" style="display:none;"><td>first child</td></tr>
					<%
					If IsArray(arrRS) Then
						For ar = LBound(arrRS, 2) To UBound(arrRS, 2)
							'Teamgbidx,useyear,PTeamGb,PTeamGbNm,TeamGb,TeamGbNm,levelno,levelNm,ridingclass,ridingclasshelp,Orderby
							idx = arrRS(0, ar)
							rullyear = arrRS(1, ar)
							pteamgb = arrRS(2, ar)
							pteamgbnm = arrRS(3, ar)
							teamgb = arrRS(4, ar)
							teamgbnm = arrRS(5, ar)
							levelno = arrRS(6, ar)
							levelnm = arrRS(7, ar)
							classnm = arrRS(8, ar)
							classhelp = arrRS(9, ar)
							sortno = arrRS(10, ar)

							%><!-- #include virtual = "/pub/html/riding/kindinfolist.asp" --><%
						Next
					End if
					%>

					</tbody>
				</table>
			</div>
			<!-- e: 테이블 리스트 -->


			<nav>
				<br><br><br>
				<%
					'jsonstr = JSON.stringify(oJSONoutput)
					'Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>
		</div>
		<!-- s: 콘텐츠 끝 -->
