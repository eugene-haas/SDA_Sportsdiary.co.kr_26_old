
			<tr style="cursor:pointer" id="titlelist_<%=b_idx%>">
				<td><%=b_idx%></td>
				<td class="date" onclick="mx.input_edit(<%=b_idx%>)"><%=b_boo%></td>
				<td class="name" >
				
			        <a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func">조추첨</a>
					<a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func">1경기</a>
				    <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func">2경기</a>
				    <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func">3경기</a>
				
				</td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><%=b_sex%></td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><%=b_booNM%></td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><%=b_GameS%></td>
				<td class="name"  onclick="mx.input_edit(<%=b_idx%>)">0</td>
				<td class="g_btn green_btn1"><a href="findcontestplayer.asp">참가신청목록</a></td>


			</tr>

