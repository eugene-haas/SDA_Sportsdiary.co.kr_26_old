
<tr style="cursor:pointer" id="titlelist_<%=b_idx%>">
	<td><span><%=b_idx%></span></td>
	<td class="date" onclick="mx.input_edit(<%=b_idx%>)"><span><%=b_boo%></span></td>
	<td class="name" >
        <a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="white-btn">조추첨</a>
		<a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="white-btn">1경기</a>
	    <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="white-btn">2경기</a>
	    <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="white-btn">3경기</a>
	</td>
	<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><span><%=b_sex%></span></td>
	<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><span><%=b_booNM%></span></td>
	<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><span><%=b_GameS%></span></td>
	<td class="name"  onclick="mx.input_edit(<%=b_idx%>)"><span>0</span></td>
	<td class="g_btn green_btn1"><a href="findcontestplayer.asp" class="white-btn">참가신청목록</a></td>
</tr>
