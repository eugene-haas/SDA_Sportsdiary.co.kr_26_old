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

'request 처리##############
REQ = chkReqMethod("p", "POST")
	If REQ <> "" Then
		Set oJSONoutput = JSON.Parse(REQ)
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)


		If hasown(oJSONoutput, "sEventYear") = "ok" Then
			ey = oJSONoutput.sEventYear
		Else
			ey = ""
		End If

		If hasown(oJSONoutput, "sClassCode") = "ok" Then
			cc = oJSONoutput.sClassCode
		Else
			cc = ""
		End If

		If hasown(oJSONoutput, "sGameName") = "ok" Then
			gn = oJSONoutput.sGameName
		Else
			gn = ""
		End If

	Else
		page = chkInt(chkReqMethod("page", "GET"), 1)
	End If




	If totalCount = "" Then
		totalCount = -1
	End If

'db 호출
  Set db = new clsDBHelper

	'대회정보 불러오기
	strTableName = " K_gameVideoInfo a LEFT JOIN K_gameFileName b ON a.GameVideo = b.GameVideo "
	strWhere = " DelYN= 'N' "

	If ey <> "" Then
		strWhere = strWhere & " AND EventYear LIKE '%"&ey&"%' "
	End If

	If cc <> "" Then
		strWhere = strWhere & " AND ClassCode LIKE '%"&cc&"%' "
	End If

	If gn <> "" Then
		strWhere = strWhere & " AND GameName LIKE '%"&gn&"%' "
	End If

	strFieldName = "(select ClassName from tblClassList Where ClassCode = a.ClassCode) AS ClassName, "
	strFieldName = strFieldName & " GameAgeDistinctText As GameAgeDistinct, "
	strFieldName = strFieldName & " GameGroupTypeText As GameGroupType, "
	strFieldName = strFieldName & " GameMatchTypeText As GameMatchType, "
	strFieldName = strFieldName & " GameMemberGenderText AS GameMemberGender, "
	strFieldName = strFieldName & " gameVideoIDX, EventYear, GameCode, GameSDate, GameEDate, GameName, a.GameVideo, GameOrder, GameMember, "
	strFieldName = strFieldName & " ( select detailType from k_detailTypeList WHERE idx = a.GameDetailTypeIDX ) detailType,  "
  strFieldName = strFieldName & " b.FileName AS GameFileName  "


	strSort = "  order by gameVideoIDX desc"
	strSortR = "  order by gameVideoIDX Asc"

	Dim intTotalCnt, intTotalPage
	intPageNum = page
	intPageSize = 20
	block_size = 10


	Set rs2 = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )

	If Not rs2.EOF Then
		arrGame = rs2.GetRows()
	End If



	'종목선택 불러오기
	SQL = "Select classIDX, classCode, className from tblClassList order by className ASC"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrClass = rs.GetRows()
	End If

	'성별선택 불러오기
	SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameMemberGender'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrGender = rs.GetRows()
	End If

	'학군선택 불러오기
	SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameAgeDistinct'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrAge = rs.GetRows()
	End If

	'경기방식선택 불러오기
	SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameMatchType'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrMatch = rs.GetRows()
	End If

	'종별선택불러오기
	SQL = "SELECT CodeValue, CodeText FROM tblCode WHERE CodeKind = 'GameGroupType'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrGroup = rs.GetRows()
	End If



db.dispose()

%>

<%'View ####################################################################################################%>
<!-- iOS에서는 position:fixed 버그가 있음, 적용하는 사이트에 맞게 position:absolute 등을 이용하여 top,left값 조정 필요 -->
<div id="dnlayer" style="display:none;position:fixed;overflow:hidden;z-index:1;-webkit-overflow-scrolling:touch;">
<img src="//t1.daumcdn.net/localimg/localimages/07/postcode/320/close.png" id="btnCloseLayer" style="cursor:pointer;position:absolute;right:-3px;top:-3px;z-index:1" onclick="closeDaumPostcode()" alt="닫기 버튼">
</div>


		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회실적</h1></div>


			<!-- s: 정보 입력 -->
				<div class="info_serch" id="gameinput_area">
				  <!-- #include virtual = "/pub/html/ksports/gameinputform.asp" -->
				</div>
			<!-- e: 정보 입력 -->

			<!-- s: 정보 검색 -->
				<div class="info_serch" id="gamesearch_area">
				  <!-- #include virtual = "/pub/html/ksports/gameinfoSearchform.asp" -->
				</div>
			<!-- e: 정보 검색 -->


			<!-- s: 전체 페이지 -->

			<!-- s: 리스트 버튼 -->
				<div class="list_btn">
					<div class="all_page" style="display:inline-block;float:left;">
						<span class="txt">전체 <span class="number" id="totcnt"><%=intTotalCnt%></span>건</span>
					</div>
					<a href="#" class="blue_btn" id="btnsave" onclick="mx.insertGame();" accesskey="i">등록<span>(I)</span></a>
					<a href="#" class="blue_btn" id="btnupdate" onclick="mx.editGame();" accesskey="e">수정<span>(E)</span></a>
					<a href="#" class="pink_btn" id="btndel" onclick="mx.deleteGame();" accesskey="r">삭제<span>(R)</span></a>
				</div>
			<!-- e: 리스트 버튼 -->

			<!-- s: 테이블 리스트 -->
				<div class="table_list contest">
					<table cellspacing="0" cellpadding="0">
						<tbody id="gamelist">
							<tr>
								<th>IDX</th><th>종목</th><th>대회일</th><th>대회이름</th><th>학군</th><th>종별</th><th>방식</th><th>경기순</th><th>참가선수</th><th>성별</th><th>세부종별</th><th>영상</th>
							</tr>
								<%
									If IsArray(arrGame) Then
										For ar = LBound(arrGame, 2) To UBound(arrGame, 2)
											rsClassName = arrGame(0, ar)
											rsGameAgeDistinct = arrGame(1, ar)
											rsGameGroupType = arrGame(2, ar)
											rsGameMatchType = arrGame(3, ar)
											rsGameMemberGender = arrGame(4, ar)
											gameVideoIDX = arrGame(5, ar)
											gameCode = arrGame(7, ar)
											rsGameSDate = arrGame(8, ar)
											rsGameEDate = arrGame(9, ar)
											rsGameName = arrGame(10, ar)
											rsGameVideo = arrGame(11, ar)
											rsGameOrder = arrGame(12, ar)
											rsGameMember = arrGame(13, ar)
											rsDetailType = arrGame(14, ar)
                      rsFileName = arrGame(15, ar)

										%>
											<!-- #include virtual = "/pub/html/ksports/gamelist.asp" -->
										<%
										Next
									End If
								%>
						 </tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->



			<!-- s: 페이징 버튼 -->
			<div class="pagination">
				<%
					Call userPaginglink (intTotalPage, 10, page, "mx.searchPlayer" )
				%>
			</div>
			<!-- e: 페이징 버튼 -->
		</div>
		<!-- s: 콘텐츠 끝 -->
