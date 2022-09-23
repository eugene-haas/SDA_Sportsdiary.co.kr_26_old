<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
  <!-- #include file='./include/config.asp' -->
  <%
    '=================================================================================
    '회원탈퇴 성공메세지 페이지
    '=================================================================================
    '로그인하지 않았다면 login.asp로 이동
    Check_Login()
  %>
</head>
<body>
<div class="l">

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file='./include/header_back.asp' -->
      <h1 class="m_header__tit">회원탈퇴</h1>
      <!-- #include file='./include/header_home.asp' -->
    </div>
  </div>


  <div class="l_content m_scroll [ _content _scroll ]">
    <div class="m_combineHeader">
      <div class="m_combineHeader__imgWrap"><img src="./images/ic_smile@3x.png" class="m_combineHeader__img"></div>
      <h2 class="m_combineHeader__tit">회원탈퇴가 안전하게<br><span class="m_combineHeader__titPoint">완료되었습니다.</span></h2>
    </div>

    <div class="m_combineCont">
      <p class="m_combineCont__txt">보다 나은 서비스로 다시 찾아 뵙겠습니다.</p>
      <a href="./login.asp" class="m_combineCont__btn">확인</a>
    </div>
  </div>

  <!-- #include file= "./include/footer.asp" -->

</div>
</body>
</html>
