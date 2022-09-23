<%
	'회원구분[선수보호자] gnb
%>

<%

	'LocateIDX_ham_1 = "66"
	'LocateIDX_ham_2 = "10"
	LocateIDX_ham_3 = "66"

%>

<div class="gnb <%=Type_Class%>" id="gnb">
  <!-- <div class="gnb-box"> -->
    <!-- S: gnb-header -->
    <div class="gnb-header clearfix">
      <!-- S: profile 사진 -->
      <div class="profile">
        <img id="imgGnb" src="<%=decode(Request.Cookies(SportsGb)("PhotoPath"), 0)%>" alt="프로필 사진">
      </div>
      <!-- E: profile 사진 -->
      <!-- S: 환영, 로그아웃 -->
      <div class="welcome">
        <h2><span><%=Request.Cookies(SportsGb)("UserName")%></span> 님 환영합니다.</h2>
        <a href="javascript:chk_logout();" class="login">로그아웃</a>
      </div>
      <!-- E: 환영, 로그아웃 -->
      <!-- S: gnb icon -->
      <div class="gnb-icon clearfix">
        <a href="../Main/main.asp">
          <img src="http://img.sportsdiary.co.kr/sdapp/gnb/home@3x.png" alt="홈으로 이동">
        </a>
        <a href="#" class="close-btn">
          <img src="http://img.sportsdiary.co.kr/sdapp/gnb/X@3x.png" alt="닫기">
        </a>
      </div>
      <!-- E: gnb icon -->
    </div>
    <!-- E: gnb-header -->
    <!-- S: navi-list 1-->
    <ul class="navi-list type1 non flex">
      <li>
        <a href="../Train/train.asp"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_pract_off@3x.png" alt></span><span class="menu-txt">훈련일지<span id="GNBTRAIN" style="display:none" class="ic-new">N</span></span></a>
      </li>
      <li>
        <a href="../MatchDiary/match-diary.asp"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_match_off@3x.png" alt></span><span class="menu-txt">대회일지<span id="GNBGAME" style="display:none" class="ic-new">N</span></span></a>
      </li>
    </ul>
    <!-- E: navi-list 1 -->
    <!-- S: navi-list 2 -->
    <ul class="navi-list type1 non flex">
      <li>
        <a href="../Strength/index.asp"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_physi_off@3x.png" alt></span><span class="menu-txt">체력측정<span id="GNBSTRENGTH" style="display:none" class="ic-new">N</span></span></a>
      </li>
      <li>
        <!-- 팀 매니저 미가입시
        <a href="#" data-toggle="modal" data-target="#now-ready"><span><img src="../images/include/gnb/icon_plan_off@3x.png" alt></span><span>팀 공지사항</span></a>
        <a href="javascript:chk_TeamNotice();"><span class="img-box"><img src="../images/include/gnb/icon_plan_off@3x.png" alt></span><span class="menu-txt">팀 공지사항<span id="GNBTNOTICE" style="display:none" class="ic-new">N</span></span></a>
        -->
        <a href="javascript:chk_LogMenuProc('TEAM_NOTICE','PARENTS');"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_plan_off@3x.png" alt></span><span class="menu-txt">팀 공지사항<span id="GNBTNOTICE" style="display:none" class="ic-new">N</span></span></a>
      </li>
    </ul>
    <!-- E: navi-list 2 -->
    <ul class="navi-list type2 flex">
      <!-- <li>
        <a href="../Board/team-notice-list.asp">
        //<a href="" data-toggle="modal" data-target="#now-ready">
          <span><img src="../images/include/gnb/ic-notice@3x.png" alt></span>
          <span>팀 공지사항</span>
        </a>
      </li> -->
      <!-- <li>
        <a href="#">
          <span><img src="../images/include/gnb/ic-video@3x.png" alt></span>
          <span>대회 영상 모음</span>
        </a>
      </li> -->
      <li>
        <a href="../Counsel/req_counsel.asp?typeMenu=req_counsel">
          <span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/ic-coach@3x.png" alt></span>
          <span class="menu-txt">지도자 상담</span>
        </a>
      </li>
    </ul>
    <!-- <ul class="navi-list non-type3 type3 flex">
      <li>
        <a href="../mypage/mypage.asp">
          <span class="img-box"><img src="../images/include/gnb/icon_myinfo_whity@3x.png" alt></span>
          <span class="menu-txt">마이페이지</span>
        </a>
      </li>
    </ul> -->
    <!-- S: cate-list -->
    <div class="cate-list">
      <!-- S: 나의 정보 -->
      <dl class="type3 clearfix">
        <!--상위메뉴-->
        <dt>나의 정보</dt>
        <!--상위메뉴-->
        <dd><a href="../Mypage/mypage.asp">마이페이지</a></dd>
        <dd><a href="../Schedule/sche-calendar.asp">나의 훈련 일정</a></dd>
        <dd><a href="../Stats/stat-training-attand.asp">나의 통계</a></dd>
        <dd class="clearfix"><a href="../Memory/memory-estimate.asp"><span class="menu-txt">메모리</span></a><span class="ic-wrap clearfix"><span id="GNBCOUNCEL" style="display:none" class="ic-new">N</span><span id="GNBCOUNCELRE" style="display:none" class="ic-re">Re</span></span></dd>
        <dd class="no-bdb clearfix"><a href="../board/my_memo.asp"><span class="menu-txt">나의 메모장</span></a><span class="ic-wrap clearfix"><span id="GNBCOUNCEL" style="display:none" class="ic-new">N</span><span id="GNBCOUNCELRE" style="display:none" class="ic-re">Re</span></span></dd>
        <dd class="clearfix"><a href="../Counsel/req_counsel.asp"><span class="menu-txt">지도자 상담</span></a><span class="ic-wrap clearfix"><span id="GNBCOUNCEL" style="display:none" class="ic-new">N</span><span id="GNBCOUNCELRE" style="display:none" class="ic-re">Re</span></span></dd>
      </dl>
      <!-- E: 나의 정보 -->
      <!-- S: 대회 정보 -->
      <dl class="clearfix">
        <!--상위메뉴-->
        <dt>대회 정보</dt>
        <!--상위메뉴-->
        <dd><a href="../Result/institute-search.asp">대회일정/결과</a></dd>
        <dd><a href="../Record/record-srch-win.asp">경기 기록실</a></dd>
        <dd><a href="../Analysis/analysis-match-result.asp">선수분석</a></dd>
        <!--//<dd><a href="../Enter/application.asp">대회 참가 신청 내역</a></dd>-->
        <dd><a href="../Analysis/analysis-film.asp">대회영상모음</a></dd>
      </dl>
      <!-- E: 대회 정보 -->
      <!-- S: 대회참가신청 -->
      <!--
      <dl class="clearfix">
        <dt><a href="#">대회참가신청</a></dt>
        <dd><a href="#">참가신청</a></dd>
        <dd><a href="#">신청 내역 확인</a></dd>
      </dl>
      -->
      <!-- E: 대회참가신청 -->
      <!-- S: 게시판 -->
      <!--
      <dl class="clearfix">
        <dt><a href="#">게시판</a></dt>
        <dd><a href="#">공지사항</a></dd>
        <dd><a href="#">기타일정</a></dd>
      </dl>
      -->
      <!-- E: 게시판 -->
      <!-- S: 커뮤니티 -->
      <dl class="clearfix">
        <dt>커뮤니티</dt>
        <dd><a href="../Board/notice-list.asp"><span class="menu-txt">공지사항<span id="GNBNOTICE" style="display:none;" class="ic-new">N</span></span></a></dd>
        <dd><a href="../Board/qa_board.asp">Q&amp;A 게시판</a></dd>
        <!-- <dd><a href="#">기술전수 칼럼</a></dd> -->
        <!-- <dd><a href="#">유도 소식</a></dd> -->
        <!-- <dd><a href="#">SD 사용후기</a></dd> -->
        <!-- <dd><a href="#">생활체육 소식</a></dd> -->
      </dl>
      <!-- E: 커뮤니티 -->
    </div>
    <!-- E: cate-list -->
    <div class="gnb-footer">
      <ul class="clearfix">
        <li class="r-bar"><a href="../Map/company.asp">사업자정보</a></li>
        <li class="r-bar"><a href="../Board/faq.asp">자주하는 질문</a></li>
        <li class="r-bar"><a href="../Map/info-map.asp">단체정보조회</a></li>
        <li class="r-bar"><a href="http://sdmain.sportsdiary.co.kr/sdmain/sdmall_request.asp">제휴/입점문의</a></li>
      </ul>
      <h3><img src="http://img.sportsdiary.co.kr/sdapp/footer/bottom-logo_judo@3x.png" alt="스포츠다이어리 유도"></h3>
    </div>
  <!-- </div> -->
  <!-- E: gnb-box -->
