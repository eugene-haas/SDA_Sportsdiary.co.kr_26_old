<!-- #include file="../include/config.asp" -->
<!-- #include file="../include/tn_config.asp" -->

<body>
  
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>파트너(Pair)찾기</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->


  <!-- S: main -->
  <div class="main partner">
    <!-- S: comu_tab_menu 상단 탭 메뉴 -->
    <div class="comu_tab_menu pack">
      <ul class="clearfix">
        <li><a href="./pt_srch.asp" class="btn">파트너 조회</a></li>
        <li><a href="./pt_history.asp" class="btn on">소통내역 보기</a></li>
      </ul>
    </div>
    <!-- E: comu_tab_menu 상단 탭 메뉴 -->

    <!-- S: pair_tab dark_blue -->
    <div class="pair_tab dark_blue pack">
      <ul class="flex">
        <li>
          <a href="#">
            <span class="ic_deco">
              <i class="fa fa-paper-plane"></i>
            </span>
            발신내역
            <span class="ic-new">N</span>
          </a>
        </li>
        <li>
          <a href="#" class="on">
            <span class="ic_deco">
              <i class="fa fa-envelope"></i>
            </span>
            수신내역
            <span class="ic-new">N</span>
          </a>
        </li>
      </ul>
    </div>
    <!-- E: pair_tab dark_blue -->

    <!-- S: srch_list -->
    <div class="srch_list pack">
      <ul>
        <li class="clearfix">
          <p class="title">
            기간선택
          </p>
          <div class="sel_box" class="on">
            <select>
              <option>최근 1주일</option>
              <option>최근 한달</option>
              <option>최근 두달</option>
              <option>최근 3개월</option>
              <option>최근 6개월</option>
              <option>최근 1년</option>
              <option>최근 3년</option>
              <option>최근 5년</option>
              <option>최근 10년</option>
            </select>
          </div>
        </li>
        <li class="clearfix">
          <p class="title">
            기간조회
          </p>
          <div class="input_box sel_2">
            <input type="date">
            <span class="divn_wave">~</span>
            <input type="date">
          </div>
        </li>
        <li class="clearfix">
          <p class="title">
            작성자 검색
          </p>
          <div class="input_box srch_area">
            <input type="text">
            <a href="#" class="btn btn_normal btn_dark_blue">검색</a>
          </div>
        </li>
      </ul>
    </div>
    <!-- E: srch_list -->
    <p class="guide_txt srch_list_guide pack">* 파트너 요청을 통해 회원님들과 <span class="orangy">소통한 내역</span>들을 모아 볼 수 있습니다.</p>

    <!-- S: srch_result_table -->
    <div class="srch_result_table pack">
      <ul>
        <li class="clearfix">
          <div class="txt_side">
            <span class="date">2017.08.29</span>
            <p class="user">
              <span class="name">김민종</span>
              <span class="birth">74.08.01</span>
            </p>
            <p class="belong">목동10단지</p>
          </div>
          <div class="btn_side">
            <a href="#" class="btn btn_normal btn_dark_blue">회원정보 / 소통하기<span class="ic-new">N</span></a>
          </div>
        </li>
        <li class="clearfix">
          <div class="txt_side">
            <span class="date">2017.08.25</span>
            <p class="user">
              <span class="name">이오희</span>
              <span class="birth">81.01.03</span>
            </p>
            <p class="belong">테니스매니아</p>
          </div>
          <div class="btn_side">
            <a href="#" class="btn btn_normal btn_dark_blue">회원정보 / 소통하기<span class="ic-new">N</span></a>
          </div>
        </li>
        <li class="clearfix">
          <div class="txt_side">
            <span class="date">2017.08.25</span>
            <p class="user">
              <span class="name">임성혁</span>
              <span class="birth">78.01.22</span>
            </p>
            <p class="belong">강서어택</p>
          </div>
          <div class="btn_side">
            <a href="#" class="btn btn_normal btn_dark_blue">회원정보 / 소통하기</a>
          </div>
        </li>
      </ul>
    </div>
    <!-- E: srch_result_table -->


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

</body>
