<!-- #include virtual = "/pub/header.swimmingM.asp" -->
<%=CONST_HTMLVER%>

<%
	Set db = new clsDBHelper
'##############################################
' 소스 뷰 경계
'##############################################
%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.home.asp" -->
    <link rel="stylesheet" href="/home/css/index.css">
</head>
<body <%=CONST_BODY%>>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
    <div class="index_wrap">
      <!-- s 헤더 영역 -->
      <h1 class="index_header">
        <img src="./images/logo-index.svg" alt="대한수영연맹 로고">
      </h1>
      <!-- e 헤더 영역 -->
      <!-- s 메인 영역 -->
      <div class="index_main">
        <section class="index_main__contents">
          <h2><strong class="hide">콘텐츠 시작</strong></h2>
          <span class="index_main__contents__span">참가하실 대회의 리스트 보기를 선택해주세요.</span>
          <ul class="index_main__contents__list-group" style="width:60%; margin: auto;">
            <li class="index_main__contents__list-group__list">
              <h3 class="index_main__contents__list-group__list__header"><span>전문선수</span>대회</h3>
              <a class="index_main__contents__list-group__list__link" href="./page/list-pro.asp">대회리스트 보기</a>
              <span class="index_main__contents__list-group__list__noti">※ 반드시 대한체육회 지도자 및 선수등록<br>절차 후 신청바랍니다.</span>
            </li>
            <li class="index_main__contents__list-group__list">
              <h3 class="index_main__contents__list-group__list__header"><span>동호인선수</span>대회</h3>
              <a class="index_main__contents__list-group__list__link" href="#a">대회리스트 보기</a>
              <span class="index_main__contents__list-group__list__noti">※ 반드시 대한체육회 동호인등록<br>절차 후 신청바랍니다.</span>
            </li>
            <!-- <li class="index_main__contents__list-group__list">
              <h3 class="index_main__contents__list-group__list__header"><span>비등록선수</span>대회</h3>
              <a class="index_main__contents__list-group__list__link" href="#a">대회리스트 보기</a>
              <span class="index_main__contents__list-group__list__noti">※ 휴대폰본인인증 혹은 아이핀 인증 후<br>참가신청이 가능합니다.</span>
            </li> -->
          </ul>
        </section>
      </div>
      <!-- e 메인 영역 -->
    </div>
  </body>


<!-- #include virtual = "/pub/html/swimming/html.footer.home.asp" -->
</html>
