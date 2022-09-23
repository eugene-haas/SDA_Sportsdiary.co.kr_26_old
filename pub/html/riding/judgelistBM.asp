			</tbody>
	  </table><br>
  </div>





<%
	bm_gbidx1 = find_gbidx '결과생성시 보낼 값 저장


	'위에꺼 말고 두번째 복합마술 찾기..$$$
	strtable = " tblRGameLevel as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx  "
	strfieldA = " a.RGameLevelidx,a.GbIDX " 
	strfieldB = " cast(a.gameno as varchar) + '경기 ('+ PTeamGbNm +') : ' + b.TeamGbNm + b.levelNm + ' ' + b.ridingclass + ' ' + b.ridingclasshelp ,a.GameDay,a.GameTime,a.gametimeend,b.TeamGbNm,isnull(a.judgecnt,0), a.judgemaxpt, judgesignYN,judgeshowYN    ,b.ridingclass , b.ridingclasshelp    ,judgeB,judgeE,judgeM,judgeC,judgeH,  teamgb,judgecnt,bestsc     ,a.maxChk,a.minChk "
	strFieldName2 = strfieldA &  "," & strfieldB

	strwhere = " a.gametitleidx = " & tidx & " and a.levelno like '"&select_f_teamgb&"%'  and a.gbidx  <> '"&find_gbidx&"' and a.DelYN = 'N' and b.DelYN = 'N' "
	SQL = "Select  top 1 "&strFieldName2&" from "&strtable&" where " & strwhere
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If not rs.eof Then
		find_gbidx = rs("gbidx")
		select_f_title =  rs(2)
		select_f_date = rs(3)
		select_f_stime = rs(4)
		select_f_etime = rs(5)
		Select_f_teamgbnm = rs(6)
		select_f_judgecnt = rs(7)
		select_f_judgemaxpt = rs(8)
		select_f_judgesignYN = rs(9)
		select_f_judgeshowYN = rs(10)

		select_f_class = rs(11)
		select_f_classhelp = rs(12)

		select_f_B = rs(13)
		select_f_E = rs(14)
		select_f_M = rs(15)
		select_f_C = rs(16)
		select_f_H = rs(17)

		select_f_teamgb = rs(18)
		select_f_boocnt = rs(19)
		select_f_bestsc = rs(20)

		select_f_MAX =  rs(21)
		select_f_MIN =  rs(22)

	    sel_orderType = GetOrderType(select_f_classhelp, select_f_teamgb, select_f_class) '마장마술...등등구분
	End if
