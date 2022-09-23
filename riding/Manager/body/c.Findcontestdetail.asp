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
'Response.write "작업 예정~~~~"
'Response.end



 'Controller ################################################################################################
	REQ = chkReqMethod("p", "POST")
	If REQ <> "" then
	Set oJSONoutput = JSON.Parse(REQ)
		selecttype = "search"
		page = chkInt(oJSONoutput.pg,1)
		stype = chkInt(oJSONoutput.st,1)
		ptype = chkInt(oJSONoutput.pt,1) '입금상태

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


	If stype = "3" Then
		selecttype = "default"
	End if

	'request 처리##############
	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper


	strSort = "  ORDER By RequestIDX Desc"
	strSortR = "  ORDER By  RequestIDX Asc"
	Dim intTotalCnt, intTotalPage

'tblLevelInfo 를 사용하지않음 다시 짜자 쿼리....

	titlesql = " b.gameTitleName as gametitle "
	attsql = " (select top 1 gameMemberIDX  from sd_TennisMember where GameTitleIDX = a.GameTitleIDX and gamekey3 = a.levelno and playeridx = a.P1_PlayerIDX ) as attmidx "
	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo_사용안함 as m  ON n.levelno = m.level  where n.levelno = a.levelno and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "
	accsql = " (select top 1 (n.fee + n.fund)   from tblRGameLevel as n left join tblLevelInfo_사용안함 as m  ON n.levelno = m.level  where n.levelno = a.level and n.GameTitleIDX = a.GameTitleIDX) as accTotal "
	paysql = " (select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar) ) as payok "
	vaccsql = " (select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar)) as vno "

	strFieldName = " a.RequestIDX,a.GameTitleIDX,a.levelno," & attsql & "," & lvlsql&"," & titlesql&","& accsql &"," & paysql & "," & vaccsql & ",a.EnterType,a.WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,EntryListYN "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint, username,userphone,txtMemo,paymentNm,PaymentType ,UserPass "


	If selecttype = "default" then
		strWhere = " a.DelYN = 'N' "

		Select Case CDbl(stype) '대회명

		Case 3 '대회명
			SQL = "Select  GameTitleIDX,gameTitleName from sd_TennisTitle where  DelYN = 'N' and gameE > getdate() - 30 or gametitleidx = 25 order by GameTitleIDX desc "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			If Not rs.EOF Then
				arrRT = rs.GetRows()
			End If

			'검색 부서 검색
			If tidx > 0 then
				strTableName = "  tblRGameLevel as a left join tblLevelInfo_사용안함 as b  ON a.levelno = b.level and b.DelYN ='N' "
				SQL = "Select a.Level,a.TeamGbNm,b.LevelNm from " & strTableName & " where a.GameTitleIDX = "&tidx&" and b.LevelNm <> '최종라운드' and a.DelYN = 'N' ORDER BY RGameLevelidx Desc "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				If Not rs.EOF Then
					arrRS = rs.GetRows()
				End If
			End If

			If tidx > 0 Then
			strWhere = " b.GameTitleIDX =  " &  tidx & " and a.DelYN = 'N'  "
			strSort = "  ORDER By level desc, RequestIDX Desc"
			strSortR = "  ORDER By level asc,  RequestIDX Asc"
			End If

			If ridx > 0 Then
			strWhere = " b.GameTitleIDX =  " &  tidx & " and level = '"&ridx&"' and a.DelYN = 'N'  "
			strSort = "  ORDER By level desc, RequestIDX Desc"
			strSortR = "  ORDER By level asc,  RequestIDX Asc"
			End if


