<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_gameTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	'strFieldName = " GameTitleIDX,stateNo,GameTitleName,GameS,GameE,GameYear,GameArea,ViewYN,ViewState,hostname,subjectnm,afternm,titleCode,titleGrade,gameNa,kgame,gameTypeE,gameTypeA,gameTypeL,gameTypeP,gameTypeG   ,vacReturnYN "

	strFieldName = " GameTitleIDX,stateNo,GameTitleName,GameS,GameE,GameArea,ViewYN,ViewState,hostname,subjectnm,afternm,titleCode,kgame "

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

      <div class="box box-primary collapsed-box">
        <div class="box-header with-border">
          <h3 class="box-title">대회리스트</h3>

          <div class="box-tools pull-right">

		  </div>
        </div>
      </div>


      <div class="row">

		<div class="col-xs-12">
          <div class="box">


            <div class="box-header" style="text-align:right;padding-right:20px;">


							<div class="col-md-6" style="width:10%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">
										<select id="mk_g0" class="form-control">
											<option value="K" <%If e_gameNa = "" Or e_gameNa = "K" then%>selected<%End if%>>수영(경영)</option>
											<option value="F" <%If e_gameNa = "F" then%>selected<%End if%>>다이빙</option>
										</select>
								  </div>
							</div>



						<div class="row" >
							<div class="col-md-6" style="width:20%;padding-left:20px;padding-right:0px;text-align:left;">
								  <div class="form-group">

									<div class="input-group date">

										<select id="mk_g0" class="form-control">
											<option value="K" <%If e_gameNa = "" Or e_gameNa = "K" then%>selected<%End if%>>전체</option>
											<option value="F" <%If e_gameNa = "F" then%>selected<%End if%>>2019</option>
										</select>
										<div class="input-group-addon" onmousedown="alert('검색하자')">
										  <i class="fa fa-fw fa-search"></i>
										</div>
									</div>


								  </div>
							</div>
							<div class="col-md-6" style="width:69%;padding-right:20px;padding-right:0px;text-align:right;">
								  <div class="form-group">
									  <!-- <a href="" class="btn btn-danger"><i class="fa fa-fw fa-file-excel-o"></i>엑셀</a>
									  <a href="#" class="btn btn-danger"><i class="fa fa-fw fa-print"></i>인쇄</a> -->
								  </div>
							</div>
						</div>
						  <!-- <h3 class="box-title">Hover Data Table</h3> -->
            </div>
            <!-- /.box-header -->







            <div class="box-body">
              <table id="swtable" class="table table-bordered table-hover" >
                <thead class="bg-light-blue-active color-palette">





						<tr>
								<th>NO</th>
								<th>대회명</th>
								<th>신청기간</th>
								<th>모집상태</th><!-- 전체,모바일,홈페이지 -->
								<th>참가신청(명)</th>
								<th>장소</th>
								<th>선수구분</th>
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
						'titlegrade = rs("titlegrade")

						'gameNa = rs("gameNa")
						kgame = rs("kgame")
						' gameTypeE = rs("gameTypeE")
						' gameTypeA = rs("gameTypeA")
						' gameTypeL = rs("gameTypeL")
						' gameTypeP = rs("gameTypeP")
						' gameTypeG    = rs("gameTypeG")
						' vacReturnYN = rs("vacReturnYN")
						%>
						  <!-- #include virtual = "/pub/html/swimming/gameattmemberlist.asp" -->
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
