<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	If request("idx") = "" Then
		Response.redirect "./contest.asp"
		Response.End
	End If


	'idx = chkInt(chkReqMethod("idx", "GET"), 1) 'titleidx 로컬스토리지 사용금지
	idx = request("teamidx") '종목인덱스
	'request 처리##############

	Set db = new clsDBHelper

	SQL = "select b.TeamGbNm,b.teamGbIDX, b.LevelNm,b.ridingclass,b.ridingclasshelp,a.GameTitleIDX,a.pubcode,a.pubName  from tblRGameLevel as a left join tblTeamGbInfo as b  ON a.GbIDX = b.teamGbIDX where a.RGameLevelidx = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	teamnm = rs("TeamGbNm")
	levelnm = rs("LevelNm")
	GbIDX = rs("teamGbIDX")
	tidx = rs("GameTitleIDX")
	pcode = rs("pubcode") '참가부상세
	pnm = rs("pubName")

	SQL = "select top 1 gameTitleName from sd_TennisTitle where GameTitleIDX = " & tidx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	title = rs("gameTitleName")



	'대회에 참여가 결정된 맴버 아이디목록 추출
	SQL ="select userName,gameMemberIDX,playerIDX from sd_TennisMember where GameTitleIDX = "&tidx&" and gamekey3 = " & GbIDX & " and pubcode = '"&pcode&"' and gubun in (0,1) and  delYN='N'  order by gameMemberIDX asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrM = rs.GetRows()
	End if

	'######################
	intPageNum = page
	intPageSize = 3000
	'PaymentType 입금확인 Y확인, N미입금, F환불    
	lvlsql = " (select top 1 m.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblTeamGbInfo as m  ON n.GbIDX = m.teamGbIDX  where n.GbIDX = a.gbidx and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "

	accsql = " (select top 1 n.fee    from tblRGameLevel as n left join tblTeamGbInfo as m  ON n.GbIDX = m.teamGbIDX  where n.GbIDX = a.gbidx and n.GameTitleIDX = a.GameTitleIDX) as accTotal "
	paysql = " (   select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.requestIDX as varchar)     ) as payok "
	vaccsql = " (  select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.requestIDX as varchar)   and sitecode = '"&sitecode&"') as vno "

	p1birthsql = " (  select top 1 Birthday from tblplayer where playeridx = a.P1_playeridx) as birth "

	strTableName = "  tblGameRequest as a "
	strFieldName = " RequestIDX,GameTitleIDX,gbidx,"&lvlsql&",EnterType,WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,EntryListYN "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint, username,userphone,txtMemo,paymentNm,PaymentType ,UserPass, "& accsql &"," & paysql & "," & vaccsql & ", "&p1birthsql&" ,P1_id , jangname, readername,readerphone , addr, raceok, pubcode,pubname"
	strSort = "  ORDER By RequestIDX Desc"
	strSortR = "  ORDER By  RequestIDX Asc"


	strWhere = " GameTitleIDX = "&tidx&"  and GbIDX = '"&GbIDX&"' and pubcode = '"&pcode&"' and DelYN = 'N'"



	SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	
	'Dim intTotalCnt, intTotalPage
	'Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	'block_size = 10

	'Call rsdrow(rs)
	'Response.end

p1rpoint = 0
p2rpoint = 0
%>


<%'View ####################################################################################################%>
<div class="admin_content">
	<a name="contenttop"></a>

	<div class="page_title"><h1>대회정보 > 대회신청 정보</h1></div>

		<form name="frm" method="post"></form>


		<div class="btn-toolbar mgt20">
				<a href="javascript:mx.contestMore(<%=tidx%>)" class="btn btn-link">
					전체 (<span id="totcnt"><%=intTotalCnt%></span>)건 / <span class="current">현재페이지(<span id="nowcnt">1</span>)</span>
				</a>
				<!-- <label for="fnd_EntryList" style="display: inline-block;"> -->
					<!-- 신청구분 -->
				<!-- </label> -->


				<%'If USER_IP = "118.33.86.240" Then%>
				<%=boo%> 테스트용 선수 자동 생성 명수 : <input type="number" id="autono" style="width:50px;height:30px;margin-bottom:0px;text-align:right;" value="1">
				<a href="#" id="btnsave" class="btn btn-default" onclick="mx.auto_frm(<%=tidx%>,<%=gbidx%>,'<%=pcode%>','<%=pnm%>');" accesskey="A">자동생성(A)</a>&nbsp;&nbsp;
				<%'End if%>


				<div class="btn-group flr">