'			If tidx > 0 And ridx > 0  then
'				strTableName = "  tblGameRequest as a inner join sd_TennisTitle as b ON a. GameTitleIDX = b. gameTitleIDX "
'				SQL = "select count(*) from " & strTableName & " where " & strWhere
'				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'				intTotalCnt = rs(0)
'
'				SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere & strSort
'				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'			Else
'				intPageNum = page
'				intPageSize = 10
'
'				strTableName = "  tblGameRequest as a inner join sd_TennisTitle as b ON a. GameTitleIDX = b. gameTitleIDX "
'				Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
'				block_size = 10
'
'			End if




		Case Else


			intPageNum = page
			intPageSize = 10

			strTableName = "  tblGameRequest as a inner join sd_TennisTitle as b ON a. GameTitleIDX = b. gameTitleIDX "
			'Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
			block_size = 10


		End Select

	Else
		Select Case CDbl(stype)
		Case 1 '입금자명
			strWhere = " a.username like '" &  svalue & "%' and a.DelYN = 'N'  "
		Case 2 '선수명
			strWhere = " (a.P1_UserName like '" &  svalue & "%' or a.P2_UserName like '" &  svalue & "%')    and a.DelYN = 'N'  "
		End select

		Select Case CDbl(ptype)
		Case 1 '전체
		Case 2 '입금전

			If strWhere = "" then
				strWhere = " a.PaymentType = 'N' and a.DelYN = 'N'  "
			Else
				strWhere =  strWhere & " and a.PaymentType = 'N' "
			End if
		Case 3 '입금완료

			If strWhere = "" then
				strWhere = " a.PaymentType = 'Y' and a.DelYN = 'N'  "
			Else
				strWhere =  strWhere & " and a.PaymentType = 'Y' "
			End if
		End select


		intPageNum = page
		intPageSize = 10

		strTableName = "  tblGameRequest as a inner join sd_TennisTitle as b ON a. GameTitleIDX = b. gameTitleIDX "
		'Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10


	End if



%>
<%'View ####################################################################################################%>
<div class="admin_content">

	<!-- s: 페이지 타이틀 -->
	<div class="page_title"><h1>참가신청관리 - 참가신청현황 > 상세보기</h1></div>
	<!-- e: 페이지 타이틀 -->

	<!-- s: 정보 검색 -->
	<div class="info_serch">
		<!-- #include virtual = "/pub/html/riding/findcontestplayer.asp" -->
	</div>
	<!-- e: 정보 검색 -->

	<hr />

	<!-- s: 전체 페이지 -->
	<div class="btn-toolbar">
<!-- 		<a href="" class="btn btn-primary">엑셀 업로드</a>  <a href="" class="btn btn-primary">엑셀 다운로드</a>  전체 <span id="totcnt"><%=intTotalCnt%></span>건</a> --> 
	</div>
	<!-- s: 전체 페이지 -->




	<!-- s: 테이블 리스트 -->
	<div class="table-responsive">
		<table cellspacing="0" cellpadding="0" class="table table-hover">
			<thead>
				<tr>
					<th>No</th>
					<th>신청인</th>
					<th>신청자전화번호</th>
					<th>입금자명</th>
					<th>입금상태</th>
					<th>선수명</th>
					<th>말</th>
					<th>종별</th>
<!-- 					<th>마방신청</th> -->
<!-- 					<th>톱밥신청포수</th> -->
					<th>상태</th>
					<th>신청취소</th>
				</tr>
			</thead>

			<tbody id="contest">
				<tr>
					<td>No</td>
					<td>신청인</td>
					<td>신청자전화번호</td>
					<td>입금자명</td>
					<td>입금상태</td>
					<td>선수명</td>
					<td>말</td>
					<td>종별</td>
<!-- 					<td>마방신청</td> -->
<!-- 					<td>톱밥신청포수</td> -->
					<td>상태</td>
					<td><a href="javascript:alert('신청취소')" class="btn btn-primary">신청취소</a></td>
				</tr>

			</tbody>
		</table>
	</div>




<%
	Call userPagingT2 (intTotalPage, 10, page, "mx.searchPlayer", oJSONoutput)
%>

</div>

