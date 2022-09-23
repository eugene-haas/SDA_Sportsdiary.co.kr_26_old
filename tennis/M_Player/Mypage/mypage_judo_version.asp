<!-- #include file="../include/config.asp" -->
<%
  '=================================================================================
  '마이페이지
  '=================================================================================
  '로그인하지 않았다면 login.asp로 이동
  Check_Login()
  
  dim UserID      : UserID      = request.Cookies("SD")("UserID")
  dim UserName    : UserName      = request.Cookies("SD")("UserName")
  
  dim PhotoPath   : PhotoPath     = decode(request.Cookies(SportsGb)("PhotoPath"), 0)
  dim PlayerReln  : PlayerReln    = decode(request.Cookies(SportsGb)("PlayerReln"), 0)
  dim EnterType   : EnterType     = request.Cookies(SportsGb)("EnterType")
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
  <!-- #include file="../include/sub_header_gnb.asp" -->
  <!-- E: sub_header_gnb -->
</div>
<!-- E: sub-header -->
<!-- S: sub -->
<div class="sub mypage">
  <div class="user-img-wrap">
    <div class="user-img"> <img src="<%=PhotoPath%>" alt="" /> </div>
    <p><%=UserName%>(<%=UserID%>) 님</p>
  </div>
  <ul class="mypage-menu">
    <li> <a href="../Mypage/myinfo.asp">
      <p><img src="../images/mypage/icon-mypage01@3x.png" alt="" /></p>
      <p> <strong>내정보 관리</strong> <span>프로필사진,개인정보 변경을 할 수 있습니다.</span> </p>
      <p><img src="../images/mypage/icon-more@3x.png" alt="내정보 관리 더보기" /></p>
      </a> </li>
    <li> <a href="../../../sdmain/fnd_pwd.asp">
      <p><img src="../images/mypage/icon-mypage02@3x.png" alt="" /></p>
      <p> <strong>비밀번호 변경</strong> <span>안전한 보안설정으로 정보를 보호하세요.</span> </p>
      <p><img src="../images/mypage/icon-more@3x.png" alt="비밀번호 변경 더보기" /></p>
      </a> </li>
    <%
    '20170721 테스트진행중
    ' IF decode(request.Cookies("UserID"),0) = "player12" Then
    %>
    <!--
    <li> <a href="../Mypage/player_card.asp">
      <p><img src="../images/mypage/icon-player-card@3x.png" alt=""></p>
      <p> <strong>내 선수증 관리</strong> <span>나의 선수증을 간편하게 관리하세요.</span> </p>
      <p> <img src="../images/mypage/icon-more@3x.png" alt="내 선수증 관리"> </p>
      </a> </li>
      -->
    <%
    ' End IF
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
  
    SELECT CASE PlayerReln
      CASE "R", "K", "S"
    %>
    <li> <a href="../Mypage/training.asp">
      <p><img src="../images/mypage/icon-mypage05@3x.png" alt="" /></p>
      <p> <strong>훈련 종류 항목관리</strong> <span>체력훈련, 도복훈련의 항목을 변경합니다.</span> </p>
      <p><img src="../images/mypage/icon-more@3x.png" alt="훈련 종류 항목관리 더보기" /></p>
      </a> </li>
    <%
    CASE ELSE
  END SELECT  
    %>
    <li> <a href="../Mypage/user_account.asp">
      <p><img src="../images/mypage/icon-mypage05@3x.png" alt=""></p>
      <p> <strong>종목 계정 관리</strong> <span>사용자의 계정을 관리 합니다.</span> </p>
      <p><img src="../images/mypage/icon-more@3x.png" alt="사용자 계정 관리"></p>
      </a> </li>
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