%>



	  <!-- #include virtual = "/pub/html/riding/judgeform.asp" -->

  
  <div class="table-responsive" id="printdivBM">

		<div class="container-fluid">
			<div class="row">


					<%Select Case select_f_classhelp%>

					<%Case CONST_TYPEA1 , CONST_TYPEA2 'type A%>
						<div class="col-sm-5 text-center bg-primary">
							<h3 class="lead"><%=select_f_date%> &nbsp;&nbsp;&nbsp;  <%=select_f_stime%>~<%=select_f_etime%></h3>
						</div>
						<div class="col-sm-7 text-center bg-primary">
							<h3 class="lead"><%=select_f_title%></h3>
						</div>

					<%Case else%>
						<div class="col-sm-5 text-center bg-primary"  style="height:74px;">
							<h3 class="lead"><%=select_f_date%> &nbsp;&nbsp;&nbsp;  <%=select_f_stime%>~<%=select_f_etime%></h3>
						</div>
						<div class="col-sm-7 text-center bg-primary">
							<h3 class="lead"><%=select_f_title%>

							&nbsp;&nbsp;<a href="javascript:$('#printdivBM').printThis({importCSS: false,loadCSS: 'http://ridingadmin.sportsdiary.co.kr/pub/js/print/print_table.css',header: '<h1><%=select_f_title%></h1>'});" class="btn btn-default">화면인쇄</a></span>
							&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>,1)' class="btn btn-default">결과인쇄</a></span>
							</h3>
						</div>

					<%End select%>


			</div>
		</div>

		<table  cellspacing="0" cellpadding="0" class="table table-hover" id="tblridingBM">
			<thead>

				<%'Select Case Select_f_teamgbnm%>
				<%'Case "마장마술"%>
				<%If sel_orderType = "MM" Then%>
				<tr>
					<th rowspan="2">출전순서<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<th rowspan="2">시각</th>
					<th rowspan="2">통합부명</th><th rowspan="2">선수명</th><th rowspan="2">마명</th><th rowspan="2">소속</th>
					<th rowspan="2">참가부명</th><th rowspan="2">경기상태</th><th rowspan="2">기권/실격</th><th rowspan="2">사유서제출</th><th rowspan="2">기록입력</th>

					<th rowspan="2">총점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<!-- <th rowspan="2">종합관찰<br>총점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th><!-- console.log($(this).closest('th').prevAll().length+1) -->

					<th colspan="<%=select_f_boocnt%>"  >심판위원<%'=select_f_judgecnt%></th>
					<th rowspan="2">비율<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
					<th rowspan="2">부별순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
					<th rowspan="2">전체순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+<%=select_f_judgecnt%>-1)" class="btn btn-default btn-xs">▼</button></span></th>
				</tr>

				<tr>
					<%If select_f_B = "Y" then%>
					<th>B지점<br>비율<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_E = "Y" then%>
					<th>E지점<br>비율<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_M = "Y" then%>
					<th>M지점<br>비율<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_C = "Y" then%>
					<th>C지점<br>비율<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
					<%If select_f_H = "Y" then%>
					<th>H지점<br>비율<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+12)" class="btn btn-default btn-xs">▼</button></span></th>
					<%End if%>
				</tr>

				
				<%'Case "장애물"%>
				<%Else '마장마술아닌것들 (장애물)%>
					<%Select Case select_f_classhelp%>
					<%Case CONST_TYPEA1 , CONST_TYPEA2, CONST_TYPEA_1 'type A%>

					<%If select_f_classhelp <> CONST_TYPEA_1 then%>
					<tr>
						<td colspan="17" style="text-align:right;" class="tbl-btnarea">


							<%
								SQL = "Select max(round) from SD_tennisMember where gametitleidx = " & tidx & " and delYN = 'N' and gamekey3 = '" &find_gbidx & "'"
								Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
								If isNull(rs(0)) = False  Then
									maxrndno = rs(0)
								End if
							%>
						<%If kgame = "Y" then%>
						<%
						Select Case maxrndno
						Case "1" : kbtn_nm = "2라운드 생성"
						Case "2" : kbtn_nm = "결승 결과생성"
						Case "3" : kbtn_nm = "1단계 재경기 생성"
						Case "4" : kbtn_nm = "2단계 재경기 생성"
						End Select
						%>
						<a class="btn btn-danger" disabled>체전</a>&nbsp;&nbsp;
						<a href="javascript:$('#printdivBM').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1><%=select_f_title%></h1>'});" class="btn btn-default">인쇄</a>&nbsp;&nbsp;</span>
						<%If select_f_teamgb <> "20103" Then '복합마술은 재경기가 없다.%>
						<a href="javascript:mx.makeReGame(<%=maxrndno%>,<%=tidx%>,<%=find_gbidx%>,'<%=kgame%>','<%=sel_orderType%>')" class="btn btn-primary"><%=kbtn_nm%></a>
						<%End if%>
						</span>

						<%else%>
						<a class="btn btn-danger" disabled>일반</a>&nbsp;&nbsp;
						<a href="javascript:$('#printdivBM').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1><%=select_f_title%></h1>'});" class="btn btn-default">인쇄</a>&nbsp;&nbsp;</span>
						<%If select_f_teamgb <> "20103" Then '복합마술은 재경기가 없다.%>
						<a href="javascript:mx.makeReGame(<%=maxrndno%>,<%=tidx%>,<%=find_gbidx%>,'<%=kgame%>','<%=sel_orderType%>')" class="btn btn-primary">재경기생성</a></span>
						<%End if%>
						<%End if%>
						</td>
					</tr>
					<%End if%>

					<tr>
						<th>출전순서<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th><th>경기상태</th><th>기권/실격</th><th>사유서제출</th><th>기록입력</th>
						<th>총소요시간<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>시간감점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>장애감점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>감점합계<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>부별순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>전체순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<%If select_f_classhelp <> CONST_TYPEA_1 and kgame = "N" And select_f_teamgb <> "20103" Then %>
						<th class='hidehtml'>재경기</th>
						<%End if%>
					</tr>

					<%Case CONST_TYPEB 'type B%>
					<tr><!-- +6 한이유는 위에 tr 첫번째의 (아래 th갯수 8개 - th(1단계 + 2단계)) -->
						<th rowspan="2">출전순서<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>

						<th rowspan="2">통합부명</th><th rowspan="2">선수명</th><th rowspan="2">마명</th><th rowspan="2">소속</th><th rowspan="2">참가부명</th><th rowspan="2">경기상태</th><th rowspan="2">기권/실격</th><th rowspan="2">사유서제출</th><th rowspan="2">기록입력</th><th colspan="4">1단계</th><th colspan="4">2단계</th>
						<th rowspan="2">부별순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+6)" class="btn btn-default btn-xs">▼</button></span></th>
						<th rowspan="2">전체순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length +6 )" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length + 6)" class="btn btn-default btn-xs">▼</button></span></th>
					</tr>
					<tr><!-- 10에 이유는 tr이 두개여서 아래쪽 갯수만큼 붙임 -->
						<th>총소요<br />시간<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length + 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>시간<br />감점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length + 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>장애<br />감점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length + 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>감점<br />합계<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>총소요<br />시간<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>시간<br />감점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>장애<br />감점<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>감점<br />합계<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length+ 10)" class="btn btn-default btn-xs">▼</button></span></th>
					</tr> class="btn btn-default btn-xs"
					<%Case CONST_TYPEC 'type C%>
					<tr>
						<th>출전순서<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th><th>경기상태</th><th>기권/실격</th><th>사유서제출</th><th>기록입력</th>
						<th>소요시간<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>벌초<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>총소요시간<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>부별순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>전체순위<br><span><button onclick="sortTDRBM($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBM ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					</tr>
					<%End Select%>
				<%End if%>
				<%'End Select%>

			</thead>
			<tbody id="listcontentsBM">












