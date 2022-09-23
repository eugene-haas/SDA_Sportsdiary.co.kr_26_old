<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>연습경기</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub rehearsal">
		<div class="top-practice-video">
			<a href="#" class="btn-skyblue">동영상 불러오기</a>
			<div class="btn-slow-motion">
				<div class="flipswitch">
					<input type="checkbox" name="flipswitch" class="flipswitch-cb" id="fs" checked />
					<label class="flipswitch-label" for="fs">
						<div class="flipswitch-inner"></div>
						<div class="flipswitch-switch"></div>
					</label>
				</div>
				<span>Slow Motion</span>
			</div>
		</div>
		<div class="practice-video" style="height:300px; display:none; background:#000;">
			<!-- 동영상이 들어갑니다 -->
		</div>
		<ul class="btn-practice-video">
			<li><a href="#">-10초</a></li>
			<li><a href="#">-5초</a></li>
			<li><a href="#">재생 ▶</a></li>
			<li><a href="#">+5초</a></li>
			<li><a href="#">+10초</a></li>
		</ul>
		<div class="practice-select">
			<div class="practice-radio">
				<strong>기술선택</strong>
				<input type="radio" name="practice-select" id="practice-select-left" /> <label for="practice-select-left" style="margin-right:5px;">좌측기술</label>
				<input type="radio" name="practice-select" id="practice-select-right" /> <label for="practice-select-right">우측기술</label>
			</div>
			<div class="flex">
				<select>
					<option>기술항목</option>
				</select>
				<select>
					<option>상세항목</option>
				</select>
			</div>
		</div>
		<div class="pracice-wrap">
			<div class="pracice-score">
				<!-- S: pop-point-display -->
				<div class="pop-point-display">
					<!-- S: display-board -->
					<div class="display-board clearfix">
						<!-- S: point-display -->
						<div class="point-display clearfix">
							<ul class="point-title clearfix">
								<li>&nbsp;</li>
								<li>한판</li>
								<li>절반</li>
								<li>유효</li>
								<li>지도</li>
								<!--<li>반칙/실격/<br />부전/기권 승</li>-->
							</ul>
							<ul class="player-1-point player-point clearfix">
								<li>
									<a onclick="#"><span class="player-name disp-win" id="DP_Edit_LPlayer">본인</span>
									<!--//<p class="player-school" id="">충남체육고등학교</p>--></a>
								</li>
								<li class="tgClass on">
								 <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1" >0</span></a>
								</li>
								<li class="tgClass">
									<a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2" >0</span></a>
								</li>
								<li class="tgClass">
									<a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3" >0</span></a>
								</li>
								<li class="tgClass">
									<a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4" >0</span></a>
								</li>
								<!--//<li>
									<select class="select-win select-box" id="DP_L_GameResult">
									</select>
								</li>-->
							</ul>
							<!--<p class="vs">vs</p>-->
							<ul class="player-2-point player-point clearfix">
								<li>
									<a onclick="#"><span class="player-name disp-win" id="DP_Edit_RPlayer">상대</span>
									<!--//<p class="player-school" id="">서울명덕초등학교</p>--></a>
								</li>
								<li class="tgClass">
									<a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb1">0</span></a>
								</li>
								<li class="tgClass">
									<a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb2">0</span></a>
								</li>
								<li class="tgClass">
									<a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
								</li>
								<li class="tgClass">
									<a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
								</li>
								<!--//<li>
									<select class="select-win select-box" id="DP_R_GameResult" >
									</select>
								</li>-->
							</ul>
							<!--//
							<div class="player-match-option player-point">
								<label for="player-match-option-01" class="tgClass"><input type="checkbox" id="player-match-option-01" /><span>부전패</span></label>
								<label for="player-match-option-02" class="tgClass"><input type="checkbox" id="player-match-option-02" /><span>무승부</span></label>
							</div>
							-->
							<!-- E: point-display -->
						</div>
						<!-- E: point-display -->
						</div>
					<!-- E: display-board -->
				</div>
				<!-- E: pop-point-display -->
			</div>
			<ul class="pracice-time">
				<li>
					<label class="on">
						<input type="radio" name="pt">
						<span>05:00~04:01</span>
					</label>
				</li>
				<li>
					<label>
						<input type="radio" name="pt">
						<span>04:00~03:01</span>
					</label>
				</li>
				<li>
					<label>
						<input type="radio" name="pt">
						<span>03:00~02:01</span>
					</label>
				</li>
				<li>
					<label>
						<input type="radio" name="pt">
						<span>02:00~01:01</span>
					</label>
				</li>
				<li>
					<label>
						<input type="radio" name="pt">
						<span>01:00~00:01</span>
					</label>
				</li>
				<li>
					<label>
						<input type="radio" name="pt">
						<span>골든스코어</span>
					</label>
				</li>
			</ul>
		</div>
		<div class="container">
			<a href="#" class="btn-or full">완료</a>
			<ul class="plactice-txt">
				<li class="pratice-txt-white">[2:13]본인: 절반(기타누으며 메치기)</li>
				<li class="pratice-txt-blue">[3:20]상대: 지도(허리채기)</li>
			</ul>
		</div>
  </div>
	<!-- E : sub -->
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
<script>
	$(document).ready(function(){
		$(".btn-skyblue").click(function(){
			$(".practice-video").show();
		});
	});
</script>
