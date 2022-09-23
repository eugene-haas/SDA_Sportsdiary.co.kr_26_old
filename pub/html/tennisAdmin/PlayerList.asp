	<tr class="gametitle"  style="cursor:pointer" id="titlelist_<%=pidx%>">
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pidx%></td>
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=pname%></td>

		<!-- <td  onclick="mx.input_edit(<%=pidx%>)"><%=belongBoo%></td> -->

		<td><%'=rankboo%>


					<select  id="openboo_<%=pidx%>" style="width:100px;margin-top:-9px"  onchange="mx.setOpenRNK(this.id)">
					<option value="">기본설정</option>

					<option value="개나리부"  <%If openboornk = "개나리부" then%>selected<%End if%>>개나리부</option>
					<option value="국화부"  <%If openboornk = "국화부" then%>selected<%End if%>>국화부</option>
					<option value="신인부"  <%If openboornk = "신인부" then%>selected<%End if%>>신인부</option>
					<option value="오픈부"  <%If openboornk = "오픈부" then%>selected<%End if%>>오픈부</option>
					<option value="베테랑부"  <%If openboornk = "베테랑부" then%>selected<%End if%>>베테랑부</option>
					</select>
<!--
					<%If psex = "WoMan" Or InStr(belongBoo,"개나") > 0 Or InStr(belongBoo,"국화")  > 0 then%>
					개나리
					<label class="switch" style="margin-bottom:-8px;" title="개나리" onclick="mx.rankBooCheck(<%=pidx%>,1)">
					<input type="checkbox" id="rankboo1_<%=pidx%>"  value="Y" <%If rb1= "Y" then%>checked<%End if%>>
					<span class="slider round"></span>
					</label>
					국화
					<label class="switch" style="margin-bottom:-8px;" title="국화"  onclick="mx.rankBooCheck(<%=pidx%>,2)">
					<input type="checkbox" id="rankboo2_<%=pidx%>"  value="Y" <%If rb2= "Y" then%>checked<%End if%>>
					<span class="slider round"></span>
					</label>


					<%elseIf psex = "Man" Or InStr(belongBoo,"오픈") > 0 Or InStr(belongBoo,"신인")  > 0  Or InStr(belongBoo,"베테")  > 0 then%>
					신인
					<label class="switch" style="margin-bottom:-8px;" title="신인부" onclick="mx.rankBooCheck(<%=pidx%>,3)">
					<input type="checkbox" id="rankboo3_<%=pidx%>"  value="Y" <%If rb3= "Y" then%>checked<%End if%>>
					<span class="slider round"></span>
					</label>
					오픈
					<label class="switch" style="margin-bottom:-8px;" title="오픈부"  onclick="mx.rankBooCheck(<%=pidx%>,4)">
					<input type="checkbox" id="rankboo4_<%=pidx%>"  value="Y" <%If rb4= "Y" then%>checked<%End if%>>
					<span class="slider round"></span>
					</label>
					베테랑
					<label class="switch" style="margin-bottom:-8px;" title="베테랑"  onclick="mx.rankBooCheck(<%=pidx%>,5)">
					<input type="checkbox" id="rankboo5_<%=pidx%>"  value="Y" <%If rb5= "Y" then%>checked<%End if%>>
					<span class="slider round"></span>
					</label>
					<%else%>
						부명칭 넣어주세요
					<%End if%>
-->
		</td>
		<td>

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
			<a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="btn" >없음
		<%else%>
			<a href="javascript:mx.RankingPoint(<%=pidx%>,'<%=pname%>')" class="btn" style="color:yellow"><%=pRankPoint%>pt <%=rankcount%>건
		<%End if%>
		</a>

		<a href="javascript:mx.sumPoint(<%=pidx%>,'<%=pname%>')" class="btn_a" style="padding:8px;">+</a>

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
		<!-- <td  onclick="mx.input_edit(<%'=pidx%>)"><%'=pgrade%></td> -->
		<td><%=writeday%></td>
		<!-- <td  onclick="mx.input_edit(<%=pidx%>)"><%=pbirth%></td>
		<td  onclick="mx.input_edit(<%=pidx%>)"><%=psex%></td> -->
	</tr>
