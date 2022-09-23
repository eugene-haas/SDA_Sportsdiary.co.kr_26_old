<!-- #include file="../include/config.asp" -->
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>나의 통계</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: record-menu -->
  <div class="record-menu stat-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li>
          <a href="#" class="btn">훈련참석정보</a>
        </li>
        <li>
          <a href="#" class="btn">공식훈련</a>
        </li>
        <li>
          <a href="#" class="btn">개인훈련</a>
        </li>
        <li>
          <a href="#" class="btn">부상정보</a>
        </li>
        <li>
          <a href="#" class="btn">체력측정결과</a>
        </li>
        <li>
          <a href="#" class="btn">전적</a>
        </li>
        <li>
          <a href="#" class="btn on">연습경기</a>
        </li>
        <li>
          <a href="#" class="btn">대회득실점</a>
        </li>
        <li>
          <a href="#" class="btn">상대성</a>
        </li>
      </ul>
    </div>
    <div class="mid-cat">
      <ul class="rank-mid menu-list clearfix">
        <li><a href="#" class="on">경기현황</a></li>
        <li><a href="#">점수별 득실점</a></li>
        <li><a href="#">기술별 득실점</a></li>
        <li><a href="#">시간대별 득실점</a></li>
        <li><a href="#">상대성</a></li>
      </ul>
    </div>
  </div>
  <!-- E: record-menu -->

  <!-- S: tail -->
  <div class="tail short-tail">
    <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->

  <!-- S: state-cont exc-match -->
  <div class="state-cont exc-match">
    <!-- S: match-list -->
    <section class="match-group">
      <h3>기간별 승률 <span class="avg">30전 27승 2패</span></h3>
      <ul class="match-list">
        <li class="clearfix">
          <p><span>[6월24일]</span>홍길동/(승)유효</p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
        <li class="clearfix">
          <p><span>[7월12일]</span>홍길동/(승)한판</p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
        <li class="clearfix">
          <p><span>[7월15일]홍길동/(승)유효</span></p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
        <li class="clearfix">
          <p><span>[7월15일]홍길동/(승)유효</span></p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
        <li class="clearfix">
          <p><span>[7월15일]홍길동/(승)유효</span></p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
        <li class="clearfix">
          <p><span>[7월15일]홍길동/(승)유효</span></p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
        <li class="clearfix">
          <p><span>[7월15일]홍길동/(승)유효</span></p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
        <li class="clearfix">
          <p><span>[7월15일]홍길동/(승)유효</span></p><a href="#" data-toggle="modal" data-target="#show-score">상세보기</a>
        </li>
      </ul>
    </section>
    <!-- E: match-list -->
  </div>
  <!-- E: state-cont exc-match -->
  <!-- S: footer -->
  <div class="footer">
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
          <a href="#" data-dismiss="modal"><img src="http://img.sportsdiary.co.kr/sdapp/stats/x@3x.png" alt="닫기"></a>
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
