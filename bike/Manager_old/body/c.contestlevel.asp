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
	Call opage.Set( "name",  "부서관리" )
  'page define##############


  Set db = new clsDBHelper

  strTableName = " sd_bikeTitle "
  strFieldName = " titleIDX,gametitlename,games,gamee,gameyear,gamearea,entertype,hostname,organize, titlecode, zipcode,sido,addr,cfg "

  If tidx > 0 then
	  SQL = "select top 1 "&strFieldName&" from " & strTableName & " where TitleIDX = " & tidx
	  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	  title = rs("gameTitleName")
	  Call opage.Set( "title",  title )
  End if



	'그룹/종목
	SQL = "Select levelno,title,subtitle,detailtitle from sd_titleList where delYN = 'N'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	'부
	SQL = "Select idx,name from sd_openList where delYN = 'N' and gubun = 2"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrD = rs.GetRows()
	End If


	strSort = "  order by levelIDX desc"
	strSortR = "  order by levelIDX Asc"
	Dim intTotalCnt, intTotalPage

	boofield = " (select title + ' ' + subtitle + ' ' + detailtitle from sd_titleList where levelno = a.levelno )  as boo "
	strFieldName = "levelIDX,titleIDX,levelno,detailtitle,GameDay,EnterType,WriteDate,DelYN,sex,booNM, " & boofield
	intPageNum = page
	intPageSize = 10
	
	strTableName = "  sd_bikeLevel  as a "
	If tidx = 0 then
		strWhere = " DelYN = 'N'  "
	else
		strWhere = " DelYN = 'N'  and titleIDX = " & tidx
	End if
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
			<div class="page_title"><h1><%=opage.name%>&nbsp;[<%=opage.title%>]</h1></div>


			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
				<!-- #include virtual = "/pub/html/bike/form.contestlevel.asp" -->
				</div>
			<!-- e: 정보 검색 -->

			<!-- s: 리스트 버튼 -->
				<div class="list_btn">
					<a href="./contest.asp" id="btnsave" class="btn" accesskey="i">대회목록</a>&nbsp;&nbsp;&nbsp;&nbsp;
					<a href="#" class="blue_btn" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
					<a href="#" class="blue_btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
					<a href="#" class="pink_btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
				</div>
			<!-- e: 리스트 버튼 -->


			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tr>
							<th>번호</th><th>분류</th><th>경기진행</th><th>성별</th><th>부</th><th>경기일자</th><th>신청(명)</th><th>신청목록</th>
						</tr>
						<tbody id="contest">
						<%
						Do Until rs.eof
							b_boo = rs("boo")
							b_idx = rs("levelIDX")
							b_tidx = rs("titleIDX")
							b_levelno = rs("levelno")
							b_sdetailtitle = rs("detailtitle")
							b_GameS = Replace(Left(rs("Gameday"),10),"-",".")
							b_writeday = Replace(Left(rs("writedate"),10),"-",".")
							b_sex = rs("sex")
							b_booNM = rs("booNM")

							%><!-- #include virtual = "/pub/html/bike/list.contestlevel.asp" --><%
					  
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








<div id="ModallastRound" class="modal hide fade step2modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="z-index:1100">






