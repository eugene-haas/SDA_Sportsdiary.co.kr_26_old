			</tbody>
	  </table><br>
  </div>





  <div class="table-responsive" id="printdivB">
		<table cellspacing="0" cellpadding="0" class="table table-hover" id="tblriding2">
			<thead>


				<tr><td colspan="17" style="text-align:right;">

						<%'체전의 3라운드는 제외 하고..%>
						<%If kgame = "N" then%>
						<%If select_f_classhelp = "FEI 238.2.2" then%><a href="javascript:mx.setHurdle(<%=tidx%>,<%=find_gbidx%>,'<%=select_f_classhelp%>',3)" class="btn btn-primary">장애물 기준 및 배치정보(재경기)</a>&nbsp;&nbsp;&nbsp;<%End if%> 
						<%End if%> 


		
						<%If kgame = "Y" then%> 
						<a href="javascript:$('#printdivB').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1><%=select_f_title%> : 결승</h1>'});" class="btn btn-default">화면인쇄</a>&nbsp;&nbsp;</span>
						&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>,3)' class="btn btn-default">결과인쇄</a></span>
						<%else%>
						<a href="javascript:$('#printdivB').printThis({importCSS: false,loadCSS: '/pub/js/print/print_table.css',header: '<h1><%=select_f_title%> : 재경기(2)</h1>'});" class="btn btn-default">화면인쇄</a>&nbsp;&nbsp;</span>
						&nbsp;&nbsp;<a href='javascript:px.goPrint(<%=req%>,3)' class="btn btn-default">결과인쇄</a></span>
						<%End if%>

						<%If CDbl(maxrndno) = 3 then%>
						<a href="javascript:mx.delReGame(<%=maxrndno%>,<%=tidx%>,<%=find_gbidx%>,'<%=kgame%>')" class="btn btn-primary">삭제<%=maxrndno%></a></span>
						<%End if%>

				
				</td></tr>


				<tr>
					<th>출전순서<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th><th>통합부명</th><th>선수명</th><th>마명</th><th>소속</th><th>참가부명</th>

					<%If kgame= "N" then%><th>경기상태</th><%End if%>
					<th>기권/실격</th><th>사유서제출</th>
					<%If kgame= "N" then%><th>기록입력</th><%End if%>

					<th>총소요시간<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<th>시간감점<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<th>장애감점<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<th>감점합계<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>

			<%If gametypestr = "단체" then%>
						<th>전체순위<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체순위<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체총시간<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<th>단체총감점<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
						<%If select_f_classhelp <> CONST_TYPEA_1 and kgame = "N" Then %>	
						<th>재경기</th>
						<%End if%>
			<%else%>
					<th>부별순위<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<th>전체순위<br><span><button onclick="sortTDR2($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▲</button><button onclick="reverseTDR2 ($(this).closest('th').prevAll().length)" class="btn btn-default btn-xs">▼</button></span></th>
					<th>재경기</th>
			<%End if%>




				</tr>



			</thead>

			<tbody id="listcontents2">



<%
	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
	fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
	fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 ,  a.pubcode  ,group_order,group_score_per ,group_score_total,group_score_1 "
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 3 and gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
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
			boono = ""
			orderno = ""
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

			r_pcode = arrZ(30,ari) '소팅용 pubcode


			'단체전 ====================
			r_group_order = arrZ(31,ari)
			r_group_score_per = arrZ(32,ari)

			r_group_score_total = arrZ(33,ari) '총감점
			r_group_score_1 = arrZ(34,ari) '총시간
			'단체전 ====================

			p_sArr = array("", r_s1,r_s2,r_s3,r_s4,r_s5)

			'버튼상태 구하기

			Select Case  r_a5
			case  "마장마술"
				'마장마술인 경우
					For x = 1 To r_judgecnt
						Select Case CStr(p_sArr(x))
						Case ""
							in01 = in01 + 1
						Case "0"
							in02 = in02 + 1
						Case Else
							in03 = in03 + 1
						End Select
					next

					If CDbl(in01) = CDbl(r_judgecnt) Then	'입력전
						btnst = 1
					End if

					If CDbl(in02) > 0 Or  CDbl(in03) > 0 Then	'입력진행
						btnst = 2
					End If

					If CDbl(in03) = CDbl(r_judgecnt) Then	'경기종료
						btnst = 3
					End if

					If r_judgecnt = "0" Then '지점 수 없음
						btnst = 1
					End If
				'마장마술인경우

			Case "장애물"

				Select Case CStr(r_s1)
				Case ""
					btnst = 1
				Case "0"
					btnst = 2
				Case Else
					btnst = 3
				End Select

			End Select

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



		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=idx%>" ><!-- style="cursor:pointer" -->
			<td style="width:100px;"><span><%=r_a7%></span></td>

			<%If r_a5 = "마장마술" then%>
			<td ><span><%=r_hh&":"&r_mm%></span></td>
			<%End if%>

			<td><span><a href="javascript:mx.changeBoo(<%=idx%>,1)"><%=r_a10%></a><!-- 초,중등부 --></span></td>

			<td  ><span><%=r_a4%></span></td>
			<td  ><span><%=r_b2%><!-- 분더바엔지 --></span></td>

			<td ><%=r_a9%><!-- 원곡중학교 --></span></td>
			<td ><span><a href="javascript:mx.changeBoo(<%=idx%>,2)"><%If r_a11 = "" then%><%=r_a10%><%else%><%=r_a11%><%End if%></a><!-- 중등부 --></span></td>
			

