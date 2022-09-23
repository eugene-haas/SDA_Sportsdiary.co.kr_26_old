<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################
  'request 처리##############
	REQ = chkReqMethod("p", "POST")
	If REQ <> "" then
	Set oJSONoutput = JSON.Parse(REQ)
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)
		'stype = chkInt(oJSONoutput.st,1)

		If hasown(oJSONoutput, "sv") = "ok" Then
			svalue = chkLength(chkStrRpl(oJSONoutput.sv, ""), 20) 
			If svalue = "" Then
			   selecttype = "default"
			End if
		Else
			selecttype = "default"
		End if

		If hasown(oJSONoutput, "tidx") = "ok" then
			tidx = oJSONoutput.tidx
		Else
			tidx = 0
		End If
		
		If hasown(oJSONoutput, "ridx") = "ok" then
			ridx = oJSONoutput.ridx
		Else
			ridx = 0
		End if
	
	Else
		'findmode 전체검색
		page = chkInt(chkReqMethod("page", "GET"), 1)
		selecttype = "default"
	End if
  'request 처리##############

  'page define##############
	Set opage = JSON.Parse("{}")
	Call opage.Set( "name",  "대회관리" )
  'page define##############


  Set db = new clsDBHelper

	'그룹/종목
	SQL = "Select titleCode,hostTitle from sd_bikeTitleCode where delYN = 'N' order by hostTitle "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	SQL = "Select idx,name from sd_openList where delYN = 'N' and gubun = 1"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrO = rs.GetRows()
	End If



	strSort = "  order by titleIDX desc"
	strSortR = "  order by titleIDX Asc"
	Dim intTotalCnt, intTotalPage

	strFieldName = "titleIDX,gametitlename,games,gamee,gameyear,gamearea,entertype,hostname,organize, titlecode, zipcode,sido,addr,cfg"
	intPageNum = page
	intPageSize = 10
	
	strTableName = "  sd_bikeTitle "
	strWhere = " DelYN = 'N'  "
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

	emode = "w"







%>
<%'View ####################################################################################################%>
<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="dnlayer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1><%=opage.name%></h1></div>


			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
				<!-- #include virtual = "/pub/html/bike/form.contest.asp" -->
				</div>
			<!-- e: 정보 검색 -->

			<!-- s: 리스트 버튼 -->
				<div class="list_btn">
					<a href="#" class="blue_btn" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
					<a href="#" class="blue_btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
					<a href="#" class="pink_btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
				</div>
			<!-- e: 리스트 버튼 -->


			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tr>
							<th>번호</th><th>기간</th><th>지역</th><th>대회명</th><th>참가신청/달력/대진표</th><th>대회요강</th><th>대회부목록</th>
						</tr>
						<tbody id="contest">
						<%
						Do Until rs.eof
							b_idx = rs("titleIDX")
							b_entertype = rs("entertype")
							b_title = rs("gametitlename")
							b_GameS = Replace(Left(rs("GameS"),10),"-",".")
							b_GameE = Replace(Left(rs("GameE"),10),"-",".")
							b_titleCode = rs("titleCode")
							b_sido = rs("Sido")
							b_zipcode = rs("zipcode")
							b_addr = rs("addr")
							b_gamearea = rs("cfg") 'NNN'
							b_hostname = rs("hostname")

							%><!-- #include virtual = "/pub/html/bike/list.contest.asp" --><%
'						  
						  rs.movenext
						  Loop
						  Set rs = Nothing
						%>
						</tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->


			<!-- s: 더보기 버튼 -->
			<div class="pagination">
				<%
					Call userPaginglink (intTotalPage, 10, page, "mx.searchPlayer" )
				%>		
			</div>
			<!-- e: 더보기 버튼 -->
		</div>
		<!-- s: 콘텐츠 끝 -->