<%If showhide = "show" then%>					
					<%If CDbl(ADGRADE) > 500 then%>
					<a href="javascript:mx.attDelList(<%=tidx%>,<%=GbIDX%>)" class="btn btn-primary">참가취소목록</a>
						<%If ln = "1" then%>
							<a href="./attexcel.asp?tidx=<%=tidx%>&gbidx=<%=teamnm%>" class="btn btn-primary"><span class="glyphicon glyphicon-save-file"></span>참가신청엑셀다운</a>
						<%Else '팀형태%>
							<a href="./attexcel.asp?tidx=<%=tidx%>&gbidx=<%=GbIDX%>" class="btn btn-primary"><span class="glyphicon glyphicon-save-file"></span>참가신청엑셀다운</a>
						<%End if%>
					<%End if%>
<%End if%>

				</div>
		</div>

		<div class="table-responsive">
			<table cellspacing="0" cellpadding="0" class="table table-hover">
				<thead>
					<tr>
						<%If CDbl(ADGRADE) > 500 then%>
						<th><span>번호</span></th><th><span>신청인</span></th>
						<th><span>전화번호</span></th><th><span>입금자명</span></th>
						<th><span>입금상태</span></th>
						<th><span>선수명(ID)</span></th><th><span>말</span></th>
						<th><span>종별</span></th><th><span>참가구분</span></th><th><span>신청구분</span></th>
						<%else%>
						<th><span>번호</span></th>
						<th><span>핸드폰</span></th>
						<th><span>입금상태</span></th>
						<th><span>선수명(ID)</span></th><th><span>생년월일</span></th><th><span>완영</span></th><th><span>단체명(단체장)</span></th>
						<th><span>지도자(핸드폰)</span></th><th><span>참가구분</span></th>
						<%End if%>
					</tr>
				</thead>



				<tbody id="contest">
				 <tr class="gametitle" ></tr>
					<%

						'no = 	intTotalCnt
						no = 1
						Do Until rs.eof


							idx = rs("RequestIDX")
							level = rs("gbidx")
							Select Case Left(level,3)
							Case "201","200"
								boo = "개인전"
							Case "202"
								boo = "단체전"
							End Select

							pidx1 = rs("P1_PlayerIDX")
							pidx2 = rs("P2_PlayerIDX")
							p1phone = rs("P1_UserPhone")

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

							p1 = "<span>" & p1nm & "</span> (" & p1t1& ", " & p1t2 & ") " & sex1
							p2 = "<span>" & p2nm & "</span> (" & p2t1& ", " & p2t2 & ") " & sex2

							player = p1 & "&nbsp;&nbsp;&nbsp;" & p2
'							teamgbnm = rs("TeamGbNm")

							p1rpoint = rs("P1_rpoint")
							p2rpoint = rs("P2_rpoint")

							p1_id = rs("P1_id")
							p1_birth = rs("birth")


							jangname = rs("jangname")
							readername = rs("readername")
							readerphone = rs("readerphone")
							addr = rs("addr")
							raceok = rs("raceok") '완주여부



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


						pcode = rs("pubcode")
						pnm = rs("pubname")


							If attmember = True Then
								rEntryListYN="<span style=""color:orange;"">참가자</span>"
								If payok = "" Or isNull(payok) = True Or payok = "1" Then
								gamemember = "<a href=""javascript:if (window.confirm('참가를 취소하면 복구 되지 않습니다.')){mx.delPlayer("& idx &", "& playeridx &");}"" class='btn btn-default' >신청취소</a>"
								Else '입금자처리
								gamemember = "<a href=""javascript:mx.refundWin("& idx &", "& playeridx &")"" class='btn btn-default'>신청취소</a>"
								End if
							Else
								rEntryListYN="<span>대기자</span>"
								gamemember = "<a href=""javascript:if (window.confirm('대기자에서 신청자로 전환됩니다.')){mx.setPlayer("& idx &")}"" class='btn btn-default'>신청전환</a>"
							End If

							%>
								<!-- #include virtual = "/pub/html/riding/gameInfoPlayerList.asp" -->
						<%
						'no = no - 1
						no = no + 1
						rs.movenext
						Loop
						Response.write "</tbody>"
						Response.write "</table>"


						Set rs = Nothing
					%>
		</div>
<!-- #include virtual = "/pub/html/riding/html.modalplayer.asp" -->
