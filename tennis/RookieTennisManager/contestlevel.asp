<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookietennisAdmin/html.head.asp" -->
<style>
	.highlighted{background-color: yellow;}
	.highlight{background-color: #fff34d;}

	/*
	 * Timepicker stylesheet
	 * Highly inspired from datepicker
	 * FG - Nov 2010 - Web3R
	 *
	 * version 0.0.3 : Fixed some settings, more dynamic
	 * version 0.0.4 : Removed width:100% on tables
	 * version 0.1.1 : set width 0 on tables to fix an ie6 bug
	 */
	.ui-timepicker-inline { display: inline; }
	#ui-timepicker-div { padding: 0.2em; }
	.ui-timepicker-table { display: inline-table; width: 0; }
	.ui-timepicker-table table { margin:0.15em 0 0 0; border-collapse: collapse; }
	.ui-timepicker-hours, .ui-timepicker-minutes { padding: 0.2em;  }
	.ui-timepicker-table .ui-timepicker-title { line-height: 1.8em; text-align: center; }
	.ui-timepicker-table td { padding: 0.1em; width: 2.2em; }
	.ui-timepicker-table th.periods { padding: 0.1em; width: 2.2em; }

	/* span for disabled cells */
	.ui-timepicker-table td span {
		display:block;
		padding:0.2em 0.3em 0.2em 0.5em;
		width: 1.2em;

		text-align:right;
		text-decoration:none;
	}
	/* anchors for clickable cells */
	.ui-timepicker-table td a {
		display:block;
		padding:0.2em 0.3em 0.2em 0.5em;
	   /* width: 1.2em;*/
		cursor: pointer;
		text-align:right;
		text-decoration:none;
	}


	/* buttons and button pane styling */
	.ui-timepicker .ui-timepicker-buttonpane {
		background-image: none; margin: .7em 0 0 0; padding:0 .2em; border-left: 0; border-right: 0; border-bottom: 0;
	}
	.ui-timepicker .ui-timepicker-buttonpane button { margin: .5em .2em .4em; cursor: pointer; padding: .2em .6em .3em .6em; width:auto; overflow:visible; }
	/* The close button */
	.ui-timepicker .ui-timepicker-close { float: right }

	/* the now button */
	.ui-timepicker .ui-timepicker-now { float: left; }

	/* the deselect button */
	.ui-timepicker .ui-timepicker-deselect { float: left; }

</style>
<script src='//cdn.rawgit.com/fgelinas/timepicker/master/jquery.ui.timepicker.js'></script>
<%If request("test") = "ok" then%>
<script type="text/javascript" src="/pub/js/RookieTennis/tennis_contestlevel_test.js<%=CONST_JSVER%>"></script>
<%else%>
<script type="text/javascript" src="/pub/js/RookieTennis/tennis_contestlevel.js<%=CONST_JSVER%>"></script>
<%End if%>

<script type="text/javascript" src="/pub/js/RookieTennis/menu1/tennis_contestlevel_result.js<%=CONST_JSVER%>"></script>

</head>

<body <%=CONST_BODY%>>
<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>

<div id="myLevelModel" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myLevelModelLabel"></div>

<div id="myConfirm" title="승패" class="modal hide fade" role="dialog"></div>




<!-- S: !@# 모달 추가  -->
<!--  script는 참고용입니다. 주석과 함께 삭제해주세요.-->
<div id="myWinModal" class="modal hide fade laketmodal" role="dialog" aria-labelledby="myWinModal">

	<div class="modal-header game-ctr">
		<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
		<h3 id="myModalLabel">SPORTS BRAND REAL SURVEY</h3>
	</div>

	<div class="modal-body laket-modal">
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
		<a href="#" class="btn btn-primary blue-btn">확인</a>
	</div>

</div>
<script>
//	$('#myWinModal').modal('show'); //경기순서에서 점수입력창
</script>
<!-- E: !@# 모달 추가  -->



 <script src="/pub/js/RookieTennis/html2canvas.min.js"></script>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/RookietennisAdmin/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.contestlevel.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.footer.asp" -->
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
