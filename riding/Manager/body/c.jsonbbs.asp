<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	Set db = new clsDBHelper

	intPageNum = PN 'requestRiding.asp에서 정의
	intPageSize = 20


	strTableName = " tblInsertData "
	strFieldName = " idx,title,updatekey,targettable,targetfield,fieldvalue,endflag,writeday "

	strSort = "  ORDER By idx Desc"
	strSortR = "  ORDER By  idx Asc"

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' "
	Else
		strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "
	End if
	
	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( B_ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10
%>


<%'View ####################################################################################################%>
<div class="admin_content">

		<a name="contenttop"></a>

		<div class="page_title"><h1>관리자 > 대량데이터인서트</h1></div>



			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">
					<!-- #include virtual = "/pub/html/riding/common/html.dataInsertForm.asp" -->
			</div>
			<!-- e: 정보 검색 -->


		<hr />

		<div class="btn-toggle">
				<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link">
					전체 (<span id="totcnt"><%=intTotalCnt%></span>)건 / <span class="current">현재페이지(<span id="nowcnt">1<%'=intTotalPage%></span>)</span>
				</a>
		</div>

		<div class="table-responsive">
		<%
			Function sorthtml(ByVal sortno)
				sorthtml =  "<button onclick=""mx.sortTD( "&sortno&" )"">▲</button><button onclick=""mx.reverseTD ( "&sortno&" )"">▼</button>"
			End Function

			Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"" id=""playerlist"">"
			Response.write "<thead><tr><th>번호</th><th>제목</th><th>대상테이블</th><th>등록일</th><th>작업진행</th></tr></thead>"
			Response.write "<tbody id=""contest"">"
			Response.write " <tr class=""gametitle"" ></tr>"

			Do Until rs.eof
				idx = rs("idx")
				p_1 = rs("title")
				P_2 = rs("targettable")
				p_6 = rs("endflag")
				writeday = Left(rs("writeday"),10)
				%><!-- #include virtual = "/pub/html/riding/common/html.dataInsertList.asp" --><%
			rs.movenext
			Loop
			Response.write "</tbody>"
			Response.write "</table>"


			Set rs = Nothing
		%>
		</div>

		<nav>
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				'Call userPaginglink (intTotalPage, 10, PN, "px.goPN" )
			%>
		</nav>

</div>
