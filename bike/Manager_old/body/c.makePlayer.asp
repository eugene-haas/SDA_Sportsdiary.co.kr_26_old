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
	intPageSize = 100



	rnkquery = "(SELECT sum(getpoint) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as rankpoint "
	rnkcount = "(SELECT count(*) FROM sd_TennisRPoint_log b where  b.PlayerIDX = a.PlayerIDX and ptuse = 'Y') as rankcount "
	strTableName = " tblPlayer as a "
	strFieldName = " PlayerIDX,UserName,UserPhone,Birthday,Sex,PersonCode,team,teamNm,team2,team2Nm,userLevel,WriteDate,belongBoo,rankboo "
	strFieldName = strFieldName & " ,"&rnkquery&", "&rnkcount&"  "
	strSort = "  ORDER By UserName Asc"
	strSortR = "  ORDER By  UserName Desc"

	'search
	If chkBlank(search_word) Then
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' "
	Else
		'strWhere = " DelYN = 'N' and GameTitleIDX = " & idx
		'page_params = "&search_word="&search_word
	End if

	'Response.write strTableName
	'Response.write strFieldName
	'Response.write strWhere


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10


	'팀정보목록가져오기
	SQL = "Select Team,TeamNm from tblTeamInfo where SportsGb = 'tennis' and DelYN = 'N' "
	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rst.EOF Then
		arrRS = rst.GetRows()
	End if
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>
		<form name="frm" method="post">
		<div class="top-navi-inner">
			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>대회관리 > 선수 관리 (tblPlayer)</strong>
				</h3>
			</div>

			<div class="top-navi-btm">


				<div class="sch">
				<!-- #include virtual = "/pub/html/tennisAdmin/PlayerSearchForm.asp" -->
				</div>

				<div class="navi-tp-table-wrap"  id="gameinput_area">
					<!-- #include virtual = "/pub/html/tennisAdmin/PlayerForm.asp" -->
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
					전체 (<strong id="totcnt"><%=intTotalCnt%></strong>)건 / <strong class="current">현재페이지(<span id="nowcnt">1</span>)</strong>
				</a>


				<a href="#" id="infochange" class="btn" onclick="mx.reqInfoChange()">정보요청</a>

				<!-- <%=boo%> 테스트용 선수 자동 생성 명수 : <input type="number" id="autono" style="width:50px;height:30px;margin-bottom:0px;text-align:right;" value="1">
				<a href="#" id="btnsave" class="btn" onclick="mx.auto_frm('<%=teamnm%>(<%=levelnm%>)');" accesskey="i">자동생성(A)</a>&nbsp;&nbsp; -->
		</div>

<%
	Function sorthtml(ByVal sortno)
		sorthtml =  "<button onclick=""mx.sortTD( "&sortno&" )"">▲</button><button onclick=""mx.reverseTD ( "&sortno&" )"">▼</button>"
	End Function

	Response.write "<table class=""table-list admin-table-list"" id=""playerlist"">"
	Response.write "<colgroup>"
	Response.write "<col width=""70px"">"
	Response.write "<col width=""60px"">"
	Response.write "<col width=""150px"">"
	Response.write "<col width=""60px"">"
	Response.write "<col width=""60px"">"
	Response.write "<col width=""60px"">"
	Response.write "<col width=""60px"">"
	Response.write "<col width=""60px"">"
	Response.write "<col width=""60px"">"
	Response.write "<col width=""60px"">"
	Response.write "</colgroup>"
	Response.write "<thead id=""headtest"">"
	Response.write "<th> 번호</th>"
	Response.write "<th>이름</th>"
	Response.write "<th><span >부(신인,오픈,베테 : 개나리,국화)</th>"
	Response.write "<th></th>"
    Response.write "<th>연락처</th>"
	Response.write "<th>팀1</th>"
	Response.write "<th>팀2</th>"
	Response.write "<th> 랭킹포인트</th>"
	Response.write "<th>등록일</th></thead>"

'	Response.write "<th onclick=""sorting(this, headtest, contest, 0,true)"" style=""cursor:pointer""> <span class=""sort-by"">번호</span></th>"
'	Response.write "<th onclick=""sorting(this, headtest, contest, 1,false)"" style=""cursor:pointer""><span class=""sort-by"">이름</th>"
'	Response.write "<th><span >부(신인,오픈,베테 : 개나리,국화)</th>"
'	Response.write "<th onclick=""sorting(this, headtest, contest, 6,true)"" style=""cursor:pointer""> <span class=""sort-by"">연락처</span></th>"
'	Response.write "<th onclick=""sorting(this, headtest, contest, 4,false)"" style=""cursor:pointer""><span class=""sort-by"">팀1</span></th>"
'	Response.write "<th onclick=""sorting(this, headtest, contest, 5,false)"" style=""cursor:pointer""><span class=""sort-by"">팀2</span></th>"
'	Response.write "<th onclick=""sorting(this, headtest, contest, 7,true)"" style=""cursor:pointer""> <span class=""sort-by"">랭킹포인트</span></th>"
'	Response.write "<th onclick=""sorting(this, headtest, contest, 9,false)"" style=""cursor:pointer""><span class=""sort-by"">등록일</span></th></thead>"
	Response.write "<tbody id=""contest"">"

	Do Until rs.eof
		pcode = rs("PersonCode") '테니스는 2억부터 자동증가 3억전까지
		pidx = rs("PlayerIDX")
		pname = rs("UserName")
		writeday = Left(rs("writedate"),10)
		pbirth = rs("Birthday")
		psex = rs("Sex")
		pteam1 = rs("teamNm")
		pteam2 = rs("team2Nm")
		pphone = rs("UserPhone")
		pgrade = rs("userLevel")
		prankpoint = rs("rankpoint")

'		Response.write prankpoint & "-"
		rankcount = rs("rankcount")
		belongBoo = rs("belongBoo")
		rankboo = rs("rankboo")

		rb1 = Left(rankboo,1)
		rb2= mid(rankboo,2,1)
		rb3 = mid(rankboo,3,1)
		rb4 = mid(rankboo,4,1)
		rb5 = mid(rankboo,5,1)
		%>
		<!-- #include virtual = "/pub/html/tennisAdmin/PlayerList.asp" -->
		<%
	rs.movenext
	Loop
	Response.write "</tbody>"
	Response.write "</table>"


	Set rs = Nothing
%>


<!-- <div>
<%'Call userPaging(intTotalPage, block_size, page, page_params, list_page)%>
</div> -->


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
