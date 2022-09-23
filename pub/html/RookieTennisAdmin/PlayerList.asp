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
						<a href="javascript:mx.setState(<%=pidx%>,'<%=s_stateNo%>','ss_<%=pidx%>')" class="btn" id="ss_<%=pidx%>">박탈</a>
					<%else%>
						<a href="javascript:mx.setState(<%=pidx%>,'<%=s_stateNo%>','ss_<%=pidx%>')" class="btn" id="ss_<%=pidx%>">해제</a>
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



		</td>


		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pphone%></td>
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pteam1%></td>
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pteam2%></td>


		<td>
		<%If rankcount = "0" then%>
			<a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="btn" >없음
		<%else%>
			<a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="btn" style="color:yellow"><%=pRankPoint%>pt <%=rankcount%>건
		<%End if%>
		</a>

		</td>

		<td><%=writeday%></td>
	</tr>
