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
