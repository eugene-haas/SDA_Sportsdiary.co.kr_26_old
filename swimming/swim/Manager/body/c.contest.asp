<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
  page = chkInt(chkReqMethod("page", "GET"), 1)
  search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
  search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

  page = iif(search_first = "1", 1, page)
  'request 처리##############

		'사은품
		SQL = "Select name from sd_gamePrize where gubun = 1  and delYN = 'N'"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then
			arrG = rs.GetRows()
		End If



	  intPageNum = page
	  intPageSize = 20
	  strTableName = " sd_TennisTitle "
	  'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	  strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo,titlecode,titlegrade,vacReturnYN,chkrange "

	  strSort = "  order by GameS desc"
	  strSortR = "  order by GameS"

	  'search
	  If chkBlank(search_word) Then
		strWhere = " DelYN = 'N' "
	  Else
		strWhere = " DelYN = 'N' and GameTitleIDX = " & tid
		page_params = "&search_word="&search_word
	  End if


  If CDbl(ADGRADE) > 500 then
	  Dim intTotalCnt, intTotalPage
	  Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	  block_size = 10
	Else
	  SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere & " and GameE >= getdate() -30 " & strSort
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if

  '대회주최
  SQL = "Select hostname from tblGameHost where DelYN = 'N' "
  Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rst.EOF Then
    arrRS = rst.GetRows()
  End If


  '대회그룹/등급
  SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
  Set rsg = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rsg.EOF Then
    arrRSG = rsg.GetRows()
  End If

  '계좌 사용량
  SQL = "Select Count(*) from SD_RookieTennis.dbo.TB_RVAS_MAST where CUST_CD IS NOT NULL " 'and sitecode = '"&sitecode&"'"
  Set rscnt = db.ExecSQLReturnRS(SQL, null, ConStr)
  vacUseCount = rscnt(0)
%>
<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회정보 <!-- (sd_TenisTitle) --></h1></div>

			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">
			  <!-- #include virtual = "/pub/html/swimAdmin/gameinfoform.asp" -->


			</div>
			<!-- e: 정보 검색 -->

      <hr />
			<!-- s: 리스트 버튼 -->
		  <div class="btn-toolbar" role="toolbar" aria-label="btns">
        
        <a href="#" class="btn btn-link">계좌 사용량 : <%=vacUseCount%> / 20000</a>

        <div class="btn-group flr">
          <a href="javascript:mx.makeGoods()" id="gdmake" class="btn btn-primary">상품등록</a>
        </div>

			</div>
			<!-- e: 리스트 버튼 -->
			<%End if%>


			<!-- s: 테이블 리스트 -->
				<div class="table-responsive">
					<table cellspacing="0" cellpadding="0" class="table table-hover">
						<thead>
							<tr>
								<%If CDbl(ADGRADE) > 500 then%>
									<th>번호</th>
									<th>대회명</th>
									<th>기간</th>
									<th>노출</th>
									<th>상세</th>
									<th>요강</th>
									<th>랭킹반영</th>
								<%Else%>
									<th>번호</th>
									<th>대회명</th>
									<th>기간</th>
								<%End if%>
							</tr>
						</thead>
						<tbody id="contest"  class="gametitle">
						<%
						Do Until rs.eof
							idx = rs("GameTitleIDX")
							title = rs("gameTitleName")
							sdate = rs("GameS")
							edate = rs("GameE")
							gamecfg = rs("cfg")
							rcvs = rs("GameRcvDateS")
							rcve = rs("GameRcvDateE")

							ViewYN = rs("ViewYN")
							MatchYN = rs("stateNo")
							viewState = rs("viewState")
							vacReturnYN = rs("vacReturnYN")
							Select Case MatchYN '게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
							Case "0" : MatchYN = "<span class='blue_font'>미노출</span>"
							Case "3" : MatchYN = "<span class='orange_font'>예선노출</span>"
							Case "4" : MatchYN = "예선마감"
							Case "5" : MatchYN = "본선노출"
							Case "6" : MatchYN = "본선마감"
							Case "7" : MatchYN = "결과노출"
							End Select

							chkrange = rs("chkrange")

							titleCode = rs("titleCode")
							titleGrade = findGrade(rs("titleGrade"))
							%>
							  <!-- #include virtual = "/pub/html/swimAdmin/gameinfolist.asp" -->
						  <%
						  rs.movenext
						  Loop
						  Set rs = Nothing
						%>

						</tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->

			<!-- <%If CDbl(ADGRADE) > 500 then%> -->
			<!-- s: 더보기 버튼 -->
			<!-- <%If nextrowidx <> "_end" then%>
			<div class="text-center well">
				<a href="javascript:mx.contestMore()" class="btn btn-link">더보기</a>
			</div>
			<%End if%> -->
			<!-- e: 더보기 버튼 -->
			<!-- <%End if%> -->
			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
					'Call userPaginglink (intTotalPage, 10, PN, "px.goPN" )
				%>
			</nav>
		</div>
		<!-- s: 콘텐츠 끝 -->
