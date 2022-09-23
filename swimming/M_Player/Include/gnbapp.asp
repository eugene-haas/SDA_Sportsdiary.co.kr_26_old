<div class="l_gnb [ _gnb ] " id="gnb">
  <div class="l_gnb__dim [ _gnbDim _gnbClose ] "></div>

  <div class="l_gnb__box [ _gnbBox ] ">
    <div class="l_gnb__cont">



<%
Cookies_id = Request.Cookies("SD")("UserID")
Cookies_name = Request.Cookies("SD")("UserName")

If Cookies_name <> "" then
%>
      <div class="m_profile">
        <div class="m_profile__imgWrap">
          <img id="imgGnb" src="http://img.sportsdiary.co.kr/images/SD/img/profile@3x.png" alt="프로필 사진" class="m_profile__img">
        </div>
        <div class="m_profile__txtWrap">
          <h2 class="m_profile__txt"><span class="m_profile__name"><%=Cookies_name%>(<%=Cookies_id%>)</span> 님</h2>
          <span class="m_profile__belong">일반</span>
        </div>
        <div class="m_profile__btns">
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/mypage/mypage.asp" class="m_profile__btn s_toMypage"></a>
        </div>
      </div>
<%else%>
      <div class="m_userJoin">
        <h2 class="m_userJoin__guide">
          <span class="m_userJoin__guideTxt">처음이신가요?</span><br>
          <span class="m_userJoin__guideTxt s_blue">회원가입을 해주세요.</span>
        </h2>
        <div class="m_userJoin__btns">
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/login.asp" class="m_userJoin__btn">
            <span class="m_userJoin__btnIcon s_login"></span><span class="m_userJoin__btnTxt s_login">로그인</span>
          </a>
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/combine_check.asp" class="m_userJoin__btn">
            <span class="m_userJoin__btnIcon s_account"></span><span class="m_userJoin__btnTxt s_account">회원가입</span>
          </a>
        </div>
      </div>
<%End if%>


      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">대회정보</h2>
        <ul class="m_navList">
          <li class="m_navList__item"> <a class="m_navList__link" href="/Result/institute-search.asp"> 대회일정/결과 </a> </li>
          <li class="m_navList__item s_notReady"> <a class="m_navList__link"> 기록/순위 </a> </li>
          

        </ul>
      </div>


    </div>

    <div class="l_gnb__fNav">
      <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="l_gnb__fNavItem s_event [ _defenseLinkIgnore ] "> 종목 선택 </a>
      <a href="javascript:alert('sportsdiary://goPushMsg');" class="l_gnb__fNavItem s_push [ _defenseLinkIgnore ] "> 앱 알림함 </a>
      <a href="/main/index.asp" class="l_gnb__fNavItem s_home [ _defenseLinkIgnore ] "> 홈으로 </a>
      <a class="l_gnb__fNavItem s_close [ _gnbClose _defenseLinkIgnore ]"> 닫기 </a>
    </div>

  </div>
</div>
