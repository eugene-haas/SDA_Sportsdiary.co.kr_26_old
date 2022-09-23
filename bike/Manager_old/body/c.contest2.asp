<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################
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


        <!-- S: sub-content -->
        <div class="sub-content">

			<!-- s: 정보 검색 -->
				<div class="info_serch box-shadow" id="gameinput_area">
				<!-- #include virtual = "/pub/html/bike/form.contest2.asp" -->
				</div>
			<!-- e: 정보 검색 -->

            <!-- S: competition_management -->
            <div class="competition_management">
    			<!-- s: 리스트 버튼 -->
    				<div class="t-btn-box">
    					<a href="#" class="navy-btn" id="btnsave" onclick="mx.input_frm();" accesskey="i">등록<span>(I)</span></a>
    					<a href="#" class="navy-btn" id="btnupdate" onclick="mx.update_frm();" accesskey="e">수정<span>(E)</span></a>
    					<a href="#" class="white-btn" id="btndel" onclick="mx.del_frm();" accesskey="r">삭제<span>(R)</span></a>
    				</div>
    			<!-- e: 리스트 버튼 -->

    			<!-- s: 테이블 리스트 -->
    				<div class="table-box basic-table-box">
    					<table cellspacing="0" cellpadding="0">
    						<tr>
    							<th>번호</th><th>기간</th><th>지역</th><th>대회명</th><th>참가신청/달력/대진표</th><th>대회요강</th><th>대회부목록</th>
    						</tr>
    						<tr id="contest">
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

        							%><!-- #include virtual = "/pub/html/bike/list.contest2.asp" --><%
        						  rs.movenext
        						  Loop
        						  Set rs = Nothing
        						%>
                            </tr>
    					</table>
    				</div>
    			<!-- e: 테이블 리스트 -->


    			<!-- s: 더보기 버튼 -->
    			<div class="paging">
    				<%
    					Call userPaginglinkBike (intTotalPage, 10, page, "mx.searchPlayer" )
    				%>
    			</div>
    			<!-- e: 더보기 버튼 -->
            </div>
            <!-- E: competition_management -->
		</div>
		<!-- s: sub-content -->
