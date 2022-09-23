<!-- #include virtual = "/pub/header.radingAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/riding/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/contestlevel.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/menu1/contestlevel_result.js<%=CONST_JSVER%>"></script>
</head>


<body <%=CONST_BODY%>>
	<div class="t_default">

		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<div id="myLevelModel" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myLevelModelLabel"></div>

		<div id="myConfirm" title="승패" class="modal fade" data-backdrop="static" role="dialog"></div>


		<!-- S: 모달 -->
		<div id="myWinModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myWinModal">

			<div class="modal-dialog">
				<div class="modal-content">

					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
						<h4 id="myModalLabel">SPORTS BRAND REAL SURVEY</h4>
					</div>

					<div class="modal-body">
						<!-- s: player-con -->
						<div class="player-con l-con">
							<table cellspacing="0" cellpadding="0">
								<tbody>
									<tr>
										<td colspan="2">
											<img src="http://tennisadmin.sportsdiary.co.kr/images/tenis/l_icon.png" alt="">
											<span class="player-title">PLAYER 1</span>
											<img src="http://tennisadmin.sportsdiary.co.kr/images/tenis/r_icon.png" alt="">
										</td>
									</tr>
									<tr>
										<th>
											<span>Name</span>
										</th>
										<th>
											<span>Score</span>
										</th>
									</tr>
									<tr>
										<td>
											<span>김성희</span>
										</td>
										<td rowspan="2">
											<span class="l-img">
												<img src="http://tennisadmin.sportsdiary.co.kr/images/tenis/tenis_icon1.png" alt="">
											</span>
											<span class="txt" id=""></span>
											<select name="" id="" onchange="">
												<option value="">:: 선택 ::</option>
												<option value="0">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
												<option value="7">7</option>
												<option value="8">8</option>
												<option value="9">9</option>
												<option value="10">10</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											<span>이병혜</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- e: player-con -->
						<!-- s: center-con -->
						<div class="vs-con">
							<span>VS</span>
						</div>
						<!-- e: center-con -->
						<!-- s: player-con -->
						<div class="player-con r-con">
							<table cellspacing="0" cellpadding="0">
								<tbody>
									<tr>
										<td colspan="2">
											<img src="http://tennisadmin.sportsdiary.co.kr/images/tenis/l_icon.png" alt="">
											<span class="player-title">PLAYER 2</span>
											<img src="http://tennisadmin.sportsdiary.co.kr/images/tenis/r_icon.png" alt="">
										</td>
									</tr>
									<tr>
										<th>
											<span>Name</span>
										</th>
										<th>
											<span>Score</span>
										</th>
									</tr>
									<tr>
										<td>
											<span>김경호</span>
										</td>
										<td rowspan="2">
											<span class="l-img">
												<img src="http://tennisadmin.sportsdiary.co.kr/images/tenis/tenis_icon1.png" alt="">
											</span>
											<span class="txt" id=""></span>
											<select name="" id="" onchange="">
												<option value="">:: 선택 ::</option>
												<option value="0">0</option>
												<option value="1">1</option>
												<option value="2">2</option>
												<option value="3">3</option>
												<option value="4">4</option>
												<option value="5">5</option>
												<option value="6">6</option>
												<option value="7">7</option>
												<option value="8">8</option>
												<option value="9">9</option>
												<option value="10">10</option>
											</select>
										</td>
									</tr>
									<tr>
										<td>
											<span>이선녀</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<!-- e: player-con -->
					</div>

					<div class="modal-footer">
						<a href="#" class="btn btn-primary">확인</a>
					</div>

			</div>
		</div>



		</div>
		<!-- E: 모달 -->

		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

		<div id="body">
			<aside>
			<%pagename = "contest.asp"%>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			<%pagename = "contestlevel.asp"%>
			</aside>

			<article>
			<!-- #include file = "./body/c.contestlevel.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->

	</div>
	<script>
    /**
     * 가로 아코디언 호출
     * tennis_contestlevel.js 파일에서 mx.accordian
     */
		$('.tourney_admin_modal').on('show.bs.modal', function(){
      var mxAccordian = new mx.Accordian('.tourney_admin_modal');
      var onOffSwitch = new mx.OnOffSwitch('.chk_btn');
    })
	</script>
</body>
</html>
