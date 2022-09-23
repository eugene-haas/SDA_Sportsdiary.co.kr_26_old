	<%For i = 1  To CDbl(pagecnt)%>
		<div class="page">
			<p class="header">
				<span class="header__titleName">대회명: <%=gametitlename%></span>
				<span class="header__titleDate">일시 : <%=select_f_date%>&nbsp;&nbsp;<%=select_f_stime%>~<%=select_f_etime%></span>
				<span class="header__titleLevel">종목 : <%=select_f_title%><span>
			</p>

			<table class="obstacles s_2phase">
				<thead>
					<tr>
					<th class="order">출전<br>순서</th>
					<th class="partName">통합<br>부명</th>
					<th class="playerName">선수명</th>
					<th class="horseName">마명</th>
					<th class="belongName">소속</th>

					<%For x = 0 To ubound(hurdleArr)%>
					<th class="obstacle"   <%If CDbl(hurdle2pahasegubun-1) > x then%>style="background:#B4B4B4;"<%End if%>>
					<%=hurdleArr(x)%>
					</th>
					<%next%>

					<th class="etc">비고</th>

					<th class="duration">소요<br>시간</th>
					<th class="timePenalty">시간<br>감점</th>
					<th class="obstaclePenalty">장애<br>감점</th>
					<th class="totalPenalty">감점<br>합계</th>

					<th class="partRanking">부별<br>순위</th>
					<th class="totalRanking">전체<br>순위</th>
					</tr>
				</thead>
				<tbody>


		<%
		If IsArray(arrZ) Then

			startno = 15 * (i -1)

			If i = CDbl(pagecnt) then
				endno = CDbl(startno)  + ( CDbl(listcnt) - (15 * (i - 1)) )  - 1
			Else
				endno = CDbl(startno) + 14
			End if

			For ari = startno To endno

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



				jinputtxtarr = isNullDefault(arrZ(38,ari),"")
				inputdata = Split(jinputtxtarr,",")
				r_bigo = isNullDefault(arrZ(39,ari),"")
				r_bigo2 = isNullDefault(arrZ(40,ari),"")


				p_sArr = array("", r_s1,r_s2,r_s3,r_s4,r_s5)

				If r_a12 <> "" And isnull(r_a12) = false then
					r_gametime = Split(Left(setTimeFormat(r_a12),5),":")
					r_hh = r_gametime(0)
					r_mm = r_gametime(1)
				Else
					r_hh = 0
					r_mm = 0
				End if
		%>
					<tr>
						<td rowspan="2" class="order"><%=r_a7%></td> <!-- 출전순서 -->
						<td rowspan="2" class="partName"><%=r_a10%></td> <!-- 통합부명 -->
						<td rowspan="2" class="playerName"><%=r_a4%></td> <!-- 선수명 -->
						<td rowspan="2" class="horseName"><%=r_b2%></td> <!-- 마명 -->
						<td rowspan="2" class="belongName"><%=r_a9%></td> <!-- 소속 -->

						<%For x = 0 To ubound(inputdata)%>
						<td class="obstacle">
						<%If CDbl(hurdle2pahasegubun-1) > x then%>
						<%=inputdata(x)%>
						<%else%>
						&nbsp;
						<%End if%>
						</td> <!-- 장애물 -->
						<%next%>

						<%For y = x To 19%>
						<td class="obstacle"> </td>
						<%next%>


						<td class="etc"><%=r_bigo%></td> <!-- 비고 -->

						<td class="duration"><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td> <!-- 소요시간 -->
						<td class="timePenalty"><%If isnumeric(r_s2) = true and r_s2 <> "0" then%> <%End if%><%=r_s2%></td> <!-- 시간감점 -->
						<td class="obstaclePenalty"><%If isnumeric(r_s3) = true and r_s3 <> "0" then%> <%End if%><%=r_s3%></td> <!-- 장애감점 -->
						<td class="totalPenalty">
						<%If r_a8 = "0" then%>
						<%If r_stotal <> "0" then%> <%End if%><%=r_stotal%>
						<%else%><%=UCase(r_a8)%><%End if%>
						</td> <!-- 감점합계 -->

						<td rowspan="2" class="partRanking">
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
						</td> <!-- 부별순위 -->
						<td rowspan="2" class="totalRanking">
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
						</td> <!-- 전체순위 -->
					</tr>

					<tr>
						<%For x = 0 To ubound(inputdata)%>
						<td class="obstacle">
						<%If CDbl(hurdle2pahasegubun-1) <= x then%>
						<%=inputdata(x)%>
						<%else%>
						&nbsp;
						<%End if%>
						</td> <!-- 장애물 -->
						<%next%>

						<%For y = x To 19%>
						<td class="obstacle"> </td>
						<%next%>

					  <td class="etc"><%=r_bigo2%></td> <!-- 비고 -->

						<td class="duration"><%If r_s4 <> "" then%><%=FormatNumber(r_s4,2)%><%End if%></td> <!-- 소요시간 -->
						<td class="timePenalty"><%If isnumeric(r_s5) = true and r_s5 <> "0" then%> <%End if%><%=r_s5%></td> <!-- 시간감점 -->
						<td class="obstaclePenalty"><%If isnumeric(r_s6) = true and r_s6 <> "0" then%> <%End if%><%=r_s6%></td> <!-- 장애감점 -->
					  <td class="totalPenalty">
						<%If r_a8 = "0" then%>
						<%If r_sper <> "0" then%> <%End if%><%=r_sper%>
						<%else%><%=UCase(r_a8)%><%End if%>
					  </td> <!-- 감점합계 -->
					</tr>
		<%
			pre_gameno = r_a2
			pre_gameday = r_a9
			pre_booorder = r_booorder



			Next
		End if
		%>

				</tbody>
			</table>

		<table class="obstaclesBottom">
		  <tbody>
			<tr>
			  <th rowspan="2" class="game">본경기</th>
			  <th class="phase">1단계</th>
			  <td class="length">전장: <%=totallength1%>M</td>
			  <td class="tempo">분속: <%=mspeed1%>M / MIN</td>
			  <td class="allowed">소정시간: <%=time1%> SEC</td>
			  <td class="limit">제한시간: <%=limittime1%> SEC</td>
			  <td rowspan="2" class="sign">심판장 서명:</td>
			</tr>
			<tr>
			  <th class="phase">2단계</th>
			  <td class="length">전장: <%=totallength2%>M</td>
			  <td class="tempo">분속: <%=mspeed2%>M / MIN</td>
			  <td class="allowed">소정시간: <%=time2%> SEC</td>
			  <td class="limit">제한시간: <%=limittime2%> SEC</td>
			</tr>
		  </tbody>
		</table>

		</div>
	<%next%>
