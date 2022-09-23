<%
 'Controller ################################################################################################


	  '등록된 최소년도
	  SQL = "Select min(useYear) from tblRealPersonNo where delYN = 'N' "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If  isNull(rs(0)) = true then
		  minyear = year(date)
	  Else
		  minyear = rs(0)
	  End if



	  intPageNum = page
	  intPageSize = 20
	  block_size = 10
	  strTableName = " tblRealPersonNo "
	  strFieldName = "  idx,useyear,TeamGb,TeamGbNm,realcnt "

	  strSort = "  order by idx asc"
	  strSortR = "  order by idx desc"

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
			<div class="page_title"><h1>공인승마대회 규정관리 > 부별성립관리   <%Call debugPrint(user_ip, "<span style=color:red;font-size:14px;>테이블명 : tblRealPersonNo[ useyear,TeamGb,TeamGbNm,realcnt]</span>")%></h1></div>

			<%If CDbl(ADGRADE) > 500 then%>

			
			<!-- s: 정보 검색 -->
			<div class="info_serch">
				<!-- #include virtual = "/pub/html/riding/makefindform.asp" -->
			</div>
			<!-- e: 정보 검색 -->
			
			
			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">
			  <!-- #include virtual = "/pub/html/riding/makeform.asp" -->
			</div>
			<!-- e: 정보 검색 -->



		      <hr />

			<%End if%>


			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>No.</th>
								<th>사용년도</th>
								<th>종목명</th>
								<th>부별성립 실인원(명)<!-- 1인2마 라면 1명 --></th>
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
							teamgb = arrRS(2, ar)
							teamgbnm = arrRS(3, ar)
							realcnt = arrRS(4, ar) '실인원명수

							%><!-- #include virtual = "/pub/html/riding/makeinfolist.asp" --><%
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
