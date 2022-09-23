<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>메모리</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <!-- S: memory-menu -->
  <div class="record-menu memory-menu">
    <div class="big-cat">
      <ul class="menu-list clearfix">
        <li>
          <a href="#" class="btn estimate">나의평가표</a>
        </li>
        <li>
          <a href="#" class="btn goodth on">잘된점 모아보기</a>
        </li>
        <li>
          <a href="#" class="btn badth">보완점 모아보기</a>
        </li>
        <li>
          <a href="#" class="btn my-diary">나의일기 모아보기</a>
        </li>
        <li>
          <a href="#" class="btn counsel">지도자상담 모아보기</a>
        </li>
      </ul>
    </div>
    <!-- S: 나의 평가표 서브메뉴 -->
    <div class="menu-list mid-cat flex">
      <ul class="rank-mid estimate clearfix" style="display: none;">
        <li><a href="" class="on">훈련평가표</a></li>
        <li><a href="">대회평가표</a></li>
      </ul>
      <!-- S: 잘된점 모아보기 서브메뉴 -->
      <ul class="rank-mid goodth clearfix" style="display: block;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="" class="favorite">즐겨찾기<span><img src="../images/memory/favorite-star-on@3x.png" alt></span></a></li>
      </ul>
      <!-- E: 잘된점 모아보기 서브메뉴 -->
      <!-- S: 보완점 모아보기 서브메뉴 -->
      <ul class="rank-mid badth clearfix" style="display: none;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="" class="favorite">즐겨찾기<span><img src="../images/memory/favorite-star-on@3x.png" alt></span></a></li>
      </ul>
      <!-- E: 보완점 모아보기 서브메뉴 -->
      <!-- S: 나의일기 모아보기 서브메뉴 -->
      <ul class="rank-mid my-diary clearfix" style="display: none;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="" class="favorite">즐겨찾기<span><img src="../images/memory/favorite-star-on@3x.png" alt></span></a></li>
      </ul>
      <!-- E: 나의일기 모아보기 서브메뉴 -->
      <!-- S: 지도자상담 모아보기 서브메뉴 -->
      <ul class="rank-mid councel clearfix" style="display: none;">
        <li><a href="" class="on">훈련일지</a></li>
        <li><a href="">대회일지</a></li>
        <li><a href="" class="favorite">즐겨찾기<span><img src="../images/memory/favorite-star-on@3x.png" alt></span></a></li>
      </ul>
      <!-- E: 지도자상담 모아보기 서브메뉴 -->
    </div>
    <!-- E: 나의 평가표 서브메뉴 -->
    <div class="menu-list small-cat flex"></div>
  </div>
  <!-- E: memory-menu -->

  <!-- S: memory-input -->
  <div class="memory-input container">
    <!-- S: sel-list -->
    <div class="sel-list">
      <!-- S: 기간 선택 -->
      <dl class="clearfix term-sel">
        <dt>기간선택</dt>
        <dd class="">
          <select name="">
            <option value="">최근 1주일</option>
            <option value="">최근 1달</option>
            <option value="">최근 1년</option>
          </select>
        </dd>
      </dl>
      <!-- E: 기간 선택 -->
      <!-- S: 기간 조회 -->
      <dl class="clearfix term-srch">
        <dt>기간조회</dt>
        <dd class="memory-term divn-3">
          <span><input type="date"></span>
          <span class="wave-divn">~</span>
          <span><input type="date"></span>
        </dd>
      </dl>
      <!-- E: 기간 조회 -->
    </div>
    <!-- E: sel-list -->
    <div class="btn-list">
      <a href="#" class="btn-left btn">닫기</a>
      <a href="#" class="btn-right btn">조회</a>
    </div>
  </div>
  <!-- E: memory-input -->

  <!-- S: tail -->
  <div class="tail memory-tail">
    <a href="#"><img src="../images/record/open-tail@3x.png" alt="닫기"></a>
  </div>
  <!-- E: tail -->

  <!-- S: good-list -->
  <section class="good-list">
   <h2><span class="img-icon"><img src="../images/memory/icon-good@3x.png" alt></span>2016/11/09 ~ 2016/12/15</h2>
   <ul>
     <li>
        <!-- S: 모아보기 리스트, 항목 -->
        <a href="#" class="clearfix">
         <span class="img-icon"><img src="../images/memory/favorite-star-on@3x.png" alt></span>
         <p>
           <span>[2016.11.15]</span>
           <span>잘된점입니다.</span>
         </p>
         <span class="icon-cont">
           <span class="glyphicon glyphicon-triangle-bottom"></span>
         </span>
       </a>
       <!-- E: 모아보기 리스트, 항목 -->
       <!-- S: memory-txt 모아보기 설명 -->
       <div class="memory-txt container">
         <h3>잘된점입니다.</h3>
         <ol>
           <li>오른쪽 다리 왼쪽을 꺽는 기술이 좋았다.</li>
           <li>안다리걸기 실력이 늘었다.</li>
         </ol>
         <div class="btn-list">
           <a href="#" class="training-diary">훈련일지보기</a>
           <a href="#" class="match-diary" style="display: none;">대회일지보기</a>
         </div>
       </div>
       <!-- E: memory-txt 모아보기 설명 -->
     </li>
     <li>
       <!-- S: 모아보기 리스트, 항목 -->
       <a href="#" class="clearfix">
         <span class="img-icon"><img src="../images/memory/favorite-star-off@3x.png" alt></span>
         <p>
           <span>[2016.11.15]</span>
           <span>잘된점입니다.</span>
         </p>
         <span class="icon-cont">
           <span class="glyphicon glyphicon-triangle-top"></span>
         </span>
       </a>
       <!-- E: 모아보기 리스트, 항목 -->
     </li>
     <li>
       <!-- S: 모아보기 리스트, 항목 -->
        <a href="#" class="clearfix">
         <span class="img-icon"><img src="../images/memory/favorite-star-on@3x.png" alt></span>
         <p>
           <span>[2016.11.15]</span>
           <span>잘된점입니다.</span>
         </p>
         <span class="icon-cont">
           <span class="glyphicon glyphicon-triangle-top"></span>
         </span>
       </a>
       <!-- E: 모아보기 리스트, 항목 -->
     </li>
     <li>
       <!-- S: 모아보기 리스트, 항목 -->
       <a href="#" class="clearfix">
         <span class="img-icon"><img src="../images/memory/favorite-star-on@3x.png" alt></span>
         <p>
           <span>[2016.11.15]</span>
           <span>잘된점입니다.</span>
         </p>
         <span class="icon-cont">
           <span class="glyphicon glyphicon-triangle-top"></span>
         </span>
       </a>
       <!-- E: 모아보기 리스트, 항목 -->
     </li>
     <li>
       <!-- S: 모아보기 리스트, 항목 -->
       <a href="#" class="clearfix">
         <span class="img-icon"><img src="../images/memory/favorite-star-on@3x.png" alt></span>
         <p>
           <span>[2016.11.15]</span>
           <span>잘된점입니다.</span>
         </p>
         <span class="icon-cont">
           <span class="glyphicon glyphicon-triangle-top"></span>
         </span>
       </a>
       <!-- E: 모아보기 리스트, 항목 -->
     </li>
     <li>
       <!-- S: 모아보기 리스트, 항목 -->
       <a href="#" class="clearfix">
         <span class="img-icon"><img src="../images/memory/favorite-star-on@3x.png" alt></span>
         <p>
           <span>[2016.11.15]</span>
           <span>잘된점입니다.</span>
         </p>
         <span class="icon-cont">
           <span class="glyphicon glyphicon-triangle-top"></span>
         </span>
       </a>
       <!-- E: 모아보기 리스트, 항목 -->
     </li>
     <li>
       <!-- S: 모아보기 리스트, 항목 -->
       <a href="#" class="clearfix">
         <span class="img-icon"><img src="../images/memory/favorite-star-on@3x.png" alt></span>
         <p>
           <span>[2016.11.15]</span>
           <span>잘된점입니다.</span>
         </p>
         <span class="icon-cont">
           <span class="glyphicon glyphicon-triangle-top"></span>
         </span>
       </a>
       <!-- E: 모아보기 리스트, 항목 -->
     </li>
   </ul>
  </section>
  <!-- E: good-list -->
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