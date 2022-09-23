<!-- #include file="../include/config.asp" -->
<%
  '=================================================================================
  '마이페이지
  '=================================================================================
  Check_Login()
  
  dim PhotoPath   : PhotoPath   = decode(Request.Cookies("PhotoPath"), 0)
  dim UserID    : UserID    = decode(Request.Cookies("UserID"),0)
  dim UserName  : UserName    = request.Cookies("UserName")
  dim PlayerReln  : PlayerReln  = decode(request.Cookies("PlayerReln"), 0)
  dim EnterType   : EnterType   = request.Cookies("EnterType")
  
  dim URL_MYPAGE


  '회원정보 링크 SET
  SELECT CASE EnterType
    CASE "E","K" : URL_MYPAGE = "../Mypage/myinfo.asp"
    CASE "A" : URL_MYPAGE = "../Mypage/myinfo_type2.asp"
  END SELECT  
%>

<!-- E: config -->
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>마이페이지</h1>
    <!-- S: sub_header_gnb -->
    <%
  SELECT CASE EnterType
  	'엘리트, 국가대표
    CASE "E", "K"	
  %>
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <%
    '생활체육의 경우 메뉴 출력 OFF
    '생활체육 컨텐츠 사용 기획 이후 제거해야함
    CASE ELSE
    %>
        <!-- S: 로그아웃 버튼 -->
        <div class="sub-logout login-btn">
          <!-- logout start -->
          <a href="javascript:chk_logout();" role="button" class="log-out">
            <span class="link-deco"><i class="fa fa-power-off" aria-hidden="true"></i></span>
            <span class="txt">로그아웃</span>
          </a>
          <!-- logout end -->
        </div>
        <!-- E: 로그아웃 버튼 -->
        <%
  END SELECT 
  %>
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <!-- S: sub -->
  <div class="sub mypage">
    <div class="user-img-wrap">
      <div class="user-img">
        <img src="<%=PhotoPath%>" alt="" />
      </div>
      <p><%=UserName%>(<%=UserID%>) 님</p>
    </div>
    <ul class="mypage-menu">
      <li>
        <a href="<%=URL_MYPAGE%>">
          <p><img src="../images/mypage/icon-mypage01@3x.png" alt="" /></p>
          <p>
            <strong>내정보 관리</strong>
            <span>프로필사진,개인정보 변경을 할 수 있습니다.</span>
          </p>
          <p><img src="../images/mypage/icon-more@3x.png" alt="내정보 관리 더보기" /></p>
        </a>
    </li>
    <li>
      <a href="../Mypage/pw-modify.asp">
          <p><img src="../images/mypage/icon-mypage02@3x.png" alt="" /></p>
          <p>
            <strong>비밀번호 변경</strong>
            <span>안전한 보안설정으로 정보를 보호하세요.</span>
          </p>
          <p><img src="../images/mypage/icon-more@3x.png" alt="비밀번호 변경 더보기" /></p>
        </a>
      </li>
      <%
	  '20170721 테스트진행중
	  IF decode(request.Cookies("UserID"),0) = "player12" Then
	  %>
      <li>
        <a href="../Mypage/player_card.asp">
          <p><img src="../images/mypage/icon-player-card@3x.png" alt=""></p>
          <p>
            <strong>내 선수증 관리</strong>
            <span>나의 선수증을 간편하게 관리하세요.</span>
          </p>
          <p>
            <img src="../images/mypage/icon-more@3x.png" alt="내 선수증 관리">
          </p>
        </a>
      </li>
      <%
	  End IF
	  %>
      <!--
      <li>
        <a href="../Mypage/school-modify-list.asp">
          <p><img src="../images/mypage/icon-mypage03@3x.png" alt="" /></p>
          <p>
            <strong>소속변경</strong>
            <span>소속변경은 주로 진학 또는 전학이 해당됩니다.</span>
          </p>
          <p><img src="../images/mypage/icon-more@3x.png" alt="소속변경 더보기" /></p>
        </a>
      </li>
      
      <li>
        <a href="#">
          <p><img src="../images/mypage/icon-mypage04@3x.png" alt="" /></p>
          <p>
            <strong>연습 상대선수 관리</strong>
            <span>연습경기에서 상대선수의 특징을 기록합니다.</span>
          </p>
          <p><img src="../images/mypage/icon-more@3x.png" alt="연습 상대선수 관리 더보기" /></p>
        </a>
      </li>
    -->
    <!-- 2016-12-28 추가 -->
    <%
  '훈련항목 관리는 선수의 경우만 출력
  '생활체육, 엘리트체육 통합사용시 수정필요
  
  IF EnterType = "E" OR EnterType = "K" Then
    SELECT CASE PlayerReln
      CASE "R", "K", "S"
      
    %>
      <li>
      <a href="../Mypage/training.asp">
        <p><img src="../images/mypage/icon-mypage05@3x.png" alt="" /></p>
        <p>
        <strong>훈련 종류 항목관리</strong>
        <span>체력훈련, 도복훈련의 항목을 변경합니다.</span>
        </p>
        <p><img src="../images/mypage/icon-more@3x.png" alt="훈련 종류 항목관리 더보기" /></p>
      </a>
      </li>
    <%
		CASE ELSE
    END SELECT
  End IF
  %>  
      <!--
      <li>
        <a href="../Mypage/pay-policy.asp">
          <p><img src="../images/mypage/icon-mypage06@3x.png" alt="" /></p>
          <p>
            <strong>결제관리</strong>
            <span>나의 스포츠다이어리 결제현황입니다.</span>
          </p>
          <p><img src="../images/mypage/icon-more@3x.png" alt="결제관리 더보기" /></p>
        </a>
      </li>
      -->
    <!--// 2016-12-28 추가 -->
    </ul>
  </div>
  <!-- E : sub -->
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