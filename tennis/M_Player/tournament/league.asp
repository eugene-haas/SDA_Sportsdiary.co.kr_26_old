<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<script src="/webtournament/www/js/global.js"></script>
<body>
  <a href="#" data-target="#show-tourney-pop" data-toggle="modal" class="init_btn"></a>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대진표</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub sub-main -->
  <div class="sub sub-main tourney h-fix">
    <!-- S: tourney-title -->
    <div class="tourney-title">
      <h3>제 16회 제주컵 유도대회</h3>
    </div>
    <!-- E: tourney-title -->
    <!-- S: tourney-sel -->
    <div class="tourney-sel">
      <ul class="clearfix">
        <li>
          <select name="">
            <option value="0">개인전</option>
            <option value="1">단체전</option>
          </select>
        </li>
        <li>
          <select name="">
            <option value="0">남자초등부</option>
            <option value="1">여자초등부</option>
            <option value="2">남자증등부</option>
            <option value="3">여자중등부</option>
          </select>
        </li>
        <li>
          <select name="">
            <option value="0">-32kg</option>
            <option value="1">-36kg</option>
            <option value="2">-42kg</option>
          </select>
        </li>
      </ul>
    </div>
    <!-- E: tourney-sel -->
    <!-- S: tourney-info -->
    <div class="tourney-info">
      <p>
        <span>개인전</span>
        <span>고등부</span>
        <span>남자+100kg</span>
      </p>
    </div>
    <!-- E: tourney-info -->
    <!-- S: medal-list -->
    <div class="medal-list">
      <ul class="clearfix scroll-x">
        <li class="golden">
          <span class="medal"></span>
          <span class="player">장선우</span>
          <span class="belong">서울체육고등학교</span>
        </li>
        <li class="silver">
          <span class="medal"></span>
          <span class="player">이상준</span>
          <span class="belong">영서고등학교</span>
        </li>
        <li class="bronze">
          <span class="medal"></span>
          <span class="player">이상준</span>
          <span class="belong">영서고등학교</span>
        </li>
        <li class="bronze">
          <span class="medal"></span>
          <span class="player">이상준</span>
          <span class="belong">영서고등학교</span>
        </li>
      </ul>
    </div>
    <!-- E: medal-list -->
  </div>
  <!-- E: sub sub-main -->
  <!-- S: container -->
  <div class="container">
    <!-- S: list_league -->
    <div id="list_league" class="list_league">
      <table border="1">
        <tbody>
          <tr>
            <td>제1조</td>
            <td>
              <p class="player-name"><span class="pre-num">1</span>우예림</p>
              <p class="player-school">삼산초등학교</p>
            </td>
            <td>
              <p class="player-name"><span class="pre-num">2</span>문려원</p>
              <p class="player-school">솔샘초등학교</p>
            </td>
            <td>
              <p class="player-name"><span class="pre-num">3</span>김보경</p>
              <p class="player-school">솔샘초등학교</p>
            </td>
            <td class="score">승패(점수)</td>
            <td class="rank">순위</td>
          </tr>
          <tr>
            <td>
              <p class="player-name"><span class="pre-num">1</span>우예림</p>
              <p class="player-school">삼산초등학교</p>
            </td>
            <td class="no"></td>
            <td class="write">
              <p class="player-name"><span>우예림</span> <span>vs</span> <span>문려원</span></p><a href="#" class="btn btn-write" onclick="mov_enterscore(this);" data-id="1"  data-toggle="modal" data-target=".groups-res"data-whatever="01">기록보기</a></td>
            <td class="write">
              <p class="player-name"><span>우예림</span> <span>vs</span> <span>김보경</span></p>
              <a href="#" class="btn btn-write" onclick="mov_enterscore(this);" data-id="2" data-whatever="01" data-toggle="modal" data-target=".film-modal">기록보기</a>
            </td>
            <td class="score">0승0무0패(0)</td>
            <td class="rank">0</td>
          </tr>
          <tr>
            <td>
              <p class="player-name"><span class="pre-num">2</span>문려원</p>
              <p class="player-school">솔샘초등학교</p>
            </td>
            <td class="write">
              <p class="player-name"><span>문려원</span> <span>vs</span> <span>우예림</span></p>
              <a href="#" class="btn btn-write" onclick="mov_enterscore(this);" data-id="3" data-whatever="01" data-toggle="modal" data-target=".film-modal">기록보기</a>
            </td>
            <td class="no"></td>
            <td class="write">
              <p class="player-name"><span>문려원</span> <span>vs</span> <span>김보경</span></p>
              <a href="#" class="btn btn-write" onclick="mov_enterscore(this);" data-id="3" data-whatever="01" data-toggle="modal" data-target=".film-modal">기록보기</a>
            </td>
            <td class="score">0승0무1패(0)</td>
            <td class="rank">2</td>
          </tr>
          <tr>
            <td>
              <p class="player-name"><span class="pre-num">3</span>김보경</p>
              <p class="player-school">솔샘초등학교</p>
            </td>
            <td class="write">
              <p class="player-name"><span>김보경</span> <span>vs</span> <span>우예림</span></p>
              <a href="#" class="btn btn-write" onclick="mov_enterscore(this);" data-id="3" data-whatever="01" data-toggle="modal" data-target=".film-modal">기록보기</a>
            </td>
            <td class="write">
              <p class="player-name"><span>김보경</span> <span>vs</span> <span>문려원</span></p>
              <a href="#" class="btn btn-write" onclick="mov_enterscore(this);" data-id="3" data-whatever="01" data-toggle="modal" data-target=".film-modal">기록보기</a>
            </td>
            <td class="no"></td>
            <td class="score">1승0무0패(100)</td>
            <td class="rank">1</td>
          </tr>
        </tbody>
      </table>
    </div>
    <!-- E: list_league -->
  </div>
  <!-- E: container -->

    <!-- S: 영상보기 모달 modal -->
  <div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"><div class="modal-backdrop fade in"></div>
  <!-- S: modal-dialog -->
  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content">
      <div class="modal-header clearfix">
        <h3 class="center">상세 스코어</h3>
        <a href="#" data-dismiss="modal">&times;</a>
      </div>
      <!-- E: modal-content -->
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: pracice-score -->
         <div id="modal_score" class="pracice-score" style="width: 100%">
          <h4><span>한판승</span></h4>
            <!-- S: pop-point-display -->
            <div class="pop-point-display">
              <!-- S: display-board -->
              <div class="display-board clearfix">
                <!-- S: point-display -->
                <div class="point-display clearfix">
                  <ul class="point-title flex">
                    <li>선수</li>
                    <li>한판</li>
                    <li>절반</li>
                    <!-- <li>유효</li> -->
                    <li>지도</li>
                    <li>반칙/실격/<br>부전/기권 승</li>
                  </ul>
                  <ul class="player-1-point player-point flex">
                    <li>
                      <a onclick="#"><span class="disp-none"></span><span class="player-name" id="DP_Edit_LPlayer">홍길동</span>
                      <p class="player-school" id="">충남체육고</p></a>
                      <p class="vs">vs</p>
                    </li>
                    <li class="tgClass">
                     <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1">0</span></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                    </li>
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_R_GameResult">
                        <option value="">선택</option>
                        <option value="">반칙</option>
                        <option value="">실격</option>
                        <option value="">부전</option>
                        <option value="">기권</option>
                      </select>
                    </li>
                  </ul>
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
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_R_GameResult">
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
          <!-- E: pracice-score -->
        </div>
        <!-- E: -->
        <!-- S: container -->
        <div class="container" >
          <!-- S: 기록보기 record-box -->
          <div  id="modal_container" class="record-box panel" style="display: block;">
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
          <!-- E: 기록보기 record-box -->
          <!-- S: 영상보기 film-box -->
          <div class="film-box panel" style="display: none;">
            <iframe width="100%" height="160" src="https://www.youtube.com/embed/CtVHss3U3WA" frameborder="0" allowfullscreen=""></iframe>
          </div>
          <!-- E: 영상보기 film-box -->
        </div>
        <!-- E: container -->
      </div>
      <!-- E: modal-body -->
      <!-- S: modal-footer -->
      <div class="modal-footer">
        <!-- S: btn-list -->
        <div class="btn-list flex">
          <button type="button" class="btn btn-orange btn-film" style="display: block;"><span class="ic-deco"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""></span>영상보기</button>
           <button type="button" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
        <!-- E: btn-list -->
     </div>
    <!-- E: modal-footer -->
   </div>
  <!-- E: modal-dialog -->
  </div>
  <!-- E: 영상보기 모달 modal -->

    <!-- S: 영상보기 모달 modal -->
  <div class="modal fade film-modal" id="show-score" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="false"><div class="modal-backdrop fade in"></div>
  <!-- S: modal-dialog -->
  <div class="modal-dialog">
    <!-- S: modal-content -->
    <div class="modal-content">
      <div class="modal-header clearfix">
        <h3 class="center">상세 스코어</h3>
        <a href="#" data-dismiss="modal">&times;</a>
      </div>
      <!-- E: modal-content -->
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: pracice-score -->
         <div id="modal_score" class="pracice-score" style="width: 100%">
          <h4><span>한판승</span></h4>
            <!-- S: pop-point-display -->
            <div class="pop-point-display">
              <!-- S: display-board -->
              <div class="display-board clearfix">
                <!-- S: point-display -->
                <div class="point-display clearfix">
                  <ul class="point-title flex">
                    <li>선수</li>
                    <li>한판</li>
                    <li>절반</li>
                    <!-- <li>유효</li> -->
                    <li>지도</li>
                    <li>반칙/실격/<br>부전/기권 승</li>
                  </ul>
                  <ul class="player-1-point player-point flex">
                    <li>
                      <a onclick="#"><span class="disp-none"></span><span class="player-name" id="DP_Edit_LPlayer">홍길동</span>
                      <p class="player-school" id="">충남체육고</p></a>
                      <p class="vs">vs</p>
                    </li>
                    <li class="tgClass">
                     <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb1">0</span></a>
                    </li>
                    <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb2">0</span></a>
                    </li>
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="LJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="LJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_R_GameResult">
                        <option value="">선택</option>
                        <option value="">반칙</option>
                        <option value="">실격</option>
                        <option value="">부전</option>
                        <option value="">기권</option>
                      </select>
                    </li>
                  </ul>
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
                    <!-- <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score" id="RJumsuGb3">0</span></a>
                    </li> -->
                    <li class="tgClass">
                      <a class="" onclick="#" name="a_jumsugb"><span class="score txt-orange" id="RJumsuGb4">0</span></a>
                    </li>
                    <li>
                      <select class="select-win select-box" id="DP_R_GameResult">
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
          <!-- E: pracice-score -->
        </div>
        <!-- E: -->
        <!-- S: container -->
        <div class="container" >
          <!-- S: 기록보기 record-box -->
          <div  id="modal_container" class="record-box panel" style="display: block;">
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
          <!-- E: 기록보기 record-box -->
          <!-- S: 영상보기 film-box -->
          <div class="film-box panel" style="display: none;">
            <iframe width="100%" height="160" src="https://www.youtube.com/embed/CtVHss3U3WA" frameborder="0" allowfullscreen=""></iframe>
          </div>
          <!-- E: 영상보기 film-box -->
        </div>
        <!-- E: container -->
      </div>
      <!-- E: modal-body -->
      <!-- S: modal-footer -->
      <div class="modal-footer">
        <!-- S: btn-list -->
        <div class="btn-list flex">
          <button type="button" class="btn btn-orange btn-film" style="display: block;"><span class="ic-deco"><img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""></span>영상보기</button>
           <button type="button" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
          <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
        </div>
        <!-- E: btn-list -->
     </div>
    <!-- E: modal-footer -->
   </div>
  <!-- E: modal-dialog -->
  </div>
  <!-- E: 영상보기 모달 modal -->

  <!-- S: 영상보기 단체전 모달 -->
  <div class="modal fade round-res groups-res" id="groupround-res" tabindex="-1" role="dialog" aria-labelledby="modal-title" aria-hidden="true" style="display: none;"><div class="modal-backdrop fade in"></div>
    <div class="modal-dialog">

    <div class="modal-content">
      <!-- S: modal-header -->
      <div class="modal-header chk-score">
        <h4 class="modal-title">상세스코어</h4>
        <a href="#" data-dismiss="modal">×</a>
      </div>
      <!-- E: modal-header -->
      <div class="modal-body group-modal">
        <h2><span class="left-arrow"><img src="../../WebTournament/www/images/tournerment/tourney/yellow-larr.png" alt=""></span><span id="iWinTeamNm">경민IT고등학교</span><span class="right-arrow"><img src="../../WebTournament/www/images/tournerment/tourney/yellow-rarr.png" alt=""></span><br><div id="iWinTeamPoint">(2011)</div>
        </h2>
        <!-- S: display-board -->
        <div class="display-board clearfix">
          <ul>
            <li class="" id="iLTeamNm">울산생활과학고등학교</li>
            <li id="iDP_LResult">0승5패<br>(505)</li>
          </ul>
          <div class="v-s">
            VS
          </div>
          <ul class="away">
            <li id="iRTeamNm" class="win">경민IT고등학교</li>
            <li id="iDP_RResult">5승0패<br>(2011)</li>
          </ul>
        </div>
        <!-- E: display-board -->
        <!-- S:record -->
        <div class="record record-box">
            <div class="home-team" id="iLTeamGroup">
            <ul class="title clearfix">
              <li>선수명</li>
              <li>체급</li>
              <li>승패</li>
            </ul>
          <ul class="clearfix">
            <li>김주윤</li>
            <li></li>
            <li></li>
          </ul>
          <ul class="clearfix">
            <li>김현지</li>
            <li></li>
            <li></li>
          </ul>
          <ul class="clearfix">
            <li>유은지</li>
            <li></li>
            <li></li>
          </ul>
          <ul class="clearfix">
            <li>유현지</li>
            <li></li>
            <li></li>
          </ul>
          <ul class="clearfix">
            <li>김민경</li>
            <li></li>
            <li></li>
          </ul>
        </div>
         <!-- <div class="v-s">
              VS
         </div> -->
        <div class="away-team" id="iRTeamGroup">
          <ul class="title clearfix">
            <li>승패</li>
            <li>체급</li>
            <li>선수명</li>
          </ul>
         <ul class="clearfix">
            <li>승</li>
            <li></li>
            <li>이수빈</li>
          </ul>
          <ul class="clearfix">
            <li>승</li>
            <li></li>
            <li>임보영</li>
          </ul>
          <ul class="clearfix">
            <li>승</li>
            <li></li>
            <li>정이주</li>
          </ul>
          <ul class="clearfix">
            <li>승</li>
            <li></li>
            <li>김은솔</li>
          </ul>
          <ul class="clearfix">
            <li>승</li>
            <li></li>
            <li>최홍영</li>
          </ul>
        </div>
        </div>
        <!-- E: record -->
        <!-- S: 영상보기 film-box -->
        <div class="film-box panel" style="display: none;">
          <iframe width="100%" height="160" src="https://www.youtube.com/embed/CtVHss3U3WA" frameborder="0" allowfullscreen=""></iframe>
        </div>
        <!-- E: 영상보기 film-box -->
      <!-- S: modal footer -->
      <div class="modal-footer">
      <!-- S: btn-list -->
      <div class="btn-list flex">
        <button type="button" class="btn btn-orange btn-film" style="display: block;">
          <span class="ic-deco">
            <img src="http://img.sportsdiary.co.kr/sdapp/stats/film-icon@3x.png" alt=""></span>영상보기</button>
        <button type="button" class="btn btn-orange btn-record" style="display: none;">기록보기</button>
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
      <!-- E: btn-list -->
      </div>
      <!--E: modal-footer -->
      </div>
      <!-- E: modal-body -->
    </div>
    <!-- modal-content -->
    </div>
    <!-- modal-dialog -->
  </div>
  <!-- E: 영상보기 모달 단체전 -->

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
