<!-- #include file="../include/config.asp" -->
<!-- #include file="../include/tn_config.asp" -->
<link rel="stylesheet" href="../css/library/jquery-ui.css">
<script src="../js/library/jquery-ui.min.js"></script>
<script src="../js/library/datepicker-ko.js"></script>
<script>
  // hori_gnb 활성화 상태 index
  var bigCatIdx = 0;
</script>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>난타 모집</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: hori_gnb -->
  <!-- #include file = "./hori_gnb.asp" -->
  <!-- E: hori_gnb -->

<!-- S: bg-ipt -->
  <div class="srch_condi bg-ipt">
    <!-- S: sel-list -->
    <ul class="sel-list">
      <!-- S: sel_2 -->
      <li class="sel_2">
        <!-- S: 성별-->
        <dl class="clearfix">
          <dt>성별</dt>
          <dd class="sel_box">
            <select>
              <option>전체</option>
              <option>남자</option>
              <option>여자</option>
            </select>
          </dd>
        </dl>
        <!-- E: 성별 -->

        <!-- S: 연령 -->
        <dl class="clearfix">
          <dt>연령</dt>
          <dd class="sel_box">
            <select>
              <option>10대</option>
              <option>20대</option>
              <option>30대</option>
              <option>40대</option>
              <option>50대</option>
            </select>
          </dd>
        </dl>
        <!-- E: 연령 -->
      </li>
      <!-- E: sel_2 -->

      <!-- S: sel_2 -->
      <li class="sel_2">
        <!-- S: 구력 -->
        <dl class="clearfix">
          <dt>구력</dt>
          <dd class="sel_box">
            <select>
              <option>1년이하</option>
              <option>1년이상</option>
              <option>1년이상</option>
              <option>1년이상</option>
            </select>
          </dd>
        </dl>
        <!-- E: 구력 -->

        <!-- S: 모집 상태 -->
        <dl class="clearfix">
          <dt>모집상태</dt>
          <dd class="sel_box">
            <select>
              <option>전체</option>
              <option>모집중</option>
              <option>모집완료</option>
            </select>
          </dd>
        </dl>
        <!-- E: 모집 상태 -->
      </li>
      <!-- E: sel_2 -->

      <!-- S: 희망일자 -->
      <li class="date_until">
        <dl class="clearfix">
          <dt>희망일자</dt>
          <dd>
            <input type="text" class="date_calendar">
          </dd>
          <dd class="wave">~</dd>
          <dd>
            <input type="text" class="date_calendar">
          </dd>
        </dl>
      </li>
      <!-- E: 희망일자 -->

      <!-- S: 희망지역 -->
      <li class="want_area">
        <dl class="clearfix">
          <dt>희망지역</dt>
          <dd class="sel_box">
            <select>
              <option>시/도 선택</option>
            </select>
          </dd>
          <dd class="sel_box">
            <select>
              <option>시/도 선택</option>
            </select>
          </dd>
        </dl>
      </li>
      <!-- E: 희망지역 -->

      <!-- S: 이름 -->
      <li class="recruit_stat">
        <dl class="clearfix">
          <dt>이름</dt>
          <dd>
            <input type="text">
          </dd>
        </dl>
      </li>
      <!-- E: 이름 -->
    </ul>
    <!-- E: sel-list -->



    <!-- S: btn-list -->
    <div class="btn-list">
      <a href="#" class="btn-left btn btn-close">닫기</a>
      <a href="#" class="btn-right btn">조회</a>
    </div>
    <!-- E: btn-list -->
  </div>
  <!-- E: bg-ipt -->

  <!-- S: tail bg-tail -->
  <div class="tail bg-tail">
    <a href="#" id="click_open" style="display: none;">
      <img src="http://img.sportsdiary.co.kr/sdapp/record/close-tail@3x.png" alt="열기">
    </a>
    <a href="#" id="click_close">
      <img src="http://img.sportsdiary.co.kr/sdapp/record/open-tail@3x.png" alt="닫기">
    </a>
  </div>
  <!-- E: tail bg-tail -->

  <!-- S: main -->
  <div class="main rally pack">
    <!-- S: title_area -->
    <div class="title_area">
      <h2>
        <span class="ic_deco">
          <i class="fa fa-pencil"></i>
        </span>
        <span class="txt">신규 모집 등록</span>
      </h2>
    </div>
    <!-- E: title_area -->


    <!-- S: prof -->
    <div class="prof flex">
      <div class="profile-img">
        <img src="http://img.sportsdiary.co.kr/sdapp/gnb/profile@3x.png" alt>
      </div>

      <!-- S: prof-list -->
      <div class="prof-list">
        <h3>김우람<span class="en-name">Kim Woo Ram</span></h3>

        <dl class="prof-belong clearfix">
          <dt>소속</dt>
          <dd>
            <ul>
              <li>위드라인고등학교</li>
            </ul>
          </dd>
        </dl>

        <dl class="clearfix">
          <dt>생년월일</dt>
          <dd>99.01.01</dd>
        </dl>

        <dl class="clearfix">
          <dt>키</dt>
          <dd>173cm</dd>
        </dl>

        <dl class="clearfix">
          <dt>사용손</dt>
          <dd>왼손</dd>
        </dl>

        <dl class="clearfix">
          <dt>복식 리턴 포지션</dt>
          <dd>백 사이드</dd>
        </dl>

        <dl class="clearfix">
          <dt>백핸드 타입</dt>
          <dd>양손 투핸드</dd>
        </dl>

        <dl class="multi_dd clearfix">
          <dt>다득점 기술</dt>
          <dd>서비스</dd>
          <dd>퍼스트 서브</dd>
          <dd>F.스트로크</dd>
        </dl>

      </div>
      <!-- E: prof-list -->

      <!-- S: text_ipt_box -->
      <div class="text_ipt_box">
        <textarea placeholder="모집글을 입력하세요.">

        </textarea>
        <!-- S: ctr_btn -->
        <div class="ctr_btn">
          <p class="orangy">※필수입력</p>
          <span class="fr">
            <span class="limit">0 / 300</span>
            <a href="#" class="btn btn-normal">등록</a>
          </span>
        </div>
        <!-- E: ctr_btn -->
      </div>
      <!-- E: text_ipt_box -->
    </div>
    <!-- E: prof -->
  </div>
  <!-- E: main -->

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

  <script>
    $('.date_calendar').datepicker({
      changeMonth: true,
      changeYear: true,
      nextText: '다음 달',
      prevText: '이전 달',
      closeText: "닫기",
      currentText: "오늘",
      dateFormat: 'yy-mm-dd',
      // monthNames: [ "1월","2월","3월","4월","5월","6월",
      // "7월","8월","9월","10월","11월","12월" ],
      // monthNamesShort: [ "1월","2월","3월","4월","5월","6월",
      // "7월","8월","9월","10월","11월","12월" ],
      // dayNames: [ "일요일","월요일","화요일","수요일","목요일","금요일","토요일" ],
      // dayNamesShort: [ "일","월","화","수","목","금","토" ],
      // dayNamesMin: [ "일","월","화","수","목","금","토" ],
      // weekHeader: "주",
    });

    function activeHoriGnb (idx) {
      var $menuList = $('.big-cat .menu-list li');
      $menuList.eq(idx).find('a').addClass('on');
    }

    activeHoriGnb(bigCatIdx);

    $('.guide_modal').modal('show');
  </script>
</body>
