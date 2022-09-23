<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<!-- #include virtual="/pub/class/json2.asp" -->
<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>
<%
 'Controller ################################################################################################
	Set db = new clsDBHelper

	intPageNum = PN 'requestRiding.asp에서 정의
	intPageSize = 20
	block_size = 10

	strTableName = " tblTeamGbInfoDetail "
	strFieldName = " idx,useyear,TeamGb,TeamGbNm,ridingclass,ridingclasshelp,title,timestr,writeOK "

	strSort = "  ORDER By idx Desc"
	strSortR = "  ORDER By  idx Asc"

	'search
	'Response.write req & "###" & pn & "########"


	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and useyear = '"&year(date)&"' "
		F1_0 = year(date) 
	Else
		If InStr(F1, ",") > 0  Then
		'Response.write f2
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			F2_0 = F2(0)
			strWhere = " DelYN = 'N' and useyear = '"& F2_0 &"' "
		Else
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "		
		End If
		
	End if

	'Response.write strwhere

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )


	If Not rs.EOF Then
		Set fd = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
		For i = 0 To Rs.Fields.Count - 1
			fd.Add LCase(Rs.Fields(i).name), i 
		Next
		arrRs = rs.GetRows()
	End If	


	'등록된 최소년도
	SQL = "Select min(useyear) from tblTeamGbInfoDetail where delYN = 'N' and writeOK = 'Y' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End If
	rs.close

%>
<%'View ####################################################################################################%>
<div class="admin_content">

	<!-- s: 페이지 타이틀 -->
	<div class="page_title"><h1>심사관리 > 심사기준관리</h1></div>
	<!-- e: 페이지 타이틀 -->

	<!-- s: 정보 검색 -->
	<div class="info_serch">
		<!-- #include virtual = "/pub/html/riding/findjgstandard.asp" -->
	</div>
	<!-- e: 정보 검색 -->

	<hr />

	<!-- s: 전체 페이지 -->
	<div class="btn-toolbar" style="text-align:right;">
		<!-- <a href="" class="btn btn-primary">엑셀 업로드</a><a href="" class="btn btn-primary">엑셀 다운로드</a> -->
		<a href="jgstandardW.asp?y=<%=F2_0%>" class="btn btn-primary" id="btnsave"  accesskey="i">등록</a><!-- onclick="mx.input_frm();" -->
	</div>
	<!-- s: 전체 페이지 -->




	<!-- s: 테이블 리스트 -->
	<div class="table-responsive">
		<table cellspacing="0" cellpadding="0" class="table table-hover">
			<thead>
				<tr>
					<th>사용년도</th>
					<th>종목명</th>
					<th>Class</th>
					<th>Class 안내</th>
					<th>심사지명</th>
					<th>소정시간(MM:SS)</th>
					<th>세부내용</th>
					<th>삭제</th>
				</tr>
			</thead>

			<tbody id="contest">

<%
			If IsArray(arrRs) Then
				For ar = LBound(arrRs, 2) To UBound(arrRs, 2)
					'idx,useyear,TeamGb,TeamGbNm,ridingclass,ridingclasshelp,title,timestr,writeOK
					idx = arrRs(fd.item("idx"),ar) '소문자로 ...필드를 부릅니다....절대로...
					useyear = arrRs(fd.item("useyear"), ar)
					TeamGb = arrRs(fd.item("teamgb"), ar)
					TeamGbNm = arrRs(fd.item("teamgbnm"), ar)
					ridingclass = arrRs(fd.item("ridingclass"), ar)
					ridingclasshelp = arrRs(fd.item("ridingclasshelp"), ar)
					title = arrRs(fd.item("title"), ar)
					timestr = arrRs(fd.item("timestr"), ar)
					%>
				<tr>
					<td><%=useyear%></td>
					<td><%=teamgbnm%>[<%=teamgb%>]</td>
					<td><%=ridingclass%></td>
					<td><%=ridingclasshelp%></td>
					<td><%=title%></td>
					<td><%=timestr%></td>
					<td><a href="javascript:mx.goManage('<%=useyear%>','<%=teamgb%>','<%=ridingclass%>', '<%=idx%>')" class="btn btn-primary">관리</a></td>
					<td><a href="javascript:mx.del('<%=idx%>','<%=pn%>','<%=useyear%>')" class="btn btn-primary">삭제</a></td>
				</tr>
					<%
				Next
			End if
%>





			</tbody>
		</table>
	</div>




<%
	jsonstr = JSON.stringify(oJSONoutput)
	Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
%>

</div>

