<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	'page = chkInt(chkReqMethod("page", "GET"), 1)
	'search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	'search_first = chkInt(chkReqMethod("search_first", "POST"), 0)
	'page = iif(search_first = "1", 1, page)
	'request 처리##############
	intPageNum = PN

	Set db = new clsDBHelper
	intPageSize = 20
	strTableName = " tblTeamInfo "
    strFieldName = " TeamIDX,Team,TeamCD,TeamNm,ShortNm,Sex,sido,sidonm,ZipCode,Address1,Address2,phone,leader_key,leader_nm,apply_YN " 'apply_YN 신청처리 플레그

	strSort = "  order by TeamIDX desc"
	strSortR = "  order by TeamIDX asc"

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  "
	Else
		If IsArray(F1) Then
		Else
			strWhere = " DelYN = 'N' and "&F1&" like '%"& F2 &"%' "
		End if
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

	<div class="page_title"><h1>대회관리 > 팀정보 <%=intPageNum%></h1></div>

	<form name="frm" method="post">


		<div class="info_serch ">
			<div class="form-horizontal" style="background:#eee;">
			<!-- #include virtual = "/pub/html/riding/TeamInfoSearchForm.asp" -->
			</div>

			<div id="Teaminfoform" class="form-horizontal">
			<!-- #include virtual = "/pub/html/riding/TeamInfoform.asp" -->
			</div> 
			
			<div class="btn-group flr">
				<a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm(9);" accesskey="i">등록(I)</a>
				<a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm(9);" accesskey="e">수정(E)</a>
				<a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
			</div>
		</div>


	</form>

	<hr />


	<div class="btn-toggle">
		<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link">
			전체 (<span id="totcnt"><%=intTotalCnt%></span>)건 
		</a>
		<div class="btn-group flr">
<%
SQL = "select seq from tblResetTeaminfo where delyn = 'N' and resetyear = '"&year(date)&"' "
Set rsr = db.ExecSQLReturnRS(SQL , null, ConStr)
If Not rsr.eof then
%>
			<a href="javascript:alert('이번년도는 초기화 하였습니다. 다시 초기화 하려면 초기화 체크 정보를 (tblResetTeaminfo 개발담당자 요청해서) 초기화 하세요.')" title="클럽목록 다운로드" class="btn btn-danger flr"><%=year(date)%>년도 팀정보초기화 완료됨</a>
<%
else
%>
			<a href="./initteaminfo.asp" title="클럽목록 다운로드" class="btn btn-primary flr"><%=year(date)%>년도 팀정보초기화</a>
			<!-- <a href="#" id="infochange" class="btn btn-primary" onclick="mx.copyTeam()">체육회 팀정보갱신</a>    대한체육회는 소속이고 승마는 별도의 팀을 관리한다 --> 
<%End if%>
		</div>
	</div>

	<div class="table-responsive">
		<table cellspacing="0" cellpadding="0" class="table table-hover" id="Teamlist">
		<thead>
		<tr>
		<th>팀코드</th>
		<th>팀명칭</th>
		<th>지역</th>
		<th>연락처</th>
		<th>우편번호</th>
		<!-- <th>리더키</th> -->
		<th>팀대표명</th>
		<th>설정삭제</th>
		<th>팀구성원</th>
		<!-- <th>신청</th> -->
		</tr>
		</thead>
	  <tbody id="contest">
		 <tr class="gametitle" ></tr>

	<%
		Do Until rs.eof
			TeamIDX = rs("TeamIDX")
			Team = rs("Team") 
			Teamcd = rs("TeamCD") '체육회 소속밀어넣은 건대 사용하지 않음
			TeamNm = rs("TeamNm")
			sido = rs("sido")
			sidonm = rs("sidonm")
			TeamTel = rs("phone")
			ZipCode = rs("ZipCode")
			Address = rs("Address1")
			AddrDtl = rs("address2")
			readerkey = rs("leader_key")
			leadernm = rs("leader_nm")
			applyYN = rs("apply_YN")
		%>
	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=TeamIDX%>" ><!-- onclick="mx.input_edit(<%=pidx%>)" -->
		<td  onclick="mx.input_edit(<%=TeamIDX%>)"><%=team%></td>
		<td  onclick="mx.input_edit(<%=TeamIDX%>)"><%=teamnm%></td>
		<td  onclick="mx.input_edit(<%=TeamIDX%>)"><%=sidonm%></td>
		<td onclick="mx.input_edit(<%=TeamIDX%>)"><%=TeamTel%></td>
		<td onclick="mx.input_edit(<%=TeamIDX%>)"><%=zipcode%></td>
		<!-- <td  ><%=readerkey%></td> -->
		<td  onclick="mx.input_edit(<%=TeamIDX%>)">(<%=readerkey%>)<%=leadernm%></td>
		<td><%If readerkey <> "" then%><a href="javascript:mx.resetTeam('<%=readerkey%>')"  class="btn btn-danger">팀설정삭제</a><%End if%></td>
		<td><a href="javascript:mx.getWindow('<%=team%>','<%=applyYN%>')"  class="btn btn-default">구성원보기</a></td>
		


		<!-- <td>
			<label class="switch" title="승인여부">
			<input type="checkbox" id="tbl_<%=teamidx%>" value="<%=applyYN%>" <%If applyYN = "Y" then%>checked<%End if%> onclick="mx.setBtnState(<%=TeamIDX%>)">
			<span class="slider round"></span>
			</label>			
		</td>	 -->	
		
		


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
