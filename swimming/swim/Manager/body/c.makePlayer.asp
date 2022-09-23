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
	strFieldName = " PlayerIDX,UserName,UserPhone,Birthday,Sex,PersonCode,team,teamNm,team2,team2Nm,userLevel,WriteDate,teamgb,belongBoo,rankboo         ,titlecode,dblrnk,levelup,openrnkboo,firstcount,gameday,gamestartyymm, stateNo  "
	strFieldName = strFieldName & " ,"&rnkquery&", "&rnkcount&"  "
	strSort = "  ORDER By UserName Asc"
	strSortR = "  ORDER By  UserName Desc"

	If chkBlank(search_word) Then
		strWhere = " SportsGb = 'tennis' and  DelYN = 'N' "
	Else
	End if

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	block_size = 10


	'팀정보목록가져오기
	SQL = "Select Team,TeamNm from tblTeamInfo where SportsGb = 'tennis' and DelYN = 'N' "
	Set rst = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rst.EOF Then
		arrRS = rst.GetRows()
	End if


  '대회그룹/등급
  SQL = "Select titleCode,titleGrade,hostTitle,idx from sd_TennisTitleCode where  DelYN = 'N' "
  Set rsg = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rsg.EOF Then
    arrRSG = rsg.GetRows()
  End if


	'부목록
	SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('201') and DelYN = 'N' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrBoo = rs.GetRows()
	End if

%>


<%'View ####################################################################################################%>
<div class="admin_content">
		<a name="contenttop"></a>

		<div class="page_title"><h1>대회관리 > 선수 관리 (tblPlayer)</h1></div>

		<form name="frm" method="post">
		<!-- <div class="top-navi-inner"> -->

			<div class="info_serch">
				<div class="form-horizontal">
					<!-- #include virtual = "/pub/html/swimAdmin/PlayerSearchForm.asp" -->
				</div>

				<div id="gameinput_area" class="form-horizontal">
					<!-- #include virtual = "/pub/html/swimAdmin/PlayerForm.asp" -->
				</div>

				<div class="btn-group flr">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
					<a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
				</div>

			</div>

		<!-- </div> -->
		</form>

	<!-- 설명 -->

	<!-- <div>
		승급자 설정: 승급자로 설정되면 다음대회가 발생시 양쪽 저장 중지<br>
		전체초기화 : 당해연도 이전 승급자들 양쪽 저장 중지<br>
		오픈부점수 반영 : 기본설정인 사람중 신인부로 참가 신청을 할 경우 신인부로 자동등록<br>
	</div> -->
	<hr />
	<!-- 설명 -->
	<div class="btn-toolbar">
		<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link">
			전체 (<span id="totcnt"><%=intTotalCnt%></span>)건 / <span class="current">현재페이지(<span id="nowcnt">1</span>)</span>
		</a>

		<div class="btn-group flr">
			<a href="#" id="infochange" class="btn btn-primary" onclick="mx.reqInfoChange()">정보요청</a>

			<a href="#" id="infochange" class="btn btn-primary" onclick="mx.help()">도움말</a>

			<!-- <%=boo%> 테스트용 선수 자동 생성 명수 : <input type="number" id="autono" style="width:50px;height:30px;margin-bottom:0px;text-align:right;" value="1">
			<a href="#" id="btnsave" class="btn" onclick="mx.auto_frm('<%=teamnm%>(<%=levelnm%>)');" accesskey="i">자동생성(A)</a>&nbsp;&nbsp; -->
		</div>
	</div>

	<div class="table-responsive">


	<%
		Function sorthtml(ByVal sortno)
			sorthtml =  "<button onclick=""mx.sortTD( "&sortno&" )"">▲</button><button onclick=""mx.reverseTD ( "&sortno&" )"">▼</button>"
		End Function

		Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"" id=""playerlist"">"
		Response.write "<thead><tr>"
		Response.write "<th>번호</th>"
		Response.write "<th>이름</th>"
		Response.write "<th>출전부서</th>"
		%><th>승급 <a href="javascript:mx.resetUPMember()" class="btn btn-primary">전년도초기화</a></th><%
		Response.write "<th>연락처</th>"
		Response.write "<th>팀1</th>"
		Response.write "<th>팀2</th>"
		Response.write "<th>랭킹포인트(+)</th>"
		Response.write "<th>등록일</th></tr></thead>"
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

			titlecode = rs("titlecode") '우승한 대회의 코드
			dblrnk = rs("dblrnk") '승급자반영여부
			levelup = rs("levelup") '우승년도

			If dblrnk = "N" Then
				titlecode = ""
			End If
			openboornk = rs("openrnkboo") '오픈부반영부서



			rb1 = Left(rankboo,1)
			rb2= mid(rankboo,2,1)
			rb3 = mid(rankboo,3,1)
			rb4 = mid(rankboo,4,1)
			rb5 = mid(rankboo,5,1)
			%>

				<!-- #include virtual = "/pub/html/swimAdmin/PlayerList.asp" -->

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

	
</div>

<!-- S: more-box -->
<!-- <div class="well text-center">
	<%If nextrowidx <> "_end" then%>
	<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link" id="_more"> <span>더 보기</span> </a>
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
