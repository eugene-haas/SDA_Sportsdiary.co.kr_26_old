<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file='./include/head.asp' -->
	<!--#include file="./include/config.asp"-->
</head>
<body>
<div class="l">

	<div class="l_header">
		<div class="m_header s_sub">
			<!-- #include file="./include/header_back.asp" -->
			<h1 class="m_header__tit">Sports Diary 통합안내</h1>
			<!-- #include file="./include/header_home.asp" -->
		</div>
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll total_id total_guide [ _content _scroll ]">

    <!-- S: top_section -->
    <section class="top_section">
      <h2>Sports Diary 가 새로워 집니다.</h2>
      <p>각 종목 및 회원 구분 별 아이디를 통합해서<br>새로워진 스포츠다이어리를 이용해 보세요.</p>
      <p><strong>회원구분 전환으로 종목 및 회원 권한 별<br> 화면 이동이 더 빠르고 쉬워 졌어요!!</strong></p>
      <div class="img_box">
        <img src="images/combine_id.png" alt="선수, 보호자, 지도자 모두 통합 아이디로 이용 가능합니다.">
      </div>
      <p>부모/엘리트/지도자 별 화면을 <br>이제 통합아이디 하나로 사용할 수 있습니다.</p>
      <p class="req">
        <label class="whole_btn ic_check act_btn on">
          <span class="txt">아이디 확인을 위한 개인정보 제공 동의(필수)</span>
          <input type="checkbox" checked>
          <svg version="1.1" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
              <path d="M16.667,62.167c3.109,5.55,7.217,10.591,10.926,15.75 c2.614,3.636,5.149,7.519,8.161,10.853c-0.046-0.051,1.959,2.414,2.692,2.343c0.895-0.088,6.958-8.511,6.014-7.3 c5.997-7.695,11.68-15.463,16.931-23.696c6.393-10.025,12.235-20.373,18.104-30.707C82.004,24.988,84.802,20.601,87,16"></path>
            </svg>
        </label>
      </p>
    </section>
    <!-- E: top_section -->

    <div class="cta">
      <a href="./total_id_sel.asp" class="btn btn-ok btn-block">통합하기</a>
    </div>

  </div>
  <!-- E: main -->

  <!-- #include file='./include/footer.asp' -->

  <script>
    WholeAgree.start('.total_guide'); // 개인 정보 제공 동의 체크 박스
  </script>

</div>
</body>
</html>
