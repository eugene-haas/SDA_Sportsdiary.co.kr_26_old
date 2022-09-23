    <%If tabletype ="2" then%>
		  <!-- S: color-guide -->
		  <section class="color-guide" id="DP_Guide">
		  <h2>각 색상별 기능을 참고하시기 바랍니다.</h2>
		  <ul class="guide-cont">
			<li>
			<a class="btn btn-danger btn-look time-in">1</a>
			<p>경기중</p>
			</li>
			<li>
			<a class="btn btn-danger btn-look time-out">2</a>
			<p>경기종료</p>
			</li>
			<!-- <li>
			<a class="btn btn-primary btn-look full">3</a>
			<p>심판승인완료</p>
			</li> -->
			<li>
			<a class="btn btn-danger btn-look handy">3</a>
			<p>양측부전패(불참)</p>
			</li>
		  </ul>
		  </section>
		  <!-- E: color-guide -->
    <%End if%>


		<div class="preli">
		  <!-- S: btn-list -->
		  <ul class="btn-list">
			<li>
			<a href="javascript:score.gameSearch(<%=CDbl(tabletype) -2%>)" class="btn btn-round-type on">예선</a>
			</li>
			<li>
			<a href="javascript:score.gameSearch(<%=CDbl(tabletype) -1%>)" class="btn btn-round-type">본선</a>
			</li>
		  </ul>
		  <!-- E: btn-list -->
		</div>


      <!-- S: preli 리그 -->
      <div class="preli-league">
        <!-- S: include preli-league -->

	  <table>
		<%
		Select Case  CStr(rscnt)
		Case "3" '3명 다 참여
			for i = 0 to datalen + 1 '열
				mem1idx = ojson.Get(i).AID
				aname = ojson.Get(i).ANM
				bname = ojson.Get(i).BNM

				groupno = ojson.Get(i).GNO
				sortno = ojson.Get(i).SNO
				ateamA = ojson.Get(i).ATANM
				ateamB = ojson.Get(i).ATBNM
				bteamA = ojson.Get(i).BTANM
				bteamB = ojson.Get(i).BTBNM
				stateno = ojson.Get(i).STNO

				twin = ojson.Get(i).TWIN
				ttie = ojson.Get(i).TTIE
				tlose = ojson.Get(i).TLOSE
				tresult = ojson.Get(i).TRANK
				%>
				
				<%If i = 0  then%>
					<thead>
						<tr>
						  <th>제<%=groupno%>조</th>
						  <%For x = 0 To 2%>
						  <th>
						  <span class="round"><%=x + 1%></span>
						  <p>
							<span class="player"><%=ojson.Get(x).ANM%></span><span class="belong">(<%=ojson.Get(i).ATANM%>,<%=ojson.Get(i).ATBNM%>)</span>
						  </p>
						 <%If singlegame = False then%> 
						  <p>
							<span class="player"><%=ojson.Get(x).BNM%></span><span class="belong">(<%=ojson.Get(i).BTANM%>,<%=ojson.Get(i).BTBNM%>)</span>
						  </p>
						  <%End if%>
						  </th>
						  <%next%>
						  <th>
						  <p class="tit">승패(점수)</p>
						  </th>
						  <th>
						  <p class="tit">순위</p>
						  </th>
						<tr>
					<thead>
					<tbody>
				<%end if%>			

					<tr>				
					<%For c = 0 To 5%>
						  <%Select Case c
						  Case 0
						  %>
							  <th>
							  <span class="round"><%=groupno%></span>
							  <p>
								<span class="player"><%=ojson.Get(i).ANM%></span>
								<span class="belong">(<%=ojson.Get(i).ATANM%>,<%=ojson.Get(i).ATBNM%>)</span>
							  </p>
							  <%If singlegame = False then%>
							  <p>
								<span class="player"><%=ojson.Get(i).BNM%></span>
								<span class="belong">(<%=ojson.Get(i).BTANM%>,<%=ojson.Get(i).BTBNM%>)</span>
							  </p>
							  <%End if%>
							  </th>
						  <%Case 1,2,3%>
							  <%If c = i + 1 then%>
								  <td>
								  <p class="no-match">
									<img src="./images/tournerment/tourney/cross_line@3x.png" alt width="169" height="99">
								  </p>
								  </td>
							  <%else%>
							  <td>
							  <p class="team">
								<span class="player1"><%=aname%></span>
								<%If singlegame = False then%>,<span class="player2"><%=bname%></span><%End if%>
							  </p>
							  <p class="v-s">vs</p>
							  <p class="team">
								<span class="player3"><%=ojson.Get(c-1).ANM%></span>
								<%If singlegame = False then%>,<span class="player4"><%=ojson.Get(c-1).BNM%></span><%End if%>
							  </p>
	 

							<%
								If IsArray(arrRS) Then

									For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 'RIDX, CIDX, GSTATE
										r_idx = arrRS(0, ar)  '열 기준
										i_idx = arrRS(1, ar)  '인덱스
										c_idx = arrRS(2, ar) '행 대상
										g_state = arrRS(3, ar) '상태   1종료 2 진행
										leftetc = arrRS(4,ar) '양측부전패 체크

										If (CStr(mem1idx) = CStr(r_idx) Or CStr(mem1idx) = CStr(c_idx))   And (CStr(ojson.Get(c-1).AID) = CStr(c_idx) Or CStr(ojson.Get(c-1).AID) = CStr(r_idx))  Then '일치한다면  행과 열이 일치한다면
											inputsc = i_idx
											laststate = g_state
											c_leftetc = leftetc
										Exit for
										Else
											inputsc = 0
											laststate = 0
										End if
									Next
								
								Else
									inputsc = 0
									laststate = 0
								End If 
							%>

							  <%If CDbl(laststate)  = 1 then%>
									<%If i >= c Then '왼쪽 오른쪽 바꿈 아래쪽%>
									<!-- <a href="javascript:score.showScore({'SCIDX':<%=inputsc%>,'P1':'<%=ojson.Get(c-1).AID%>',P2:'<%=mem1idx%>','GN':0,'JONO':<%=groupno%>});" class="btn btn-result" >결과보기</a> -->
									<%else%>
									<a href="javascript:score.showScore({'SCIDX':<%=inputsc%>,'P1':'<%=mem1idx%>',P2:'<%=ojson.Get(c-1).AID%>','GN':0,'JONO':<%=groupno%>});" class="btn btn-<%If CDbl(c_leftetc) > 3 then%>danger<%else%>result<%End if%>" >결과보기</a>
									<%End if%>
							  <%else%>
								    <%If tabletype = "2" then%>
									<%If i >= c Then '왼쪽 오른쪽 바꿈 아래쪽%>
								    <!-- <a href="javascript:score.inputScore({'SCIDX':<%=inputsc%>,'P1':'<%=ojson.Get(c-1).AID%>',P2:'<%=mem1idx%>','GN':0,'JONO':<%=groupno%>})" class="btn btn-enter-score">스코어입력</a> -->
									<%else%>
								    <a href="javascript:score.inputScore({'SCIDX':<%=inputsc%>,'P1':'<%=mem1idx%>',P2:'<%=ojson.Get(c-1).AID%>','GN':0,'JONO':<%=groupno%>})" class="btn btn-<%If laststate = "2" then%>enter-score<%else%>ready<%End if%>">스코어입력</a>
									<%End if%>
								   <%End if%>
							  <%End if%>
							  </td>
							  <%End if%>

						  <%Case 4%>
							  <td class="win-lose">
							  <span class="record-box"><%=twin%>승<%=ttie%>무<%=tlose%>패</span>
							  <span class="point">(<%=twin*10%>)</span>
							  </td>

						  <%Case 5%>
							  <td class="order"><%If tresult = "0" then%>( - )<%else%><%=tresult%><%End if%></td>
						  <%End Select %>
					<%next%>
					</tr>


			<%next%>

		<%Case "1"%>

			<%
			for i = 0 to 0 '열
				mem1idx = ojson.Get(i).AID
				aname = ojson.Get(i).ANM
				bname = ojson.Get(i).BNM

				groupno = ojson.Get(i).GNO
				sortno = ojson.Get(i).SNO
				ateamA = ojson.Get(i).ATANM
				ateamB = ojson.Get(i).ATBNM
				bteamA = ojson.Get(i).BTANM
				bteamB = ojson.Get(i).BTBNM
				stateno = ojson.Get(i).STNO

				twin = ojson.Get(i).TWIN
				ttie = ojson.Get(i).TTIE
				tlose = ojson.Get(i).TLOSE
				tresult = ojson.Get(i).TRANK

				
				%>
				
				<%If i = 0  then%>
					<thead>
						<tr>
						  <th>제<%=groupno%>조</th>
						  <%For x = 0 To 0%>
						  <th>
						  <span class="round"><%=x + 1%></span>
						  <p>
							<span class="player"><%=ojson.Get(x).ANM%></span><span class="belong">(<%=ojson.Get(i).ATANM%>,<%=ojson.Get(i).ATBNM%>)</span>
						  </p>
						  <%If singlegame = False then%>
						  <p>
							<span class="player"><%=ojson.Get(x).BNM%></span><span class="belong">(<%=ojson.Get(i).BTANM%>,<%=ojson.Get(i).BTBNM%>)</span>
						  </p>
						  <%End if%>
						  </th>
						  <%next%>
						  <th>
						  <p class="tit">승패(점수)</p>
						  </th>
						  <th>
						  <p class="tit">순위</p>
						  </th>
						<tr>
					<thead>
					<tbody>
				<%end if%>			

					<tr>				
					<%For c = 0 To 3%>
						  <%Select Case c
						  Case 0
						  %>
							  <th>
							  <span class="round"><%=groupno%></span>
							  <p>
								<span class="player"><%=ojson.Get(i).ANM%></span>
								<span class="belong">(<%=ojson.Get(i).ATANM%>,<%=ojson.Get(i).ATBNM%>)</span>
							  </p>
							  
							  <%If singlegame = False then%>
							  <p>
								<span class="player"><%=ojson.Get(i).BNM%></span>
								<span class="belong">(<%=ojson.Get(i).BTANM%>,<%=ojson.Get(i).BTBNM%>)</span>
							  </p>
							  <%End if%>

							  </th>
						  <%Case 1%>
							  <%If c = i + 1 then%>
								  <td>
								  <p class="no-match">
									<img src="./images/tournerment/tourney/cross_line@3x.png" alt width="169" height="99">
								  </p>
								  </td>
							  <%else%>
							  <td>
							  <p class="team">
								<span class="player1"><%=aname%></span>
								<%If singlegame = False then%>,<span class="player2"><%=bname%></span><%End if%>
							  </p>
							  <p class="v-s">vs</p>
							  <p class="team">
								<span class="player3"><%=ojson.Get(c-1).ANM%></span>
								<%If singlegame = False then%>,<span class="player4"><%=ojson.Get(c-1).BNM%></span><%End if%>
							  </p>
							<%
								If IsArray(arrRS) Then

									For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 'RIDX, CIDX, GSTATE
										r_idx = arrRS(0, ar)  '열 기준
										i_idx = arrRS(1, ar)  '인덱스
										c_idx = arrRS(2, ar) '행 대상
										g_state = arrRS(3, ar) '상태   1: 종료 , 2: 진행
										leftetc = arrRS(4,ar) '양측부전패 체크

										If (CStr(mem1idx) = CStr(r_idx) Or CStr(mem1idx) = CStr(c_idx))   And (CStr(ojson.Get(c-1).AID) = CStr(c_idx) Or CStr(ojson.Get(c-1).AID) = CStr(r_idx))  Then '일치한다면  행과 열이 일치한다면
										'If CStr(mem1idx) = CStr(r_idx) And CStr(ojson.Get(c-1).AID) = CStr(c_idx)  Then '일치한다면  행과 열이 일치한다면
											inputsc = i_idx
											laststate = g_state
											c_leftetc = leftetc
										Exit for
										Else
											inputsc = 0
											laststate = 0
										End if
									Next
								
								Else
									inputsc = 0
									laststate = 0
								End If 
							%>
							  <%If CDbl(laststate)  = 1 then%>
									<%If i >= c Then '왼쪽 오른쪽 바꿈 아래쪽%>
									<%else%>
									<a href="javascript:score.showScore({'SCIDX':<%=inputsc%>,'P1':'<%=mem1idx%>',P2:'<%=ojson.Get(c-1).AID%>','GN':0,'JONO':<%=groupno%>});" class="btn btn-<%If CDbl(c_leftetc) > 3 then%>danger<%else%>result<%End if%>" >결과보기</a>
									<%End if%>
							  <%else%>
								   <%If tabletype = "2" then%>
									<%If i >= c Then '왼쪽 오른쪽 바꿈 아래쪽%>
									<%else%>
								   <a href="javascript:score.inputScore({'SCIDX':<%=inputsc%>,'P1':'<%=mem1idx%>',P2:'<%=ojson.Get(c-1).AID%>','GN':0,'JONO':<%=groupno%>})" class="btn btn-<%If laststate = "2" then%>enter-score<%else%>ready<%End if%>">스코어입력</a>
								   <%End if%>
								   <%End if%>
							  <%End if%>
							  </td>
							  <%End if%>

						  <%Case 2%>
							  <td class="win-lose">
							  <span class="record-box"><%=twin%>승<%=ttie%>무<%=tlose%>패</span>
							  <span class="point"><%If tresult = "0" then%>( - )<%else%><%=tresult%><%End if%></span>
							  </td>

						  <%Case 3%>
							  <td class="order">-</td>
						  <%End Select %>
					<%next%>
					</tr>


			<%next%>

		<%Case "2"%>
			<%
			for i = 0 to  1 '열
				mem1idx = ojson.Get(i).AID
				aname = ojson.Get(i).ANM
				bname = ojson.Get(i).BNM

				groupno = ojson.Get(i).GNO
				sortno = ojson.Get(i).SNO
				ateamA = ojson.Get(i).ATANM
				ateamB = ojson.Get(i).ATBNM
				bteamA = ojson.Get(i).BTANM
				bteamB = ojson.Get(i).BTBNM
				stateno = ojson.Get(i).STNO
				'rt1 = ojson.Get(i).RT1

				twin = ojson.Get(i).TWIN
				ttie = ojson.Get(i).TTIE
				tlose = ojson.Get(i).TLOSE
				tresult = ojson.Get(i).TRANK

				
				%>
				
				<%If i = 0  then%>
					<thead>
						<tr>
						  <th>제<%=groupno%>조</th>
						  <%For x = 0 To 1%>
						  <th>
						  <span class="round"><%=x + 1%></span>
						  <p>
							<span class="player"><%=ojson.Get(x).ANM%></span><span class="belong">(<%=ojson.Get(i).ATANM%>,<%=ojson.Get(i).ATBNM%>)</span>
						  </p>
						  <%If singlegame = False then%>
						  <p>
							<span class="player"><%=ojson.Get(x).BNM%></span><span class="belong">(<%=ojson.Get(i).BTANM%>,<%=ojson.Get(i).BTBNM%>)</span>
						  </p>
						  <%End if%>
						  </th>
						  <%next%>
						  <th>
						  <p class="tit">승패(점수)</p>
						  </th>
						  <th>
						  <p class="tit">순위</p>
						  </th>
						<tr>
					<thead>
					<tbody>
				<%end if%>			

					<tr>				
					<%For c = 0 To 4%>
						  <%Select Case c
						  Case 0
						  %>
							  <th>
							  <span class="round"><%=groupno%></span>
							  <p>
								<span class="player"><%=ojson.Get(i).ANM%></span>
								<span class="belong">(<%=ojson.Get(i).ATANM%>,<%=ojson.Get(i).ATBNM%>)</span>
							  </p>
							  <%If singlegame = False then%>
							  <p>
								<span class="player"><%=ojson.Get(i).BNM%></span>
								<span class="belong">(<%=ojson.Get(i).BTANM%>,<%=ojson.Get(i).BTBNM%>)</span>
							  </p>
							  <%End if%>
							  </th>
						  <%Case 1,2%>
							  <%If c = i + 1 then%>
								  <td>
								  <p class="no-match">
									<img src="./images/tournerment/tourney/cross_line@3x.png" alt width="169" height="99">
								  </p>
								  </td>
							  <%else%>
							  <td>
							  <p class="team">
								<span class="player1"><%=aname%></span>
								<%If singlegame = False then%>,<span class="player2"><%=bname%></span><%End if%>
							  </p>
							  <p class="v-s">vs</p>
							  <p class="team">
								<span class="player3"><%=ojson.Get(c-1).ANM%></span>
								<%If singlegame = False then%>,<span class="player4"><%=ojson.Get(c-1).BNM%></span><%End if%>
							  </p>
	 

							<%
								If IsArray(arrRS) Then

									For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 'RIDX, CIDX, GSTATE
										r_idx = arrRS(0, ar)  '열 기준
										i_idx = arrRS(1, ar)  '인덱스
										c_idx = arrRS(2, ar) '행 대상
										g_state = arrRS(3, ar) '상태 1: 종료 , 2: 진행
										leftetc = arrRS(4,ar) '양측부전패 체크

										If (CStr(mem1idx) = CStr(r_idx) Or CStr(mem1idx) = CStr(c_idx))   And (CStr(ojson.Get(c-1).AID) = CStr(c_idx) Or CStr(ojson.Get(c-1).AID) = CStr(r_idx))  Then '일치한다면  행과 열이 일치한다면
										'If CStr(mem1idx) = CStr(r_idx) And CStr(ojson.Get(c-1).AID) = CStr(c_idx)  Then '일치한다면  행과 열이 일치한다면
											inputsc = i_idx
											laststate = g_state
											c_leftetc = leftetc
										Exit for
										Else
											inputsc = 0
											laststate = 0
										End if
									Next
								
								Else
									inputsc = 0
									laststate = 0
								End If 
							%>

							  <%If CDbl(laststate)  = 1 then%>
									<%If i >= c Then '왼쪽 오른쪽 바꿈 아래쪽%>
									<%else%>
									<a href="javascript:score.showScore({'SCIDX':<%=inputsc%>,'P1':'<%=mem1idx%>',P2:'<%=ojson.Get(c-1).AID%>','GN':0,'JONO':<%=groupno%>});" class="btn btn-<%If CDbl(c_leftetc) > 3 then%>danger<%else%>result<%End if%>" >결과보기</a>
									<%End if%>
							  <%else%>
								   <%If tabletype = "2" then%>
									<%If i >= c Then '왼쪽 오른쪽 바꿈 아래쪽%>
									<%else%>
								   <a href="javascript:score.inputScore({'SCIDX':<%=inputsc%>,'P1':'<%=mem1idx%>',P2:'<%=ojson.Get(c-1).AID%>','GN':0,'JONO':<%=groupno%>})" class="btn btn-<%If laststate = "2" then%>enter-score<%else%>ready<%End if%>">스코어입력</a>
								   <%End if%>
								   <%End if%>
							  <%End if%>
							  </td>
							  <%End if%>

						  <%Case 3%>
							  <td class="win-lose">
							  <span class="record-box"><%=twin%>승<%=ttie%>무<%=tlose%>패</span>
							  <span class="point"><%If tresult = "0" then%>( - )<%else%><%=tresult%><%End if%></span>
							  </td>

						  <%Case 4%>
							  <td class="order">-</td>
						  <%End Select %>
					<%next%>
					</tr>


			<%next%>
			
	
		<%End Select %>

		    </tbody>
      </table>

		
		<!-- S: btn-list -->
		<div class="btn-list">
		  <%If tabletype = "22" then%>
		  <a href="javascript:score.gameSearch(20)" class="btn btn-show-list">예선 조 목록 보기</a>
		  <%else%>
		  <a href="javascript:score.gameSearch(<%If tabletype = "2" then%>0<%else%>10<%End if%>)" class="btn btn-show-list">예선 조 목록 보기</a>
		  <%End if%>
		</div>
		<!-- E: btn-list -->


	</div>
      <!-- E: preli 리그 -->