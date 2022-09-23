

<%
'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
	SQL = "select top 1 a.judgecnt,a.judgemaxpt,a.judgesignYN,a.judgeshowYN,b.ridingclass , b.ridingclasshelp,b.teamgb  from tblRGameLevel  as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx  where gametitleidx = '"&tidx&"' and Gbidx = '"&rt_gbidx&"'  "
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



'마장마술껄로 gbidx가 생성된다.

'Response.write "" &select_f_teamgb & "---"



	'Gbidx 의 내용 위에 꺼랑 조인해서 가져오기.....class classhelp
	'attcnt = " ( select max(tryoutsortno) from SD_tennisMember where  gametitleidx = " & tidx & " and delYN = 'N' and gubun < 100 and gamekey3 = a.gamekey3) as attcnt "

	tblnm = " SD_tennisMember as a INNER JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx INNER JOIN tblPlayer as c ON a.playeridx = c.playeridx  "
	fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
	fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 "
	fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval   ,c.ksportsno , a.pt, a.crapeNo, a.crapedate "
	'SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&rt_gbidx&"' and a.round = 2 and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.teamgb = '"&select_f_teamgb&"'  and a.round = 2 and a.gubun < 100   and boo_orderno < 4  order by a.boo_orderno asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrZ = rs.GetRows()
	End If
	rs.close


'Call getrowsdrow(arrz)


	If IsArray(arrZ) Then 
		For ari = LBound(arrZ, 2) To UBound(arrZ, 2)
			in01 = 0 '앱력전갯수
			in02 = 0 '입력중갯수
			in03 = 0 '완료갯수

			r_a1 = arrZ(0, ari) 'idx
			idx = r_a1

			'배열로 인덱스 값을 가져올수 있도록 만들어두자.
			If ari = 0 Then
				idxarr = idx
			Else
				idxarr = idxarr & "," & idx
			End If
			'배열로 인덱스 값을 가져올수 있도록 만들어두자.					
			
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

			r_kno = arrZ(38,ari) '체육인번호
			r_attcnt = arrZ(39, ari) '참가인원 (경기당)


			r_crapeNo = arrZ(40, ari) '획득포인트
			r_crapeDate = arrZ(41, ari) '획득상금

			'Response.write "@@@@@@@@@@@@@@@@@@@@@@@@"&in01


			'흠 .................................각설정에 따라서 성적을 구하자...
			attkey1 = r_a3 & r_b1
			score_str = ""
			Select Case r_round 
			Case "1"
				If CStr(attkey3) = CStr(attkey1) Then
					score_str = score_str3
					attkey3 = ""
					score_str3 = ""
				End If
				If score_str = "" And CStr(attkey2) = CStr(attkey1) Then
					score_str = score_str2
					attkey2 = ""
					score_str2 = ""
				End If
				If score_str = "" Then
					If r_a8 = "0" Then
					score_str = score_str & r_stotal & "("&r_s2 & "”" & r_s3 &")"
					Else
					score_str = score_str & UCase(r_a8)
					End if
				End If				

			Case "2"
				attkey2 = r_a3 & r_b1
				score_str2 = "재"
				If r_a8 = "0" Then
				score_str2 = score_str2 & r_stotal & "("&r_s2 & "”" & r_s3 &")"
				Else
				score_str2 = score_str2 & UCase(r_a8)
				End if				
			Case "3"
				attkey3 = r_a3 & r_b1
				score_str3 = "재"
				If r_a8 = "0" Then
				score_str3 = score_str3 & r_stotal & "("&r_s2 & "”" & r_s3 &")"
				Else
				score_str3 = score_str3 & UCase(r_a8)
				End if
			End Select

			
			%>
		  <tr class="gametitle_<%=r_a2%>"  id="titlelist_<%=idx%>"  onclick="mx.input_edit(<%=idx%>,$(this))">
				<td><span style="display:none;"><%=ari+1%></span><input type="checkbox" id="chk_<%=idx%>" name="chk" value="<%=idx%>"></td>
				<td><%=select_f_PTeamGbNm%></td>
				<td><span style="display:none;"><%=r_crapeNo%></span><input id="crape_<%=idx%>" type="text" value="<%=r_crapeNo%>" style="width:70px;"  readonly /></td>
				<td><%=Select_f_teamgbnm%></td>
				<td><%=t_gametitlename%></td>
				<td><%=t_titlecode%></td>
				<td><%=r_a4%></td>
				<td><%=r_b2%></td>
				<td><%=r_a9%></td>
				<td><%=r_a3%></td><!-- pidx -->
				<td><%If  r_kno = "" then%>없음<%else%><%=r_kno%><%End if%></td>
				<td><%=Split(r_class," ")(0)%></td>
				<td>결승</td>
				<td><%=r_round%></td>
				<td><%If r_a11 = "" then%><%=r_a10%><%else%><%=r_a11%><%End if%></td>

				<td>
					<%If r_a8 = "0" then%><%=r_stotal%><%else%><span style="display:none;"><%=errdic(r_a8)%></span><%=UCase(r_a8)%><%End if%>
				</td>



				<td><%=r_booorder%></td>
				<td><%=r_totalorder%></td>
				<td><%=r_crapeDate%></td><!-- 상장번호부여시 넣어야한다. -->
		  </tr>

<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		pre_booorder = r_booorder
		Next

		%><input type="hidden" id="idxarr" value="[<%=idxarr%>]"><%

	End if
%>



