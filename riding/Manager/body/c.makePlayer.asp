<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
'	idx = chkInt(chkReqMethod("idx", "GET"), 1)
'	teamidx = chkInt(chkReqMethod("teamidx", "GET"), 1)
	
	Set db = new clsDBHelper
	
	'================
	intPageNum = PN
	intPageSize = 20
	strTableName = " tblPlayer as a "
	strFieldName = " PlayerIDX,UserName,userType,UserPhone,Birthday,Sex,team,teamNm,    ksportsno,startyear,nowyear"
	strFieldName = strFieldName 
	strSort = "  ORDER By UserName Asc"
	strSortR = "  ORDER By  UserName Desc"
	

	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and usertype = 'P' "
	Else
		If IsArray(F1) Then
		Else
			strWhere = " DelYN = 'N' and usertype = 'P' and "&F1&" like '%"& F2 &"%' "
		End if
	End if

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

%>


<%'View ####################################################################################################%>
<div class="admin_content">
		<a name="contenttop"></a>

		<div class="page_title"><h1>대회관리 > 선수 정보</h1></div>
		<a href="makeplayer.asp" id="infochange" class="btn btn-primary" >선수</a>
		<a href="horse.asp" id="infochange" class="btn btn-primary" >말</a>
		<a href="referee.asp" id="infochange" class="btn btn-primary" >심판</a>

		
		<form name="frm" method="post">
			<div class="info_serch">
				<div class="form-horizontal">
					<!-- #include virtual = "/pub/html/riding/PlayerSearchForm.asp" -->
				</div>

				<!-- <div id="gameinput_area" class="form-horizontal"> -->
					<%'<!-- #include virtual = "/pub/html/riding/PlayerForm.asp" -->%>
				<!-- </div>
				<div class="btn-group flr">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm();" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm();" accesskey="e">수정(E)</a>
					<a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
				</div> -->

			</div>
		</form>

	<hr />
	<div class="btn-toolbar">
		<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link">
			전체 (<span id="totcnt"><%=intTotalCnt%></span>)건
		</a>

		<div class="btn-group flr">
			<!-- <a href="#" id="infochange" class="btn btn-primary" onclick="mx.reqInfoChange()">정보요청</a> -->
			<a href="#" id="infochange" class="btn btn-primary" onclick="mx.copyPlayer()">체육회선수정보가져오기</a>
		</div>
	</div>

	<div class="table-responsive">
		<table cellspacing="0" cellpadding="0" class="table table-hover" id="playerlist">
		<thead>
		<tr>
		<th>idx</th>
		<th>구분</th>
		<th>체육인번호</th>
		<th>이름</th>
		<th>생년월일</th>
		<th>등록년도(현재)</th>
		<th>팀</th>
		<th>연락처</th>
		</tr>
		</thead>
		<tbody id="contest">

	<%
		Do Until rs.eof
			pidx = rs("PlayerIDX")
			pname = rs("UserName")
			pbirth = rs("Birthday")
			psex = rs("Sex")
			pteam = rs("teamNm")
			pphone = rs("UserPhone")
			'userType P 사람 H 말 G 그룹, J 심판, S 스튜어드
			usertype = rs("usertype")
			Select Case usertype 
			Case "P" : gubunstr = "선수"
			Case "H" : gubunstr = "말"
			Case "G" : gubunstr = "그룹"
			Case "J","S" : gubunstr = "심판"
			End Select
			startyear = rs("startyear") 
			nowyear = rs("nowyear")
			ksportsno = rs("ksportsno")
			%>
			<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=pidx%>" onclick="mx.input_edit(<%=pidx%>)">
				<td  ><%=pidx%></td>
				<td  ><%=gubunstr%></td>
				<td  ><%=ksportsno%></td>
				<td><%=pname%></td>
				<td><%=pbirth%></td>
				<td><%=startyear%>[<%=nowyear%>]</td>
				<td  ><%=pteam%></td>
				<td  ><%=pphone%></td>
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
