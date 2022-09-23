<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!-- #include file="./include/config.asp" -->
	<%
		'로그인이 되어있다면 index.asp 이동
		Check_NoLogin()
	%>
</head>
<body>
<div class="l">

	<div class="l_header">
		<div class="m_header s_sub">
    <!-- #include file="./include/header_back.asp" -->
    <h1 class="m_header__tit">비밀번호 찾기</h1>
		<!-- #include file="./include/header_home.asp" -->
	  </div>
	</div>


  <div class="l_content m_scroll find_id combine_check [ _content _scroll ]">

    <div class="m_combineHeader">
      <div class="m_combineHeader__imgWrap"><img src="images/ic_check@3x.png" class="m_combineHeader__img"></div>
      <p class="m_combineHeader__txtLarge">비밀번호 찾기 결과 안내</p>
    </div>

    <div class="m_combineCont">
			<div class="m_combineCont__txt">
        <p>등록된 휴대폰 번호로 임시 비밀번호가<br> 전송되었습니다.</p>
      </div>

      <a href="./login.asp" class="m_combineCont__btn">로그인</a>
    </div>

  </div>


  <!-- #include file='./include/footer.asp' -->

</div>
</body>
</html>
