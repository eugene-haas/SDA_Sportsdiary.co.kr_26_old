<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>대회영상모음</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <!-- S: sub -->
  <div class="sub">
    <!-- S: main stat-record -->
    <div class="main stat-record">
      <div class="stat-film-title">
        <h3>제16회 제주컵 유도대회 <span>대회기간: 2016년 3월 25일 ~ 28일 (3일간)</span></h3>
      </div>
      <!-- S: 개인전 stat-film -->
      <section class="stat-film">
        <div class="div-title">
          <h4>개인전 [금메달]</h4>
          <p class="list-info"><span>고등부</span><span>남자</span><span>-66kg</span></p>
        </div>
        <!-- S: container -->
        <div class="container">
          <ul class="stat-list">
            <li class="clearfix">
              <span class="cut-off">결승</span>
              <span class="stat-txt">홍길동 vs 김지훈 (승) / 한판</span>
              <a href="#" class="show-film" data-target="#showFilm" data-toggle="modal"><img src="../images/stats/film-icon@3x.png" alt="대회영상보기"></a>
            </li>
            <li class="clearfix">
              <span class="cut-off">준결승</span>
              <span class="stat-txt">홍길동 vs 김지훈 (승) / 한판</span>
              <a href="#" class="show-film" data-target="#showFilm" data-toggle="modal"><img src="../images/stats/film-icon@3x.png" alt="대회영상보기"></a>
            </li>
            <li class="clearfix">
              <span class="cut-off">8강</span>
              <span class="stat-txt">홍길동 vs 김지훈 (승) / 한판</span>
              <a href="#" class="show-film" data-target="#showFilm" data-toggle="modal"><img src="../images/stats/film-icon@3x.png" alt="대회영상보기"></a>
            </li>
            <li class="clearfix">
              <span class="cut-off">16강</span>
              <span class="stat-txt">홍길동 vs 김지훈 (승) / 한판</span>
              <a href="#" class="show-film" data-target="#showFilm" data-toggle="modal"><img src="../images/stats/film-icon@3x.png" alt="대회영상보기"></a>
            </li>
            <li class="clearfix">
              <span class="cut-off">32강</span>
              <span class="stat-txt">홍길동 vs 김지훈 (승) / 한판</span>
              <a href="#" class="show-film" data-target="#showFilm" data-toggle="modal"><img src="../images/stats/film-icon@3x.png" alt="대회영상보기"></a>
            </li>
          </ul>
        </div>
        <!-- E: container -->
      </section>
      <!-- E: 개인전 stat-film -->
    </div>
    <!-- E: main stat-record -->
  </div>
  <!-- E : sub -->
  <!-- S: 영상보기 모달 modal -->
  <div class="modal fade show-film" id="showFilm" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><img src="../images/stats/x@3x.png" alt="닫기"></button>
          <h4 class="modal-title" id="myModalLabel">대회영상보기</h4>
        </div>
        <div class="modal-body">
          ...
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
      </div>
    </div>
  </div>
  <!-- E: 영상보기 모달 modal -->
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