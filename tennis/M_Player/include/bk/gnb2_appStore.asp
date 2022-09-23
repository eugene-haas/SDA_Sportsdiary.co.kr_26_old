http://img.sportsdiary.co.kr/sdapp<script type="text/javascript">
  function chk_logout(){
    var expdate = new Date();

    expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
    setCookie("sd_saveid", "", expdate);
    setCookie("sd_savepass", "", expdate);

    var strAjaxUrl = "/M_Player/Ajax/logout.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {
        },
      success: function(retDATA) {
        if(retDATA){
          if (retDATA=="TRUE") {
            alink = "/M_Player/Main/login.asp"
            $(location).attr('href',alink);   //a href
          }else{
            alert('로그아웃중에 오류가 발생하였습니다.');
          }
        }
      }, error: function(xhr, status, error){
        alert ("오류발생! - 시스템관리자에게 문의하십시오!");
      }
    });
  }

  //쿠키정보 저장
  function setCookie (name, value, expires) {
    document.cookie = name + "=" + escape (value) +
    "; path=/; expires=" + expires.toGMTString();
  }

  $(document).ready(function(){
    //팀공지사항 24시간 이전 정보체크
    var strAjaxUrl="/M_Player/ajax/Main_ChkTeamNotice.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {},
      success: function(retDATA) {
        if(retDATA=="TRUE"){
          $("#NewNotice").css("display","block");
        }
        else{
          $("#NewNotice").css("display","none");
        }
      }, error: function(xhr, status, error){
        alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
      }
    });
  });

  //소속 팀매니저 가입체크
  function chk_TeamNotice(){
    var strAjaxUrl="/M_Player/ajax/Main_ChkTeamManager.asp";

    $.ajax({
      url: strAjaxUrl,
      type: 'POST',
      dataType: 'html',
      data: {},
      success: function(retDATA) {
        if(retDATA=="FALSE"){
          //팀매니저 미가입시 Modal OPEN
          $("#now-ready").modal();
        }
        else{
          $('form[name=frm]').attr('action',"/M_Player/board/team-notice-list.asp");
          $('form[name=frm]').submit();

          $(location).attr('href', "/M_Player/board/team-notice-list.asp");
        }
      }, error: function(xhr, status, error){
        alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!");
      }
    });
  }
</script>
<div class="gnb">
  <!-- <div class="gnb-box"> -->
    <!-- S: gnb-header -->
    <div class="gnb-header clearfix">
      <!-- S: profile 사진 -->
      <div class="profile">
        <img id="imgGnb" src="<%=decode(Request.Cookies("PhotoPath"), 0)%>" alt="프로필 사진">
      </div>
      <!-- E: profile 사진 -->
      <!-- S: 환영, 로그아웃 -->
      <div class="welcome">
        <h2><span><%=Request.Cookies("UserName")%></span> 님 환영합니다.</h2>
        <a href="javascript:chk_logout();" class="login">로그아웃</a>
      </div>
      <!-- E: 환영, 로그아웃 -->
      <!-- S: gnb icon -->
      <div class="gnb-icon clearfix">
        <a href="../Main/index.asp">
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
    <ul class="navi-list flex">
      <li>
        <a href="../Train/train.asp"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_pract_off@3x.png" alt></span><span class="menu-txt">훈련일지<span class="ic-new">N</span></span></a>
      </li>
      <li>
        <a href="../MatchDiary/match-diary.asp"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_match_off@3x.png" alt></span><span class="menu-txt">대회일지<span class="ic-new">N</span></span></a>
      </li>
    </ul>
    <!-- E: navi-list 1 -->
    <!-- S: navi-list 2 -->
    <ul class="navi-list flex">
      <li>
        <a href="../Strength/index.asp"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_physi_off@3x.png" alt></span><span class="menu-txt">체력측정</span></a>
      </li>
      <li>
        <!-- 팀 매니저 미가입시 <a href="#" data-toggle="modal" data-target="#now-ready"><span><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_plan_off@3x.png" alt></span><span>팀 공지사항</span></a> -->
        <a href="javascript:chk_TeamNotice();"><span class="img-box"><img src="http://img.sportsdiary.co.kr/sdapp/gnb/icon_plan_off@3x.png" alt></span><span class="menu-txt">팀 공지사항<span style="display:none" id="NewNotice" class="ic-new">N</span></span></a>
      </li>
    </ul>
    <!-- E: navi-list 2 -->
    <!-- S: cate-list -->
    <div class="cate-list">
      <!-- S: 나의 정보 -->
      <dl class="clearfix">
        <!--상위메뉴-->
        <dt>나의 정보</dt>
        <!--상위메뉴-->
        <dd><a href="../Mypage/mypage.asp">마이페이지</a></dd>
        <dd><a href="../Schedule/sche-calendar.asp">나의 훈련 일정</a></dd>
        <dd><a href="../Stats/stat-intro.asp">나의 통계</a></dd>
        <dd><a href="../Memory/memory-intro.asp">메모리</a></dd>
      </dl>
      <!-- E: 나의 정보 -->
      <!-- S: 대회 정보 -->
      <dl class="clearfix">
        <!--상위메뉴-->
        <dt>대회 정보</dt>
        <!--상위메뉴-->
        <dd><a href="../Result/institute-search.asp">대회일정/결과</a></dd>
        <dd><a href="../Record/record-intro.asp">경기 기록실</a></dd>
        <dd><a href="../Analysis/analysis-intro.asp">선수분석</a></dd>
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
        <dd><a href="../Board/notice-list.asp">공지사항</a></dd>
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
        <li class="r-bar">
          <a href="../Map/company.asp">사업자정보</a>
        </li>
        <li class="r-bar">
          <a href="../Board/faq.asp">자주하는 질문</a>
        </li>
        <li>
          <a href="../Map/info-map.asp">단체정보조회</a>
        </li>
      </ul>
      <h3><img src="http://img.sportsdiary.co.kr/sdapp/footer/bottom-logo@3x.png" alt="스포츠다이어리 유도"></h3>
    </div>
  <!-- </div> -->
</div>
<!-- S: tops top-btn -->
<div class="tops btn-div">
  <a href="#" class="top_btn">TOP</a>
</div>
<!-- E: tops top-btn -->
<!-- S: modal now-ready -->
<div class="modal fade confirm-modal" id="now-ready" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="http://img.sportsdiary.co.kr/sdapp/public/close-x@3x.png" alt="닫기"></span></button>
        <h4 class="modal-title" id="myModalLabel">알림</h4>
      </div>
      <div class="modal-body">
        <p class="pop-guide">지도자가 팀매니저 관리 시<br>확인하실 수 있습니다.</p>
      </div>
      <div class="modal-footer clearfix">
        <label class="img-replace"><input type="checkbox"><span>오늘 하루 보지 않기</span></label>
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
<!-- E: modal now-ready -->
