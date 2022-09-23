	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=pidx%>">
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pidx%></td>
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pname%></td>

		<!-- <td  onclick="mx.input_edit(<%=pidx%>)"><%=belongBoo%></td> -->

		<td><%'=rankboo%>

					<select id="openboo_<%=pidx%>"style="width:100px;margin-top:-9px">
						<option value="">==선택==</option>
							<%
							If IsArray(arrBoo) Then
								For ab = LBound(arrBoo, 2) To UBound(arrBoo, 2)

									sex = arrBoo(0, ab)
									PTeamGb = arrBoo(1, ab)
									PTeamGbNm = arrBoo(2, ab)
									TeamGb = arrBoo(3, ab)
									TeamGbNm = arrBoo(4, ab)
									EnterType = arrBoo(5, ab)

								%>
										<option value="<%=TeamGb%>" <%If belongBoo = TeamGbNm then%>selected<%End if%>><%=TeamGbNm%></option>
								<%
								Next
							End if
							%>
					</select>


					<%If s_stateNo = "0" then%>
						<a href="javascript:mx.setState(<%=pidx%>,'<%=s_stateNo%>','ss_<%=pidx%>')" class="Btn blue_btn" id="ss_<%=pidx%>">박탈</a>
					<%else%>
						<a href="javascript:mx.setState(<%=pidx%>,'<%=s_stateNo%>','ss_<%=pidx%>')" class="Btn blue_btn" id="ss_<%=pidx%>">해제</a>
					<%End if%>

		</td>
		<td>
						<%
						'		s_teamgb     출전부서코드
						'		s_firstcount  일등횟수
						'		s_gameday   순위마지막 날짜
						'		s_gamestartyymm   입단년월
						'		s_stateNo    박탈 정상
						'		s_lastorder   마지막 순위(입상자만)
						'		dblrnk    원스타 2스타로 승급 또는 2스타 승급 Y
						'		levelup	승급년도

						Response.write "우승:"&s_firstcount & " 입상:" & s_lastorder
						%>

						<!--
						<%If levelup <> "0" then%>
						<%=levelup%>
						<%End if%>
						<select  id="codeno_<%=pidx%>" class="sl_search"  onchange="mx.setUPMember(this.id)">
						<option value="">==선택==</option>
							<%	'titleCode,titleGrade,hostTitle
							If IsArray(arrRSG) Then
								For ar_g = LBound(arrRSG, 2) To UBound(arrRSG, 2)
									g_titleCode = arrRSG(0, ar_g)
									g_titleGrade = arrRSG(1, ar_g)
									g_hostTitle = arrRSG(2, ar_g)

									If g_titleCode = titlecode Then
										rnktitle = g_hostTitle
									End if

									%><option value="<%=g_titleCode%>"  <%If g_titleCode = titlecode then%>selected<%End if%>> <%=g_hostTitle%></option><%
								Next
							End if
							%>
						</select>
                        <%If levelup <> "0" then%>
                            <a href="javascript:mx.setRankerWindow(<%=pidx%>,'<%=pname%>','<%=rnktitle%>')"  class="btn_a"  style="padding:8px;"><%=dblrnk%></a>
                            <input type="hidden" id="hiddenSetrank_<%=pidx%>" onclick="javascript:mx.setRankerWindow(<%=pidx%>,'<%=pname%>','<%=rnktitle%>')">
                        <%End if%>
						<%rnktitle = ""%>
						-->

		</td>


		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pphone%></td>
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pteam1%></td>
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pteam2%></td>


		<!-- <td ><%=belongBoo%></td> -->

		<%
			'if(isnull(pRankPoint) or isnull(pteamGb)) THEN
		%>
		<td>
		<%If rankcount = "0" then%>
			<a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="Btn blue_btn">없음
		<%else%>
			<a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="Btn blue_btn"><%=pRankPoint%>pt <%=rankcount%>건
		<%End if%>
		</a>

		<!-- <a href="javascript:mx.sumPoint(<%=pidx%>,'<%=pname%>')" class="btn_a" style="padding:8px;">+</a> -->

		</td>
		<%
			'ELSE
		%>
			<%
				'if Len(pteamGb) = 0 or Cint(pRankPoint) = 0 Then
			%>
				<!-- <td><a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="btn_a" style="color:red">랭킹 포인트</a></td> -->
			<%
				'ELSE
				'pteamGb = REPLACE(pteamGb,"전","")
				'pteamGb = REPLACE(pteamGb,"부","")
			%>
			<!-- <td><a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="btn_a"><%'=pteamGb & " "%> <%'=pRankPoint%></a></td> -->
			<%
				'END IF
			'END IF
		%>

		<td><%=writeday%></td>
	</tr>
