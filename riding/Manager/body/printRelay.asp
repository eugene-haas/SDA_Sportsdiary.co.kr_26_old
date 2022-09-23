	<%For i = 1  To CDbl(pagecnt)%>
		<div class="page">
			<p class="header">
				<span class="header__titleName">대회명: <%=gametitlename%></span>
				<span class="header__titleDate">일시 : <%=select_f_date%>&nbsp;&nbsp; <%=select_f_stime%>~<%=select_f_etime%></span>
				<span class="header__titleLevel">종목 : <%=select_f_title%><span>
			</p>

			<table class="obstacles s_TableA">
				<thead>
					<tr>
					<th class="order">출전순서</th>
					<th class="playerName">팀명</th>
					<th class="horseName">마명</th>

					<th class="obstacle" colspan="3">선수</th>

					<%If arrZ(1, 0) = "2" then%>
					<th class="etc">전적</th>
					<%End if%>
					<th class="totalRanking">전체순위</th>
					<%If arrZ(1, 0) = "2" then%>
					<th class="etc">비고</th>
					<%End if%>
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
			'For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
			ari = CDbl(ari)

'If CDbl(endno) = 37 Then
'Response.write "<tr><td>"&  ari & " -" & Endno&"</td></tr>"
'Response.end
'End if

'If ax= "aa" then
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

				p_sArr = array("", r_s1,r_s2,r_s3,r_s4,r_s5)

				If r_a12 <> "" And isnull(r_a12) = false then
					r_gametime = Split(Left(setTimeFormat(r_a12),5),":")
					r_hh = r_gametime(0)
					r_mm = r_gametime(1)
				Else
					r_hh = 0
					r_mm = 0
				End If
				
				r_member = arrZ(46,ari)
				If InStr(r_member,",") > 0 Then
					r_m = split(r_member,",")
					r_m1 = r_m(0)
					r_m2 = r_m(1)
					r_m3 = r_m(2)
				End if
				t_win = arrZ(47,ari)
				t_lose = arrZ(48,ari)


		
		
		%>
					<tr>
						<td class="order"><%=r_a7%></td> <!-- 출전순서 -->
						<td class="playerName"><%=r_a4%></td> <!-- 팀명 -->
						<td class="horseName"><%=r_b2%></td> <!-- 마명 -->





						<td class="obstacle"><%=r_m1%></td>
						<td class="obstacle"><%=r_m1%></td>
						<td class="obstacle"><%=r_m1%></td>




						<%If r_a2 = "2" then%>
						<td class="etc"><%=t_win%>승 <%=t_lose%>패</td> 
						<%End if%>
						<td class="totalRanking">
							<%
							Select Case r_totalorder
							Case "200" : orderno = "<span style='display:none;'>A</span>E"
							Case "300" : orderno = "<span style='display:none;'>B</span>R"
							Case "400" : orderno = "<span style='display:none;'>C</span>W"
							Case "500" : orderno = "<span style='display:none;'>D</span>D"
							Case Else
								If r_a2 = "3" Then
									If CDbl(r_totalorder) < 5 Then
									orderno = r_totalorder &"위"
									ElseIf CDbl(r_totalorder) = 5 then
									orderno = "8강"
									ElseIf CDbl(r_totalorder) = 6 then
									orderno = "16강"
									ElseIf CDbl(r_totalorder) = 7 then
									orderno = "32강"
									ElseIf CDbl(r_totalorder) = 8 then
									orderno = "64강"
									End if
								else
								orderno = r_totalorder
								End if
							End Select 
							%>
							<%=orderno%>				
						</td> <!-- 전체순위 -->
						<%If r_a2 = "2" then%>
						<td class="etc"><%=r_bigo%></td> <!-- 비고 -->
						<%End if%>
					</tr>
		<%
			pre_gameno = r_a2
			pre_gameday = r_a9
			pre_booorder = r_booorder

			
'End if			
			Next
		End if
		%>

				</tbody>
			</table>

		<table class="obstaclesBottom">
		  <tbody>
			<tr>
			  <th class="game" style="border:0px;">
			  </th>
			  <td class="length" style="border:0px;"></td>
			  <td class="tempo" style="border:0px;"></td>
			  <td class="allowed" style="border:0px;"></td>
			  <td class="limit" style="border:0px;"></td>
			  <td class="sign">심판장 서명:</td>
			</tr>
		  </tbody>
		</table>

		</div>
	<%next%>