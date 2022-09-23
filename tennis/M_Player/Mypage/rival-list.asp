<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<body class="lack-bg">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>연습 상대 관리</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub mypage">
    <ul class="top-list">
      <li>&middot; 연습게임 및 실전 경기에서 상대방 선수의 특징을 기록하여 실력향상에 도움이 될 수 있습니다.</li>
      <li>&middot; 리스트에서 상대선수를 수정이 가능하며, 상대선수를 신규로 추가할 수 있습니다.</li>
    </ul>
    <div class="rival-list-wrap">
      <a href="#" class="btn-full-white">연습 상대선수 등록</a>
      <ul class="rival-list">
        <li>
          <a href="#" data-target="#regist-modal" data-toggle="modal">
            <p>
              <span class="rival-name">김희주(용인고)</span>
              <span class="icon-navy">오른손/오른쪽 기술사용</span>
            </p>
            <p><img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon-more@3x.png" alt="자세히 보기" /></p>
          </a>
        </li>
        <li>
          <a href="#" data-target="#regist-modal" data-toggle="modal">
            <p>
              <span class="rival-name">강하나(대한체고)</span>
              <span class="icon-navy">왼손/양쪽 기술사용</span>
            </p>
            <p><img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon-more@3x.png" alt="자세히 보기" /></p>
          </a>
        </li>
      </ul>
    </div>
  </div>
  <!-- E : sub -->
  <!-- S: 연습상대 신규 등록, 조회, 수정 modal -->
  <div class="modal fade confirm-modal rival-modal" id="regist-modal" tabindex="-1" role="dialog" aria-labelledby="" aria-hidden="true">
    <div class="modal-dialog">
      <div class="modal-content modal-small">
        <!-- 신규 -->
        <div class="modal-header">연습 상대선수 신규등록<a href="#" data-dismiss="modal" class="close"><img src="http://img.sportsdiary.co.kr/sdapp/stats/x@3x.png" alt="닫기"></a></div>
        <!-- 조회 및 수정
        <div class="modal-header">연습 상대선수 조회 및 수정</div> -->
        <div class="modal-body">
          <ul class="modal-list">
            <li class="clearfix">
              <p><label for="rival-name-pop">선수명</label></p>
              <p><input type="text" id="rival-name-pop" /></p>
            </li>
            <li class="clearfix">
              <p>사용손</p>
              <p>
                <select>
                  <option>사용 손 선택</option>
                </select>
              </p>
            </li>
            <li class="clearfix">
              <p>특기</p>
              <p>
                <select>
                  <option>손기술</option>
                </select>
              </p>
            </li>
          </ul>
          <div class="scroll-box">
            <ul class="rival-check-list">
              <li>
                <label class="img-replace"><input type="checkbox"><span>업어치기</span></label>
              </li>
              <li>
                <label class="img-replace"><input type="checkbox"><span>한팔 업어치기</span></label>
              </li>
              <li>
                <label class="img-replace"><input type="checkbox"><span>양소매 업어치기</span></label>
              </li>
              <li>
                <label class="img-replace"><input type="checkbox"><span>한소매 업어치기</span></label>
              </li>
              <li>
                <label class="img-replace">
                <input type="checkbox"><span>외깃 업어치기</span></label>
              </li>
              <li>
                <label class="img-replace">
                <input type="checkbox"><span>빗당겨치기</span></label>
              </li>
            </ul>
          </div>
          <ul class="rival-select-list">
            <li>[손기술] 업어치기 <a href="#" class="btn-delete"><span class="glyphicon glyphicon-remove"></span></a></li>
            <li>[손기술] 한팔 업어치기 <a href="#" class="btn-delete"><span class="glyphicon glyphicon-remove"></span></a></li>
            <li>[손기술] 외깃 업어치기 <a href="#" class="btn-delete"><span class="glyphicon glyphicon-remove"></span></a></li>
          </ul>
          <textarea id="" placeholder="특이사항을 입력해주세요" class="txt-gray"></textarea>
          <div class="btn-center">
            <a href="#" class="btn-left">취소</a>
            <a href="#" class="btn-right" data-dismiss="modal">등록</a>
          </div>
          <!-- 조회 및 수정일 경우 -->
          <div class="btn-center">
            <a href="#" class="btn-left">선수삭제</a>
            <a href="#" class="btn-right">수정완료</a>
          </div>
        </div>
      </div>
      <!-- ./ modal-content -->
    </div> <!-- ./modal-dialog -->
  </div>
  <!-- E : 연습상대 신규 등록, 조회, 수정 modal -->
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