<%If kgame= "N" then%>
			<td ><span>
			<%Select Case r_gamest%>
			<%Case "1"%>
			<a href="javascript:mx.setGameState(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,1)" class="btn btn-white">경기시작</a>
			<%Case "2"%>
			<a href="javascript:mx.setGameState(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,2)" class="btn btn-green">진행중</a>
			<%Case "3"%>
			<a href="javascript:mx.setGameState(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,3)" class="btn btn-blue">경기종료</a>
			<%End Select%>

			</span></span></td>
<%End if%>

			<td><span>
					<select id="giveup_<%=idx%>" class="form-control 
						<%Select case r_a8 
						Case "e" : Response.write "form-control-yellow"
						Case "r" :  Response.write "form-control-gray"
						Case "w" : Response.write "form-control-gray"
						Case "d" : Response.write "form-control-red"
						Case Else 
						End Select 
						%>"
					<%If kgame= "N" then%>onchange= "mx.setGiveUp(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>,'ING')" style="width:100px;"<%End if%>   <%If kgame= "Y" then%>disabled<%End if%>><!-- 개별 바로바로 저장 -->
						<option value="">==사유==</option>
						<option value="E" <%If r_a8 = "e" then%>selected<%End if%>>실권(E)</option>
						<option value="R" <%If r_a8 = "r" then%>selected<%End if%>>기권(R) 진행중</option>
						<option value="W" <%If r_a8 = "w" then%>selected<%End if%>>기권(W) 시작전</option>
						<option value="D" <%If r_a8 = "d" then%>selected<%End if%>>실격(D)</option>
					</select>
			</span></td>

			<td  ><span>
					<select id="giveupdoc_<%=idx%>" class="form-control" <%If kgame= "N" then%>onchange= "mx.setGiveUpDoc(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>)"<%End if%> style="width:100px;"  <%If kgame= "Y" then%>disabled<%End if%>><!-- 개별 바로바로 저장 -->
						<option value="">==선택==</option>
						<option value="Y"  <%If r_a8_1 = "Y" then%>selected<%End if%>>○</option>
						<option value="N" <%If r_a8_1 = "N" then%>selected<%End if%>>X</option>
					</select>
			</span></td>


<%If kgame= "N" then%>
			<td>
				<%Select Case CStr(btnst) %>
				<%Case "1"%>
				<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-white">기록입력</a></span>
				<%Case "2"%>
				<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-green">입력중..</a></span>
				<%Case "3"%>
					<%If r_s4 = "" And r_classhelp = CONST_TYPEB then%>
						<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-success">1단계완료</a></span>
					<%else%>
						<a href="javascript:mx.inputRecord(<%=idx%>,<%=tidx%>,<%=find_gbidx%>,<%=r_round%>,'<%=kgame%>')" class="btn btn-blue">완료/수정</a></span>
					<%End if%>
				<%Case else%>
					::<%=btnst%>::
				<%End Select %>
			</td>
<%End if%>

			<%Select Case r_a5
			Case "마장마술"%>

			<td><%=r_stotal%></td>
			<td><%=r_sper%>%</td>
			
			<td>
			<%
			Select Case r_booorder
			Case "200" : boono = "<span style='display:none;'>A</span>E"
			Case "300" : boono = "<span style='display:none;'>B</span>R"
			Case "400" : boono = "<span style='display:none;'>C</span>W"
			Case "500" : boono = "<span style='display:none;'>D</span>D"
			Case Else
			boono = r_booorder
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


			<%case "장애물"%>
				<%Select Case r_classhelp%>

				<%Case CONST_TYPEA1 , CONST_TYPEA2,CONST_TYPEA_1 'type A%>
					<td><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td><!-- 총소요시간 -->
					<td><%=r_s2%></td>
					<td><%=r_s3%></td>
					<td><%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%></td>
					<td>
					<%
					Select Case r_booorder
					Case "200" : boono = "<span style='display:none;'>A</span>E"
					Case "300" : boono = "<span style='display:none;'>B</span>R"
					Case "400" : boono = "<span style='display:none;'>C</span>W"
					Case "500" : boono = "<span style='display:none;'>D</span>D"
					Case Else
					boono = r_booorder
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



					<td><span> <input type="checkbox" id="<%=r_round%>_<%=idx%>" value=<%=idx%>></td><!-- gbidx + pubcode    클릭시 연계성 알려줌 나중에 --> </span></td>
					<%
						pre_v1 = r_s1
						pre_v2 = r_stotal
					%>
				<%Case CONST_TYPEB 'type B%>
					<td><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td>
					<td><%=r_s2%></td>
					<td><%=r_s3%></td>
					<td><%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%></td>

					<td><%=r_s4%></td>
					<td><%=r_s5%></td>
					<td><%=r_s6%></td>
					<td><%=r_sper%></td>

					<td>
					<%
					Select Case r_booorder
					Case "200" : boono = "<span style='display:none;'>A</span>E"
					Case "300" : boono = "<span style='display:none;'>B</span>R"
					Case "400" : boono = "<span style='display:none;'>C</span>W"
					Case "500" : boono = "<span style='display:none;'>D</span>D"
					Case Else
					boono = r_booorder
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
					<td><%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%></td>

					<td>
					<%
					Select Case r_booorder
					Case "200" : boono = "<span style='display:none;'>A</span>E"
					Case "300" : boono = "<span style='display:none;'>B</span>R"
					Case "400" : boono = "<span style='display:none;'>C</span>W"
					Case "500" : boono = "<span style='display:none;'>D</span>D"
					Case Else
					boono = r_booorder
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

			<%End Select%>
		  </tr>
<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		Next
	End if


%>
