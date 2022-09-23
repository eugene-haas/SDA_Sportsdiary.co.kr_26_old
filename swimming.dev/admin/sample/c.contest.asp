<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################
	intPageNum = PN
	intPageSize = 20
	strTableName = " sd_gameTitle "
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임

	'0국제, 1체전, 2장소, 3주최 , 4주관, 5후원, 6협찬, 7대회명, 8요강, 9규모, 10레인수 ,11대회코드, 12참가비 , 13대회기간 , 14신청기간 , 15대회구분 , 16구분, 17개인, 18팀, 19시도신청, 20시도승인, 21팀당2명이내제한, 22종목수
	strFieldName = " gubun,kgame,GameArea,hostname,subjectnm,afternm,sponnm,GameTitleName,summaryURL,gameSize,ranecnt,titleCode,attmoney,GameS,GameE,atts,atte,GameType,EnterType,attTypeA,attTypeB,attTypeC,attTypeD,teamLimit,attgameCnt,GameTitleIDX    ,ViewState,ViewStateM,ViewYN,MatchYN,stateNo"	


	

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"


	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N' and ( gameS >=  '"& year(date) & "-01-01" &"' and  gameS < '"& CDbl(year(date))+1 & "-01-01" &"' )  "
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("gameS","gameS","gametype","entertype","GameTitleName")
			F1_0 = F2(0)
			F1_1 = F2(1)
			F1_2 = F2(2)
			F1_3 = F2(3)
			F1_4 = F2(4)

			For i = 0 To ubound(fieldarr)
				Select Case i
				Case 0
					findyear = F2(i)
				Case 1
					If F2(i) = "" Then
						finddateS = findyear & "-01-01"
						finddateE = CDbl(findyear)+1 & "-01-01"
					Else
						finddateS = findyear & "-"&addZero(F2(i))&"-01"
						finddateE = DateAdd("m",1 , finddateS)
					End if
					strWhere = " DelYN = 'N' and ( gameS >= '" & finddateS &"' and gameS < '"& finddateE &"')  "

				Case 2
					If F2(i) <> "A" Then 'A K F 국내/국제  A 01, 02 , 09로 변경
						strWhere = strWhere & " and "&fieldarr(i)&" = '"& F2(i) &"' "
						'Response.write strWhere
					End if
				Case 3
					If F2(i) <> "T" Then 'T E A
						strWhere = strWhere & " and "&fieldarr(i)&" = '"& F2(i) &"' "
						'Response.write strWhere
					End If
				Case 4
						If F2(i) <> "" then
							strWhere = strWhere & " and "&fieldarr(i)&" like  '%"& F2(i) &"%' "
						End if
				End Select
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


'Call rsdrow(rs)
'Response.write strWhere
'Response.end



