<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_TennisTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,stateNo,GameTitleName,GameS,GameE,GameYear,GameArea,ViewYN,ViewState,hostname,subjectnm,afternm,titleCode,titleGrade,gameNa,kgame,gameTypeE,gameTypeA,gameTypeL,gameTypeP,gameTypeG   ,vacReturnYN "

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"



	'search
	If chkBlank(F2) Then
		strWhere = " stateno < 100 and DelYN = 'N'  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("gameS","gameS","gameNa","gameTypeE","gameTypeA","gameTypeL","GameTitleName")
			F1_0 = F2(0)
			F1_1 = F2(1)
			F1_2 = F2(2)
			F1_3 = F2(3)
			F1_4 = F2(4)
			F1_5 = F2(5)
			F1_6 = F2(6)

			For i = 0 To ubound(fieldarr)
				Select Case i
				Case 0
					findyear = F2(i)
				Case 1
					If F2(i) = "" Then
						finddateS = findyear & "-01-01"
						finddateE = CDbl(findyear) +1 & "-01-01"
					Else
						finddateS = findyear & "-"&addZero(F2(i))&"-01"
						finddateE = DateAdd("m",1 , finddateS)
					End if
					strWhere = " DelYN = 'N' and "&fieldarr(i)&" >= '" & finddateS &"' and "&fieldarr(i)&" < '"& finddateE &"' "

				Case 2
					If F2(i) <> "A" then
						strWhere = strWhere & " and "&fieldarr(i)&" = '"& F2(i) &"' "
					End if
				Case 3,4,5
					If F2(i) <> "" then
						strWhere = strWhere & " and "&fieldarr(i)&" = '"& F2(i) &"' "
					End If
				Case 6
						If F2(i) <> "" then
							strWhere = strWhere & " and "&fieldarr(i)&" like  '%"& F2(i) &"%' "
						End if
				End Select
				'Response.write fieldarr(i) & "<br>"
			next

		Else
			strWhere = " stateno < 100 and DelYN = 'N' and "&F1&" = '"& F2 &"' "
		End if
	End if



'Response.write strWhere
'Response.end

	If CDbl(ADGRADE) > 500 then
		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10

	Else
		SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere & " and GameE >= getdate() -30 " & strSort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if

'Call rsdrow(rs)
'Response.end

	'계좌 사용량
	'SQL = "Select Count(*) from SD_RookieTennis.dbo.TB_RVAS_MAST where CUST_CD IS NOT NULL " 'and sitecode = '"&sitecode&"'"
	'Set rscnt = db.ExecSQLReturnRS(SQL, null, ConStr)
	'vacUseCount = rscnt(0)
%>
<%'View ####################################################################################################%>



		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>대회정보관리 <!-- (sd_TenisTitle) --></h1></div>

			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 정보 검색 -->
			<div class="info_serch form-horizontal" id="gameinput_area">
			  <!-- #include virtual = "/pub/html/riding/gameinfoform.asp" -->
			</div>
			<!-- e: 정보 검색 -->

			<!-- s: 정보 검색 -->
			<div class="info_serch">
				<!-- #include virtual = "/pub/html/riding/gamefindform.asp" -->
			</div>
			<!-- e: 정보 검색 -->


			<hr />
			<!-- s: 리스트 버튼 -->
		  <div class="btn-toolbar" role="toolbar" aria-label="btns">

<%If USER_IP = "118.33.86.240" Then%>
        <!-- <a href="#" class="btn btn-link">계좌 사용량 : <%=vacUseCount%> / 20000(회사에서만)</a> -->
<%End if%>

        <div class="btn-group flr">
<%If USER_IP = "118.33.86.240" Then%>
		  <!-- <a href="javascript:alert('2차 작업 기획 진행중 ....이라네')" id="gdmake" class="btn btn-primary">참가신청제한관리(회사에서만보임)</a> --><!-- mx.makeGoods() -->
<%End if%>
		</div>

			</div>
			<!-- e: 리스트 버튼 -->
			<%End if%>


			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<table cellspacing="0" cellpadding="0" class="table table-hover">
					<thead>
						<tr>
								<th>No.</th>
								<th>대회명</th>
								<th>기간</th>
								<th>장소</th>
								<th>참가신청/달력/출전순서표</th>
								<th>세부종목/일정</th>
								<th>요강</th>
								<!-- <th>참가신청제한</th> -->
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<tr id="fc" style="display:none;"><td>first child</td></tr>
					<%
					Do Until rs.eof
						idx = rs(0)
						GameTitleName = rs("GameTitleName")
						GameS = rs("GameS")
						GameE = rs("GameE")
						GameArea = rs("GameArea")
						ViewYN = rs("ViewYN")
						MatchYN = rs("stateNo")
						ViewState = rs("ViewState")
						hostname = rs("hostname")
						subjectnm = rs("subjectnm") '주관
						afternm = rs("afternm") '후원

						titlecode = rs("titlecode")
						titlegrade = rs("titlegrade")

						gameNa = rs("gameNa")
						kgame = rs("kgame")
						gameTypeE = rs("gameTypeE")
						gameTypeA = rs("gameTypeA")
						gameTypeL = rs("gameTypeL")
						gameTypeP = rs("gameTypeP")
						gameTypeG    = rs("gameTypeG")
						vacReturnYN = rs("vacReturnYN")

'Response.write ViewYN
						%>
						  <!-- #include virtual = "/pub/html/riding/gameinfolist.asp" -->
					  <%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>

					</tbody>
				</table>
			</div>
			<!-- e: 테이블 리스트 -->

			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>
		</div>
		<!-- s: 콘텐츠 끝 -->
