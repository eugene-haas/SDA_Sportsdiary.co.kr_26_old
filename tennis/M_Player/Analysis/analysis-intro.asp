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
    <h1>선수분석</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: memory-menu -->
  <div class="record-menu analysis-menu">
    <div class="menu-list big-cat clearfix">
      <ul class="menu-list clearfix">
        <li>
          <a href="../Analysis/analysis-match-point.asp" class="btn estimate">대회득실점</a>
        </li>
        <li>
          <a href="../Analysis/analysis-relativity-get.asp" class="btn goodth">상대성</a>
        </li>
        <li>
          <a href="../Analysis/analysis-match-result.asp" class="btn badth">전적</a>
        </li>
      </ul>
    </div>
  </div>
  <!-- E: memory-menu -->
  <!-- S: record-bg -->
  <div class="record-bg">
    <div class="record-intro">
      <h2><strong>상대선수의 정보</strong>를<br>쉽고 빠르게 확인하세요!</h2>
    </div>
    <div class="bottom-logo">
      <span class="logo-img">
        <img src="http://img.sportsdiary.co.kr/sdapp/gnb/bottom_logo@3x.png" alt="스포츠다이어리 유도협회">
      </span>
    </div>
    <!-- E: record-bg -->
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: record-bg -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