'페이지 입력폼 상태 확인
pageYN = getPageState( "MN0101", "대회정보관리" ,Cookies_aIDX , db)
%>
<%'View ####################################################################################################%>

      <div class="box box-primary <%If pageYN="N" then%>collapsed-box<%End if%>">
        <div class="box-header with-border">
          <h3 class="box-title">기본정보등록</h3>

          <div class="box-tools pull-right">
            <button type="button" class="btn btn-box-tool" data-widget="collapse" onclick="px.hiddenSave({'YN':'<%=pageYN%>','PC':'MN0101'},'/setPageState.asp')"><i class="fa fa-<%If pageYN="N" then%>plus<%else%>minus<%End if%>"></i></button>
          </div>
        </div>

		<div class="box-body" id="gameinput_area">
			<%If CDbl(ADGRADE) > 500 then%>
			<!-- s: 등록화면 -->
			  <!-- #include virtual = "/pub/html/sample/gameinfoform.asp" -->
			<!-- e: 등록 화면 -->
			<%End if%>
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


	<div class="box box-primary" style="padding-top:5px;padding-bottom:5px;">
		<!-- #include virtual = "/pub/html/swimming/gamefindform.asp" -->
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
								<th>구분</th>
								<th>대회코드</th>
								<th>대회명</th>
								<th>대회기간</th>
								<th>신청기간</th>
								<th>선수구분</th>
								<th>Home/Mobile/신청/대진</th><!-- 전체,모바일,홈페이지 -->
								<th>세부종목</th>
								<th>경기순서</th>
						</tr>
					</thead>
					<tbody id="contest"  class="gametitle">
					<%
					Do Until rs.eof

						l_gubun = rs(0)
						Select Case l_gubun 
						Case "01" : l_gubun = "명칭"
						Case "02" : l_gubun = "승인"
						Case "09" : l_gubun = "기타"
						End Select 
						l_kgame = rs(1)
						Select Case l_kgame 
						Case "03" : l_kgame = "통합"
						Case "01" : l_kgame = "전문"
						Case "02" : l_kgame = "생활"
						End Select 
						l_GameArea = rs(2)
						l_hostname = rs(3)
						l_subjectnm = rs(4)
						l_afternm = rs(5)
						l_sponnm = rs(6)
						l_GameTitleName = rs(7)
						l_summaryURL = rs(8)
						l_gameSize = rs(9) '규모
						l_ranecnt = rs(10)
						l_titleCode = rs(11)
						l_attmoney = rs(12)
						l_GameS = Replace(rs(13),"-","/") & " - "
						l_GameE = Replace(rs(14),"-","/")

						l_atts = Replace(Left(rs(15),11),"-","/") & Left(setTimeFormat(CDate(rs(15))),5)  & " - "
						l_atte = Replace(Left(rs(16),11),"-","/") & Left(setTimeFormat(CDate(rs(16))),5)
						l_checkatte = CDate(rs(16))
						l_GameType = rs(17)
						l_EnterType = rs(18)
						l_attTypeA = rs(19)
						l_attTypeB = rs(20)
						l_attTypeC = rs(21)
						l_attTypeD = rs(22)
						l_teamLimit = rs(23)
						l_attgameCnt = rs(24)
						l_idx = rs(25)

						l_ViewState = rs(26) 
						l_ViewStateM = rs(27) 
						l_ViewYN = rs(28) 
						l_MatchYN = rs(29) 
						l_stateNo = rs(30) 

					 %>
		<tr id="titlelist_<%=l_idx%>" style="text-align:center;">
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=ar+1%></span></td>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span>T-4</span></td>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span>20200001</span></td>
			<td onclick="mx.input_edit(<%=l_idx%>)" style="text-align:left;"><span>2020  탁구 디비전 T4 리그</span></td>
			
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_GameS%><%=l_GameE%></span></td>

			<%If 	l_checkatte < now() then%>	
			<td onclick="mx.input_edit(<%=l_idx%>)" class="bg-gray"><span><%=l_atts%><%=l_atte%></span></td>
			<%else%>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span><%=l_atts%><%=l_atte%></span></td>
			<%End if%>
			<td onclick="mx.input_edit(<%=l_idx%>)"><span>생활체육</span></td>

			<td>
			<span>
				<%'홈페이지 모바일 신청 대진 확인서%>
				<a href="javascript:mx.setBtnState('btn1_<%=l_idx%>',<%=l_idx%>,'ViewState')" id="btn1_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_ViewState = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
				<a href="javascript:mx.setBtnState('btn2_<%=l_idx%>',<%=l_idx%>,'ViewStateM')" id="btn2_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_ViewStateM = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
				<a href="javascript:mx.setBtnState('btn3_<%=l_idx%>',<%=l_idx%>,'ViewYN')" id="btn3_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_ViewYN = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
				<a href="javascript:mx.setBtnState('btn4_<%=l_idx%>',<%=l_idx%>,'MatchYN')" id="btn4_<%=l_idx%>" class="btn btn-fix-sm btn-<%If l_MatchYN = "N" then%>default">N</a> <%else%>warning">Y</a><%End if%>
			</span>			
			</td>
			<td><span><a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'TITLE':'<%=l_GameTitleName%>','KYN':'<%=l_kgame%>'},'05.sample.asp?idx=<%=l_idx%>')" class="btn btn-primary">관리</a></span></td>
			<td><span><a href="javascript:px.goSubmit({'IDX':<%=l_idx%>,'TITLE':'<%=l_GameTitleName%>'},'gameorder.asp')" class="btn btn-primary">경기순서</a></span></td>
		</tr>					 
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
