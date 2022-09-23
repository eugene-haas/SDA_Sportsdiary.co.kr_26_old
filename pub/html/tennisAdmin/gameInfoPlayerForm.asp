		<input type="hidden" id="attidx" value="<%=updateidx%>" /><!-- 참가신처 인덱스 -->
		<input type="hidden" id="TitleIDX" value="<%=idx%>" />

		<table class="navi-tp-table">
			<caption>대회정보관리 신청관리</caption>
			<colgroup>
				<col width="64px"><col width="*"><col width="64px"><col width="*"><col width="94px"><col width="*"><col width="94px"><col width="*">
			</colgroup>

			<tbody>
				<tr>
					<th scope="row">대회명</th>
					<td colspan="2"><%=title%>&nbsp;&nbsp;<%=teamnm%> (<%=levelnm%>) &nbsp;&nbsp;신청인 : </span id="applyid">운영자</span></td>
				</tr>
				<tr>
					<th scope="row">&nbsp;</th>
					<td colspan="2">이름 / 성별 / 생년월일 / 등급 / 핸드폰/소속팀1/소속팀2 /랭킹포인트</td>
				</tr>

				<tr id ="player1">
					<!-- #include virtual = "/pub/html/tennisAdmin/gameinfoPlayerFormP1.asp" -->
				</tr>


				<%If Left(levelno,3) = "201" Or  Left(levelno,3) = "202"  then%>
				<tr  id ="player2">
					<!-- #include virtual = "/pub/html/tennisAdmin/gameinfoPlayerFormP2.asp" -->
				</tr>
				<%End if%>


			</tbody>
		</table>