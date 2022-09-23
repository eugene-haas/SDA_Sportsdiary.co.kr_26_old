<!-- #include file="../include/config.asp" -->
<!-- #include file="../include/tn_config.asp" -->
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>내주변 레슨코트 찾기</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: main -->
  <div class="main lesson pack">

    <!-- S: comu_tab_menu 상단 탭 메뉴 -->
    <div class="comu_tab_menu">
      <ul class="clearfix">
        <li><a href="./register.asp" class="btn on">레슨코치 PR 등록</a></li>
        <li><a href="./pt_history.asp" class="btn">레슨코트 조회</a></li>
      </ul>
    </div>
    <!-- E: comu_tab_menu 상단 탭 메뉴 -->

    <!-- S: tab tab_2 -->
    <div class="tab tab_2 sel_wr">
      <ul class="clearfix">
        <li>
          <a href="#" class="btn btn_normal on">
            <span class="ic_deco">
              <i class="fa fa-pencil"></i>
            </span>
            <span>등록/수정하기</span>
            <span class="ic-new">N</span>
          </a>
        </li>
        <li>
          <a href="#" class="btn btn_normal">
            <span class="ic_deco">
              <i class="fa fa-file-text"></i>
            </span>
            <span>레슨요청 내역</span>
            <span class="ic-new">N</span>
          </a>
        </li>
      </ul>
    </div>
    <!-- E: tab tab_2 -->

    <!-- S: file_attach -->
    <section class="section_box big_box court_add">
      <h3>
        <span class="ic_deco">
          <i class="fa fa-pencil"></i>
        </span>
        <span>레슨코트 등록하기</span>
      </h3>
      <ul class="file_attach">

        <li class="add_file clearfix">
          <div class="btn_group">
            <a href="#" class="btn btn-empty">첨부하기</a>
          </div>
          <div class="text_group">
            <p>사진 최대 3장</p>
          </div>
        </li>

        <li class="added_file clearfix">
          <div class="pic">
            <img src="http://img.sportsdiary.co.kr/sdapp/public/mini_dummy_vertical.png" alt="">
          </div>
          <div class="file_name">
            <span>image.jpg</span>
          </div>
          <div class="del">
            <a href="#" class="btn btn-del">
              <img src="http://img.sportsdiary.co.kr/sdapp/public/btn_x_circle@3x.png" alt="닫기">
            </a>
          </div>
        </li>

        <li class="added_file clearfix">
          <div class="pic">
            <img src="http://img.sportsdiary.co.kr/sdapp/public/mini_dummy_width.png" alt="">
          </div>
          <div class="file_name">
            <span>image.jpg</span>
          </div>
          <div class="del">
            <a href="#" class="btn btn-del">
              <img src="http://img.sportsdiary.co.kr/sdapp/public/btn_x_circle@3x.png" alt="닫기">
            </a>
          </div>
        </li>

        <li class="added_file clearfix">
          <div class="pic">
            <img src="http://img.sportsdiary.co.kr/sdapp/public/mini_dummy_width.png" alt="">
          </div>
          <div class="file_name">
            <span>image.jpg</span>
          </div>
          <div class="del">
            <a href="#" class="btn btn-del">
              <img src="http://img.sportsdiary.co.kr/sdapp/public/btn_x_circle@3x.png" alt="닫기">
            </a>
          </div>
        </li>

      </ul>
    </section>
    <!-- E: file_attach -->

    <!-- S: select_box 레슨지역 -->
    <section class="section_box sel_md">
      <h3>레슨지역</h3>
      <ul>
        <li class="sel_box">
          <select>
            <option>:: 시/도를 선택하세요 ::</option>
            <option>서울</option>
            <option>경기</option>
          </select>
        </li>
        <li class="sel_box">
          <select>
            <option>:: 시/군/구를 선택하세요 ::</option>
            <option>마포</option>
            <option>용산</option>
            <option>강남</option>
          </select>
        </li>
        <li>
          <input type="text" placeholder="상세주소를 입력해주세요">
        </li>
      </ul>
    </section>
    <!-- E: select_box 레슨지역 -->

    <!-- S: select_box 레슨코트명 -->
    <section class="section_box sel_md">
      <h3>레슨코트명</h3>
      <ul>
        <li>
          <input type="text" placeholder="코트명을 입력해 주세요.">
        </li>
      </ul>
    </section>
    <!-- E: select_box 레슨코트명 -->

    <!-- S: input_box 레슨비 -->
    <section class="section_box lesson_cost">
      <h3>레슨비</h3>
      <ul>
        <li>
          <div class="pay">
            <input type="text">
            <span class="txt">만원</span>
          </div>
          <div class="talk">
            <label>
              <input type="checkbox">
              <span class="txt">직접상담</span>
            </label>
          </div>
        </li>
      </ul>
    </section>
    <!-- E: input_box 레슨비 -->

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
