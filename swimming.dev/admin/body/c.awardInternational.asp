<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_gameTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " GameTitleIDX,stateNo,GameTitleName,GameS,GameE,GameYear,GameArea,ViewYN,ViewState,hostname,subjectnm,afternm,titleCode,titleGrade,gameNa,kgame,gameTypeE,gameTypeA,gameTypeL,gameTypeP,gameTypeG   ,vacReturnYN "

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"



	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  "
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
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "
		End if
	End if

	If CDbl(ADGRADE) > 500 then
		Dim intTotalCnt, intTotalPage
		Set rs = GetBBSSelectRS( ConStr, strTableName, strFieldName, strWhere, intPageSize, intPageNum, intTotalCnt, intTotalPage )
		block_size = 10

	Else
		SQL = "select " & strFieldName & " from " & strTableName & " where " & strWhere & " and GameE >= getdate() -30 " & strSort
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	End if
%>
<%'View ####################################################################################################%>

      <div class="box box-primary">
        <div class="box-header with-border">
          <h3 class="box-title">대회 목록</h3>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/swimming/awardInternationalForm.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>





      <div class="row">

		<div class="col-xs-12">
          <div class="box">
            <!-- <div class="box-header">
              <h3 class="box-title">Hover Data Table</h3>
            </div> -->
            <!-- /.box-header -->

            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">





						<tr>
								<th>NO</th>
								<th>년도</th>
								<th>대회명</th>
								<th>대회코드</th>
								<th>대회기간</th>
								<th>진행상태</th>
								<th>장소</th><!-- 전체,모바일,홈페이지 -->
								<th>구분</th>
								<th>조회</th>
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
						%>
						  <!-- #include virtual = "/pub/html/swimming/list.awardInternational.asp" -->
					  <%
					  rs.movenext
					  Loop
					  Set rs = Nothing
					%>

					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>




			<nav>
				<%
					jsonstr = JSON.stringify(oJSONoutput)
					Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
				%>
			</nav>

		<!-- s: 콘텐츠 끝 -->
