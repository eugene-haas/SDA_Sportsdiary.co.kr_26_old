<%
	If kgame = "" Then
		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
		kgame = rs("kgame") 'YN 체전여부 
	End if

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
	fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval     ,group_order,group_score_per ,group_score_total,group_score_1 "
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 1 and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

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


			'단체전 ====================
			r_group_order = arrZ(38,ari)
			r_group_score_per = arrZ(39,ari)

			r_group_score_total = arrZ(40,ari) '총감점
			r_group_score_1 = arrZ(41,ari) '총시간
			'단체전 ====================

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

				<%If sel_orderType = "MM" then%>
				<td ><%=r_hh&":"&r_mm%></td>
				<%End if%>


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
							<%If (r_s4 = "" Or Left(r_s4,1) = "0" ) And r_classhelp = CONST_TYPEB then%>
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

				
			<%If gametypestr = "단체" then%>

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
				
				<td><%=r_group_order%></td><!--  단체순위 -->
				<td><%=r_group_score_per%></td><!-- 단체총비율 -->

			
			
			<%else%>
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
			<%End if%>


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

					
			<%If gametypestr = "단체" then%>
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
					<td><%=r_group_order%></td><!--  단체순위 -->
					<td><%=r_group_score_1%></td><!-- 단체총시간 score1-->
					<td><%=r_group_score_total%></td><!-- 단체총감점 tryoutresult -->

			<%else%>
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
						If CDbl(r_totalorder) < 0 then
							orderno = "<span style='display:none;'>"&Abs(r_totalorder) & ".1" &"</span>-"
						else
							orderno = r_totalorder
						End if
					End Select 
					%>
					<%=orderno%>
					</td>
			<%End if%>

					<%If select_f_classhelp <> CONST_TYPEA_1 and kgame = "N" And select_f_teamgb <> "20103" Then %>
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
					<td><%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%></td>

					<td><%If r_s4 <> "" then%><%=FormatNumber(r_s4,2)%><%End if%></td>
					<td><%=r_s5%></td>
					<td><%=r_s6%></td>

					<td><%If r_a8 = "0" then%><%=r_sper%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%></td>


					
			<%If gametypestr = "단체" then%>                    
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
					<td><%=r_group_order%></td><!--  단체순위 -->
					<td><%=r_group_score_1%></td><!-- 단체총시간 score1-->
					<td><%=r_group_score_total%></td><!-- 단체총감점 tryoutresult -->
			<%else%>
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
            <%end if%>



				<%Case CONST_TYPEC 'type C%>
					<td><%If r_s1 <> "" then%><%=FormatNumber(r_s1,2)%><%End if%></td>
					<td><%=r_s2%></td>
					
					<td>
					<%If r_a8 = "0" then%>
					<%If r_stotal <> "" then%><%=FormatNumber(r_stotal,2)%><%End if%>
					<%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%>
					</td>

			<%If gametypestr = "단체" then%>                    
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
					<td><%=r_group_order%></td><!--  단체순위 -->
					<td><%=r_group_score_1%></td><!-- 단체총시간 score1-->
					<td><%=r_group_score_total%></td><!-- 단체총감점 tryoutresult -->
			<%else%>

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
					%><%=boono%>
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
			<%End if%>


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

