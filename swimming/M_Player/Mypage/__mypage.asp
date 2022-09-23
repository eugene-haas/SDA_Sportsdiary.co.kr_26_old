<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
</head>
<body>
<div class="l">

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
    <div class="m_header s_sub">
  		<!-- #include file="../include/header_back.asp" -->
  		<h1 class="m_header__tit">마이페이지</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>
	</div>

  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_myProfile">
			<div class="m_myProfile__imgWrap">
				<div class="m_myProfile__imgOuter">
					<img id="imgMypage" src="http://img.sportsdiary.co.kr/images/SD/img/profile@3x.png" class="m_myProfile__img" alt="">
				</div>
				<img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon_camera.png" class="m_myProfile__imgIcon" alt="">
			</div>

			<p class="m_myProfile__txtWrap">
				<span class="m_myProfile__name">김우람(player11) 님</span><br>
				<span class="m_myProfile__belong">일반</span>
			</p>
		</div>

		<ul class="m_myMenuList">
      <li class="m_myMenuList__item">
        <a href="javascript:chk_onSubmitMenu('INFO');" class="m_myMenuList__anchor s_info">
          <span class="m_myMenuList__txt">정보관리</span>
        </a>
      </li>

      <li class="m_myMenuList__item">
        <a href="javascript:chk_onSubmitMenu('PASS');" class="m_myMenuList__anchor s_password">
          <span class="m_myMenuList__txt">비밀번호 변경</span>
        </a>
      </li>

			<li class="m_myMenuList__item">
        <a href="http://sdmain.sportsdiary.co.kr/sdmain/PushSetting.asp" class="m_myMenuList__anchor s_push">
          <span class="m_myMenuList__txt">앱 알림 수신 설정</span>
        </a>
      </li>
		</ul>

    <ul class="m_myMenuList s_more">
      <li class="m_myMenuList__item">
        <a href="javascript:chk_logout();" class="m_myMenuList__anchorOut">
          <span class="m_myMenuList__ic"><i class="fa fa-power-off"></i></span>
          <span class="m_myMenuList__txt"> 로그아웃 </span>
        </a>
      </li>
      <li class="m_myMenuList__item">
        <a href="javascript:chk_onSubmitMenu('DROP');" class="m_myMenuList__anchorOut">
          <span class="m_myMenuList__ic"><i class="fa fa-sign-out"></i></span>
          <span class="m_myMenuList__txt"> 회원탈퇴 </span>
        </a>
      </li>
    </ul>
	</div>

</div>
</body>
</html>
