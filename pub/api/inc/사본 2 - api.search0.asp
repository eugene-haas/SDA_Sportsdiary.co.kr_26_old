     <%If tabletype ="0" and CMD <>"20003" and CMD <>"20031" then%>
      <!-- S: color-guide -->
      <section class="color-guide" id="DP_Guide">
        <h2>각 색상별 기능을 참고하시기 바랍니다.</h2>
        <ul class="guide-cont">
          <li>
            <a class="btn btn-danger btn-look time-in">1</a><p>경기중</p>
          </li>
          <li>
            <a class="btn btn-danger btn-look time-out">2</a><p>경기종료</p>
          </li>
          <!-- <li>
            <a class="btn btn-primary btn-look full">3</a><p>심판승인완료</p>
          </li> -->
          <li>
            <a class="btn btn-danger btn-look handy">3</a><p>양측부전패(불참)</p>
          </li>
        </ul>
      </section>
      <!-- E: color-guide -->
    <%End if%>


      <!-- S: preli 예선 -->
      <div class="preli">

       <%'app 
       If  CMD <>"20003" and CMD <>"20031" then%> 
        <!-- S: btn-list -->
        <ul class="btn-list">
          <li>
            <a href="javascript:score.gameSearch(<%=tabletype%>)" class="btn btn-round-type on">예선</a>
          </li>
          <li>
            <a href="javascript:score.gameSearch(<%=CDbl(tabletype) + 1%>)" class="btn btn-round-type">본선</a>
          </li>
        </ul>
       <% end if %>
        <!-- E: btn-list -->

	<%If tabletype = "0" Or tabletype = "20"  Then '###############################################################################################%>

	
	<%If gamestate <> "" Then  	'게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임%>
      <!-- S: include preli -->
      <div class="preli-table">
        <table class="table table-striped">
        <thead>
          <tr>
          <th > <span>그룹</span></th>
          <th style="max-width:120px;min-width:80px;"> <span>지역</span> <span>(코트)</span></th>
          <th <%If singlegame = False then%>colspan="2"<%End if%>>1번</th>
          <th <%If singlegame = False then%>colspan="2"<%End if%>>2번</th>
          <th <%If singlegame = False then%>colspan="2"<%End if%>>3번</th>
          <%If  CMD <>"20003" and  cmd <> CMD_GAMESEARCH_Home then%> 
           <th>경기입력</th>
          <% end if %>
          </tr>
        </thead>

		<%If CDbl(gamestate) < 3 Or rscnt = 0  then%>

			
			<tbody>
			  <tr>
				<td colspan="<%If singlegame = False then%>9<%else%>9<%End if%>"><%If statestr <> "" then%><%=statestr%><%End if%></td>
			  </tr>
			</tbody>

		
		<%else%>

			<tbody>

				<%
				groupnotmp = 0
				For joo =1 To maxgno
					teamcnt = 0
					rtcnt = 0
					Response.write "<tr>"
					For i = 0 to datalen + 1
						'$$$
							mem1idx = ojson.Get(i).AID
							aname = ojson.Get(i).ANM
							bname = ojson.Get(i).BNM

							groupno = ojson.Get(i).GNO
							sortno = ojson.Get(i).SNO
							ateamA = ojson.Get(i).ATANM
							ateamB = ojson.Get(i).ATBNM
							bteamA = ojson.Get(i).BTANM
							bteamB = ojson.Get(i).BTBNM
							'stateno = ojson.Get(i).STNO
							rt1 = ojson.Get(i).RT1 '순위

							RTW = ojson.Get(i).RTW '승
							RTT = ojson.Get(i).RTT '무
							RTL = ojson.Get(i).RTL '패
                            
							place = ojson.Get(i).place '지역
                            courtno= ojson.Get(i).courtno '코트정보'

							If ateamA <>"" then
								ateamprint = ateamA
								If ateamB <> "" Then
									ateamprint = ateamprint & "," & ateamB
								End if
							End If

							If bteamA <>"" then
								bteamprint = bteamA
								If bteamB <> "" Then
									bteamprint = bteamprint & "," & bteamB
								End if
							End If		

						'$$$

						If CDbl(joo) = CDbl(groupno) Then
						teamcnt = teamcnt + 1
						If rt1 = "1" Or rt1 = "2"  then
							rt1class = " class=""pass"" "
							rtcnt = rtcnt + 1 '진출자
						Else
							rt1class = ""					
						End If



						If USER_IP = "118.33.86.240" Then
							If groupno <> groupnotmp  Then
								'Response.write "<td>temp--" &groupno & "-#"&groupnotmp & "</td>"							
							End if
						End If
						
						If sortno  = "1" Or groupno <> groupnotmp Then
							%>
                            <td>제<%=groupno%>조<% 
                            If CMD ="20003" then%> 
                            <%
                                if rtcnt >0 then 
                                %> <a href="javascript:score.gameSearch({'TT':12, 'SIDX': <%=groupno%>});" class="btn btn-show-result" style="display:none;">결과</a> <%end if  %><%
                                end if
                             %></td>
                             <td style="width:70px;">  <% if place <> "" then Response.Write place  end if %><%if courtno >0 then  %>  <span class="belong">(<%=courtno %> 코트)</span><% end if %></td><%
						End if
				        %>

							<td <%=rt1class%>>
                                <div>
									<% If  RT1<>0  then%> <span class="result"><%=RT1 %>위</span><%end if %>
                                    <% If  RT1<>0  then%><span class="point"><%'Response.Write RTW &"/"&RTT&"/"&RTL %></span><%end if %>
                                </div>
								<span class="player"><%=aname%></span>
								<span class="belong"><%=ateamprint%></span>
							</td>
							<%If singlegame = False then%>
							<td <%=rt1class%>>
								<span class="player"><%=bname%></span>
								<span class="belong"><%=bteamprint%></span>
							</td>
							<%End if%>

				        <%						
						End If
					groupnotmp = groupno
					Next

					'각조별 상태
					Select Case rtcnt 
					Case 0 :   rt1btnstate = "btn-ready" '예선준비중
					Case 1 :   rt1btnstate = "btn-ready" '예선진행중
					Case 2 :   rt1btnstate = "btn-finish" '예선경기종료
					End Select

					For n = 1 To 3- CDbl(teamcnt)

						if  n =1 then 
                        %><!-- <td>3</td><td>4</td> --><%
                        end if 
						%><td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td>
						<%If singlegame = False then%><td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td><%End if%><%
					Next						
					%>
                   
                     <% 'app 
                     If  CMD <>"20003" and  cmd <> CMD_GAMESEARCH_Home then%> 
        
                    <td><a href="javascript:score.gameSearch({'TT':<%If tabletype = "20"  then%>22<%else%>2<%End if%>, 'SIDX': <%=joo%>})" class="btn <%=rt1btnstate%>">입력</a></td>
                       
                    <% end if
					Response.write "</tr>"					
				Next
				%>

			</tr>
			</tbody>



 <%If dddd= 1 then%>		  
			  <tr>
				<%
				'예선 gametable 에서 상태를 가져와서 예선 대진표 완료여부 확인 후 표시

				for i = 0 to datalen + 1
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
					rt1 = ojson.Get(i).RT1
					courtno = ojson.Get(i).courtno
					place = ojson.Get(i).place

					If ateamA <>"" then
						ateamprint = ateamA
						If ateamB <> "" Then
							ateamprint = ateamprint & "," & ateamB
						End if
					End If

					If bteamA <>"" then
						bteamprint = bteamA
						If bteamB <> "" Then
							bteamprint = bteamprint & "," & bteamB
						End if
					End If		

					'경기결과에 따라 진출여부표시
					'If rt1 = "pass"  then
					If rt1 = "1" Or rt1 = "2"  then
						rt1class = " class=""pass"" "
					Else
						rt1class = ""					
					End If
					
					'각조별 상태
					Select Case stateno 
					Case "0" :   rt1btnstate = "btn-ready" '예선준비중
					Case "2" :   rt1btnstate = "btn-ready" '예선진행중
					Case "4" :   rt1btnstate = "btn-finish" '예선경기종료
					Case "6" :   rt1btnstate = "btn-comp" '예선심판승인완료
					Case "8" :   rt1btnstate = "no-game" '양측부전패(불참)
					End Select
				%>
				  <%If groupno <> groupnotmp then%>
						<td>제<%=groupno%>조  
                         <%If  CMD ="20003" then%> 
    
                         <%end if  %>
                        </td>
                         <td>  <% if place <> "" then Response.Write place  end if %><%if courtno >0 then  %>  <span class="belong">(<%=courtno %> 코트)</span><% end if %></td><%
				    End if%>
					<td <%=rt1class%>>
						<span class="player"><%=aname%></span>
						<span class="belong"><%=ateamprint%></span>
					</td>
					<%If singlegame = False then%>
					<td <%=rt1class%>>
						<span class="player"><%=bname%></span>
						<span class="belong"><%=bteamprint%></span>
					</td>
					<%End if%>
			  
			  <%If CDbl(sortno) = 3 then%>
                    <% 'app 
                   If  CMD <>"20003" and cmd  <> CMD_GAMESEARCH_Home then%> 
					<td>
						<a href="javascript:score.gameSearch({'TT':<%If tabletype = "20"  then%>22<%else%>2<%End if%>, 'SIDX': <%=groupno%>})" class="btn <%=rt1btnstate%>">입력</a>
					</td>
                    <%end if  %>
			  </tr>
			 
			  <%If i < datalen + 1 then%>
			  <tr>
			  <%End if%>

			  <%End if%>
			<%
			groupnotmp = groupno
			next%>


			<%For n = 1 To 3- CDbl(sortno)%>
				<td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td>
				<%If singlegame = False then%><td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td><%End if%>
			<%next%>
               

			<%If sortno <> "3" then%>
                  <% 'app 
                   If  CMD <>"20003" and  cmd <> CMD_GAMESEARCH_Home then%> 
				<td>
					<a href="javascript:score.gameSearch({'TT':<%If tabletype = "20"  then%>22<%else%>2<%End if%>, 'SIDX': <%=groupno%>})" class="btn <%=rt1btnstate%>">입력</a>
				</td>
                <% end if  %>
			<%End if%>


			</tr>
			</tbody>
