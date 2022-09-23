<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	idx = chkInt(chkReqMethod("idx", "GET"), 1)
	teamidx = chkInt(chkReqMethod("teamidx", "GET"), 1)

	page = chkInt(chkReqMethod("page", "GET"), 1)

	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

	page = iif(search_first = "1", 1, page)
	'request 처리##############

	Set db = new clsDBHelper

	intPageNum = page
	intPageSize = 20


	strTableName = " tblGameHost "
	strFieldName = " idx,hostname,hostimg,makegamecnt,writedate,SportsGb "

	strSort = "  ORDER By idx Desc"
	strSortR = "  ORDER By  idx Asc"
	strWhere = " SportsGb = 'tennis' and  DelYN = 'N' "

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10
%>


<%'View ####################################################################################################%>
<div class="admin_content">

		<a name="contenttop"></a>

		<div class="page_title"><h1>대회관리 > 대회주최</h1></div>
		<form name="frm" method="post">

			<div class="info_serch">

				<div class="form-horizontal"  id="gameinput_area">
					<!-- #include virtual = "/pub/html/swimAdmin/gamehost/html.hostForm.asp" -->
				</div>
				<div class="btn-group flr">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
					<a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
				</div>
			</div>

		</form>

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
			Response.write "<thead><tr><th>번호</th><th>주최명칭</th><th>로그이미지</th><th>주최수</th><th>등록일</th></tr></thead>"
			Response.write "<tbody id=""contest"">"
			Response.write " <tr class=""gametitle"" ></tr>"

			Do Until rs.eof
				idx = rs("idx")
				hostname = rs("hostname")
				hostimg = rs("hostimg")
				makegamecnt = rs("makegamecnt")
				writeday = Left(rs("writedate"),10)
				%><!-- #include virtual = "/pub/html/swimAdmin/gamehost/html.GameHostList.asp" --><%
			rs.movenext
			Loop
			Response.write "</tbody>"
			Response.write "</table>"


			Set rs = Nothing
		%>
		</div>

		<!-- S: more-box -->
		<!-- <div class="well text-center">
		  <%If nextrowidx <> "_end" then%>
		  <a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn" id="_more"> <span>더 보기</span> </a>
		  <%End if%>
		</div> -->
		<!-- E: more-box -->
		<nav>
			<%
				jsonstr = JSON.stringify(oJSONoutput)
				Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				'Call userPaginglink (intTotalPage, 10, PN, "px.goPN" )
			%>
		</nav>

</div>
