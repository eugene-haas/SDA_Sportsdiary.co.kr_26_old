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
	strFieldName = " PlayerIDX,UserName,userType,UserPhone,Birthday,Sex,team,teamNm,    ksportsno,startyear,nowyear , hpassport,hfield,hhairclr,hchipno,ProfileIMG1,ProfileIMG2,ProfileIMG3 ,delYN   "
	strFieldName = strFieldName 
	strSort = "  ORDER By playeridx desc"
	strSortR = "  ORDER By  playeridx asc"


	


	'search

	' delYN NY W(승인대기상태)
	If chkBlank(F2) Then
		strWhere = " DelYN in ('N','W')  and usertype = 'H' "
	Else
		If IsArray(F1) Then
		Else
			strWhere = " DelYN in ('N','W')  and usertype = 'H' and "&F1&" like '%"& F2 &"%' "
		End if
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10
%>


<%'View ####################################################################################################%>
<div class="admin_content">
		<a name="contenttop"></a>

		<div class="page_title"><h1>대회관리 > 말 정보</h1></div>
		<a href="makeplayer.asp" id="infochange" class="btn btn-primary" >선수</a>
		<a href="horse.asp" id="infochange" class="btn btn-primary" >말</a>
		<a href="referee.asp" id="infochange" class="btn btn-primary" >심판</a>

		
		<form name="frm" method="post">
			<div class="info_serch">
				<div class="form-horizontal" style="background:#eee">
					<!-- #include virtual = "/pub/html/riding/PlayerSearchForm.asp" -->
				</div>

				<div id="formarea" class="form-horizontal">
					<!-- #include virtual = "/pub/html/riding/horseForm.asp" -->
				</div>
				<div class="btn-group flr">
					<a href="#" id="btnsave" class="btn btn-primary" onclick="mx.input_frm(23);" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn btn-primary" onclick="mx.update_frm(23);" accesskey="e">수정(E)</a>
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
		<th>여권번호</th>
		<th>이름</th>
		<th>산지</th>
		<th>모색</th>
		<th>칩번호</th>
		<th>사진</th>
		<th>승인</th>
		</tr>
		</thead>
		<tbody id="contest">

	<%

		photoarr = array("전면","측면","후면")
		Do Until rs.eof
			pidx = rs("PlayerIDX")
			pname = rs("UserName")
			pbirth = rs("Birthday")
			psex = rs("Sex")
			pteam = rs("teamNm")
			pphone = rs("UserPhone")
			'userType P 사람 H 말 G 그룹, J 심판, S 스튜어드

			hpassport = rs("hpassport")
			hfield = rs("hfield")
			hhairclr = rs("hhairclr")
			hchipno = rs("hchipno")

			img1 = isnulldefault(rs("ProfileIMG1"),"")
			img2 = isnulldefault(rs("ProfileIMG2"),"")
			img3 = isnulldefault(rs("ProfileIMG3"),"")




			startyear = rs("startyear") 
			nowyear = rs("nowyear")
			ksportsno = rs("ksportsno")
			
			delyn = rs("delyn")
			
			%>
			<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=pidx%>">
				<td  onclick="mx.input_edit(<%=pidx%>)"><%=pidx%></td>
				<td  onclick="mx.input_edit(<%=pidx%>)"><%=hpassport%></td>
				<td onclick="mx.input_edit(<%=pidx%>)"><%=pname%></td>
				<td onclick="mx.input_edit(<%=pidx%>)"><%=hfield%></td>
				<td onclick="mx.input_edit(<%=pidx%>)" ><%=hhairclr%></td>
				<td  onclick="mx.input_edit(<%=pidx%>)"><%=hchipno%></td>
				<td>
					<a href="javascript:mx.fileupload(<%=pidx%>,'1');" class="btn btn-<%If img1 = "" then%>default<%else%>primary<%End if%>" >여권</a>
					<a href="javascript:mx.fileupload(<%=pidx%>,'2');;" class="btn btn-<%If img2 = "" then%>default<%else%>primary<%End if%>">전면</a>
					<a href="javascript:mx.fileupload(<%=pidx%>,'3');;" class="btn btn-<%If img3 = "" then%>default<%else%>primary<%End if%>">측면</a>
				</td>

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
