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
	strTableName = " tblTeamInfo "
    strFieldName = " ROW_NUMBER() OVER(ORDER BY TeamIDX ) num ,TeamIDX,Team,TeamNm,dbo.FN_SidoName(sido,'judo')sido,TeamTel,ZipCode,Address,AddrDtl,TeamLoginPwd ,dbo.FN_TeamCnt(Team,SportsGb) TeamPlayerCnt"

	strSort = "  order by TeamNm asc"
	strSortR = "  order by TeamNm desc"

	'search
	If chkBlank(search_word) Then
		strWhere = " DelYN = 'N' "
	Else
		strWhere = " DelYN = 'N' and TeamIDX = " & tid
		page_params = "&search_word="&search_word
	End if
    
	Dim intTotalCnt, intTotalPage

	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

    Function Ceil(ByVal intParam)
        Ceil = -(Int(-(intParam)))
    End Function
%>
<a name="contenttop"></a>

		<form name="frm" method="post">
		<div class="top-navi-inner">

			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
                    <strong>대회관리 > 팀정보</strong>
				</h3>
			</div>

			<div class="top-navi-btm">

				<div class="sch">				
				<!-- #include virtual = "/pub/html/tennisAdmin/TeamInfoSearchForm.asp" -->				
				</div>

				<div class="navi-tp-table-wrap"  id="Teaminfoform">
					<!-- #include virtual = "/pub/html/tennisAdmin/TeamInfoform.asp" -->
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
				전체 (<strong id="totcnt"><%=intTotalCnt%></strong>)건 / 
                <strong class="current">현제 페이지( <span id="nowcnt">1</span>  / <span id="totPage"><%=Ceil(intTotalCnt/10) %>  </span>)</strong>
			</a>
			<!-- 자동 생성 팀수 : <input type="number" id="autono" style="width:50px;height:30px;margin-bottom:0px;text-align:right;" value="1">
			<a href="#" id="btnsaveAuto" class="btn" onclick="mx.auto_frm();" accesskey="i">자동생성(A)</a>&nbsp;&nbsp; -->

		&nbsp;&nbsp;<a href="./teamexcel.asp" title="클럽목록 다운로드"><img src="/images/favicon/excel.png" style="margin-bottom:-5px;"></a>
		</div>
<%

	Response.write "<table class=""table-list admin-table-list"" id=""Teamlist"">"
	Response.write "<thead><th>번호</th><th>팀코드</th><th>팀명칭</th><th>지역</th><th>연락처</th><th>우편번호</th><th>주소</th><th>상세주소</th><th>팀원수</th></thead>"
    Response.write "<tbody id=""contest"">"
	Response.write " <tr class=""gametitle"" ></tr>"

	Do Until rs.eof
		num = rs("num")
		TeamIDX = rs("TeamIDX")
		Team = rs("Team")
		TeamNm = rs("TeamNm")
		sido = rs("sido")
		TeamTel = rs("TeamTel")
		ZipCode = rs("ZipCode")
		Address = rs("Address")
		AddrDtl = rs("AddrDtl")
		TeamLoginPwd = rs("TeamLoginPwd")
		TeamPlayerCnt = rs("TeamPlayerCnt")
	%>
		<!-- #include virtual = "/pub/html/tennisAdmin/TeamInfolist.asp" -->
	<%
	rs.movenext
	Loop
	Response.write "</tbody>"
	Response.write "</table>"

	Set rs = Nothing
%>
<br><br>
<!-- S: more-box -->
<div class="more-box">
  <%If nextrowidx <> "_end" then%>
  <a href="javascript:mx.contestMore()" class="btn btn-more" id="_more">
	<span>더 보기</span>
	<span class="ic-deco"><i class="fa fa-plus"></i></span>
  </a>
  <%End if%>
</div>
<!-- E: more-box -->

