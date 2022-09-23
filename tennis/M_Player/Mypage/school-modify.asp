<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<body class="lack-bg">
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>변경할 소속 선택</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub mypage pt13">
    <form>
      <fieldset>
        <legend>선수 소속 변경하기</legend>
        <div class="content">
          <ul class="player-school">
            <li>
              <p class="number img-replace"><strong>1</strong></p>
              <p>
                <select>
                  <option>소속구분</option>
                </select>
              </p>
            </li>
            <li>
              <p class="number img-replace"><strong>2</strong></p>
              <p>
                <select>
                  <option>지역선택</option>
                </select>
              </p>
            </li>
            <li>
              <p><strong>3</strong></p>
              <p>
                <select>
                  <option>소속선택</option>
                </select>
              </p>
            </li>
          </ul>
        </div>
      </fieldset>
    </form>
    <div class="container">
      <div class="txt-join">
      * 소속이름을 잘못 선택 하여 가입한 경우 또는 본인의 소속이름이
        없을 경우, 스포츠다이어리팀 담당에게 연락하여 변경요청 바랍니다.
        <span>(스포츠다이어리팀 담당: 070-7493-8111)</span>
      </div>
      <div class="btn-center">
        <a href="#" class="btn-left">취소</a>
        <a href="#" class="btn-right">적용</a>
      </div>
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