<%End if%>


		<%End if%>

        </table>
      </div>
    <!-- E: include preli -->
	<%End if%>






	<%Else '############################################################################################################%>


	  <h3 class="preli-result-title"><%=key3name%></h3>
      <!-- S: include preli -->
      <div class="preli-table preli-result">
        <table class="table table-striped">

        <thead>
          <tr>
          <th > <span>그룹</span></th>
          <th > <span>지역</span> <span>(코트)</span></th>
          <th <%If singlegame = False then%>colspan="2"<%End if%>>
            <span class="ic-deco">
            <img src="images/tournerment/public/champ1@3x.png" alt="1위">
            </span>
            <span>1위</span>
          </th>
          <th <%If singlegame = False then%>colspan="2"<%End if%>>
            <span class="ic-deco">
            <img src="images/tournerment/public/champ2@3x.png" alt="2위">
            </span>
            <span>2위</span>
          </th>
          <th <%If singlegame = False then%>colspan="2"<%End if%>>
            <span class="ic-deco">
            <img src="images/tournerment/public/champ3@3x.png" alt="3위">
            </span>
            <span>3위</span>
          </th>
          <th>보기</th>
          </tr>
        </thead>		


		<%If CDbl(gamestate) < 3 Or rscnt = 0  then%>
			<tbody>
			  <tr>
				<td colspan="<%If singlegame = False then%>9<%else%>9<%End if%>"><%If statestr <> "" then%><%=statestr%><%End if%></td>
			  </tr>
			</tbody>
		<%else%>

			<tbody>
			  <tr>
				<%
				'예선 gametable 에서 상태를 가져와서 예선 대진표 완료여부 확인 후 표시

				for i = 0 to datalen + 1
					mem1idx = ojson.Get(i).AID
					aname = ojson.Get(i).ANM
					bname = ojson.Get(i).BNM

					groupno = ojson.Get(i).GNO
					sortno = ojson.Get(i).SNO
					ateamA = ojson.Get(i).ATANM
					ateamB = ojson.Get(i).ATBNM
					bteamA = ojson.Get(i).ATBNM
					bteamB = ojson.Get(i).ATBNM
					stateno = ojson.Get(i).STNO
					rt1 = ojson.Get(i).RT1
                    
					courtno = ojson.Get(i).courtno
					place = ojson.Get(i).place


					'경기결과에 따라 진출여부표시
					If rt1 = "1" Or rt1 = "2"   then
						rt1class = " class=""pass"" "
					Else
						rt1class = ""					
					End If
					
					'각조별 상태
					Select Case stateno 
					Case "0" :   rt1btnstate = "btn-ready" '예선준비중
					Case "2" :   rt1btnstate = "btn-ready" '예선진행중
					Case "4" :   rt1btnstate = "btn-finish" '예선경기종료
					Case "6" :   rt1btnstate = "btn-comp" '예선심판승인완료
					Case "8" :   rt1btnstate = "no-game" '양측부전패(불참)
					End Select
				%>
				  <%If groupno <> groupnotmp then%>
						<td>제<%=groupno%>조</td>
                        <td>  <% if place <> "" then Response.Write place  end if %><%if courtno >0 then  %>  <span class="belong">(<%=courtno %> 코트)</span><% end if %></td>
				  <%End if%>
					<td <%=rt1class%>>
						<span class="player"><%=aname%></span>
						<span class="belong"><%=ateamA%>,<%=ateamB%></span>
					</td>
					<%If singlegame = False then%>
					<td <%=rt1class%>>
						<span class="player"><%=bname%></span>
						<span class="belong"><%=bteamA%>,<%=bteamB%></span>
					</td>
					<%End if%>
			  <%'If sortno = 3 then
			  If i > 0 And (i + 1) mod 3 = 0 then
			  %>
                  <% 'app 
                   If  CMD <>"20003" and cmd  <> CMD_GAMESEARCH_Home then%> 
					<td>
						<a href="javascript:score.gameSearch({'TT':12, 'SIDX': <%=groupno%>});" class="btn btn-show-result">보기</a>
						<!-- <a href="javascript:score.gameSearch({'TT':2, 'SIDX': <%=groupno%>})" class="btn <%=rt1btnstate%>">입력</a> -->
					</td>
                    <%end if  %>
			  </tr>
			  <tr>
			  <%End if%>
			<%
			groupnotmp = groupno
			next%>

			<%
			namergi = i  mod 3
			Select Case mamergi
			Case 0 : mamergiblock = -1
			Case 1 : mamergiblock = 2
			Case 2 :  mamergiblock = 1
			End Select 

			For n = 0 To mamergiblock%>
				<td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td>
				<%If singlegame = False then%><td><span class="player">&nbsp;</span><span class="belong">&nbsp;</span></td><%End if%>
			<%next%>

			<%'If sotrno <> "3" then
			If mamergiblock > -1 then
			%>
                <% 'app 
                If  CMD <>"20003" and  cmd <> CMD_GAMESEARCH_Home then%> 
				<td>
					<a href="javascript:score.gameSearch({'TT':12, 'SIDX': <%=groupno%>});" class="btn btn-show-result">보기</a>
					<!-- <a href="javascript:score.gameSearch({'TT':2, 'SIDX': <%=groupno%>})" class="btn <%=rt1btnstate%>">입력</a> -->
				</td>
                <% end if  %>
			<%End if%>
			</tr>

			  <tr>
				<td colspan="<%If singlegame = False then%>9<%else%>6<%End if%>">조회 조건을 선택 후, 조회버튼을 눌러주세요.</td>
			  </tr>

			</tbody>
		<%End if%>

        </table>
      </div>
      <!-- E: preli-table -->

    <%End if%>
    </div>
      <!-- E: preli 예선 -->