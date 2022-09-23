<%
'	If kgame = "" Then
'		SQL = "select top 1 kgame from sd_TennisTitle where GameTitleIDX = " & tidx
'		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'		kgame = rs("kgame") 'YN 체전여부 
'	End if


'	'독립적으로 지점수, 최고점수, 심판장서명완료 가 되었는지 확인할수 있게 되어야한다. (gbidx 에서 한개라도 누락이라면 안된거임) 다시적용하록 메시지
'	SQL = "select top 1 a.judgecnt,a.judgemaxpt,a.judgesignYN,a.judgeshowYN,b.ridingclass , b.ridingclasshelp  from tblRGameLevel  as a inner join tblTeamGbInfo as b  ON a.gbidx = b.teamgbidx  where gametitleidx = '"&tidx&"' and Gbidx = '"&find_gbidx&"'  "
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rs.EOF Then
'		arrC = rs.GetRows()
'	End If
'	rs.close
'
'	If IsArray(arrC) Then
'			r_judgecnt = arrC(0, 0)
'			r_judgemaxpt = arrC(1, 0)
'			r_judgesignYN = arrC(2, 0)
'			r_judgeshowYN = arrC(3, 0)
'			r_class = arrC(4, 0)
'			r_classhelp = arrC(5, 0)
'	End if


	'Gbidx 의 내용 위에 꺼랑 조인해서 가져오기.....class classhelp

'	tblnm = " SD_tennisMember as a LEFT JOIN sd_tennisMember_partner as b ON a.gamememberidx = b.gamememberidx "
'	fldnm = "a.gameMemberIDX,a.gubun,a.playeridx,a.username,a.key3name,a.tryoutgroupno,a.tryoutsortno,a.tryoutresult,a.teamAna,a.pubname,a.orgpubname,b.playeridx,b.username,a.gametime,a.gamekey3,a.requestIDX,tryoutdocYN "
'	fldnm = fldnm & "  ,score_sgf,score_1,score_2,score_3,score_4,score_5,score_total,score_per,boo_orderno,total_order  ,gamest,round ,    score_6 "
'	fldnm = fldnm & " ,per_1,per_2,per_3,per_4,per_5 ,score_total2 ,        a.pubcode, a.midval "
'	SQL = "Select "&fldnm&" from "&tblnm&" where a.gametitleidx = " & tidx & " and a.delYN = 'N' and a.gamekey3 = '"&find_gbidx&"' and round = 1 and a.gubun < 100 order by a.tryoutsortno,a.tryoutgroupno, a.pubcode, a.orgpubcode asc"
'	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
'
'	If Not rs.EOF Then
'		arrZ = rs.GetRows()
'	End If
'	rs.close


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
				<td style="width:100px;"><%=CDbl(attno) + CDbl(r_a7)%></td>

				<%If sel_orderType = "MM" then%>
				<td ><%=r_hh&":"&r_mm%></td>
				<%End if%>


				<td><a href="javascript:mx.changeBoo(<%=idx%>,1)"><%=r_a10%></a></td>
				<td  ><a href="javascript:mx.changeWindow(<%=idx%>,1)"><%=r_a4%></a></td><!-- <span class="glyphicon glyphicon-refresh"></span> -->
				<td  ><a href="javascript:mx.changeWindow(<%=idx%>,2)"><%=r_b2%></a></td><%'말명%>
				<td ><%=r_a9%></td>
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




		  </tr>
<%
		pre_gameno = r_a2
		pre_gameday = r_a9
		pre_booorder = r_booorder
		Next
	End if
%>