<%
'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select top 1 a.judgecnt,a.judgemaxpt,a.judgesignYN,a.judgeshowYN,b.ridingclass , b.ridingclasshelp  from tblRGameLevel  as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx  where gametitleidx = '"&tidx&"' and Gbidx = '"&find_gbidx&"'  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrC = rs.GetRows()
	End If
	rs.close

	If IsArray(arrC) Then
			r_judgecnt = arrC(0, 0)
			r_judgemaxpt = arrC(1, 0)
			r_judgesignYN = arrC(2, 0)
			r_judgeshowYN = arrC(3, 0)
			r_class = arrC(4, 0)
			r_classhelp = arrC(5, 0)
	End if


	'Gbidx 의 내용 위에 꺼랑 조인해서 가져오기.....class classhelp

	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
	fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 "
	fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval "
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 1 and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


	'Response.write sql & "<br>"
	'Call rsdrow(rs)
	'Response.end

	If Not rs.EOF Then
		arrZ = rs.GetRows()
	End If
	rs.close

	If IsArray(arrZ) Then 
		For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
			in01 = 0 '앱력전갯수
			in02 = 0 '입력중갯수
			in03 = 0 '완료갯수

			r_a1 = arrZ(0, ari) 'idx
			idx = r_a1
			r_a2 = arrZ(1, ari) 'gubun   0 순서설정전 1(순서설정완료 : 비체전인경우) 100 '공지사항 이름은 sc playeridx = 0 순서번호는 ? a.tryoutsortno,a.tryoutgroupno 1번위라면 0 100부터 
			r_a3 = arrZ(2, ari)' pidx
			r_a4 = arrZ(3, ari) 'unm
			r_a5 = arrZ(4, ari) '종목
			r_a6 = arrZ(5, ari) '경기 그룹번호 (체전이아니면 이것만사용)
			r_a7 = arrZ(6, ari) '출전순서

			r_a8 = isNullDefault(arrZ(7, ari),"") '최종결과 (기권/실격포함)


			r_a9 = arrZ(8, ari) '소속
			r_a10 = arrZ(9, ari) '통합부명
			r_a11 = isNullDefault(arrZ(10, ari),"") '참가부명
			r_b1 = arrZ(11, ari) 'pidx 말
			r_b2 = arrZ(12, ari) '말명칭
			r_a12 = arrZ(13, ari) ' 경기시간

			r_a14 = arrZ(14, ari) 'gbidx
			r_a15 = arrZ(15, ari) 'requestIDX 참가신청 인덱스

			r_a8_1 = arrZ(16, ari) '문서제출여부			

			'##################
			',score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order
			r_sgf = arrZ(17,ari) 'sgf
			r_s1 = isNullDefault(arrZ(18,ari),"")
			r_s2 = isNullDefault(arrZ(19,ari),"")
			r_s3 = isNullDefault(arrZ(20,ari),"")
			r_s4 = isNullDefault(arrZ(21,ari),"")
			r_s5 = isNullDefault(arrZ(22,ari),"")
			r_s6 = isNullDefault(arrZ(29,ari),"")

			r_stotal = arrZ(23,ari) '장애물 소요시간
			r_sper = arrZ(24,ari) '장애물인경우 B,C 타입 소요시간 2
			r_booorder = arrZ(25,ari)
			r_totalorder = arrZ(26,ari)

			r_gamest = arrZ(27,ari) '게임상태
			r_round = arrZ(28,ari) '재경기라운드 1(본경기) 2 재경기 3 재경기2

			r_per1 = arrZ(30,ari)
			r_per2 = arrZ(31,ari)
			r_per3 = arrZ(32,ari)
			r_per4 = arrZ(33,ari)
			r_per5 = arrZ(34,ari)
			r_total2 = arrZ(35,ari) '종합관찰총점

			r_pcode = arrZ(36,ari) '소팅용 pubcode
			r_midval = isNullDefault(arrZ(37,ari),"") '중간값

			p_sArr = array("", r_s1,r_s2,r_s3,r_s4,r_s5)

			'버튼상태 구하기
		
			'Select Case  r_a5 
			'case  "마장마술" 
			If sel_orderType = "MM" then
				'마장마술인 경우
					For x = 1 To 5 
						Select Case CStr(p_sArr(x))
						Case "" '널값갯수
							in01 = in01 + 1
						Case "0" '입력진행 또는 0으로 입력한것 갯수
							in02 = in02 + 1
						Case Else
							in03 = in03 + 1
						End Select 
					next

					If CDbl(in01) = CDbl(r_judgecnt) Or CDbl(in01) = 5 Then	'입력전
						btnst = 1
					End if
					
					If CDbl(r_stotal) > 0 then
					If CDbl(in02) > 0 Or  CDbl(in03) > 0 Then	'입력진행
						btnst = 2
					End If
					End if

					If CDbl(in03) = CDbl(r_judgecnt) Then	'경기종료
						btnst = 3
					End if			

					If r_judgecnt = "0" Then '지점 수 없음
						btnst = 1
					End If
					'Response.write in01& "$$$$$$$$$$$$"
				'마장마술인경우

			'Case "장애물"
			else

				Select Case CStr(r_s1)
				Case ""
					btnst = 1
				Case "0"
					btnst = 2
				Case Else
					btnst = 3
				End Select 		
				
			'End Select 
			End if

			'Response.write "##########--" &in01 & "<br>"

			'Response.write "@@@@@@@@@@@@@@@@@@@@@@@@"&in01

			If r_a12 <> "" And isnull(r_a12) = false then
				r_gametime = Split(Left(setTimeFormat(r_a12),5),":")
				r_hh = r_gametime(0)
				r_mm = r_gametime(1)
			Else
				r_hh = 0
				r_mm = 0
			End if
			%>


		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=idx%>" >
				<td style="width:100px;"><%=r_a7%></td>

				<%'If r_a5 = "마장마술" then%>
				<%If sel_orderType = "MM" then%>
				<td ><%=r_hh&":"&r_mm%></td>
				<%End if%>
				<%'End if%>

				<td><a href="javascript:mx.changeBoo(<%=idx%>,1)"><%=r_a10%></a></td>
				<td  ><a href="javascript:mx.changeWindow(<%=idx%>,1)"><%=r_a4%></a></td><!-- <span class="glyphicon glyphicon-refresh"></span> -->
				<td  ><a href="javascript:mx.changeWindow(<%=idx%>,2)"><%=r_b2%></a></td><%'말명%>
				<td ><%=r_a9%></td>
				<td ><a href="javascript:mx.changeBoo(<%=idx%>,2)"><%If r_a11 = "" then%><%=r_a10%><%else%><%=r_a11%><%End if%></a></td>
				<td >
					<%Select Case r_gamest%>
					<%Case "1"%>
					<a href="javascript:mx.setGameState(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,1)" class="btn btn-white">경기시작</a>
					<%Case "2"%>
					<a href="javascript:mx.setGameState(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,2)" class="btn btn-green">진행중</a>
					<%Case "3"%>
					<a href="javascript:mx.setGameState(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,3)" class="btn btn-blue">경기종료</a>
					<%End Select%>
				</td>
				<td>
						<select id="giveup_<%=idx%>" class="form-control 
						<%Select case r_a8 
						Case "e" : Response.write "form-control-yellow"
						Case "r" :  Response.write "form-control-gray"
						Case "w" : Response.write "form-control-gray"
						Case "d" : Response.write "form-control-red"
						Case Else 
						End Select 
						%>"
						onchange= "mx.setGiveUp(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>,'ING')" style="width:100px;" >
							<option value="">==사유==</option>
							<option value="E" <%If r_a8 = "e" then%>selected<%End if%>>실권(E)</option>
							<option value="R" <%If r_a8 = "r" then%>selected<%End if%>>기권(R) 진행중</option>
							<option value="W" <%If r_a8 = "w" then%>selected<%End if%>>기권(W) 시작전</option>
							<option value="D" <%If r_a8 = "d" then%>selected<%End if%>>실격(D)</option>
						</select>
				</td>
				<td>
						<select id="giveupdoc_<%=idx%>" class="form-control" onchange= "mx.setGiveUpDoc(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>)" style="width:100px;">
							<option value="">==선택==</option>						
							<option value="Y"  <%If r_a8_1 = "Y" then%>selected<%End if%>>○</option>
							<option value="N" <%If r_a8_1 = "N" then%>selected<%End if%>>X</option>
						</select>
				</td>
				<td>
					<%If r_a8 = "0" then%>
						<%Select Case CStr(btnst) %>
						<%Case "1"%>
						<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-white">기록입력</a>
						<%Case "2"%>
						<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-green">입력중..</a>
						<%Case "3"%>
							<%If r_s4 = "" And r_classhelp = CONST_TYPEB then%>
								<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-success">1단계완료</a>
							<%else%>
								<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-blue">완료/수정</a>
							<%End if%>
						<%Case else%>
							<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-white">기록입력</a>
						<%End Select %>
					<%else%>
							<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-blue">완료/수정</a>
					<%End if%>
				</td>

				
				
				<%'Select Case r_a5 
				'Case "마장마술"%>
				<%If sel_orderType = "MM" then%>

				<td><%=r_stotal%></td>
				<!-- <td><%'=r_total2%></td> -->


					<%
						'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@
							clocColor =""
							midlocColor = ""
							If CStr(btnst)	<> "1" then
							Select Case CDbl(r_judgecnt)
							Case 1 : '지점이 하나라면 무조건 동점이다.
							Case 2
								clocColor = "style='color:red;'"
								'무조건 C지점값
							Case 3
								'r_midval 
								midlocColor = "style='color:red;'"
							Case 4 '이것도 짝수임 그래서...
								clocColor = "style='color:red;'"

							Case 5 '최대 최소값을 뺀 3개값의 중간값으로 비교한다.
								'r_midval 
								midlocColor = "style='color:red;'"
							End Select 
							End if
						'Y갯수에 따라서 중간값 을 넣는다.@@@@@@@@@@@@@	
					%>

				
				<%If r_judgecnt = 0 then%>
					<td>0</td>			
				<%else%>
					<%If select_f_B = "Y" then%>
						<td  <%If CStr(r_midval) = CStr(r_per1) then%><%=midlocColor%><%midlocColor=""%><%End if%>><%=FormatNumber(r_per1,sousoojerm)%></td>
					<%End if%>
					<%If select_f_E = "Y" then%>
						<td  <%If CStr(r_midval) = CStr(r_per2) then%><%=midlocColor%><%midlocColor=""%><%End if%>><%=FormatNumber(r_per2,sousoojerm)%></td>
					<%End if%>
					<%If select_f_M = "Y" then%>
						<td  <%If CStr(r_midval) = CStr(r_per3) then%><%=midlocColor%><%midlocColor=""%><%End if%>><%=FormatNumber(r_per3,sousoojerm)%></td>
					<%End if%>
					<%If select_f_C = "Y" then%>
						<td  <%If CStr(r_midval) = CStr(r_per4) then%><%=midlocColor%><%midlocColor=""%><%End if%>  <%=clocColor%>><%=FormatNumber(r_per4,sousoojerm)%></td>
					<%End if%>
					<%If select_f_H = "Y" then%>
						<td  <%If CStr(r_midval) = CStr(r_per5) then%><%=midlocColor%><%midlocColor=""%><%End if%>><%=FormatNumber(r_per5,sousoojerm)%></td>
					<%End if%>
				<%End if%>



				<td>
				<%If r_a8 = "e" Or r_a8 = "r" then%>
				<%=UCase(r_a8)%>
				<%else%>
				<%=FormatNumber(r_sper,sousoojerm)%>%
				<%End if%>
				</td>
				<td><%
				Select Case r_booorder
				Case "200" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"A</span>E"
				Case "300" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"B</span>R"
				Case "400" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"C</span>W"
				Case "500" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"D</span>D"
				Case Else
				boono = "<span style='display:none;'>"&r_pcode&r_a10&"</span>" & r_booorder
				End Select 
				%><%=Trim(boono)%></td>

				<td>
				<%
				Select Case r_totalorder
				Case "200" : orderno = "<span style='display:none;'>A</span>E"
				Case "300" : orderno = "<span style='display:none;'>B</span>R"
				Case "400" : orderno = "<span style='display:none;'>C</span>W"
				Case "500" : orderno = "<span style='display:none;'>D</span>D"
				Case Else
				orderno = r_totalorder
				End Select 
				%>
				<%=orderno%>
				</td>

			<%'case "장애물" '##########################################################%>
			<%else%>
				<%Select Case r_classhelp %>
				<%Case CONST_TYPEA1 , CONST_TYPEA2,CONST_TYPEA_1 'type A   재경기가 있는 장애물 %>
					<td><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td>
					<td><%=r_s2%></td>
					<td><%=r_s3%></td>
					<td>
					<%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%>
					</td>
					<td>
					<%
					Select Case r_booorder
					Case "200" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"A</span>E"
					Case "300" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"B</span>R"
					Case "400" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"C</span>W"
					Case "500" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"D</span>D"
					Case Else
						If CDbl(r_booorder) < 0 then
							boono = "<span style='display:none;'>"&Abs(r_booorder) & ".1" &"</span>-"
						else
							boono =  r_booorder
						End if
					End Select 

					%>
					<%=boono%>
					</td>

					<td>
					<%
					Select Case r_totalorder
					Case "200" : orderno = "<span style='display:none;'>A</span>E"
					Case "300" : orderno = "<span style='display:none;'>B</span>R"
					Case "400" : orderno = "<span style='display:none;'>C</span>W"
					Case "500" : orderno = "<span style='display:none;'>D</span>D"
					Case Else
						If CDbl(r_totalorder) < 0 then
							orderno = "<span style='display:none;'>"&Abs(r_totalorder) & ".1" &"</span>-"
						else
							orderno = r_totalorder
						End if
					End Select 
					%>
					<%=orderno%>
					</td>
					<%If select_f_classhelp <> CONST_TYPEA_1 and kgame = "N" And select_f_teamgb <> "20103" Then %>
					<%'If select_f_classhelp <> CONST_TYPEA_1 then%>
					<td><input type="checkbox" id="<%=r_round%>_<%=idx%>" value=<%=idx%>></td></td>
					<%End if%>					
					<%
						pre_v1 = r_s1
						pre_v2 = r_stotal
					%>



				<%Case CONST_TYPEB 'type B%>
					<td><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td>
					<td><%=r_s2%></td>
					<td><%=r_s3%></td>
					<%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%>

					<td><%=r_s4%></td>
					<td><%=r_s5%></td>
					<td><%=r_s6%></td>
					<td><%=r_sper%></td>

					<td>
					<%
					Select Case r_booorder
					Case "200" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"A</span>E"
					Case "300" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"B</span>R"
					Case "400" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"C</span>W"
					Case "500" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"D</span>D"
					Case Else
					boono = "<span style='display:none;'>"&r_pcode&r_a10&"</span>" & r_booorder
					End Select 

					%>
					<%=boono%>
					</td>

					<td>
					<%
					Select Case r_totalorder
					Case "200" : orderno = "<span style='display:none;'>A</span>E"
					Case "300" : orderno = "<span style='display:none;'>B</span>R"
					Case "400" : orderno = "<span style='display:none;'>C</span>W"
					Case "500" : orderno = "<span style='display:none;'>D</span>D"
					Case Else
						orderno = r_totalorder
					End Select 
					%>
					<%=orderno%>
					</td>
					<td></td>
				<%Case CONST_TYPEC 'type C%>
					<td><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td>
					<td><%=r_s2%></td>
					<%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%>

					<td>
					<%
					Select Case r_booorder
					Case "200" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"A</span>E" 'pubcode 소팅용
					Case "300" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"B</span>R"
					Case "400" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"C</span>W"
					Case "500" : boono = "<span style='display:none;'>"&r_pcode&r_a10&"D</span>D"
					Case Else
					boono = "<span style='display:none;'>"&r_pcode&r_a10&"</span>" & r_booorder
					End Select 


					%>
					<%=boono%>
					</td>

					<td>
					<%
					Select Case r_totalorder
					Case "200" : orderno = "<span style='display:none;'>A</span>E"
					Case "300" : orderno = "<span style='display:none;'>B</span>R"
					Case "400" : orderno = "<span style='display:none;'>C</span>W"
					Case "500" : orderno = "<span style='display:none;'>D</span>D"
					Case Else
						orderno = r_totalorder
					End Select 
					%>
					<%=orderno%>
					</td>
				<%End select%>

			<%'End Select%>
			<%End if%>
		  </tr>
<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		pre_booorder = r_booorder
		Next
	End if
%>