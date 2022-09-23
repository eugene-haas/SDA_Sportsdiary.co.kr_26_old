<%
	If IsArray(arrZ) Then 
		For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
			in01 = 0 '앱력전갯수
			in02 = 0 '입력중갯수
			in03 = 0 '완료갯수

			r_a1 = arrZ(0, ari) 'idx
			idx = r_a1
			r_a2 = arrZ(1, ari) 'gubun   0 순서설정전 1(순서설정완료 : 비체전인경우) 100 '공지사항 이름은 sc playeridx = 0 순서번호는 ? a.tryoutsortno,a.tryoutgroupno 1번위라면 0 100부터 


			r_a3 = arrZ(2, ari)' pidx
			r_teamnm = arrZ(3, ari) 'unm
			r_a5 = arrZ(4, ari) '종목
			r_a6 = arrZ(5, ari) '경기 그룹번호 (체전이아니면 이것만사용)
			r_a7 = arrZ(6, ari) '출전순서
			r_a8 = isNullDefault(arrZ(7, ari),"") '최종결과 (기권/실격포함)

			r_tryoutresult = r_a8 '결과저장

			r_a9 = arrZ(8, ari) '소속
			r_a10 = arrZ(9, ari) '통합부명
			r_a11 = isNullDefault(arrZ(10, ari),"") '참가부명
			r_b1 = arrZ(11, ari) 'pidx 말
			r_b2 = arrZ(12, ari) '말명칭
			r_a12 = arrZ(13, ari) ' 경기시간

			r_a14 = arrZ(14, ari) 'gbidx
			r_a15 = arrZ(15, ari) 'requestIDX 참가신청 인덱스
			r_requestidx = r_a15

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


			r_round = arrZ(28,ari) '재경기라운드 1(본경기) 2 재경기 3 재경기2 (릴레이경우 실지 토너먼트 라운드 수)

			r_per1 = arrZ(30,ari)
			r_per2 = arrZ(31,ari)
			r_per3 = arrZ(32,ari)
			r_per4 = arrZ(33,ari)
			r_per5 = arrZ(34,ari)
			r_total2 = arrZ(35,ari) '종합관찰총점

			r_pcode = arrZ(36,ari) '소팅용 pubcode
			r_midval = isNullDefault(arrZ(37,ari),"") '중간값

			p_sArr = array("", r_s1,r_s2,r_s3,r_s4,r_s5)

			r_gidx_s = arrZ(38,ari) '참가자들 idx
			r_pnm_s = arrZ(39,ari) '참가자들
			If InStr(r_gidx_s,",") > 0 Then
				r_gidxarr = Split(r_gidx_s,",")
				r_gidx0 = r_gidxarr(0)
				r_gidx1 = r_gidxarr(1)
				r_gidx2 = r_gidxarr(2)
			Else
				r_gidx0 = ""
				r_gidx1 = ""
				r_gidx2 = ""
			End If
			If InStr(r_pnm_s,",") > 0 Then
				r_pnmarr = Split(r_pnm_s,",")
				r_pnm0 = r_pnmarr(0)
				r_pnm1 = r_pnmarr(1)
				r_pnm2 = r_pnmarr(2)
			Else
				r_pnm0 = ""
				r_pnm1 = ""
				r_pnm2 = ""
			End if	
			r_t_win = arrZ(40,ari) '리그승수
			r_t_lose = arrZ(41,ari) '리그패수
			r_bigo = arrZ(42,ari) ' 비고


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


		<%If r_teamnm <> "부전" then%>
		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=idx%>" >
				<td style="width:100px;"><%=r_a7%></td>
				<td  ><%=r_teamnm%></td>

				<td  ><a href="javascript:mx.changeWindow(<%=idx%>,2)"><%=r_b2%></a></td><%'말명%>

				<!-- 선수 -->
				<td ><a href="javascript:mx.changeWindow(<%=r_gidx0%>,100,<%=r_requestidx%>)"><%=r_pnm0%></a></td>
				<td ><a href="javascript:mx.changeWindow(<%=r_gidx1%>,100,<%=r_requestidx%>)"><%=r_pnm1%></a></td>
				<td ><a href="javascript:mx.changeWindow(<%=r_gidx2%>,100,<%=r_requestidx%>)"><%=r_pnm2%></a></td>
				<!-- 선수 -->
				
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
						onchange= "mx.setGiveUp(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>,'ING')"  >
							<option value="">==사유==</option>
							<option value="E" <%If r_a8 = "e" then%>selected<%End if%>>실권(E)</option>
							<option value="R" <%If r_a8 = "r" then%>selected<%End if%>>기권(R) 진행중</option>
							<option value="W" <%If r_a8 = "w" then%>selected<%End if%>>기권(W) 시작전</option>
							<option value="D" <%If r_a8 = "d" then%>selected<%End if%>>실격(D)</option>
						</select>
				</td>
				<td>
						<select id="giveupdoc_<%=idx%>" class="form-control" onchange= "mx.setGiveUpDoc(<%=tidx%>,<%=r_a14%>,<%=idx%>,<%=r_a15%>)" >
							<option value="">==선택==</option>						
							<option value="Y"  <%If r_a8_1 = "Y" then%>selected<%End if%>>○</option>
							<option value="N" <%If r_a8_1 = "N" then%>selected<%End if%>>X</option>
						</select>
				</td>

			<%
			If gubunLT = "3" Then '토너먼트만
				gg = gangtdno
				For g=1 To gangtdno%>
					<td>
					<%
					If Cdbl(r_round) >= CDbl(g) then
						ggstr =2^gg
						Select Case ggstr
						Case 4
							If CDbl(r_totalorder) > 0 And   CDbl(r_totalorder) <= 4  then
								Response.write "준결승" 
							Else
								Response.write "-"
							End if
						Case 2
							If CDbl(r_totalorder) > 0 And   CDbl(r_totalorder) <= 2 then
								Response.write "결승"
							Else
								Response.write "-"
							End If
							
						Case Else
								Response.write ggstr & "강"
						End Select 

					End if
					%><%'=r_round%>
					</td>
				<%
				gg = gg - 1
				Next
			
			Else ' 리그
				Response.write  "<td>" & r_t_win & "승 " & r_t_lose & "패</td>"

			End if
			%>

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
					<%If gubunLT = "3" Then '토너먼트만%>
					<%=orderno%>
					<%Else

						Select Case r_totalorder
						Case "200" : orderno = "E"
						Case "300" : orderno = "R"
						Case "400" : orderno = "W"
						Case "500" : orderno = "D"
						Case Else
							orderno = r_totalorder
						End Select 					
					
					%>
					<input type="text" value="<%=orderno%>" id = "torder_<%=r_a1%>" onblur="mx.changeRank(<%=r_a1%>, this.value)" class="form-control" style="width:80px;">
					<%End if%>
					</td>
					<%If gubunLT = "2" Then '리그%>
					<td>
					<input type="text" value="<%=r_bigo%>" id = "tbigo_<%=r_a1%>" onblur="mx.changeBigo(<%=r_a1%>, this.value)" class="form-control" style="width:80px;">
					</td>
					<%End if%>
		  </tr>
		<%End if	%>
<%

		Next
	End if
%>

