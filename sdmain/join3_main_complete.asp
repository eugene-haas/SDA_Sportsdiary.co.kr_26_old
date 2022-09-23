<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!--#include file="./include/config.asp"-->
  <%

  %>

</head>
<body>
<div class="l">
  <div class="l_header">

    <div class="m_header s_sub">
      <!-- #include file="./include/header_back.asp" -->
      <h1 class="m_header__tit">통합회원가입 완료</h1>
      <!-- #include file="./include/header_home.asp" -->
    </div>

  </div>

  <!-- S: main user_info pack -->
  <div class="l_content m_scroll [ _content _scroll ]">
    <!-- S: sdmain-pack -->
    <div class="sdmain-pack join-end">
      <div class="join-logo">
        <img src="./images/sd_logo__origin.png" alt="스포츠 다이어리">
      </div>
      <h2>Sports Diary 회원가입이<br>완료 되었습니다.</h2>
      <p class="welcome-msg-2">앞으로 다양한 종목과 풍성한 서비스를<br>제공하도록 노력하겠습니다.</p>
			<p class="welcome-msg-3">종목 및 회원구분추가를 원하시면<br>계정추가를 진행해주세요</p>
      <div class="btn-list">
				<div class="account">
					<a href="#" data-toggle="modal" data-target="#accountp-modal"><span class="icon"><i class="fa fa-question"></i></span>계정추가란?</a>
				</div>
        <a href="./join_MemberTypeGb.asp" class="btn btn-default">계정 추가</a>
        <a href="./index.asp" class="btn btn-ok">시작하기</a>
      </div>
    </div>
    <!-- E: sdmain-pack -->
  </div>

	<!-- s: account-modal -->
	<div class="modal fade account-modal" id="accountp-modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-body">
					<h2>계정추가란?</h2>
					<p>※ 계정추가 개수제한 없음</p>
					<p>
					일반회원 이나 유도 종목의 선수로 가입했지만 <span class="bluy">동시에 보호자,지도자인 경우
					계정을 추가로 등록</span>하여 자유롭게 이용하실 수 있습니다.
					</p>
					<p>
					또는 일반회원으로 가입했지만
					<span class="bluy">자전거 생활체육(동호인) 선수일 경우나
					다른 종목의 구분에 속해 있을 경우,
					가입한 계정 외 자유롭게 계정을 추가</span>하여
					종목별로 이용하실 수 있습니다.
					</p>
				</div>
				<div class="modal-footer">
					<a href="#" data-dismiss="modal">닫기</a>
				</div>
			</div>
		</div>
	</div>
	<!-- e: account-modal -->

  <!-- #include file='./include/footer.asp' -->
  
</div>
</body>
</html>
