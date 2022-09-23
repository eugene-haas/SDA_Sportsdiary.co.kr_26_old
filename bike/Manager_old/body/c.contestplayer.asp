<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	If request("idx") = "" Then
		Response.redirect "./contest.asp"
		Response.End
	End If

	ln = chkReqMethod("ln", "GET") '대회전체



	idx = chkInt(chkReqMethod("idx", "GET"), 1)
	teamidx = chkInt(chkReqMethod("teamidx", "GET"), 1)
	page = chkInt(chkReqMethod("page", "GET"), 1)



	entryfilter = chkInt(chkReqMethod("entrylist", "GET"), 0) '0 전체, 1 참가자 , 2 대기자

	search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
	search_first = chkInt(chkReqMethod("search_first", "POST"), 0)
	page = iif(search_first = "1", 1, page)
	titleidx = idx

	'EntryFilter 정보
	IF entryfilter = 1 then
	entryfilter = "Y"
	ELSEIF entryfilter = 2 Then
	entryfilter = "N"
	ELSE
	entryfilter = ""
	end if

	'request 처리##############

	'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
	Set db = new clsDBHelper

	strTableName = " sd_TennisTitle "
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,EnterType "

	SQL = "select top 1 "&strFieldName&" from " & strTableName & " where GameTitleIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	title = rs("gameTitleName")
	entertype = rs("EnterType")


	SQL = "select a.TeamGbNm,a.level, b.LevelNm  from tblRGameLevel as a left join tblLevelInfo as b  ON a. level = b.level where a.RGameLevelidx = " & teamidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	teamnm = rs("TeamGbNm")
	levelnm = rs("LevelNm")
	levelno = rs("level")

	Select Case Left(levelno,3)
	Case "200"
		boo = "단식"
	Case "201"
		boo = "복식"
	End Select



'sql = "select userName,gameMemberIDX from sd_TennisMember where GameTitleIDX = 65 and gamekey3 = 20101002 and gubun in (0,1) and delYN='N' order by gameMemberIDX asc"
'Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'response.write SQL
'Call rsdrow(rs)


	'대회에 참여가 결정된 맴버 아이디목록 추출
	If ln = "0" Then
	SQL ="select userName,gameMemberIDX,playerIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gubun in (0,1) and  delYN='N'  order by gameMemberIDX asc"
	else
	SQL ="select userName,gameMemberIDX,playerIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gamekey3 = " & levelno & " and gubun in (0,1) and  delYN='N'  order by gameMemberIDX asc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)




'response.write SQL
'Call rsdrow(rs)
'Response.end

	If Not rs.EOF Then
		arrM = rs.GetRows()
	End if

	'######################

	intPageNum = page
	intPageSize = 3000
	'PaymentType 입금확인 Y확인, N미입금, F환불

	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "

	accsql = " (select top 1 (n.fee + n.fund)   from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as accTotal "
	paysql = " (select top 1 VACCT_NO from TB_RVAS_LIST where CUST_CD = a.RequestIDX) as payok "
	vaccsql = " (select top 1 VACCT_NO from TB_RVAS_MAST where CUST_CD = a.RequestIDX) as vno "


	strTableName = "  tblGameRequest as a "
	strFieldName = " RequestIDX,GameTitleIDX,level,"&lvlsql&",EnterType,WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,EntryListYN "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint, username,userphone,txtMemo,paymentNm,PaymentType ,UserPass, "& accsql &"," & paysql & "," & vaccsql
	strSort = "  ORDER By RequestIDX Desc"
	strSortR = "  ORDER By  RequestIDX Asc"

	If ln = "0" Then
		strWhere = " DelYN = 'N' and GameTitleIDX = " & idx
	Else
		strWhere = " GameTitleIDX = "&idx&"  and level = '"&levelno&"' and DelYN = 'N'"
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10





p1rpoint = 0
p2rpoint = 0

	bRS = listBoo() '부목록 코드, 이름 rs fn_tennis.asp
%>


