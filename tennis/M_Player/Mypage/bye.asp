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
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>회원탈퇴</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

<!-- S: sub -->
<div class="sub user_bye">
  <!-- S: img_box -->
  <div class="img_box">
    <img src="http://img.sportsdiary.co.kr/sdapp/mypage/ic_smile@3x.png" alt>
  </div>
  <!-- E: img_box -->

  <h2>회원탈퇴가 안전하게<br><span class="bluy">완료되었습니다.</span></h2>

  <p class="ment">보다 나은 서비스로 다시 찾아 뵙겠습니다.</p>
</div>
<!-- E: sub -->

<!-- S: bot_btn -->
<div class="bot_btn cta">
  <a href="#" class="btn btn-block btn-ok">확인</a>
</div>
<!-- E: bot_btn -->

<!-- S: bot-config -->
<!-- #include file= "../include/bot_config.asp" -->
<!-- E: bot-config -->
</body>
