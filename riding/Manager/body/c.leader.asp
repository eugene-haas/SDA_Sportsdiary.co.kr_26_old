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
	intPageNum = page

	Set db = new clsDBHelper
	intPageSize = 100
	strTableName = " tblLeader "
    strFieldName = " ksportsno,startyear,userType,UserName,userNameCn,userNameEn,Birthday,Sex,sidoCode,sido,UserPhone,Team,teamnm,addr1,addr2,zipcode,email,CDB "

	strSort = "  order by username asc"
	strSortR = "  order by UserName desc"

	'search
	If chkBlank(search_word) Then
		strWhere = " DelYN = 'N' "
	Else
		strWhere = " DelYN = 'N' "
		page_params = "&search_word="&search_word
	End if

	Dim intTotalCnt, intTotalPage

	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

    Function Ceil(ByVal intParam)
        Ceil = -(Int(-(intParam)))
    End Function

%>
<div class="admin_content">
	<a name="contenttop"></a>

	<div class="page_title"><h1>대회관리 > 리더정보 </h1></div>



	<hr />


	<div class="btn-toggle">
		<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link">
			전체 (<span id="totcnt"><%=intTotalCnt%></span>)건 /<span class="current"> 현재페이지(<span id="nowcnt">1</span>/<span id="totPage"><%=Ceil(intTotalCnt/10) %></span>)</span>
		</a>
		<!-- 자동 생성 팀수 : <input type="number" id="autono" style="width:50px;height:30px;margin-bottom:0px;text-align:right;" value="1">
		<a href="#" id="btnsaveAuto" class="btn" onclick="mx.auto_frm();" accesskey="i">자동생성(A)</a>&nbsp;&nbsp; -->
		<div class="btn-group flr">
			<!-- <a href="./teamexcel.asp" title="클럽목록 다운로드" class="btn btn-primary flr"><span class="glyphicon glyphicon-save-file"></span>엑셀다운로드</a> -->
			<a href="#" id="infochange" class="btn btn-primary" onclick="mx.copyPlayer()">리더정보갱신</a>
		</div>
	</div>

	<div class="table-responsive">
		<table cellspacing="0" cellpadding="0" class="table table-hover" id="Teamlist">
		<thead>
		<tr>
		<th>코드</th>
		<th>이름</th>
		<th>지역</th>
		<th>연락처</th>
		<th>우편번호</th>
		<th>팀명</th>
		<th>CDB(부코드)</th>
		<th>이메일</th>
		</tr>
		</thead>
	  <tbody id="contest">
		 <tr class="gametitle" ></tr>

	<%
		Do Until rs.eof
			ksportsno = rs("ksportsno")
			UserName = rs("UserName")
			startyear = rs("startyear")
			sidonm = rs("sido")
			TeamTel = rs("UserPhone")
			ZipCode = rs("ZipCode")
			teamnm = rs("teamnm")
			email = rs("email")
			cdb = rs("cdb")
		%>
	<tr class="gametitle"  style="cursor:pointer" >
		<td  ><%=ksportsno%></td>
		<td  ><%=UserName%>(<%=startyear%>)</td>
		<td  ><%=sidonm%></td>
		<td><%=TeamTel%></td>
		<td><%=ZipCode%></td>
		<td  ><%=teamnm%></td>
		<td  ><%=cdb%></td>
		<td  ><%=email%></td>
	</tr>
		<%
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
		%>
	</nav>

</div>
