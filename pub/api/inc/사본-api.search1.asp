    <%If tabletype ="1" then%>
      <!-- S: color-guide -->
      <section class="color-guide" id="DP_Guide">
      <h2>각 색상별 기능을 참고하시기 바랍니다.</h2>
      <ul class="guide-cont">
        <!--
        <li>
        <a class="btn btn-primary btn-look">1</a>
        <p>입력대기</p>
        </li>
        
        <li>
        <a class="btn btn-danger btn-look time-out">2</a>
        <p>선수등록</p>
        </li>
        -->
        <li><a class="btn btn-danger btn-look time-in">1</a><p>경기중</p></li>
        <li><a class="btn btn-danger btn-look time-out">2</a><p>경기종료</p></li>
        <!-- <li><a class="btn btn-primary btn-look full">3</a><p>심판승인완료</p></li> -->
        <li><a class="btn btn-danger btn-look handy">3</a><p>양측부전패(불참)</p></li>
      </ul>
      </section>
      <!-- E: color-guide -->
    <%End if%>



	  <div class="preli">
		<!-- S: btn-list -->
		<ul class="btn-list">
		  <li>
		  <a href="javascript:score.gameSearch(<%=CDbl(tabletype) -1%>)" class="btn btn-round-type">예선</a>
		  </li>
		  <li>
		  <a href="javascript:score.gameSearch(<%=tabletype%>)" class="btn btn-round-type on">본선</a>
		  </li>
		</ul>
		<!-- E: btn-list -->
 
   
   <%If tabletype = "1" Or tabletype="21" Then '#################################################################%>

	<%
	'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	'다음 부전 라운드 추가
	sub setNextRoundIn(ByVal idx , ByVal rd, ByVal sortno, ByVal intype) '대진맴버인덱스, 라운드번호, 승자위치, 홀수소팅번호 체크할 조건절
		Dim insertfield, selectfield,selectSQL,SQL, rs,nextRound,midx,nextSortNo,chkwhere
		nextRound = CDbl(rd) + 1 '최종라운드여부 확인
		If CDbl(sortno) = 0 Then
			SQL = "Select sortNo from sd_TennisMember where gameMemberIDX = " & idx
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			sortno = rs(0)
			If CDbl(sortno) Mod 2 = 1 Then
				sortno = CDbl(sortno) +1
			End if
			nextSortNo = Fix(CDbl(sortno) /2) 
		else
			nextSortNo = Fix(CDbl(sortno) /2) 
		End if

		'있는지 확인해보자
		chkwhere = " GameTitleIDX = " & gameidx & " and  gamekey3 = " & strs3  

		If intype = "부전" then		
		SQL = "Select sortno from sd_TennisMember where PlayerIDX = 0 and " & chkwhere & " and Round = " & nextRound & " and sortNo = " & nextSortNo
		Else
		SQL = "Select sortno from sd_TennisMember where " & chkwhere & " and Round = " & nextRound & " and sortNo = " & nextSortNo
		End if
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


		If rs.eof Then 	'없다면
			insertfield = " gubun,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,key3name,Round,SortNo "
			
			If intype = "부전" then
				selectfield = "  2,GameTitleIDX,0,'부전',gamekey1,gamekey2,gamekey3,TeamGb,'','',key3name,"&nextRound&","&nextSortNo&"  "
			else
				selectfield = "  2,GameTitleIDX,PlayerIDX,userName,gamekey1,gamekey2,gamekey3,TeamGb,TeamANa,TeamBNa,key3name,"&nextRound&","&nextSortNo&"  "
			End if
			
			selectSQL = "Select top 1 "&selectfield&"  from sd_TennisMember where gameMemberIDX = " & idx

			SQL = "SET NOCOUNT ON  insert into sd_TennisMember ("&insertfield&")  "&selectSQL&" SELECT @@IDENTITY"

			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			midx = rs(0)

			'파트너 insert
			insertfield  = " gameMemberIDX,PlayerIDX,userName,TeamANa,TeamBNa "

			If intype = "부전" then			
				selectfield =  " "&midx&",0,'부전','','' "
			else
				selectfield =  " "&midx&",PlayerIDX,userName,TeamANa,TeamBNa "
			End if

			
			SQL = "insert into sd_TennisMember_partner ("&insertfield&")  select top 1 " & selectfield & " from sd_TennisMember_partner where gameMemberIDX = " & idx
			Call db.execSQLRs(SQL , null, ConStr)
		End if
	End sub
	
	'$$$$$$$$$$$$$$$
	Sub tournState(ByVal ridx, ByVal p1idx, ByVal p2idx, ByVal p1name, ByVal p2name,ByVal pos,ByVal row, ByVal startcnt, ByVal laststate , ByVal win ,ByVal gameround,ByVal p1pidx,ByVal p2pidx, ByVal sortno)

		Dim winpos, finalimg,finalidx,winname,btnst,winstr,makecount,k

		k = sortno

		If Fix(sortno /2) = 1 Then
			sortno = CDbl(sortno) + 1
		End if
		sortno = Fix(sortno /2 )

		
		winpos = "" '비김 (양쪽패) 등등
		btnst = "in"

		If p1idx ="" Or p2idx = "" Then 

			If pos = "M" Then '최종라운드라면
				%>
				<img src="images/tournerment/0<%=row%>_final.png" alt=""><!-- <a href="javascript:alert('전라운드가 결과가 나오지 않았습니다.');"  class="btn btn-danger btn-look ready"><%=sortno%></a> -->
				<%
			Else
				If p1idx = ""  and p2idx = "" Then
					%><img src="images/tournerment/0<%=row%>_<%=pos%>_basic.png"><%
				else
					%><img src="images/tournerment/0<%=row%>_<%=pos%>_basic.png"><%
					%><a href="javascript:alert('전라운드가 결과가 나오지 않았습니다.');" class="btn btn-danger btn-look ready" ><%=sortno%><%'=Fix(startcnt/2+1)%></a><%
				End if
			End If
		Else


				If p1name = "부전" Or p2name = "부전"   then
					If (p1name = "부전" and p2name = "부전")   Then'모두부전인경우 처리
						%><img src="images/tournerment/0<%=row%>_<%=pos%>_basic.png"><%

						'2라운드이상이라면 부전 인서트 해주기
						If CDbl(row) >=2 Then
							Call setNextRoundIn(p1idx, row,  0, "부전") '대진맴버인덱스, 라운드번호,  짝수소팅번호
						End if

					Else '한쪽만 부전인경우
							if p1name = "부전"  then
								%><img src="images/tournerment/0<%=row%>_<%=pos%>_bottom.png"><%
								
								'2라운드이상이라면 부전상대자로 이긴사람 인서트 해주기
								If CDbl(row) >=2 Then
									Call setNextRoundIn(p2idx, row,  0, "선수") 
								End If
								
							Else
								%><img src="images/tournerment/0<%=row%>_<%=pos%>_top.png"><%
								If CDbl(row) >=2 Then
									Call setNextRoundIn(p1idx, row,  0,"선수") 
									End if
							End If

							%><a href="javascript:alert('부전승');" class="btn btn-danger btn-look time-out" ><%=sortno%><%'=Fix(startcnt/2+1)%></a><%
					End If

				Else

					If pos = "M" Then '최종라운드라면
					
						Select Case win
						Case "left" 
						winpos = "L"
						winname = p1name
						Case "right" 
						winpos = "R"
						winname = p2name
						End Select 			
						Select Case CDbl(laststate)
						Case 1 '종료
							finalimg = CDbl(row  + 1) & "_win_" & winpos
							finalidx = ridx
							btnst = "time-out"
						Case 2'진행중
							finalimg = "0"& row &"_final"
							finalidx = ridx
							btnst = "time-in"
						Case 0'진행전
							finalimg = "0"& row &"_final"
							finalidx = 0
							btnst = " ready"
						End Select 
						%>
						<%If laststate = "1" Then
						SQL = "select a.userName , b.userName from sd_TennisMember as a INNER JOIN sd_TennisMember_partner as b ON a.gameMemberIDX = b.gameMemberIDX where a.gameMemberIDX = " & p1idx
						Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
						%>
						<a role="button" class="final-match-box winner" data-id="44" data-toggle="modal">
						<p><span class="final-player"><%=rs(0) & " " & rs(1)%></span> 승</p></a>
						<%End if%>
						<img src="images/tournerment/<%=finalimg%>.png">
						
							<%If laststate = "1" then%>
							<a href="javascript:score.showScore({'SCIDX':<%=ridx%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':1,'JONO':0});" class="btn btn-danger btn-look time-out" ><%=sortno%><%'=Fix(startcnt/2+1)%></a>
							<%else%>
							<a href="javascript:score.inputMainScore({'SCIDX':<%=finalidx%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':1,'JONO':0,'RD':<%=row%>,'GRND':<%=gameround%>,'SNO':<%=sortno%>});" class="btn btn-danger btn-look <%=btnst%>"><%=sortno%><%'=Fix(startcnt/2+1)%></a>			
							<%End if%>
						<%
					else
							Select Case CDbl(laststate)
							Case 1 '종료
								Select Case win
								Case "left"
								 winpos = "top"
								 winstr = "▲"
								Case "right"
								winpos = "bottom"
								 winstr = "▼"
								Case "tie"
								winpos = "basic"
								winstr = "부전"

								End Select 
							%>
							<img src="images/tournerment/0<%=row%>_<%=pos%>_<%=winpos%>.png"><%'=winstr%><%'=winpos%>
							<a href="javascript:score.showScore({'SCIDX':<%=ridx%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':1,'JONO':0});" class="btn btn-danger btn-look time-out" ><%=sortno%><%'=Fix(startcnt/2+1)%></a>
							<%
							Case 2 '진행중
							%>
							<img src="images/tournerment/0<%=row%>_<%=pos%>_basic.png">
							<a href="javascript:score.inputMainScore({'SCIDX':<%=ridx%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':1,'JONO':0,'RD':<%=row%>,'GRND':<%=gameround%>,'SNO':<%=sortno%>});" class="btn btn-danger btn-look time-in"><%=sortno%><%'=Fix(startcnt/2+1)%></a>
							<%
							Case "", 0 '진행전
							%>
							<img src="images/tournerment/0<%=row%>_<%=pos%>_basic.png">				
							<a href="javascript:score.inputMainScore({'SCIDX':<%If laststate = "" then%>0<%else%><%=ridx%><%End if%>,'P1':<%=p1idx%>,P2:<%=p2idx%>,'GN':1,'JONO':0,'RD':<%=row%>,'GRND':<%=gameround%>,'SNO':<%=sortno%>});" class="btn btn-danger btn-look ready"><%=sortno%><%'=Fix(startcnt/2+1)%></a>
							<%
							End select
					End If

				End if
	
		End if
	End Sub



	Function roundrowcnt(ByVal roundno, ByVal nowroundno)
		Dim rndrow
		rndrow = FIX(CDbl(roundno ) / 2)

		For r = 1 To nowroundno
			rndrow = FIX(rndrow / 2 )
		next
		roundrowcnt = rndrow
	End Function 	


	Function roundinfofind(ByVal p1)
		Dim row, col,midx1,midx2,ridx,stateno,laststate,resultidx,winresult,win

		'라운드 상태와 인덱스 찾기 펑션
		If IsArray(arrRS) Then
		For ar = LBound(arrRS, 2) To UBound(arrRS, 2) '***결과들어간 애들만있슴****
			row = arrRS(0, ar)  '행 라운드
			col =  arrRS(1, ar)  '열
			midx1 = arrRS(2, ar)  '기준 선수1
			midx2 = arrRS(3, ar)  '기준 선수2
			ridx = arrRS(4, ar)  '결과 인덱스
			stateno = arrRS(5, ar) '게임상태 (0진행전,  2, 진행 , 1, 종료)
			winresult = arrRS(6, ar)  'left right (top bottom) tie
		
			If p1 <> "" then
			If CDbl(midx1) = CDbl(p1) Then
				win= winresult
				laststate = stateno ' 0 진행전 1 종료 2 진행중
				resultidx = ridx

				'If row = 2 then
				'Response.write "<br>"&ridx & "-" &win & "<br>"
				'End If
				
				Exit for
			End If
			End if
		Next
		End if
		roundinfofind = array(laststate, resultidx, win)
	End Function


	
	'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	'****************	
	If tabletype = "1" Then
		
		'1라운드 부전대진표 처리
		'조건 1라운드에 부전자가 쌍으로 있는 경우 2라운드에 부전자생성 
		'생성 여부 판단해서 1회만 되도록 처리
		strwhere = " GameTitleIDX = " & gameidx & " and  gamekey3 = " & strs3  & " and gubun = "&checkgubun&" and Round = 1 " 'gubun  0예선 1예선종료 2 본선대기 3 본선입력완료 4 본선종료 ...
		strsort = " order by SortNo asc"
		strfield = " gamememberIDX, playerIDX, userName, SortNo  "
		SQL = "select "& strfield &" from  sd_TennisMember  where " & strwhere & strsort

		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrTmp = rs.GetRows() 'RIDX, CIDX, GSTATE
		End if
	

		If IsArray(arrTmp) Then '결과값
	
			'chkflag = False
			topok = False
			bottomok = False			
			For tarr = LBound(arrTmp, 2) To UBound(arrTmp, 2) '2라운드부터 대진표

				m_idx = arrTmp(0, tarr)  '기준선수
				m_pidx = arrTmp(1, tarr) '플레이어 인덱스 0체크
				m_name = arrTmp(2, tarr)
				m_sortno = arrTmp(3,tarr) '플레이어인덱스 부전자 0

				If CDbl(m_sortno) Mod 2 = 1 Then '홀수열
					topidx = m_idx
					topsort = m_sortno
					If  CDbl(m_pidx) = 0 Then '홀수 부전
						topok = true
					End if
				Else '짝수열
					bottomidx = m_idx
					bottomsort = m_sortno
					If  CDbl(m_pidx) = 0 Then '짝수 부전
						bottomok = true
					End if
				End if

				'짝수 열에 초기화
				'Response.write topok & "-" & bottomok&"<br>"
				
				If CDbl(m_sortno) Mod 2 = 0 Then
					If topok = True And bottomok = True Then '양쪽부전
						Call setNextRoundIn(bottomidx, 1,  bottomsort, "부전") '대진맴버인덱스, 라운드번호,  짝수소팅번호
					End If
					If topok = false And bottomok = True Then '짝부전
						Call setNextRoundIn(topidx, 1,  0, "선수") 
					End If
					If topok = True And bottomok = False Then '홀부전
						Call setNextRoundIn(bottomidx, 1,  0, "선수") 
					End if					
					
					
					topok = False
					bottomok = False
				End if



