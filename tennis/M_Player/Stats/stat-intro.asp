<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
  '로그인체크
  Check_Login()
%>
<body class="lack-bg">

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>나의 통계</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: memory-menu -->
  <div class="record-menu stat-menu">
    <div class="menu-list big-cat clearfix">
      <ul class="menu-list clearfix">
        <li>
          <a href="../Stats/stat-training-attand.asp" class="btn estimate">훈련참석정보</a>
        </li>
        <li>
          <a href="../Stats/stat-ptrain-place.asp" class="btn goodth">공식훈련</a>
        </li>
        <li>
          <a href="../Stats/stat-strain-place.asp" class="btn badth">개인훈련</a>
        </li>
        <li>
          <a href="../Stats/stat-injury-dist.asp" class="btn my-diary">부상정보</a>
        </li>
        <li>
          <a href="../Stats/stat-gauge.asp" class="btn counsel">체력측정결과</a>
        </li>
        <li>
          <a href="../Stats/stat-record.asp" class="btn counsel">전적</a>
        </li>
        <!--
        <li>
          <a href="stat-present.asp" class="btn counsel">연습경기</a>
        </li>
        -->
        <li>
          <a href="../Stats/stat-match-point.asp" class="btn counsel">대회득실점</a>
        </li>
        <li>
          <a href="../Stats/stat-relativity-get.asp" class="btn counsel">상대성</a>
        </li>
        <!--//<li>
          <a href="../Stats/weight-in-record.asp" class="btn">대회별 계체기록</a>
        </li>-->
      </ul>
    </div>
  </div>
  <!-- E: memory-menu -->
  <!-- S: record-bg -->
  <div class="record-bg">
    <div class="record-intro">
      <h2><strong>나의 차트</strong>를<br>쉽고 빠르게 확인하세요!</h2>
    </div>
    <div class="bottom-logo">
      <span class="logo-img">
        <img src="http://img.sportsdiary.co.kr/sdapp/gnb/bottom_logo@3x.png" alt="스포츠다이어리 유도협회">
      </span>
    </div>
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: record-bg -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
