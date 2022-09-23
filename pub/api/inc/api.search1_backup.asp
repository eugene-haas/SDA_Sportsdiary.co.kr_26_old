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
        <li><a class="btn btn-primary btn-look full">3</a><p>심판승인완료</p></li>
        <li><a class="btn btn-danger btn-look handy">4</a><p>양측부전패(불참)</p></li>
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

				Function roundrowcnt(ByVal roundno, ByVal nowroundno)
					Dim rndrow
					rndrow = FIX(CDbl(roundno ) / 2)

					For r = 1 To nowroundno
						rndrow = FIX(rndrow / 2 )
					next
					roundrowcnt = rndrow
				End Function 


				Select Case roundno
				Case 4 : rndcnt = 1
				Case 8 : rndcnt = 2
				Case 16 : rndcnt = 3
				Case 32 : rndcnt = 4
				Case 64 : rndcnt = 5
				Case 128 : rndcnt = 6
				Case 256 : rndcnt = 7
				End Select

				
				
				for i = 1 to datalen + 1  '부전위치저장
					If ojson.Get(i - 1).ANM = "부전" Then
						If i Mod 2 = 1 Then '홀
							imsiplayerno = imsiplayerno & ","  & Fix(CDbl(i + 1) /2)		'1강 그래프 
							bujunno = bujunno & ","  & CDbl(i + 1)								'부전이있는 팀
						Else '짝
							imsiplayerno = imsiplayerno & ","  & Fix(CDbl(i) /2)			'1강그래프
							bujunno = bujunno & ","  & CDbl(i - 1)								'부전이있는 팀
						End if
					End if
				Next
				imsiplayerno = Mid(imsiplayerno,2)
				bujunno = Mid(bujunno,2)


				'각라운드 올라간 번호를 배열화해두자



				leftmembercnt = FIX(CDbl(datalen + 1) / 2)
				for i = 0 to leftmembercnt -1
				'For i = 0 To 1

					mem1idx = ojson.Get(i).AID
					aname = ojson.Get(i).ANM
					bname = ojson.Get(i).BNM

					'groupno = ojson.Get(i).GNO
					col = ojson.Get(i).CO
					row = ojson.Get(i).RO

					ateamA = ojson.Get(i).ATANM
					ateamB = ojson.Get(i).ATBNM
					bteamA = ojson.Get(i).ATBNM
					bteamB = ojson.Get(i).ATBNM
					postionno = ojson.Get(i).PNO  ' 파트너의 시작위치 정보 
					%>
				 
				 <%
				 drowbujunclass = "team-match clearfix"
				 
				 'If aname <> "부전"  Then

					bujunnochk = Split(bujunno,",")
					For n = 0 To ubound(bujunnochk)
						If Cdbl(bujunnochk(n)) = CDbl(i + 1) Then
							drowbujunclass = "no-match"
						Exit for
						End If
					Next						 
				 %>
					<div class="match">
						<div class="<%=drowbujunclass%>">
							<div class="player-info clearfix"> 
							<span class="player-name"><%=aname%></span>
							<span class="player-school"><%=ateamA%>,<%=ateamB%></span>
							</div>
							<div class="player-info clearfix"> 
							<span class="player-name"><%=bname%></span>
							<span class="player-school"><%=bteamA%>,<%=bteamB%></span>
							</div>
						</div>
					</div>
				
				<%
					'End if
				Next
				%>

			</div>
			<!-- E: match-list -->

			<%For i = 1 To rndcnt%>
					<div id="round_0<%=i%>_left" class="round-<%=i%>">
						<%
						rcnt = roundrowcnt(roundno , i)
						For r = 1 To  rcnt
						%>

							<%
							If i = 1 then

								imsichk = Split(imsiplayerno,",")
								For n = 0 To ubound(imsichk)
									If Cdbl(imsichk(n))  = CDbl(r) Then
										drowimsi = true
									Exit for
									End If
								Next

							End if
							%>
							<%If drowimsi = True then%>
								<div class="line-div"> <img src="images/tournerment/01_L_center.png" alt=""></div>
								<%drowimsi = false%>
							<%else%>
								<div class="line-div">
								<img src="images/tournerment/0<%=i%>_L_bottom.png" alt="">
									<a onClick="javascript:score.showScore();" data-toggle="modal" role="button" class="btn btn-danger btn-look time-out">1.</a><%'=imsiplayerno%>
								</div>
							<%End If
							%>					
					
						<%
						Next%>
					</div>
			<%next%>

			
			<!-- S: final-match -->
			<div class="final-match">
				<div id="final_div" class="final-div">
					<div class="line-div"><a onClick="editscore(this)" role="button" class="final-match-box winner" data-id="44" data-toggle="modal">
					<p><span class="final-player">오상우</span> 승</p>
					<!--<p><span>승(절반)</span>(1)<i class='fa fa-plus' aria-hidden='true'></i></p>-->
					</a> <img src="images/tournerment/<%=CDbl(rndcnt) + 2%>_win_R.png" alt=""> <a onClick="editscore(this)" data-toggle="modal" data-id="44" data-whatever="06" role="button" class="btn btn-danger btn-look time-out">44.</a></div>
				</div>
			</div>
			<!-- E: final-match -->



		</div>
		<!-- E: left-side -->


		<%'#######################################################################################%>


		<!-- S: right-side -->
		<div class="right-side">
			
			<!-- S: match-list -->
			<div id="match_list_right" class="match-list">
				<%
				for i = leftmembercnt  to datalen 
				'For i = 2 To 3
					mem1idx = ojson.Get(i).AID
					aname = ojson.Get(i).ANM
					bname = ojson.Get(i).BNM
					'groupno = ojson.Get(i).GNO
					col = ojson.Get(i).CO
					row = ojson.Get(i).RO
					ateamA = ojson.Get(i).ATANM
					ateamB = ojson.Get(i).ATBNM
					bteamA = ojson.Get(i).ATBNM
					bteamB = ojson.Get(i).ATBNM
					positionno = ojson.Get(i).PNO  ' 파트너의 시작위치 정보 
					%>				
				  

				 <%
				 drowbujunclass = "team-match clearfix"
				 
				 'If aname <> "부전"  Then

					bujunnochk = Split(bujunno,",")
					For n = 0 To ubound(bujunnochk)
						If Cdbl(bujunnochk(n)) = CDbl(i + 1) Then
							drowbujunclass = "no-match"
						Exit for
						End If
					Next						 
				 %>
				  <div class="match">
						<div class="<%=drowbujunclass%>">
						<div class="player-info clearfix"> 
						  <span class="player-name"><%=aname%></span>
						  <span class="player-school"><%=ateamA%>,<%=ateamB%></span>
						</div>
						<div class="player-info clearfix">
						  <span class="player-name"><%=bname%></span>
						  <span class="player-school"><%=bteamA%>,<%=bteamB%></span>
						</div>
						</div>
				  </div>
				  <%
				  'End if			
				Next
				%>

			</div>
			<!-- E: match-list -->

			<%For i = 1 To rndcnt%>
					<div id="round_0<%=i%>_right" class="round-<%=i%>">
						<%
						drowimsi = false
						rcnt = roundrowcnt(roundno , i)
						For r = 1 To  rcnt%>

							<%
							If i = 1 then

								imsichk = Split(imsiplayerno,",")
								For n = 0 To ubound(imsichk)
									If Cdbl(imsichk(n)) - rcnt = CDbl(r) Then
										drowimsi = true
									Exit for
									End If
								Next

							End if
							%>
							<%If drowimsi = True then%>
								<div class="line-div"> <img src="images/tournerment/01_R_center.png" alt=""></div>
								<%drowimsi = false%>
							<%else%>
								<div class="line-div">
								<img src="images/tournerment/0<%=i%>_R_bottom.png" alt="">
									<a onClick="javascript:score.showScore();" data-toggle="modal" role="button" class="btn btn-danger btn-look time-out">1.</a>
								</div>
							<%End If
							%>

					<%Next%>
					</div>
			<%next%>
		</div>
		<!-- E: right-side -->


	<!-- E: include tennis-tourney -->
	</div>
	<!-- E: tourney-->

	
<%End if%>
