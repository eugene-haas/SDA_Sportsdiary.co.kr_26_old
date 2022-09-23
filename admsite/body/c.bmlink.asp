<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<%
 'Controller ################################################################################################

	'Constr = B_ConStr
	TN = "tblAdminMember"

	Set db = new clsDBHelper


%>
<%'View ####################################################################################################%>
		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>민턴주요URL</h1></div>


					관리자, 홈페이지, 참가신청 왼쪽메뉴이용

			<hr />


			<!-- s: 테이블 리스트 -->
				<div class="table-responsive">
					<table cellspacing="0" cellpadding="0" class="table table-hover">
						<thead>
							<tr>
								<th>번호</th>
								<th>설명</th>
								<th>링크</th>
							</tr>
						</thead>
						<tbody id="contest">
										<tr>
											<td><span>1</span></td>
											<td><span>전광판(대회별 URL다름)</span></td>
											<td><span>http://koreabadminton.org/ScoreBoardElite/scoreboard_view_elite_new.asp?Gametitleidx=1800&GameDay=2020-10-25&stadiumIDX=1362</span></td>
										</tr>

										<tr>
											<td><span>2</span></td>
											<td><span>스코어보드</span></td>
											<td><span>http://badminton.sportsdiary.co.kr/badminton/SD_OS.1/score_board/score_board_login.asp</span></td>
										</tr>
										<tr>
											<td><span>3</span></td>
											<td><span>참가신청</span></td>
											<td><span>http://koreabadminton.org/entryElite/game_list.asp</span></td>
										</tr>
										<tr>
											<td><span>4</span></td>
											<td><span>심판입력</span></td>
											<td><span>http://badminton.sportsdiary.co.kr/badminton/sd_os.1/intro.asp</span></td>
										</tr>
										<tr>
											<td><span>5</span></td>
											<td><span>챌린지판독관용</span></td>
											<td><span>http://badminton.sportsdiary.co.kr/badminton/SD_OS.1/login_challenge.asp</span></td>
										</tr>
										<tr>
											<td><span>6</span></td>
											<td><span>엘리트대진추첨</span></td>
											<td><span>http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/lotteryElite.asp</span></td>
										</tr>
										<tr>
											<td><span>7</span></td>
											<td><span>엘리트 전광판코트배정</span></td>
											<td><span>http://badmintonadmin.sportsdiary.co.kr/Main/GameNumber/SettingGameOrder_board.asp</span></td>
										</tr>
										<tr>
											<td><span>8</span></td>
											<td><span>엘리트 경기진행순서</span></td>
											<td><span>http://badmintonadmin.sportsdiary.co.kr/Main/GameNumber/autoGameSchedule_Elite.asp</span></td>
										</tr>
										<tr>
											<td><span>9</span></td>
											<td><span>경기운영관리</span></td>
											<td><span>http://badmintonadmin.sportsdiary.co.kr/Main/GameTitleMenu/OperateNew.asp</span></td>
										</tr>


						</tbody>
					</table>
				</div>
			<!-- e: 테이블 리스트 -->

			<!-- s: 더보기 버튼 -->

			<!-- e: 더보기 버튼 -->

		</div>
		<!-- s: 콘텐츠 끝 -->
