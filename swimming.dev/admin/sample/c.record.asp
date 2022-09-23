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
			

			<ul class="nav nav-tabs">
              <li class="active"><a href="#tab_1" data-toggle="tab" aria-expanded="false">경기진행순서</a></li>
              <li class=""><a href="#tab_2" data-toggle="tab" aria-expanded="false">경기진행결과</a></li>
            </ul>
			
        </div>
        <!-- <div class="box-footer"></div> -->
      </div>


	<div class="box box-primary" style="padding-top:5px;padding-bottom:5px;">
		<!-- #include virtual = "/pub/html/sample/gamefindform.asp" -->
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
								<th rowspan="2">탁구대</th>
								<th rowspan="2">순서</th>
								<th rowspan="2">시간</th>
								<th rowspan="2">승패결과</th>
								<th rowspan="2">오더등록</th>
								<th colspan="2">팀1</th>
								<th colspan="2">팀2</th>
						</tr>
						<tr>
								<th>소속</th>
								<th>승패</th>
								<th>소속</th>
								<th>승패</th>
						</tr>

					</thead>
					<tbody id="contest"  class="gametitle">








		<tr  style="text-align:center;">
			<td ><span>1</span></td>
			<td ><span>1</span></td>
			<td ><span>09:00 - 10:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>익산한성탁구클럽</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
			<td><span>김형경탁구클럽</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
		</tr>	


		<tr  style="text-align:center;">
			<td ><span>2</span></td>
			<td ><span>1</span></td>
			<td ><span>09:00 - 10:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>남원한빛탁구교실</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
			<td><span>임성청탁구교실</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
		</tr>	

		<tr  style="text-align:center;">
			<td ><span>3</span></td>
			<td ><span>1</span></td>
			<td ><span>09:00 - 10:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>솔내탁구클럽</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
			<td><span>OK탁구클럽</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
		</tr>	

		<tr  style="text-align:center;">
			<td ><span>4</span></td>
			<td ><span>1</span></td>
			<td ><span>09:00 - 10:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>김재훈탁구스쿨</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
			<td><span>남악탁구장</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
		</tr>	
<!--  -->

		<tr  style="text-align:center;">
			<td ><span>1</span></td>
			<td ><span>2</span></td>
			<td ><span>10:00 - 11:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>웰빙에이스</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
			<td><span>파워탁구클럽</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
		</tr>	

		<tr  style="text-align:center;">
			<td ><span>2</span></td>
			<td ><span>2</span></td>
			<td ><span>10:00 - 11:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>옥과탁구클럽</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
			<td><span>용봉탁구교실</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
		</tr>	


		<tr  style="text-align:center;">
			<td ><span>3</span></td>
			<td ><span>2</span></td>
			<td ><span>10:00 - 11:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>어울림탁구클럽</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
			<td><span>우리무궁화</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
		</tr>	

		<tr  style="text-align:center;">
			<td ><span>4</span></td>
			<td ><span>2</span></td>
			<td ><span>10:00 - 11:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>김도영탁구클럽</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
			<td><span>와와탁구클럽</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
		</tr>	

<!--  -->
		<tr  style="text-align:center;">
			<td ><span>1</span></td>
			<td ><span>3</span></td>
			<td ><span>11:00 - 12:00</span></td>

			<td><span><a href="" class="btn btn-primary">선택</a></span></td>
			<td><span><a href="" class="btn btn-primary">등록</a></span></td>

			<td ><span>전주ytc탁구클럽</span></td>
			<td ><span class="btn btn-default" style="color:#60C5F1">WIN</span></td>
			<td><span>용소탁구</span></td>
			<td><span><span class="btn btn-default" >LOSE</span></td>
		</tr>	




		


					</tbody>
				</table>


            </div>
          </div>
        </div>

	  </div>




		<nav>
			<%
				'jsonstr = JSON.stringify(oJSONoutput)
				'Call userPagingT2 (intTotalPage, 10, PN, "px.goPN", jsonstr )
			%>
		</nav>




		<!-- s: 콘텐츠 끝 -->
