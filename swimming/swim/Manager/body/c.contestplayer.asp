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
	teamidx = request("teamidx")
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

	Set db = new clsDBHelper

	strTableName = " sd_TennisTitle "
	strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,EnterType "

	SQL = "select top 1 "&strFieldName&" from " & strTableName & " where GameTitleIDX = " & idx
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	title = rs("gameTitleName")
	entertype = rs("EnterType")



	If isnumeric(teamidx) = true then
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
	Else
		SQL = "select teamNm from tblTeamInfo where team = '"&teamidx&"' "
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		teamnm = rs("teamnm")
		ln = "1"
	End if







	'대회에 참여가 결정된 맴버 아이디목록 추출
	If ln = "0" Then
	SQL ="select userName,gameMemberIDX,playerIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gubun in (0,1) and  delYN='N'  order by gameMemberIDX asc"
	ElseIf ln = "1" then
	SQL ="select userName,gameMemberIDX,playerIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gubun in (0,1) and TeamANa = '"&teamnm&"' and  delYN='N'  order by gameMemberIDX asc"
	else
	SQL ="select userName,gameMemberIDX,playerIDX from sd_TennisMember where GameTitleIDX = "&idx&" and gamekey3 = " & levelno & " and gubun in (0,1) and  delYN='N'  order by gameMemberIDX asc"
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



	If Not rs.EOF Then
		arrM = rs.GetRows()
	End if

	'######################
	intPageNum = page
	intPageSize = 3000
	'PaymentType 입금확인 Y확인, N미입금, F환불
	lvlsql = " (select top 1 n.TeamGbNm + '('+ m.LevelNm + ')'  from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as TeamGbNm "

	accsql = " (select top 1 (n.fee + n.fund)   from tblRGameLevel as n left join tblLevelInfo as m  ON n. level = m.level  where n.level = a.level and n.GameTitleIDX = a.GameTitleIDX) as accTotal "
	'paysql = " (   select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_LIST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.requestIDX as varchar)     ) as payok "
	paysql = " payOK "
	vaccsql = " (  select top 1 VACCT_NO from SD_rookieTennis.dbo.TB_RVAS_MAST where CUST_CD = '"&Left(sitecode,2)&"' + Cast(a.requestIDX as varchar)   and sitecode = '"&sitecode&"') as vno "

	p1birthsql = " (  select top 1 Birthday from tblplayer where playeridx = a.P1_playeridx) as birth "

	strTableName = "  tblGameRequest as a "

'If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
'	strFieldName ="  RequestIDX, "& accsql &"," & paysql & "," & vaccsql & ", "&p1birthsql&" ,p1_username"
'Else
	strFieldName = " RequestIDX,GameTitleIDX,level,"&lvlsql&",EnterType,WriteDate,P1_PlayerIDX,P1_UserName,P1_UserLevel,P1_TeamNm,P1_TeamNm2,P1_UserPhone,P1_Birthday,P1_SEX,EntryListYN "
	strFieldName = strFieldName & " ,P2_PlayerIDX,P2_UserName,P2_UserLevel,P2_TeamNm,P2_TeamNm2,P2_UserPhone,P2_Birthday,P2_SEX,P1_rpoint,P2_rpoint, username,userphone,txtMemo,paymentNm,PaymentType ,UserPass, "& accsql &"," & paysql & "," & vaccsql & ", "&p1birthsql&" ,P1_id , jangname, readername,readerphone , addr, raceok "
'End if
	
	strSort = "  ORDER By RequestIDX Desc"
	strSortR = "  ORDER By  RequestIDX Asc"

	If ln = "0" Then
		strWhere = " DelYN = 'N' and GameTitleIDX = " & idx
	ElseIf ln = "1" Then
		strWhere = " DelYN = 'N' and GameTitleIDX = " & idx & " and p1_teamNm = '"&teamnm&"' "
	Else
		strWhere = " GameTitleIDX = "&idx&"  and level = '"&levelno&"' and DelYN = 'N'"
	End if


	Dim intTotalCnt, intTotalPage
	Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
	block_size = 10

If Request.ServerVariables("REMOTE_ADDR") = "118.33.86.240" Then
'Response.write paysql

'Call rsdrow(rs)
'Response.end
End if



p1rpoint = 0
p2rpoint = 0

	bRS = listBoo() '부목록 코드, 이름 rs fn_tennis.asp
%>


<%'View ####################################################################################################%>
<div class="admin_content">
	<a name="contenttop"></a>

	<div class="page_title"><h1>대회정보 > 대회신청 정보</h1></div>

		<form name="frm" method="post"></form>


		<div class="btn-toolbar mgt20">
				<a href="javascript:mx.contestMore(<%=titleidx%>)" class="btn btn-link">
					전체 (<span id="totcnt"><%=intTotalCnt%></span>)건 / <span class="current">현재페이지(<span id="nowcnt">1</span>)</span>
				</a>
				<!-- <label for="fnd_EntryList" style="display: inline-block;"> -->
					<!-- 신청구분 -->
				<!-- </label> -->

				<div class="btn-group flr">

					<%If CDbl(ADGRADE) > 500 then%>
					<a href="javascript:mx.attDelList(<%=titleidx%>,<%=levelno%>)" class="btn btn-primary">참가취소목록</a>
						<%If ln = "1" then%>
							<a href="./attexcel.asp?tidx=<%=titleidx%>&levelno=<%=teamnm%>" class="btn btn-primary"><span class="glyphicon glyphicon-save-file"></span>참가신청엑셀다운</a>
						<%Else '팀형태%>
							<a href="./attexcel.asp?tidx=<%=titleidx%>&levelno=<%=levelno%>" class="btn btn-primary"><span class="glyphicon glyphicon-save-file"></span>참가신청엑셀다운</a>
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
						<th><span>선수명(ID)</span></th><th><span>완영</span></th><th><span>단체명(단체장)</span></th>
						<th><span>지도자(핸드폰)</span></th><th><span>참가구분</span></th><th><span>신청구분</span></th>
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

<%
'Do Until rs.eof
'
'Response.write rs("P1_UserName") & " " & rs("vno")  & "<br>"
'
'rs.movenext
'loop
'Response.write "</body></table>"
'Response.end
%>

				 <tr class="gametitle" ></tr>
					<%

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
							p1userphone = rs("P1_UserPhone")

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
							teamgbnm = rs("TeamGbNm")

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
						payok = rs("payok") '입금완료여부 (사용된 가상계좌번호) 변경됨 그냥 필드로 
						vno = rs("vno")



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
								<!-- #include virtual = "/pub/html/swimAdmin/gameInfoPlayerList.asp" -->
						<%
						no = no - 1
						rs.movenext
						Loop
						Response.write "</tbody>"
						Response.write "</table>"


						Set rs = Nothing
					%>
		</div>
<!-- #include virtual = "/pub/html/swimAdmin/html.modalplayer.asp" -->
