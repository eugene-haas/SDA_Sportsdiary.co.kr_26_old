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
	strFieldName = " PlayerIDX,UserName,userType,UserPhone,Birthday,Sex,team,teamNm,    Ajudgelevel,Kef1,Kef2,Kef3,Kef4,FEI1,FEI2,FEI3,FEI4,FEI5,FEI6,FEI7,FEI8,FEI9,DELYN "
	strFieldName = strFieldName 
	strSort = "  ORDER By playeridx desc"
	strSortR = "  ORDER By  playeridx asc"






	'search
	If chkBlank(F2) Then
		strWhere = "  DelYN in ( 'N' ,'W')  and usertype in ( 'J','S','M') "
	Else
		If IsArray(F1) Then
		Else
			strWhere = " DelYN  in ( 'N' ,'W') and usertype in ( 'J','S','M') and "&F1&" like '%"& F2 &"%' "
		End if
	End if	

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10
%>


<%'View ####################################################################################################%>
<div class="admin_content">
		<a name="contenttop"></a>

		<div class="page_title"><h1>대회관리 > 심판 정보</h1></div>
		<a href="makeplayer.asp" id="infochange" class="btn btn-primary" >선수</a>
		<a href="horse.asp" id="infochange" class="btn btn-primary" >말</a>
		<a href="referee.asp" id="infochange" class="btn btn-primary" >심판</a>

		
		<form name="frm" method="post">
			<div class="info_serch">
				<div class="form-horizontal" style="background:#eee">
					<!-- #include virtual = "/pub/html/riding/PlayerSearchForm.asp" -->
				</div>

				<div id="formarea" class="form-horizontal">
					<!-- #include virtual = "/pub/html/riding/rForm.asp" -->
				</div>
				<div class="btn-group flr">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm(17);" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm(17);" accesskey="e">수정(E)</a>
					<a href="#" id="btndel" class="btn btn-danger" onclick="mx.del_frm();" accesskey="r">삭제(R)</a>
				</div>

			</div>
		</form>

	<hr />
	<div class="btn-toolbar">
		<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link">
			전체 (<span id="totcnt"><%=intTotalCnt%></span>)건
		</a>

		<div class="btn-group flr">
			<!-- <a href="#" id="infochange" class="btn btn-primary" onclick="mx.reqInfoChange()">정보요청</a> -->
		</div>
	</div>

	<div class="table-responsive">
		<table cellspacing="0" cellpadding="0" class="table table-hover" id="playerlist">
		<thead>
		<tr>
		<th>idx</th>
		<th>구분</th>
		<th>생체정심판</th>
		<th>이름</th>
		<th>연락처</th>

		<th>마장마술등급</th>
		<th>장애물등급</th>
		<th>스튜어드</th>
		<th>수의사</th>

		<!-- <th>장애물레벨</th>
		<th>마술스타</th>
		<th>코스디자인레벨</th>
		<th>마술스튜레벨</th>
		<th>장애물스튜레벨</th>
		<th>종마스튜레벨</th>
		<th>지구스튜레벨</th>
		<th>수의사(JDE)</th>
		<th>PTV</th> -->
		<th>승인여부</th>

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

			Ajudgelevel = rs("Ajudgelevel")
			Kef1 = rs("Kef1")
			Kef2 = rs("Kef2")
			Kef3 = rs("Kef3")
			Kef4 = rs("Kef4")
			FEI1 = rs("FEI1")
			FEI2 = rs("FEI2")
			FEI3 = rs("FEI3")
			FEI4 = rs("FEI4")
			FEI5 = rs("FEI5")
			FEI6 = rs("FEI6")
			FEI7 = rs("FEI7")
			FEI8 = rs("FEI8")
			FEI9 = rs("FEI9")

			delyn = rs("DELYN") 'N W Y (W 대기상태
			
			
			Select Case usertype 
			Case "J","S","M" : gubunstr = "심판"& usertype
			End Select

			%>
			<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=pidx%>" onclick="mx.input_edit(<%=pidx%>)">
				<td  ><%=pidx%></td>
				<td  ><%=gubunstr%></td>
				<td  ><%=Ajudgelevel%></td>
				<td><%=pname%></td>
				<td  ><%=pphone%></td>

				<td  ><%=Kef1%></td>
				<td  ><%=Kef2%></td>
				<td  ><%=Kef3%></td>
				<td  ><%=Kef4%></td>

				<!-- <td  ><%=FEI1%></td>
				<td  ><%=FEI2%></td>
				<td  ><%=FEI3%></td>
				<td  ><%=FEI4%></td>
				<td  ><%=FEI5%></td>
				<td  ><%=FEI6%></td>
				<td  ><%=FEI7%></td>
				<td  ><%=FEI8%></td>
				<td  ><%=FEI9%></td> -->

				<td>
					<label class="switch" title="승인여부">
					<input type="checkbox" id="tbl_<%=pidx%>" value="<%=delyn%>" <%If delyn = "N" then%>checked<%End if%> onclick="mx.setBtnState(<%=pidx%>)">
					<span class="slider round"></span>
					</label>			
				</td>		


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
