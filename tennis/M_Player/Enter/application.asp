<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<body class="lack-bg">
  <!-- S: sub-header -->
	<div class="sd-header sd-header-sub">
		<!-- #include file="../include/sub_header_arrow.asp" -->
		<h1>대회참가신청</h1>
		<!-- #include file="../include/sub_header_gnb.asp" -->
	</div>
	<!-- #include file = "../include/gnb.asp" -->
	<!-- E: sub-header -->
  <!-- S: sub -->
  <div class="sub application enter">
    <div class="clip-box">
      <p class="img-clip"><img src="http://img.sportsdiary.co.kr/sdapp/sub/icon-clip@3x.png" alt="" /></p>
    </div>
    <div>
      <div class="tabc">
        <!-- 01 참가 신청하기 -->
        <ul class="application-list">
          <li>
            <p><strong class="tit-application">제16회 제주컵 유도대회</strong> <span class="icon-red">마감종료 D-2</span> <a href="../Result/match-sch.asp" class="btn-schedule">일정표</a></p>
            <p class="day">참가신청기간: 2016-10.30~2016-11-01</p>
            <p class="cta-btn">
              <a href="application-check.asp" class="btn btn-grayline">개인전 신청내역보기</a>
              <a href="application-team.asp" class="btn btn-grayline">단체전 신청내역보기</a>
            </p>
            <p class="txt-or">※ 참가신청 마감일이 종료된 후에는 신청서 수정이 불가합니다.</p>
          </li>
          <li>
            <p><strong class="tit-application">2016 추계 중고등학교 유도대회</strong><a href="../Result/match-sch.asp" class="btn-schedule">일정표</a></p>
            <p class="cta-btn">
              <a href="../tournament/tourney.asp" class="btn-skyline">개인전 대진표보기</a>
              <a href="../tournament/tourney.asp" class="btn-skyline">단체전 대진표보기</a>
            </p>
          </li>
        </ul>
      </div>
      <!-- <div class="tabc" style="display:none;">
        02 신청내역 확인하기
        <ul class="application-list">
          <li>
            <p><strong class="tit-application">제16회 제주컵 유도대회</strong> <span class="icon-red">마감종료 D-2</span> <a href="#" data-toggle="modal" data-target="#sche-table" class="btn-schedule">일정표</a></p>
            <p class="day">참가신청기간: 2016-10.30~2016-11-01</p>
            <p class="cta-btn">
              <a href="./application-write.asp" class="btn btn-skyline">개인전 신청하기</a>
              <a href="./application-write.asp" class="btn btn-skyline">단체전 신청하기</a>
            </p>
          </li>
          <li>
            <p><strong class="tit-application">2016 추계 중고등학교 유도대회</strong> <a href="#" data-toggle="modal" data-target="#sche-table" class="btn-schedule">일정표</a></p>
            <p>
              <a href="#" class="btn-skyline">개인전 신청하기</a>
              <a href="#" class="btn-skyline">단체전 신청하기</a>
            </p>
          </li>
        </ul>
      </div> -->
    </div>
  </div>
  <!-- E : sub -->
  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
    <!-- S: sche-table modal -->
  <div class="sche-table modal fade confirm-modal" id="sche-table" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="http://img.sportsdiary.co.kr/sdapp/public/close-x@3x.png" alt="닫기"></span></button>
        <h4 class="modal-title" id="myModalLabel">일정표</h4>
      </div>
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: sche-title -->
        <div class="sche-title">
          <h2>2016 제주컵 유도대회</h2>
          <p class="match-term">2016년11월26일(토)~30일(수)</p>
        </div>
        <!-- E: sche-title -->
        <!-- S: stadium -->
        <div class="stadium">
          <p>경기장: 제주, 한라체육관</p>
        </div>
        <!-- E: stadium -->
        <!-- S: match-day -->
        <div class="match-day">
          <select name="">
            <option value="0">2016년 11월 27일(일)</option>
            <option value="1">2016년 11월 27일(일)</option>
            <option value="2">2016년 11월 27일(일)</option>
          </select>
        </div>
        <!-- E: match-day -->
        <!-- S: match-list -->
        <div class="match-list">
          <h3>[개인전]</h3>
          <!-- S: 체급 -->
          <dl>
           <dt>남중부(7체급)</dt>
           <dd>-45kg,-48kg,-51kg,-55kg,-60kg,-66kg,-73kg</dd>
          </dl>
          <!-- E: 체급 -->
          <!-- S: 체급 -->
          <dl>
            <dt>여중부(5체급)</dt>
            <dd>-42kg,-45kg,-48kg,-52kg,-57kg</dd>
          </dl>
          <!-- E: 체급 -->
          <!-- S: 체급 -->
          <dl>
            <dt>남고부(5체급)</dt>
            <dd>-55kg,-60kg,-66kg,-73kg,-81kg</dd>
          </dl>
          <!-- E: 체급 -->
          <!-- S: 체급 -->
          <dl>
            <dt>여고부(5체급)</dt>
            <dd>-45kg,-48kg,-52kg,-57kg,-63kg</dd>
          </dl>
          <!-- E: 체급 -->
        </div>
        <!-- E: match-list -->
        <!-- S: time-table -->
          <div class="time-table">
            <ul>
              <li class="clearfix">
                <span class="time">10:00 ~</span>
                <span class="cont">경기시작</span>
              </li>
              <li class="now clearfix">
                <span class="time">11:00 ~</span>
                <span class="cont">개회식</span>
              </li>
              <li class="clearfix">
                <span class="time">17:00 ~</span>
                <span class="cont">결승 및 시상식(예정)</span>
              </li>
              <li class="clearfix">
                <span class="time">17:00 ~ 17:30</span>
                <span class="cont">공식계체(11.28일 참가선수)</span>
              </li>
            </ul>
          </div>
          <!-- E: time-table -->
      </div>
      <!-- E: modal-body -->
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
  <!-- E: sche-table modal -->
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
