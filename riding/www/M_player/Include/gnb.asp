<div class="l_gnb [ _gnb ] " id="gnb">
  <div class="l_gnb__dim [ _gnbDim _gnbClose ] "></div>

  <div class="l_gnb__box [ _gnbBox ] ">
    <div class="l_gnb__cont">

      <div class="m_profile" v-if="login_chk">
        <div class="m_profile__imgWrap">
          <img id="imgGnb" src="http://img.sportsdiary.co.kr/images/SD/img/profile@3x.png" alt="프로필 사진" class="m_profile__img">
        </div>
        <div class="m_profile__txtWrap">
          <h2 class="m_profile__txt"><span class="m_profile__name">{{name}}</span> 님</h2>
          <span class="m_profile__belong">{{grade}}</span>
        </div>
        <div class="m_profile__btns">
          <a href="http://sdmain.sportsdiary.co.kr/sdmain/mypage/mypage.asp" class="m_profile__btn s_toMypage"></a>
        </div>
      </div>

      <div class="m_userJoin" v-else>
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

      <!-- <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">나의 다이어리</h2>
        <ul class="m_navHList">
          <li class="m_navHList__item"> <a class="m_navHList__link s_train" href="../Train/train.asp"> 훈련일지 </a> </li>
          <li class="m_navHList__item"> <a class="m_navHList__link s_match" href="../MatchDiary/match-diary.asp"> 대회일지 </a> </li>
          <li class="m_navHList__item"> <a class="m_navHList__link s_physic" href="../Strength/index.asp"> 체력측정 </a> </li>
          <li class="m_navHList__item"> <a class="m_navHList__link s_injury" href="../Stats/stat-injury-dist.asp"> 부상정보 </a> </li>
        </ul>
      </div>

      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">나의 정보</h2>
        <ul class="m_navList">
          <li class="m_navList__item"> <a class="m_navList__link" href="http://sdmain.sportsdiary.co.kr/sdmain/mypage/mypage.asp"> 마이페이지 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../Schedule/sche-calendar.asp"> 나의 훈련 일정 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../Stats/stat-record.asp"> 나의 통계 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../Memory/memory-estimate.asp"> 메모리 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../board/my_memo.asp"> 나의 메모장 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="javascript:chk_LogMenuProc('COUNSEL', '../Counsel/req_counsel.asp?typeMenu=req_counsel');"> 지도자 상담 </a> </li>
        </ul>
      </div> -->

      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">대회정보</h2>
        <ul class="m_navList">
          <li class="m_navList__item"> <a class="m_navList__link" href="../Result/institute-search.asp"> 대회일정/결과 </a> </li>
          <li class="m_navList__item s_notReady"> <a class="m_navList__link"> 기록/순위 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../result/gamevideo.asp"> 경기영상 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../result/stadium_sketch.asp"> 현장스케치 </a> </li>
        </ul>
      </div>

      <!-- <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">커뮤니티</h2>
        <ul class="m_navList">
          <li class="m_navList__item"> <a class="m_navList__link" href="../Board/notice-list.asp"> 공지사항 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../Board/qa_board.asp"> Q&amp;A 게시판 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../Media/list.asp"> SD 뉴스 </a> </li>
          <li class="m_navList__item"> <a class="m_navList__link" href="../Column/list.asp"> SD 칼럼 </a> </li>
        </ul>
      </div>

      <div class="m_gnbBoard">
        <h2 class="m_gnbBoard__tit">게시판</h2>
        <ul class="m_navHList s_3items">
          <li class="m_navHList__item"> <a class="m_navHList__link s_notice" href="javascript:chk_LogMenuProc('TEAM_NOTICE', '../board/team-notice-list.asp');"> 팀 공지사항 </a> </li>
          <li class="m_navHList__item"> <a class="m_navHList__link s_faq" href="../Board/faq.asp"> 자주하는 질문 </a> </li>
          <li class="m_navHList__item"> <a class="m_navHList__link s_ins" href="../Map/info-map.asp"> 단체정보조회 </a> </li>
        </ul>
      </div> -->

      <!-- S: main banner 03 -->
      <!-- E: main banner 03 -->

    </div>

    <div class="l_gnb__fNav">
      <a href="http://sdmain.sportsdiary.co.kr/sdmain/index.asp" class="l_gnb__fNavItem s_event [ _defenseLinkIgnore ] "> 종목 선택 </a>
      <a href="javascript:alert('sportsdiary://goPushMsg');" class="l_gnb__fNavItem s_push [ _defenseLinkIgnore ] "> 앱 알림함 </a>
      <a href="../main/index.asp" class="l_gnb__fNavItem s_home [ _defenseLinkIgnore ] "> 홈으로 </a>
      <a class="l_gnb__fNavItem s_close [ _gnbClose _defenseLinkIgnore ]"> 닫기 </a>
    </div>

  </div>
</div>
