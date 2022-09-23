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
<a name="contenttop"></a>

		<form name="frm" method="post">

		<div class="top-navi-inner">
			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>대회관리 > 대회주최</strong>
				</h3>
			</div>

			<div class="top-navi-btm">
		
				<div class="navi-tp-table-wrap"  id="gameinput_area">
					<!-- #include virtual = "/pub/html/RookietennisAdmin/gamehost/html.hostForm.asp" -->
				</div>

				<div class="btn-right-list">
					<a href="#" id="btnsave" class="btn" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
					<a href="#" id="btndel" class="btn btn-delete" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
				</div>
			</div>

		</div>
		</form>


		<div class="btn-left-list">
				<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn-more-result">
					전체 (<strong id="totcnt"><%=intTotalCnt%></strong>)건 / <strong class="current">현재페이지(<span id="nowcnt">1<%'=intTotalPage%></span>)</strong>
				</a>
		</div>

<%
	Function sorthtml(ByVal sortno)
		sorthtml =  "<button onclick=""mx.sortTD( "&sortno&" )"">▲</button><button onclick=""mx.reverseTD ( "&sortno&" )"">▼</button>"
	End Function

	Response.write "<table class=""table-list admin-table-list"" id=""playerlist"">"
	Response.write "<colgroup><col width=""70px""><col width=""90px""><col width=""50px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""></colgroup>"
	Response.write "<thead><th>번호</th><th>주최명칭</th><th>로그이미지</th><th>주최수</th><th>등록일</th></thead>"
	Response.write "<tbody id=""contest"">"
	Response.write " <tr class=""gametitle"" ></tr>"

	Do Until rs.eof
		idx = rs("idx")
		hostname = rs("hostname")
		hostimg = rs("hostimg")
		makegamecnt = rs("makegamecnt") 
		writeday = Left(rs("writedate"),10)
		%><!-- #include virtual = "/pub/html/RookietennisAdmin/gamehost/html.GameHostList.asp" --><%
	rs.movenext
	Loop
	Response.write "</tbody>"
	Response.write "</table>"


	Set rs = Nothing
%>

<!-- S: more-box -->
<div class="more-box">
  <%If nextrowidx <> "_end" then%>
  <a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn-more-list" id="_more">
	<span>더 보기</span>
	<span class="ic-deco"><i class="fa fa-plus"></i></span>
  </a>
  <%End if%>
</div>
<!-- E: more-box -->

