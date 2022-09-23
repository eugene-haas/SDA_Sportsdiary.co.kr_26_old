<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- #include file="../include/head.asp" -->
	<!-- #include file="../include/config.asp" -->
  <!-- #include file="../Library/sub_config.asp" -->

	<%
		'=================================================================================
		'마이페이지
		'=================================================================================
		'로그인하지 않았다면 login.asp로 이동
		' Check_Login()

		dim UserID      : UserID      	= request.Cookies("SD")("UserID")
		dim UserName    : UserName      = request.Cookies("SD")("UserName")
		dim PlayerReln  : PlayerReln    = decode(request.Cookies(SportsGb)("PlayerReln"), 0)
		dim EnterType   : EnterType     = request.Cookies(SportsGb)("EnterType")
	%>
	<script>
		//메뉴 링크
		function chk_onSubmitMenu(valType){
			var txt_URL = '';

			switch(valType){
				case 'DROP' 	: txt_URL = 'http://sdmain.sportsdiary.co.kr/sdmain/user_out.asp'; break;			//회원탈퇴
				case 'ADD' 		: txt_URL = 'http://sdmain.sportsdiary.co.kr/sdmain/join_MemberTypeGb.asp'; break;	//계정추가
				case 'SET'		: txt_URL = 'http://sdmain.sportsdiary.co.kr/sdmain/user_account.asp'; break; 											//종목메인설정
				case 'PASS'		: txt_URL = 'http://sdmain.sportsdiary.co.kr/sdmain/pwd_change.asp'; break;			//비밀번호변경
				case 'INFO'		: txt_URL = './myinfo.asp'; break;													//MY INFO
				case 'TEAM'		: txt_URL = './school-modify-list.asp'; break;										//소속변경
				case 'TRAIN' 	: txt_URL = './training.asp'; break;												//훈련종류항목관리
				case 'CARD'		: txt_URL = './player_card.asp'; break;												//선수증관리
			}
			$(location).attr('href', txt_URL);
		}

		$(document).ready(function(){
		 	/*
			1. 종목별 회원가입 계정카운트 조회, 1개일 경우는 계정전환아이콘 메뉴 출력하지 않음
				- 20171124 update 출력으로 변경
				- 함수위치 include/gnb_Type/player_gnb.asp
			*/
			//chk_JoinUser_COUNT('<%=request.Cookies(SportsGb)("SportsGb")%>');
		});
	</script>
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
					<img id="imgMypage" src="<%=Img_IDType%>" class="m_myProfile__img" alt="" />
				</div>
				<img src="http://img.sportsdiary.co.kr/sdapp/mypage/icon_camera.png" class="m_myProfile__imgIcon" alt="">
			</div>
			<p class="m_myProfile__txtWrap">
				<span class="m_myProfile__name"><%=UserName%>(<%=UserID%>) 님</span><br />
				<span class="m_myProfile__belong"><%=txt_Name%></span>
			</p>
		</div>

		<div class="m_myMenuL">
			<a href="javascript:chk_onSubmitMenu('INFO');" class="m_myMenuL__anchor s_info"><span class="m_myMenuL__txt">정보관리</span></a>
			<a href="javascript:chk_onSubmitMenu('PASS');" class="m_myMenuL__anchor s_pass"><span class="m_myMenuL__txt">비밀번호 변경</span></a>
		</div>

		<ul class="m_myMenuList">
			<li class="m_myMenuList__item">
        <a  href="javascript:chk_onSubmitMenu('ADD');" class="m_myMenuList__anchor s_addAccount">
          <span class="m_myMenuList__txt">계정추가</span>
        </a>
      </li>
			<li class="m_myMenuList__item">
        <a href="javascript:chk_onSubmitMenu('SET');" class="m_myMenuList__anchor s_set">
          <span class="m_myMenuList__txt">종목메인설정</span>
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

	<!-- #include file="../include/bottom_menu.asp" -->
	<!-- #include file= "../include/bot_config.asp" -->

</div>
</body>
</html>
