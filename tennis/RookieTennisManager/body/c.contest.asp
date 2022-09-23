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
	  strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,ViewYN,MatchYN,viewState,stateNo,titlecode,titlegrade,vacReturnYN "

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
  SQL = "Select Count(*) from TB_RVAS_MAST where CUST_CD IS NOT NULL "'and sitecode = '"&sitecode&"'"
  Set rscnt = db.ExecSQLReturnRS(SQL, null, ConStr)
  vacUseCount = rscnt(0)
%>
<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회정보 <!-- (sd_TenisTitle) --></h1></div>

			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
				  <!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfoform.asp" -->
				</div>
			<!-- e: 정보 검색 -->

			<!-- s: 리스트 버튼 -->
				<div class="list_btn">
					<a href="javascript:mx.makeGoods()" id="gdmake" class="blue_btn"  style="float:left;">상품등록</a>

					<a href="#" class="" style="color:black;display:inline-block;width:200px;">계좌 사용량 : <%=vacUseCount%> / 20000</a>
					<a href="#" class="blue_btn" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
					<a href="#" class="blue_btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
					<a href="#" class="pink_btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
				</div>
			<!-- e: 리스트 버튼 -->
			<%End if%>


			<!-- s: 테이블 리스트 -->
			<div class="table_list contest">
				<table cellspacing="0" cellpadding="0">
					<tr>
					<%If CDbl(ADGRADE) > 500 then%>
						<th>번호</th><th>대회명</th><th>기간</th><th>노출</th><th>상세</th><th>요강</th><th>랭킹반영</th>
					<%Else%>
						<th>번호</th><th>대회명</th><th>기간</th></thead>
					<%End if%>
					</tr>
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


						titleCode = rs("titleCode")
						titleGrade = findGrade(rs("titleGrade"))
						%>
						  <!-- #include virtual = "/pub/html/RookietennisAdmin/gameinfolist.asp" -->
					  <%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>

					</tbody>
				</table>
			</div>
			<!-- e: 테이블 리스트 -->

			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 더보기 버튼 -->
			<%If nextrowidx <> "_end" then%>
			<div class="more_btn">
				<a href="javascript:mx.contestMore()">더보기</a>
			</div>
			<%End if%>
			<!-- e: 더보기 버튼 -->
			<%End if%>
		</div>
		<!-- s: 콘텐츠 끝 -->
