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
<div class="sub user_out">
  <ul class="guide_list">
    <li>
      <p>통합아이디로 가입된 모든 계정의 서비스 이용기록, 개인 기록 및 정보가 삭제되며, 삭제된 데이터는 복구되지 않습니다.</p>
    </li>
    <li>
      <p>탈퇴 이후 아이디 복구 및 동일한 아이디로 재가입은 불가 능 합니다.</p>
    </li>
    <li>
      <p>게시판 및 커뮤니티에 등록한 모든 게시물과 업로드 한 이미지 및 영상은 탈퇴 후에도 삭제되지 않으며, 삭제를 원할 경우 반드시 탈퇴 이전에 삭제해 주셔야 합니다.</p>
    </li>
    <li>
      <p>전자상거래 등에서의 소비자보호에 관한 법률 제 6조
(거래기록의 보전 등)에 의거, 거래의 주체를 식별할 수 있는 정보에 한하여 서비스 이용에 관한 동의를 철회한 경우에도 이를 보전할 수 있으며, 동법 시행령 제6조에 의거 다음과 같이 거래 기록을 보관합니다.</p>
    </li>
  </ul>

  <pre class="record_ob">
- 표시,광고에 관한 기록 : 6개월
- 계약 또는 청약철회 등에 관한 기록 : 5년
- 대금결제 및 재화 등의 공급에 관한 기록 : 5년
- 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년
  </pre>

  <p class="assign_date">서비스해지일자 : 2017년 11월 10일</p>

  <!-- S: ipt_box -->
  <div class="ipt_box input-form">
    <label>
      <span class="tit">비밀번호를 입력하세요.</span>
      <input type="password" class="input-control no_placeholder">
    </label>
  </div>
  <!-- E: ipt_box -->
</div>
<!-- E: sub -->

<!-- S: bot_btn -->
<div class="bot_btn cta">
  <a href="./bye.asp" class="btn btn-block btn-ok">확인</a>
</div>
<!-- E: bot_btn -->


<!-- S: bot-config -->
<!-- #include file= "../include/bot_config.asp" -->
<!-- E: bot-config -->
</body>
