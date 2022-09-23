<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	  '등록된 최소년도
	  SQL = "Select min(useYear) from tblTeamGbInfo where delYN = 'N' "
	  Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	  If  isNull(rs(0)) = true then
		  minyear = year(date)
	  Else
		  minyear = rs(0)
	  End if



	'#############################
	intPageNum = PN 'requestRiding.asp에서 정의
	intPageSize = 20

	If F1_0 = "" Then
		F1_0 = 1
	End if


	strTableName = " tblLimitAtt "
	strFieldName = " seq, gubun,chkyear,Teamgbnm,  chkHkind   ,chkClass,updown,zeropointcnt,chkandor,prizecnt,attokYN,limitTeamgbnm,limitchkClass,writedate "

	strSort = "  ORDER By seq Desc"
	strSortR = "  ORDER By  seq Asc"

	'search
	'Response.write F1 & "<br>"
	'Response.end
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and gubun= '1' and chkyear = '"&year(date)&"' "
		F1_0 = 1 '선수 말 (2)
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If
		If IsArray(F1) Then
			fieldarr = array("gubun","chkyear")
			F1_0 = F1(0)
			F1_1 = F1(1)
			F2_0 = F2(0)
			F2_1 = F2(1)

			strWhere = " DelYN = 'N' and "&fieldarr(0)&" = '" & F2_0 &"' and "&fieldarr(1)&" = '"& F2_1 &"' "
		Else
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "
		End if
	End if

	'Response.write f1_0 & strwhere

	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	if rs.eof Then
		arrList = ""
	Else
		Dim rsdic
		Set rsdic = Server.CreateObject("Scripting.Dictionary") '필드를 좀더 쉽게 찾자.
		For i = 0 To Rs.Fields.Count - 1
			rsdic.Add LCase(Rs.Fields(i).name), i
		Next
		arrList = rs.getrows()
	end if
	set rs = Nothing



%>

<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>공인승마대회 규정관리 > 참가자격 제한</h1></div>

			<%If CDbl(ADGRADE) > 500 then%>

			<!-- s: 정보 검색 -->
			<div class="info_serch" id = "input_area">
				<!-- #include virtual = "/pub/html/riding/limitedform.asp" -->
			</div>
			<!-- e: 정보 검색 -->
		      <hr />
			<%End if%>




			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
							<th colspan="5">조건</th>
							<th colspan="7" class="borl">참가제한사항</th>
						</tr>
						<tr>
							<th>No.</th>
							<th>등록년도</th>
							<th>종목</th>
							<th>마종</th>
							<th>Class</th>
							<th>해당범위</th>
							<th>무감점(횟수)</th>
							<th>조건</th>
							<th>입상실적(횟수)</th>
							<th>참가가능여부</th>
							<th>종목</th>
							<th>Class</th>
						</tr>
					</thead>

					<tbody id="tbodycontents"  class="gametitle">

			<%
			If IsArray(arrList) Then
			For ar = LBound(arrList, 2) To UBound(arrList, 2)
				'dic 소문자로
				seq= arrList(rsdic.Item("seq"), ar)
				chkyear= arrList(rsdic.Item("chkyear"), ar)
				Teamgbnm= arrList(rsdic.Item("teamgbnm"), ar)
				chkHkind   = arrList(rsdic.Item("chkhkind"), ar)
				chkClass= arrList(rsdic.Item("chkclass"), ar)
				updown= arrList(rsdic.Item("updown"), ar)
				zeropointcnt= arrList(rsdic.Item("zeropointcnt"), ar)
				chkandor= arrList(rsdic.Item("chkandor"), ar)
				prizecnt= arrList(rsdic.Item("prizecnt"), ar)

				attokYN= arrList(rsdic.Item("attokyn"), ar)
				limitchkClass= arrList(rsdic.Item("limitchkclass"), ar)
				limitTeamgbnm= arrList(rsdic.Item("limitteamgbnm"), ar)
				writedate= arrList(rsdic.Item("writedate"), ar)

				If chkClass <> "" and chkclass <> "-1" Then
					chkClass = classarr(chkClass)
				End If
				If limitchkClass <> "" and limitchkClass <> "-1" then
					limitchkClass = classarr(limitchkClass)
				End if
			%>
						<tr onclick="mx.input_edit(<%=seq%>)" style="cursor:pointer;" id="titlelist_<%=seq%>">
							<td><%=seq%></td>
							<td><%=chkyear%></td>
							<td><%=Teamgbnm%></td>
							<td><%=chkHkind%></td>
							<td><%=chkClass%></td>
							<td><%=updown%></td>
							<td><%=zeropointcnt%></td>
							<td><%=chkandor%></td>
							<td><%=prizecnt%></td>

							<td><%=attokYN%></td>
							<td><%=limitTeamgbnm%></td>
							<td><%=limitchkClass%></td>
						</tr>
			<%
			Next
			End if
			%>

					</tbody>
				</table>
			</div>


			<!-- e: 테이블 리스트 -->


			<nav>
				<br><br><br>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>
		</div>
		<!-- s: 콘텐츠 끝 -->
