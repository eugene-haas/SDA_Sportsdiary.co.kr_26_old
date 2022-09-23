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
		<h1>메모리</h1>
		<!-- #include file="../include/sub_header_gnb.asp" -->
	</div>
	<!-- #include file = "../include/gnb.asp" -->
	<!-- E: sub-header -->

<!-- S: memory-menu -->
<div class="record-menu memory-menu">
  <div class="menu-list big-cat clearfix">
    <ul class="menu-list clearfix">
      <li> <a href="../Memory/memory-estimate.asp" class="btn estimate">나의평가표</a> </li>
      <li> <a href="../Memory/memory-good.asp" class="btn goodth">잘된점 모아보기</a> </li>
      <li> <a href="../Memory/memory-bad.asp" class="btn badth">보완점 모아보기</a> </li>
      <li> <a href="../Memory/memory-diary.asp" class="btn my-diary">나의일기 모아보기</a> </li>
      <li> <a href="../Memory/memory-councel.asp" class="btn counsel">지도자상담 모아보기 <span id="SUBCOUNCEL" style="display:none" class="ic-new">N</span></a> </li>
    </ul>
  </div>
</div>
<!-- E: memory-menu -->
<!-- S: record-bg -->
<div class="record-bg">
  <div class="record-intro">
    <h2><strong>메모리</strong>에서<br>
      나의 <strong>일지기록</strong>를 확인해 보세요!</h2>
  </div>
  <div class="bottom-logo"> <span class="logo-img"> <img src="http://img.sportsdiary.co.kr/sdapp/gnb/bottom_logo@3x.png" alt="스포츠다이어리 유도협회"> </span> </div>
  <!-- S: bottom-menu -->
  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- E: bottom-menu -->
</div>
<!-- E: record-bg -->
<!-- S: bot-config -->
<!-- #include file= "../include/bot_config.asp" -->
<!-- E: bot-config -->
</body>
