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
    <!-- S: btn_list -->
    <div class="btn_list write_recruit clearfix">
      <a href="./rally_write.asp" class="btn btn_orangy">
        <span class="ic_deco">
          <i class="fa fa-pencil"></i>
        </span>
        <span class="txt">신규모집등록</span>
      </a>
    </div>
    <!-- E: btn_list -->
    <!-- S: srch_result_list -->
    <div class="srch_result_list">
      <p class="total_info_txt"><span class="orangy">130</span> 건의 모집글</p>
      <ul>
        <li class="clearfix">
          <!-- S: player_info -->
          <div class="player_info">
            <p class="name"><b>김민종(30대 남자)</b></p>
            <!-- S: show_info -->
            <div class="show_info">
              <p class="career">
                <span class="orangy">구력</span>
                <span>5년</span>
              </p>
              <p class="want_area">
                <span class="orangy">희망지역</span>
                <span>서울 마포구</span>
              </p>
            </div>
            <!-- E: show_info -->
            <!-- S: want_date -->
            <div class="want_date">
              <p>
                <span class="title">희망일자</span>
                <span>2017.10.01 ~ 2017.11.01</span>
              </p>
            </div>
            <!-- E: want_date -->
          </div>
          <!-- E: player_info -->

          <!-- S: btn_box -->
          <div class="btn_box btn_love_call">
            <a href="../userInfo/info.asp" class="btn btn_normal btn_dark_blue">
              <span class="ic-new">N</span>
              <span class="ic_deco">
                <img src="http://img.sportsdiary.co.kr/sdapp/rally/btn_love_call.png" alt>
              </span>
              <span>프로필</span>
              <span>러브콜</span>
            </a>
          </div>
          <!-- E: btn_box -->
        </li>
        <li class="clearfix">
          <!-- S: player_info -->
          <div class="player_info">
            <p class="name"><b>김민종(30대 남자)</b></p>
            <!-- S: show_info -->
            <div class="show_info">
              <p class="career">
                <span class="orangy">구력</span>
                <span>5년</span>
              </p>
              <p class="want_area">
                <span class="orangy">희망지역</span>
                <span>서울 마포구</span>
              </p>
            </div>
            <!-- E: show_info -->
            <!-- S: want_date -->
            <div class="want_date">
              <p>
                <span class="title">희망일자</span>
                <span>2017.10.01 ~ 2017.11.01</span>
              </p>
            </div>
            <!-- E: want_date -->
          </div>
          <!-- E: player_info -->

          <!-- S: btn_box -->
          <div class="btn_box btn_love_call">
            <a href="../userInfo/info.asp" class="btn btn_normal btn_dark_blue">
              <span class="ic-new">N</span>
              <span class="ic_deco">
                <img src="http://img.sportsdiary.co.kr/sdapp/rally/btn_love_call.png" alt>
              </span>
              <span>프로필</span>
              <span>러브콜</span>
            </a>
          </div>
          <!-- E: btn_box -->
        </li>
        <li class="clearfix">
          <!-- S: player_info -->
          <div class="player_info">
            <p class="name"><b>김민종(30대 남자)</b></p>
            <!-- S: show_info -->
            <div class="show_info">
              <p class="career">
                <span class="orangy">구력</span>
                <span>5년</span>
              </p>
              <p class="want_area">
                <span class="orangy">희망지역</span>
                <span>서울 마포구</span>
              </p>
            </div>
            <!-- E: show_info -->
            <!-- S: want_date -->
            <div class="want_date">
              <p>
                <span class="title">희망일자</span>
                <span>2017.10.01 ~ 2017.11.01</span>
              </p>
            </div>
            <!-- E: want_date -->
          </div>
          <!-- E: player_info -->

          <!-- S: btn_box -->
          <div class="btn_box btn_love_call">
            <a href="../userInfo/info.asp" class="btn btn_normal btn_dark_blue off">
              <span class="ic-new">N</span>
              <span class="end_txt">모집 종료</span>
            </a>
          </div>
          <!-- E: btn_box -->
        </li>

        <li class="clearfix">
          <!-- S: player_info -->
          <div class="player_info">
            <p class="name"><b>김민종(30대 남자)</b></p>
            <!-- S: show_info -->
            <div class="show_info">
              <p class="career">
                <span class="orangy">구력</span>
                <span>5년</span>
              </p>
              <p class="want_area">
                <span class="orangy">희망지역</span>
                <span>서울 마포구</span>
              </p>
            </div>
            <!-- E: show_info -->
            <!-- S: want_date -->
            <div class="want_date">
              <p>
                <span class="title">희망일자</span>
                <span>2017.10.01 ~ 2017.11.01</span>
              </p>
            </div>
            <!-- E: want_date -->
          </div>
          <!-- E: player_info -->

          <!-- S: btn_box -->
          <div class="btn_box">
            <div class="on_off_switch">
              <input type="checkbox" class="chk_ipt">
              <a href="#" class="btn btn_switch">
                <span class="front">종료</span>
                <span class="back">모집중</span>
              </a>
            </div>
          </div>
          <!-- E: btn_box -->
        </li>

        <li class="clearfix">
          <!-- S: player_info -->
          <div class="player_info">
            <p class="name"><b>김민종(30대 남자)</b></p>
            <!-- S: show_info -->
            <div class="show_info">
              <p class="career">
                <span class="orangy">구력</span>
                <span>5년</span>
              </p>
              <p class="want_area">
                <span class="orangy">희망지역</span>
                <span>서울 마포구</span>
              </p>
            </div>
            <!-- E: show_info -->
            <!-- S: want_date -->
            <div class="want_date">
              <p>
                <span class="title">희망일자</span>
                <span>2017.10.01 ~ 2017.11.01</span>
              </p>
            </div>
            <!-- E: want_date -->
          </div>
          <!-- E: player_info -->

          <!-- S: btn_box -->
          <div class="btn_box">
            <div class="on_off_switch">
              <input type="checkbox" class="chk_ipt">
              <a href="#" class="btn btn_switch">
                <span class="front">종료</span>
                <span class="back">모집중</span>
              </a>
            </div>
          </div>
          <!-- E: btn_box -->
        </li>

        <li class="clearfix">
          <!-- S: player_info -->
          <div class="player_info">
            <p class="name"><b>김민종(30대 남자)</b></p>
            <!-- S: show_info -->
            <div class="show_info">
              <p class="career">
                <span class="orangy">구력</span>
                <span>5년</span>
              </p>
              <p class="want_area">
                <span class="orangy">희망지역</span>
                <span>서울 마포구</span>
              </p>
            </div>
            <!-- E: show_info -->
            <!-- S: want_date -->
            <div class="want_date">
              <p>
                <span class="title">희망일자</span>
                <span>2017.10.01 ~ 2017.11.01</span>
              </p>
            </div>
            <!-- E: want_date -->
          </div>
          <!-- E: player_info -->

          <!-- S: btn_box -->
          <div class="btn_box btn_love_call btn_line1">
            <a href="../userInfo/info.asp" class="btn btn_normal btn_dark_blue">
              <span class="ic-new">N</span>
              <span class="txt">프로필 / 러브콜</span>
            </a>
          </div>
          <!-- E: btn_box -->
        </li>
      </ul>
    </div>
    <!-- E: srch_result_list -->
  </div>
  <!-- E: main -->

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

    <!-- S: guide_modal -->
    <div class="modal fade guide_modal">
      <!-- S: modal-dialog -->
      <div class="modal-dialog">
        <!-- S: modal-content -->
        <div class="modal-content">
          <!-- S: modal-header -->
          <div class="modal-header">
            <h3>알림</h3>
            <a href="#" class="btn btn-close" data-dismiss="modal">&times;</a>
          </div>
          <!-- E: modal-header -->
          <!-- S: modal-body -->
          <div class="modal-body">
            <div class="img_box">
              <img src="http://img.sportsdiary.co.kr/sdapp/rally/rally_guide.png" alt="회원정보를 조회 후 나와 맞는 난타친구를 찾아보세요.">
            </div>
          </div>
          <!-- E: modal-body -->
        </div>
        <!-- E: modal-content -->
      </div>
      <!-- E: modal-dialog -->
    </div>
    <!-- E: guide_modal -->

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
