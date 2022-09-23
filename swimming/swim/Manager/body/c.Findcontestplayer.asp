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

	titlesql = " b.gameTitleName as gametitle "
	attsql = " (select top 1 gameMemberIDX  from sd_TennisMember where GameTitleIDX = a.GameTitleIDX and gamekey3 = a.level and playeridx = a.P1_PlayerIDX ) as attmidx "
	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "
	accsql = " (select top 1 (n.fee + n.fund)   from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as accTotal "
	paysql = " (select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar) ) as payok "
	vaccsql = " (select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.RequestIDX as varchar)) as vno "				

	strFieldName = " a.RequestIDX,a.GameTitleIDX,a.level," & attsql & "," & lvlsql&"," & titlesql&","& accsql &"," & paysql & "," & vaccsql & ",a.EnterType,a.WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,EntryListYN "
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
				strTableName = "  tblRGameLevel as a left join tblLevelInfo as b  ON a.level = b.level and b.DelYN ='N' "
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

			
			If tidx > 0 And ridx > 0  then
				strTableName = "  tblGameRequest as a inner join sd_TennisTitle as b ON a. GameTitleIDX = b. gameTitleIDX "
				SQL = "select count(*) from " & strTableName & " where " & strWhere 
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

				intTotalCnt = rs(0)

				SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere & strSort
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			Else
				intPageNum = page
				intPageSize = 10

				strTableName = "  tblGameRequest as a inner join sd_TennisTitle as b ON a. GameTitleIDX = b. gameTitleIDX "
				Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
				block_size = 10

			End if


		

		Case Else


			intPageNum = page
			intPageSize = 10
			
			strTableName = "  tblGameRequest as a inner join sd_TennisTitle as b ON a. GameTitleIDX = b. gameTitleIDX "
			Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
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
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10


	End if



%>
<%'View ####################################################################################################%>
<div class="admin_content">

	<!-- s: 페이지 타이틀 -->
	<div class="page_title">
		<h1>대회정보 <i class="fas fa-angle-right"></i> 대회신청 정보 (tblGameRequest)</h1>
	</div>
	<!-- e: 페이지 타이틀 -->

	<!-- s: 정보 검색 -->
	<div class="search_top">
		<!-- #include virtual = "/pub/html/swimAdmin/attmemberform.asp" -->
	</div>
	<!-- e: 정보 검색 -->


	<!-- s: 전체 페이지 -->
	<div class="all_page">
		<span class="txt">전체 <span class="number" id="totcnt"><%=intTotalCnt%></span>건</span>
	</div>
	<!-- s: 전체 페이지 -->


	<!-- s: 테이블 리스트 -->
	<div class="table_list findcontestplayer">
		<table cellspacing="0" cellpadding="0">
			<tr>
				<th>번호</th>
				<th>대회명</th>
				<th>부명</th>
				<th>입금자명</th>
				<th>전화번호</th>
				<th>입금상태</th>
				<th>선수A</th>
				<th>선수B</th>
				<th>선수교체</th>
				<th>참가구분</th>
				<th>예선구분</th>
				<th>계좌발송</th>
			</tr>
			<tbody id="contest">
<%
	no = 	intTotalCnt
	Do Until rs.eof

		title = rs("gametitle")
		tidx = rs("GameTitleIDX")
		idx = rs("RequestIDX")
		level = rs("level")
		levelno = level

		p1nm = rs("P1_UserName")
		p1t1 = rs("P1_TeamNm")
		p1t2 = rs("P1_TeamNm2")
		p2nm = rs("P2_UserName")
		p2t1 = rs("P2_TeamNm")
		p2t2 = rs("P2_TeamNm2")
		attmidx = rs("attmidx")


		p1 = "<span style='color:orange'>" & p1nm & "</span> (" & p1t1& ", " & p1t2 & ") " & sex1
		p2 = "<span style='color:orange'>" & p2nm & "</span> (" & p2t1& ", " & p2t2 & ") " & sex2

		player = p1 & "&nbsp;&nbsp;&nbsp;" & p2
		teamgbnm = rs("TeamGbNm")

		If attmidx = "" Or isnull(attmidx) = true Then
			attmember = False
			playeridx = 0		
		Else
			attmember = true
			playeridx = attmidx
		End if
		

		
		pidx1 = rs("P1_PlayerIDX")
		pidx2 = rs("P2_PlayerIDX")

		pay_username = rs("username") '신청인
		pay_userphone = rs("userphone")
		pay_txtMemo = rs("txtMemo")
		pay_paymentNm = rs("paymentNm") '입금자명
		pay_PaymentType = rs("PaymentType")	'PaymentType 입금확인 Y확인, N미입금, F환불

		Select Case  pay_PaymentType
		Case "Y" : paytypestr = "입금"
		Case "M" : paytypestr = "미입금"
		Case "F" : paytypestr = "환불"
		Case Else : paytypestr = "미입금"
		End Select 
		
		p_UserPass = rs("UserPass")

		acctotal = rs("acctotal") '참가비
		payok = rs("payok") '입금완료여부 (사용된 가상계좌번호)
		vno = rs("vno")


'If USER_IP = "118.33.86.240" then
		If attmember = True Then
			rEntryListYN="<span style='color:orange;'>참가자</span>"
			If payok = "" Or isNull(payok) = True Or payok = "1" Then
			gamemember = "<a href=""javascript:if (window.confirm('참가를 취소하면 복구 되지 않습니다.')){mx.delPlayer("& idx &", "& playeridx &");}"" class='btn_a' style='color:red'>신청취소</a>"
			Else '입금자처리
			gamemember = "<a href=""javascript:mx.refundWin("& idx &", "& playeridx &")"" class='btn_a' style='color:red'>신청취소</a>"
			End if
		Else
			rEntryListYN="대기자"
			gamemember = "<a href=""javascript:if (window.confirm('대기자에서 신청자로 전환됩니다.')){mx.setPlayer("& idx &")}"" class='btn_a'>신청전환</a>"
		End If
'Else
'		If attmember = True Then
'			rEntryListYN="<span style='color:orange;'>참가자</span>"
'			gamemember = "<a href=""javascript:if (window.confirm('참가를 취소하면 복구 되지 않습니다.')){mx.delPlayer("& idx &", "& playeridx &");}"" class='btn_a' style='color:red'>신청취소</a>"
'		Else
'			rEntryListYN="대기자"
'			gamemember = "<a href=""javascript:if (window.confirm('대기자에서 신청자로 전환됩니다.')){mx.setPlayer("& idx &")}"" class='btn_a'>신청전환</a>"
'		End If
'End if



		SQL = "Select n.TeamGbNm + '('+ m.LevelNm + ')',n.level  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where  n.GameTitleIDX = " & tidx & " and m.delYN = 'N'  and m.LevelNm <> '최종라운드' ORDER BY n.RGameLevelidx Desc"
		Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs2.EOF Then 
			arrRS = rs2.GetRows()
		End If

		%>

		<!-- #include virtual = "/pub/html/swimAdmin/findgameInfoPlayerList.asp" -->
	<%
	no = no - 1
	rs.movenext
	Loop
	Set rs = Nothing
%>
			</tbody>
		</table>
	</div>




<%
	Call userPaginglink (intTotalPage, 10, page, "mx.searchPlayer" )
%>
<!-- #include virtual = "/pub/html/swimAdmin/html.modalplayer.asp" -->

</div>