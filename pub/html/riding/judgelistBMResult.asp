  <div class="table-responsive" id="printdivBMResult">

		<table  cellspacing="0" cellpadding="0" class="table table-hover" id="tblridingBMResult">
			<thead>
					<tr>
						<td colspan="17" style="text-align:right;" class="tbl-btnarea">
						<%If kgame = "Y" then%>
							<a class="btn btn-danger" disabled>체전</a>&nbsp;&nbsp;
							<a href="javascript:$('#printdivBMResult').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1>복합마술 최종결과</h1>'});" class="btn btn-default">인쇄</a>&nbsp;&nbsp;
							&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>,2)' class="btn btn-default">결과인쇄</a></span>
						<%else%>
							<a class="btn btn-danger" disabled>일반</a>&nbsp;&nbsp;
							<a href="javascript:$('#printdivBMResult').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1>복합마술 최종결과</h1>'});" class="btn btn-default">인쇄</a>&nbsp;&nbsp;
							&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>,2)' class="btn btn-default">결과인쇄</a></span>
						<%End if%>
						</td>
					</tr>
					<tr>
						<th>출전순서<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th>
						<th>장애물<br>소요시간<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>시간감점<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>장애감점<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>감점합계<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>

						<th>마장마술<br>총 감점<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>복합마술<br>점수<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>

						<th>부별순위<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>전체순위<br><span><button onclick="sortTDRBMResult($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDRBMResult ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>

					</tr>



			</thead>
			<tbody id="listcontentsBM">





<%
	'Gbidx 의 내용 위에 꺼랑 조인해서 가져오기.....class classhelp

	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
	fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 "
	fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval "
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&rt_gbidx&"' and a.round = 2 and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrZR = rs.GetRows()
	End If
	rs.close

	If IsArray(arrZR) Then 
		For ari = LBound(arrZR, 2) To UBound(arrZR, 2)
			in01 = 0 '앱력전갯수
			in02 = 0 '입력중갯수
			in03 = 0 '완료갯수

			r_a1 = arrZR(0, ari) 'idx
			idx = r_a1
			r_a2 = arrZR(1, ari) 'gubun   0 순서설정전 1(순서설정완료 : 비체전인경우) 100 '공지사항 이름은 sc playeridx = 0 순서번호는 ? a.tryoutsortno,a.tryoutgroupno 1번위라면 0 100부터 
			r_a3 = arrZR(2, ari)' pidx
			r_a4 = arrZR(3, ari) 'unm
			r_a5 = arrZR(4, ari) '종목
			r_a6 = arrZR(5, ari) '경기 그룹번호 (체전이아니면 이것만사용)
			r_a7 = arrZR(6, ari) '출전순서

			r_a8 = isNullDefault(arrZR(7, ari),"") '최종결과 (기권/실격포함)


			r_a9 = arrZR(8, ari) '소속
			r_a10 = arrZR(9, ari) '통합부명
			r_a11 = isNullDefault(arrZR(10, ari),"") '참가부명
			r_b1 = arrZR(11, ari) 'pidx 말
			r_b2 = arrZR(12, ari) '말명칭
			r_a12 = arrZR(13, ari) ' 경기시간

			r_a14 = arrZR(14, ari) 'gbidx
			r_a15 = arrZR(15, ari) 'requestIDX 참가신청 인덱스

			r_a8_1 = arrZR(16, ari) '문서제출여부			

			'##################
			',score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order
			r_sgf = arrZR(17,ari) 'sgf
			r_s1 = isNullDefault(arrZR(18,ari),"")
			r_s2 = isNullDefault(arrZR(19,ari),"")
			r_s3 = isNullDefault(arrZR(20,ari),"")
			r_s4 = isNullDefault(arrZR(21,ari),"")
			r_s5 = isNullDefault(arrZR(22,ari),"")
			r_s6 = isNullDefault(arrZR(29,ari),"")

			r_stotal = arrZR(23,ari) '장애물 소요시간
			r_sper = arrZR(24,ari) '장애물인경우 B,C 타입 소요시간 2
			r_booorder = arrZR(25,ari)
			r_totalorder = arrZR(26,ari)

			r_gamest = arrZR(27,ari) '게임상태
			r_round = arrZR(28,ari) '재경기라운드 1(본경기) 2 재경기 3 재경기2

			r_per1 = arrZR(30,ari)
			r_per2 = arrZR(31,ari)
			r_per3 = arrZR(32,ari)
			r_per4 = arrZR(33,ari)
			r_per5 = arrZR(34,ari)
			r_total2 = arrZR(35,ari) '복합마술점수

			r_pcode = arrZR(36,ari) '소팅용 pubcode
			r_midval = isNullDefault(arrZR(37,ari),"") '중간값
			'Response.write "@@@@@@@@@@@@@@@@@@@@@@@@"&in01
			%>


		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=idx%>" >
				<td style="width:100px;"><%=r_a7%></td>


				<td><%=r_a10%></td>
				<td  ><%=r_a4%></td>
				<td  ><%=r_b2%></td><%'말명%>
				<td ><%=r_a9%></td>
				<td ><%If r_a11 = "" then%><%=r_a10%><%else%><%=r_a11%><%End if%></td>


					<td><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td>
					<td><%=r_s2%></td>
					<td><%=r_s3%></td>
					<td>
					<%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%>
					</td>
					
					<td><%=FormatNumber(r_sper,1)%></td><%'마장마술 총감점%>
					<td><%=FormatNumber(r_total2,1)%></td><%'복합마술점수  100 - (마장마술 총감점 + 감점합계)%>
					
					
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
					<%
						pre_v1 = r_s1
						pre_v2 = r_stotal
					%>
		  </tr>
<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		pre_booorder = r_booorder
		Next
	End if
%>
			</tbody>
	  </table><br>
  </div>