<%'View ####################################################################################################%>
<a name="contenttop"></a>

		<form name="frm" method="post">

		<div class="top-navi-inner">
			<div class="top-navi-tp">
				<h3 class="top-navi-tit" style="height: 50px;">
					<strong>대회정보 > 대회신청 정보 (tblGameRequest)</strong>
				</h3>
			</div>

			<div class="top-navi-btm">
				<div class="navi-tp-table-wrap"  id="gameinput_area">
					<!-- #include virtual = "/pub/html/tennisAdmin/gameInfoPlayerForm.asp" -->
				</div>

				<div class="btn-right-list">

					<%If USER_IP = "118.33.86.240" Then%>
					<!-- <a href="./contestplayer.asp?idx=<%=idx%>&teamidx=<%=teamidx%>&ln=0" id="btnsave" class="btn">대회 전체 참가자 보기</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; -->
					<%End if%>

					<a href="./contestlevel.asp?idx=<%=idx%>" id="btnsave" class="btn" accesskey="i">부목록</a>&nbsp;&nbsp;&nbsp;&nbsp;

					<a href="#" id="btnsave" class="btn" onclick="mx.input_frm('<%=teamnm%>(<%=levelnm%>)');" accesskey="i">등록(I)</a>
					<a href="#" id="btnupdate" class="btn" onclick="mx.update_frm('<%=teamnm%>(<%=levelnm%>)');" accesskey="e">수정(E)</a>
					<a href="#" id="btndel" class="btn btn-delete" onclick="if (confirm('신청내역을 삭제하시겠습니까?')) {mx.del_frm();}" accesskey="r">삭제(R)</a>
				</div>
			</div>

		</div>
		</form>


		<div class="btn-left-list">
				<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn-more-result">
					전체 (<strong id="totcnt"><%=intTotalCnt%></strong>)건 / <strong class="current">현재페이지(<span id="nowcnt">1</span>)</strong>
				</a>

				<%If USER_IP = "118.33.86.240-" Then%>
				<%=boo%> 테스트용 선수 자동 생성 명수 : <input type="number" id="autono" style="width:50px;height:30px;margin-bottom:0px;text-align:right;" value="1">
				<a href="#" id="btnsave" class="btn" onclick="mx.auto_frm('<%=teamnm%>(<%=levelnm%>)');" accesskey="i">자동생성(A)</a>&nbsp;&nbsp;
				<%End if%>



				<label for="fnd_EntryList" style="display: inline-block;"><!-- 신청구분 --></label>
				<a href="javascript:mx.attDelList(<%=titleidx%>,<%=levelno%>)" class="btn">참가취소목록</a>
				<a href="./attexcel.asp?tidx=<%=titleidx%>&levelno=<%=levelno%>" class="btn" >참가신청엑셀다운로드</a>
		</div>
<%

	Response.write "<table class=""table-list admin-table-list"">"
	'Response.write "<colgroup><col width=""60px""><col width=""60px""><col width=""60px""><col width=""60px""><col width=""*""><col width=""60px""></colgroup>"
	'Response.write "<thead><th>번호</th><th>대회명</th><th>구분</th><th>참여부</th><th>신청정보</th><th>선수A</th><th>PT</th><th>A소속</th><th>선수B</th><th>PT</th><th>B소속</th><th>예선구분</th></thead>"
	Response.write "<thead><th>번호</th><th>신청인</th><th>전화번호</th><th>입금자명</th><th style='border-right: 5px solid red;'>입금상태</th><th>선수A</th><th style='width:200px;'>A소속</th><th>선수B</th><th>B소속</th><th>참가구분</th><th>예선구분</th></thead>"
	Response.write "<tbody id=""contest"">"
	Response.write " <tr class=""gametitle"" ></tr>"


	no = 	intTotalCnt
	Do Until rs.eof


		idx = rs("RequestIDX")
		level = rs("level")
		Select Case Left(level,3)
		Case "201","200"
			boo = "개인전"
		Case "202"
			boo = "단체전"
		End Select

		pidx1 = rs("P1_PlayerIDX")
		pidx2 = rs("P2_PlayerIDX")

		p1nm = rs("P1_UserName")
		p1t1 = rs("P1_TeamNm")
		p1t2 = rs("P1_TeamNm2")
		Sex1 = rs("P1_SEX")
		If Sex1 = "Man" Then
			Sex1 = "남"
		else
			Sex1 = "여"
		End if

		p2nm = rs("P2_UserName")
		p2t1 = rs("P2_TeamNm")
		p2t2 = rs("P2_TeamNm2")
		Sex2 = rs("P2_SEX")
		rEntryListYN = rs("EntryListYN")
		If rEntryListYN = "Y" Then
			rEntryListYN="참가자"
		Else
			rEntryListYN="대기자"
		End If

		If Sex2 = "Man" Then
			Sex2 = "남"
		else
			Sex2 = "여"
		End if

		p1 = "<span style='color:orange'>" & p1nm & "</span> (" & p1t1& ", " & p1t2 & ") " & sex1
		p2 = "<span style='color:orange'>" & p2nm & "</span> (" & p2t1& ", " & p2t2 & ") " & sex2

		player = p1 & "&nbsp;&nbsp;&nbsp;" & p2
		teamgbnm = rs("TeamGbNm")

		p1rpoint = rs("P1_rpoint")
		p2rpoint = rs("P2_rpoint")

		attmember = False
		playeridx = 0
		If IsArray(arrM) Then '플레이어 1로만 구분
			For arp = LBound(arrM, 2) To UBound(arrM, 2)
				playerNM = arrM(0, arp)
				p1_playerIDX = arrM(2,arp)

				If playerNM = p1nm And CDbl(p1_playerIDX) = CDbl(pidx1) Then
					attmember = true
					playeridx = arrM(1,arp) 'gameMemberIDX
				End If

			Next
		End If

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

		%>
			<!-- #include virtual = "/pub/html/tennisAdmin/gameInfoPlayerList.asp" -->
	<%
	no = no - 1
	rs.movenext
	Loop
	Response.write "</tbody>"
	Response.write "</table>"


	Set rs = Nothing
%>
<!-- #include virtual = "/pub/html/tennisAdmin/html.modalplayer.asp" -->
