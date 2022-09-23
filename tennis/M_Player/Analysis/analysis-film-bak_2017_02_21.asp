<!-- #include file="../include/config.asp" -->
<!-- google chart -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<!-- fusionchart api -->
<script src="../js/library/fusioncharts.js"></script>
<script src="../js/library/fusioncharts.theme.fint.js"></script>
<script src="../js/library/fusioncharts.charts.js"></script>
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>선수분석</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <!-- S: record-menu -->
  <div class="record-menu stat-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li>
          <a href="#" class="btn">대회득실점</a>
        </li>
        <li>
          <a href="#" class="btn">상대성</a>
        </li>
        <li>
          <a href="#" class="btn on">전적</a>
        </li>
      </ul>
    </div>
    <div class="menu-list mid-cat">
      <ul class="rank-mid clearfix" style="display: block;">
        <li><a href="#">선수프로필</a></li>
        <li><a href="#">입상현황</a></li>
        <li><a href="#" class="on">대회영상모음</a></li>
        <li><a href="#">대회영상즐겨찾기<span class="icon-on-favorite">★</span></a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

    <!-- S: record-input -->
  <div class="record-input">
   
<!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 -->
      <dl class="clearfix">
        <dt>년도</dt>
        <dd>
          <select name="">
            <option value="">2016년</option>
            <option value="">2017년</option>
            <option value="">2018년</option>
          </select>
        </dd>
      </dl>
      <!-- E: 기간 -->
      <!-- S: 대회명 -->
      <dl class="clearfix">
        <dt>대회명</dt>
        <dd>
          <select name="">
            <option value="">::대회명을 선택하세요::</option>
            <option value="">::대회명을 선택하세요::</option>
            <option value="">::대회명을 선택하세요::</option>
          </select>
        </dd>
      </dl>
      <!-- E: 대회명 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list">
      <a href="#" class="btn-left btn">닫기</a>
      <a href="#" class="btn-right btn">조회</a>
    </div>
  </div>

  <!-- S: tail -->
  <div class="tail short-tail">
    <a href="#"><img src="../images/record/close-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->
  
  <!-- S: main stat-record -->
  <div class="main stat-record">
      <div class="stat-film-title">
        <p class="stat-year container">2017년</p>
        <h3>제16회 제주컵 유도대회 <span>대회기간: 2016년 3월 25일 ~ 28일 (3일간)</span></h3>
      </div>
      <!-- S: 개인전 stat-film -->
      <section class="stat-film">
        <div class="div-title">
          <h4>개인전 [금메달]</h4>
          <!-- <p class="list-info"><span>개인전</span><span>고등부</span><span>남자 -66kg</span></p> -->
        </div>
        <!-- S: container -->
        <div class="ana container">
          <dl class="stat-list">
            <dt>
              <span class="icon-favorite">★</span>
              <span>결승</span>
              <a href="#" class="show-film" data-target="#show-score" data-toggle="modal"><img src="../images/stats/film-icon@3x.png" alt="대회영상보기"></a>
            </dt>
            <dd>
              <ul>
                <li>
                  <p class="me">홍길동<span class="school">서울체육고등학교</span></p>
                  <p class="vs">VS</p>
                  <p class="you">김지훈(한판승)<span class="school">서울중앙고등학교</span></p>
                </li>
              </ul>
            </dd>
          </dl>
        </div>
        <!-- E: container -->
      </section>
      <!-- E: 개인전 stat-film -->
      <!-- S: 단체전 stat-film -->
      <section class="stat-film group">
        <div class="div-title">
          <h4>단체전 [8강]</h4>
          <!-- <p class="list-info"><span>단체전</span><span>고등부</span><span>남자</span></p> -->
        </div>
        <!-- S: container -->
        <div class="ana container">
          <dl class="stat-list">
            
          </dl>
        </div>
        <!-- E: container -->
      </section>
      <!-- E: 단체전 stat-film -->
  </div>
  <!-- E: main stat-record -->

  <!-- S: footer -->
  <div class="footer light-footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: 상세보기 모달 -->
  <div class="modal fade" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content">
        <div class="modal-header clearfix">
          <h3 class="center">상세 스코어</h3>
          <a href="#" data-dismiss="modal"><img src="../images/stats/x@3x.png" alt="닫기"></a>
        </div>
        <div class="modal-body">
           <div class="pracice-score" style="width: 100%">
          <!-- S: pop-point-display -->
                  <div class="pop-point-display">
                    <!-- S: display-board -->
                    <div class="display-board clearfix">
                      <!-- S: point-display -->
                      <div class="point-display clearfix">
                        <ul class="point-title flex">
                          <li>&nbsp;</li> 
                          <li>한판</li>
                          <li>절반</li>
                          <li>유효</li>
                          <li>지도</li>
                          <li>반칙/실격/<br />부전/기권 승</li>
                        </ul>
                        <ul class="player-1-point player-point flex">
                          <li>
                            <a onclick="#"><span class="disp-win"></span><span class="player-name" id="DP_Edit_LPlayer">홍길동</span>
                            <p class="player-school" id="">충남체육고</p></a>
                          </li>
                          <li class="tgClass">
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
                          <li>
                            <select class="select-win select-box" id="DP_R_GameResult" >
                              <option value="">선택</option>
                              <option value="">반칙</option>
                              <option value="">실격</option>
                              <option value="">부전</option>
                              <option value="">기권</option>
                            </select>
                          </li>
                        </ul>
                        <p class="vs">vs</p>
                        <ul class="player-2-point player-point flex">
                          <li>
                            <a onclick="#"><span class="disp-none"></span><span class="player-name" id="DP_Edit_RPlayer">이의준</span>
                            <p class="player-school" id="">서울명덕초</p></a>
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
                          <li>
                            <select class="select-win select-box" id="DP_R_GameResult" >
                              <option value="">선택</option>
                              <option value="">반칙</option>
                              <option value="">실격</option>
                              <option value="">부전</option>
                              <option value="">기권</option>
                            </select>
                          </li>
                        </ul>
                        <!-- E: point-display -->
                      </div>
                      <!-- E: point-display -->
                      </div>
                    <!-- E: display-board -->
                  </div>
                  <!-- E: pop-point-display -->
                </div>
                <!-- <ul class="pracice-time">
                  <li><a href="#">05:00~04:01</a></li>
                  <li class="on"><a href="#">04:00~03:01</a></li>
                  <li><a href="#">03:00~02:01</a></li>
                  <li><a href="#">02:00~01:01</a></li>
                  <li><a href="#">01:00~00:01</a></li>
                  <li><a href="#">골든스코어</a></li>
                  <li>
                    <label class="on">
                      <input type="radio" name="pt" style="width: 1px; height: 1px; margin: -1px; overflow: hidden; clip: rect(0,0,0,0);">
                      <span>05:00~04:01</span>
                    </label>
                  </li>
                  <li>
                    <label>
                      <input type="radio" name="pt">
                      <span>05:00~04:01</span>
                    </label>
                  </li>
                  <li>
                    <label>
                      <input type="radio" name="pt">
                      <span>05:00~04:01</span>
                    </label>
                  </li>
                  <li>
                    <label>
                      <input type="radio" name="pt">
                      <span>05:00~04:01</span>
                    </label>
                  </li>
                  <li>
                    <label>
                      <input type="radio" name="pt">
                      <span>05:00~04:01</span>
                    </label>
                  </li>
                  <li>
                    <label>
                      <input type="radio" name="pt">
                      <span>05:00~04:01</span>
                    </label>
                  </li>
                </ul> -->
              </div>
              <div class="container">
                <h3>득실기록</h3>
                <ul class="plactice-txt">
                  <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                  <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                  <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                  <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                  <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                  <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                  <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                  <li class="pratice-txt-blue">[3:20]이의준: 지도(허리채기)</li>
                  <li class="pratice-txt-white">[2:13]홍길동: 절반(기타누으며 메치기)</li>
                </ul>
              </div>
                  </div>
                  <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
                  </div>
                </div>
              </div>
            </div>
  </div>
  <!-- E: 상세보기 모달 -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>