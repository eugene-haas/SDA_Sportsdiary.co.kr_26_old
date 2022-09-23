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

  Set db = new clsDBHelper

	SQL = "Select title from K_titleList where delYN = 'N' group by title order by title "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End If

	SQL = "Select idx,name from K_openList where delYN = 'N' and gubun = 1"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrH = rs.GetRows()
	End If

	SQL = "Select idx,name from K_openList where delYN = 'N' and gubun = 2"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrO = rs.GetRows()
	End If



	strSort = "  order by GIDX desc"
	strSortR = "  order by GIDX Asc"
	Dim intTotalCnt, intTotalPage

	strFieldName = "GIDX,SportsGb,SportsGbSub,GameTitle,GameType,Sido,zipcode,addr,Stadium,GameYear,GameS,GameE,Gamedatecnt,GameHost,GameOrganize"
	strFieldName = strFieldName & ",VOD1,VOD2,VOD3,VOD4,VOD5,VOD6,m_videoDate,h_videoDate,ip"

	intPageNum = page
	intPageSize = 10
	
	strTableName = "  K_gameinfo "
	strWhere = " DelYN = 'N'  "
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10



	'SQL = "Select top 10 GIDX,"&strFieldName&" from K_gameinfo where delYN = 'N' order by GIDX desc"
	'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

%>
<%'View ####################################################################################################%>
<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="dnlayer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회정보</h1></div>


			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gameinput_area">
				  <!-- #include virtual = "/pub/html/ksports/inputform.asp" -->
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
							<th>번호</th><th>기간</th><th>지역</th><th>체육관명</th><th>대분류</th><th>종목</th><th>대회명</th><th>대회일수</th><th>종별</th><th>촬영일수</th>
						</tr>
						<tbody id="contest">
						<%
						k_shotcnt = 0
						Do Until rs.eof
							k_idx = rs("GIDX")
							k_sgb = rs("SportsGb")
							k_sgbsub = rs("SportsGbSub")
							k_title = rs("GameTitle")
							k_gametype = rs("GameType")
							k_sido = rs("Sido")
							k_zipcode = rs("zipcode")
							k_addr = rs("addr")
							k_Stadium = rs("Stadium")
							k_GameYear = rs("GameYear")

							k_GameS = Replace(Left(rs("GameS"),10),"-",".")
							k_GameE = Replace(Left(rs("GameE"),10),"-",".")
							k_Gamedatecnt = rs("Gamedatecnt")
							k_GameHost = rs("GameHost")
							k_GameOrganize = rs("GameOrganize")
							k_VOD1 = rs("VOD1")
							k_VOD2 = rs("VOD2")
							k_VOD3 = rs("VOD3")
							k_VOD4 = rs("VOD4")
							k_VOD5 = rs("VOD5")
							k_VOD6 = rs("VOD6")
							k_mvod = rs("m_videoDate")
							k_hvod = rs("h_videoDate")
							k_ip = rs("ip")

							If k_mvod <> "" Then
								k_shotcnt = CDbl(ubound(Split(k_mvod,","))) + 1
							End If
							If k_hvod <> "" Then
								k_shotcnt = CDbl(k_shotcnt) +CDbl(ubound(Split(k_hvod,","))) + 1
							End if							

							k_VOD = k_VOD1& k_VOD2 & k_VOD3 & k_VOD4 & k_VOD5 & k_VOD6

							%><!-- #include virtual = "/pub/html/ksports/onelinelist.asp" --><%
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
				<!-- <a href="javascript:mx.contestMore()">더보기</a> -->
			</div>
			<!-- e: 더보기 버튼 -->
		</div>
		<!-- s: 콘텐츠 끝 -->