'				If  CDbl(m_pidx) = 0 Then '부전이라면
'
'					If CDbl(m_sortno) Mod 2 = 1 Then '홀수열
'						'Response.write m_sortno& "<br>"
'						chkflag = true
'					End If
'					
'					If chkflag = True  Then
'						If  CDbl(m_sortno) Mod 2 = 0  Then '모두 부전인경우
'								Call setNextRoundIn(m_idx, 1,  m_sortno, "부전") '대진맴버인덱스, 라운드번호,  짝수소팅번호
'								chkflag = False
'						Else '홀수열 부전
'						
'						End If
'					Else
'						If  CDbl(m_sortno) Mod 2 = 0  Then '짝수열 부전 
'						End if
'					End if
'				Else
'					chkflag = false				
'				End If
				




			Next

		End If
	
	End if
	'****************
	%>
	








	
	<!-- S: tourney-->
	<div class="tourney clearfix">
	<!-- S: include tennis-tourney -->

		<!-- S: left-side -->
		<div class="left-side clearfix">

			<!-- S: match-list -->
			<div id="match_list_left" class="match-list">

				<%
				'rndcnt = array(3,5,7,9,11,13,15,17,19,21)
				roundno  = datalen + 1 '몇강인지
				harfno = roundno / 2

				Select Case roundno
					Case 4 : rndcnt = 1
					Case 8 : rndcnt = 2
					Case 9,10,11,12,13,14,15,    16 
						 rndcnt = 3
						tempmembercnt = 16 -  roundno

					Case 32 : rndcnt = 4
					Case 64 : rndcnt = 5
					Case 128 : rndcnt = 6
					Case 256 : rndcnt = 7
				End Select

				'################################
				leftmembercnt = FIX(CDbl(datalen + 1) / 2)

				for i = 0 to leftmembercnt -1
					mem1idx = ojson.Get(i).AID
					aname = ojson.Get(i).ANM
					bname = ojson.Get(i).BNM
					col = ojson.Get(i).CO
					row = ojson.Get(i).RO

					ateamA = ojson.Get(i).ATANM
					ateamB = ojson.Get(i).ATBNM
					bteamA = ojson.Get(i).ATBNM
					bteamB = ojson.Get(i).ATBNM
					postionno = ojson.Get(i).PNO  ' 파트너의 시작위치 정보 
					%>
				  <div class="match <%If aname = "부전"  Then%>no-player<%End if%>">
						<div class="team-match clearfix">
							<div class="player-info clearfix"> 
							  <span class="player-name"><%If aname <> "부전"  Then%><%=aname%><%else%>부전<%End if%></span>
							  <span class="player-school"><%If aname <> "부전"  Then%><%=ateamA%>,<%=ateamB%><%End if%></span>
							</div>
							<div class="player-info clearfix">
							  <span class="player-name"><%If aname <> "부전"  Then%><%=bname%><%End if%></span>
							  <span class="player-school"><%If aname <> "부전"  Then%><%=bteamA%>,<%=bteamB%><%End if%></span>
							</div>						
						</div>
				  </div>
				<%
				Next
				%>
			</div>

		<%
		'################
		'왼쪽
		'################
		%>
			<!-- E: match-list  왼쪽-->

			<%For i = 1 To rndcnt%>
					<div id="round_0<%=i%>_left" class="round-<%=i%>">
						<%
						rcnt = roundrowcnt(roundno , i)

						'2라운드 부터 ~
						scnt = i						
						laststate = "" '0이진행전 이므로 "" 공백으로
						resultidx = 0
						win = ""
						
						For r = 1 To  rcnt '라운드 카운트(그려질 선갯수)%>
								<div class="line-div">
									<%
										If i = 1 Then '1라운드 정보
												p1 = ojson.Get(CDbl(scnt-1)).AID
												p2 = ojson.Get(CDbl(scnt)).AID
												p1name = ojson.Get(CDbl(scnt)-1).ANM
												p2name = ojson.Get(CDbl(scnt)).ANM
												sortno =  ojson.Get(CDbl(scnt)).RO
												'라운드 상태와 인덱스 찾기
												arrinfo = roundinfofind(p1)
												laststate = arrinfo(0)
												resultidx = arrinfo(1)
												win = arrinfo(2)
												tn_sortno = sortno
										
										Else
											If IsArray(arrRS2) Then '결과값
												For ar2 = LBound(arrRS2, 2) To UBound(arrRS2, 2) '2라운드부터 대진표
													pidx = arrRS2(0, ar2)  '기준선수
													rows = arrRS2(1, ar2)  'round = i
													sortno = arrRS2(2, ar2)  'rcnt 로 구분 1 = 1,2     2 = 3,4    3 = 5,6  4= 7,8
													playeridx = arrRS2(3,ar2)  '플레이어인덱스 부전자 0




													'각열에 있는 두명을  올라가 있는지 확인
													If CDbl(sortno Mod 2 ) = 1 Then
														chkr =  Fix( CDbl(sortno  + 1) /2 ) '두명씩이니까
													Else
														chkr =  Fix( CDbl(sortno) /2 )  
													End If

													If CDbl(rows) = i  Then '같은라운드에서
															If  r = chkr And  CDbl(sortno Mod 2 ) = 1 Then '홀수열
																p1 = pidx '맴버인덱스
																p1pidx = playeridx
																tn_sortno = sortno
															End If

															If r= chkr And CDbl(sortno Mod 2 ) = 0 Then 
																p2 = pidx
																p2pidx = playeridx
																tn_sortno = sortno
															End If
													End if
													
												Next

												If p1 = "" And p2 = "" Then
													'p1pidx = "머지"
													'입력 표시 그림 하지만 클릭시 입력이 될지 말지 가서 결정해주자.  결과가 안나온 것이면 입력되지 않도록 후처리 요망
												else
														p1name = ""
														p2name = ""
														'라운드 상태와 인덱스 찾기
														arrinfo = roundinfofind(p1)
														laststate = arrinfo(0)
														resultidx = arrinfo(1)
														win = arrinfo(2)
												End if

											End If

										End if

									'라인 및 입력 버튼
									Call tournState(resultidx, p1, p2, p1name, p2name, "L", i, scnt , laststate, win, roundno ,p1pidx,p2pidx,tn_sortno)
									%>
								</div>
						<%
							p1pidx = ""
							p2pidx = ""
							p1 = ""
							p2 = ""
							tn_sortno = 0
							resultidx = ""
							scnt = scnt + 2 '두팀씩
							laststate = ""
							win = ""
						Next
						%>
					</div>
			<%next%>

			







		<%
		'leftmembercnt
		'################
		'중앙 최종라운드 선수
		'################
		cnterroundno = CDbl(rndcnt) + 1

		If IsArray(arrRS2) Then

			For ar2 = LBound(arrRS2, 2) To UBound(arrRS2, 2) '2라운드부터 대진표
				pidx = arrRS2(0, ar2)  '기준선수
				rows = arrRS2(1, ar2)  'round = i
				sortno = arrRS2(2, ar2)  'rcnt 로 구분 1 = 1,2     2 = 3,4    3 = 5,6  4= 7,8
				playeridx = arrRS2(3,ar2)  '플레이어인덱스 부전자 0


					'각열에 있는 두명을  올라가 있는지 확인
					If CDbl(sortno Mod 2 ) = 1 Then
						chkr = sortno + 1
					Else
						chkr = sortno
					End If

					If CDbl(rows) = cnterroundno  Then 
						If CDbl(sortno) = 1 Then '왼쪽맴법뺀만큼부터시작
							p1 = pidx '맴버인덱스
							p1pidx = playeridx
						End If

						If CDbl(sortno) = 2 then
							p2 = pidx
							p2pidx = playeridx
						End If
					End if
				
			Next

			If p1 = "" And p2 = "" Then
				'입력 표시 그림 하지만 클릭시 입력이 될지 말지 가서 결정해주자.  결과가 안나온 것이면 입력되지 않도록 후처리 요망
			else
					p1name = ""
					p2name = ""
					'라운드 상태와 인덱스 찾기
					arrinfo = roundinfofind(p1)
					laststate = arrinfo(0)
					resultidx = arrinfo(1)
					win = arrinfo(2)
			End if

		End If
		%>

			<!-- S: final-match -->
			<div class="final-match" ><!-- style="background:green;"> -->
				<div id="final_div" class="final-div">
					<div class="line-div"><%'=cnterroundno%>
					<%
					If scnt <> "" then
					Call tournState(resultidx, p1, p2, p1name, p2name, "M", i, scnt , laststate, win, roundno ,p1pidx,p2pidx, 2)
					End if
					%>
					</div>

				</div>
			</div>
			<!-- E: final-match -->

		</div>
		<!-- E: left-side -->














		<%
		'################
		'오른쪽
		'################
		%>
		<!-- S: right-side -->
		<div class="right-side">
			
			<!-- S: match-list -->
			<div id="match_list_right" class="match-list">
				<%
				for i = leftmembercnt  to datalen 
					mem1idx = ojson.Get(i).AID
					aname = ojson.Get(i).ANM
					bname = ojson.Get(i).BNM
					col = ojson.Get(i).CO
					row = ojson.Get(i).RO
					ateamA = ojson.Get(i).ATANM
					ateamB = ojson.Get(i).ATBNM
					bteamA = ojson.Get(i).ATBNM
					bteamB = ojson.Get(i).ATBNM
					positionno = ojson.Get(i).PNO  ' 파트너의 시작위치 정보 
				 %>
				  <div class="match <%If aname = "부전"  Then%>no-player<%End if%>">
						<div class="team-match clearfix">
							<div class="player-info clearfix"> 
							  <span class="player-name"><%If aname <> "부전"  Then%><%=aname%><%else%>부전<%End if%></span>
							  <span class="player-school"><%If aname <> "부전"  Then%><%=ateamA%>,<%=ateamB%><%End if%></span>
							</div>
							<div class="player-info clearfix">
							  <span class="player-name"><%If aname <> "부전"  Then%><%=bname%><%End if%></span>
							  <span class="player-school"><%If aname <> "부전"  Then%><%=bteamA%>,<%=bteamB%><%End if%></span>
							</div>						
						</div>
				  </div>
				<%
				Next
				%>
			</div>
			<!-- E: match-list -->

			<%
			For i = 1 To rndcnt%>
					<div id="round_0<%=i%>_right" class="round-<%=i%>">
						<%
						rcnt = roundrowcnt(roundno , i)

						'2라운드 부터 ~
						scnt = leftmembercnt		'왼쪽명수				
						laststate = ""
						resultidx = 0
						win = ""
						startnum = fix( (CDbl(scnt) / i + 1)  ) -1
						'Response.write startnum
						For r = 1 To  rcnt '선수는 rcnt * 2
						%>

								<div class="line-div">
									<%
										If i = 1 Then '1라운드

										p1 = ojson.Get(CDbl(scnt)).AID
										p2 = ojson.Get(CDbl(scnt)+1).AID
										p1name = ojson.Get(CDbl(scnt)).ANM
										p2name = ojson.Get(CDbl(scnt)+1).ANM
										sortno = ojson.Get(CDbl(scnt+1)).RO

												'라운드 상태와 인덱스 찾기
												arrinfo = roundinfofind(p1)
												laststate = arrinfo(0)
												resultidx = arrinfo(1)
												win = arrinfo(2)
												tn_sortno = sortno
												'Response.write  "----------"& sortno
										Else


											If IsArray(arrRS2) Then

												'For ar2 = LBound(arrRS2, 2) To UBound(arrRS2, 2) '2라운드부터 대진표 (대진자 두명을 뽑아)
												For ar2 = startnum To UBound(arrRS2, 2) '2라운드부터 대진표 (대진자 두명을 뽑아)
													pidx = arrRS2(0, ar2)  '기준선수
													rows = arrRS2(1, ar2)  'round = i
													sortno = arrRS2(2, ar2)  'rcnt 로 구분 1 = 1,2     2 = 3,4    3 = 5,6  4= 7,8
													playeridx = arrRS2(3,ar2)  '플레이어인덱스 부전자 0


													'각열에 있는 두명을  올라가 있는지 확인
													If CDbl(sortno Mod 2 ) = 1 Then
														chkr =  Fix( CDbl(sortno - startnum + 1) /2 )
													Else
														chkr =  Fix( CDbl(sortno - startnum) /2 )  
													End If

													If CDbl(rows) = i  Then '같은라운드에서
															If  r = chkr And  CDbl(sortno Mod 2 ) = 1 Then '홀수열
																p1 = pidx '맴버인덱스
																p1pidx = playeridx
																tn_sortno = sortno
															End If

															If r= chkr And CDbl(sortno Mod 2 ) = 0 Then 
																p2 = pidx
																p2pidx = playeridx
																tn_sortno = sortno
															End If
													End if

												Next

												If p1 = "" And p2 = "" Then
													'입력 표시 그림 하지만 클릭시 입력이 될지 말지 가서 결정해주자.  결과가 안나온 것이면 입력되지 않도록 후처리 요망
												else
														p1name = ""
														p2name = ""
														'라운드 상태와 인덱스 찾기
														arrinfo = roundinfofind(p1)
														laststate = arrinfo(0)
														resultidx = arrinfo(1)
														win = arrinfo(2)
												End if

											End If
											

										End if

									'라인 및 입력 버튼
									Call tournState(resultidx, p1, p2, p1name, p2name, "R", i, scnt , laststate ,win ,roundno,p1pidx,p2pidx,tn_sortno)
									%>
								</div>

							<%
							p1pidx = ""
							p2pidx = ""
							p1 = ""
							p2 = ""
							tn_sortno = 0
							resultidx = ""
							scnt = scnt + 2 '두팀씩
							laststate = ""
							win = ""
						Next
						%>
					</div>
			<%
			Next
			%>
		</div>
		<!-- E: right-side -->


	<!-- E: include tennis-tourney -->
	</div>
	<!-- E: tourney-->

	
<%End if%>