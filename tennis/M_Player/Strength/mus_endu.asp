<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<script  type="text/javascript" src="../js/Strength.js"></script>
<%
    StimFistCd_h      = fInject(Request("StimFistCd_h"))
	datetimepicker1_h = fInject(Request("datetimepicker1_h"))

    if IsNull(fInject(Request("datetimepicker1_h")))then
        datetimepicker1_h=Date()
    else
          if fInject(Request("datetimepicker1_h"))="" then
           datetimepicker1_h=Date()
        else
            datetimepicker1_h=fInject(Request("datetimepicker1_h"))
        end if
    end if

    if IsNull(fInject(Request("StimFistCd_h")))then
      StimFistCd_h="0"
    else
          if fInject(Request("StimFistCd_h"))="" then
           StimFistCd_h="0"
        else
            StimFistCd_h=fInject(Request("StimFistCd_h"))
        end if
    end if
%>

<body>
<form name="frm" id="frm" method="post">
  <input type="hidden" name="StimFistCd_h" id="StimFistCd_h" value="<%=StimFistCd_h %>">
  <input type="hidden" name="datetimepicker1_h"id="datetimepicker1_h"   value="<%=datetimepicker1_h %>">
  <input type="hidden" name="COUNT"id="COUNT"/>

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>체력측정</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: sub -->
  <div class="sub train strength">
       <div class="top-icon-menu">
      <ul class="flex">
        <li>
          <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_pract_off@3x.png" alt="훈련일지" /></a>
        </li>
        <li>
          <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_match_off@3x.png" alt="대회일지" /></a>
        </li>
        <li>
          <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_physi_on@3x.png" alt="체력측정" /></a>
        </li>
        <li>
          <a href="#"><img src="http://img.sportsdiary.co.kr/sdapp/train/icon_notice_off@3x.png" alt="팀 공지사항" /></a>
        </li>
      </ul>
      <p>나의 체력 상태를 입력하고 <span>동일체급</span> <br /> 혹은
      <span>국가대표 선수</span>의 체력과 비교해보세요.</p>
    </div>
    <!-- S : datepicker-wrap 훈련날짜 -->
    <div class="datepicker-wrap clearfix">
      <label for="datetimepicker1">측정날짜</label>
      <div class='input-group date' >
        <input id="datetimepicker1" type='date' class="form-control" onchange="Strength_serch(); return false;" value="<%=datetimepicker1_h %>">
        <span class="input-group-addon">
          <span class="glyphicon glyphicon-calendar"></span>
        </span>
      </div>
      <a href="#" class="btn-navy" onclick="DateToday(); return false;">오늘</a>
    </div>
    <!-- E : datepicker-wrap 훈련날짜 -->
    <!-- S : 컨디션 -->
    <div class="navyline-top-list">
        <label for="StimFistCd">측정항목</label>
        <select id="StimFistCd"onchange='StimFistCd_serch();'>
        </select>
    </div>
    <!-- E : 컨디션 -->
    <!-- S : 체력측정 guide-tip -->
    <div class="navyline-top-list guide-tip clearfix">
      <!-- S: list-bu-navy-wrap -->
      <div class="list-bu-navy-wrap bg-gray">
        <!-- S: tip-title -->
        <div class="tip-title">
          <a href=".tip-cont" data-toggle="collapse" class="set-collapse">
            <h3>
              <span class="deco-icon"><img src="http://img.sportsdiary.co.kr/sdapp/strength/icon_hand@3x.png" alt=""></span><span>근지구력 측정 가이드 팁 보기</span>
              <span class="img-round"><span class="caret"></span></span>
            </h3>
          </a>
        </div>
        <!-- E: tip-title -->
      </div>
      <!-- E: list-bu-navy-wrap -->
      <!-- S: tip-cont -->
      <div class="tip-cont container collapse">
        <p class="tip-txt">일정한 시간내에 최대의 반복횟수를 끌어올릴 수 있는 근육의 지구력 측정입니다.</p>
        <h4 class="l-bar">측정순서</h4>
        <h5 class="list-title">팔굽혀펴기 / 윗몸일으키기</h5>
        <ul class="user-guide">
          <li><span class="number-list">1</span>모든 측정은 1분동안 반복 실시 합니다.</li>
          <li><span class="number-list">2</span>1분 내, 가장 많은  횟수를 기록합니다.</li>
        </ul>

        <!-- S: tip-footer -->
        <div class="tip-footer">
            <h4 class="l-bar">출처</h4>
            <ul class="clearfix">
              <li><img src="http://img.sportsdiary.co.kr/sdapp/strength/sociate-1@3x.png" alt=""></li>
              <li><img src="http://img.sportsdiary.co.kr/sdapp/strength/sociate-2@3x.png" alt=""></li>
            </ul>
            <p class="tip-info">체력측정의 방법은 국가대표 선수들의 체력측정 방법과 동일합니다.</p>
        </div>
        <!-- E: tip-footer -->
      </div>
      <!-- E: tip-cont -->
    </div>
    <!-- E : 체력측정 guide-tip -->

    <!-- S: exc-list -->
    <div class="exc-list">
      <ul id ="exc-list">
        <li class="clearfix">
          <div class="event-img">
            <img src="http://img.sportsdiary.co.kr/sdapp/strength/icon-push-up@3x.png" alt>
          </div>
          <div class="exc-cont">
            <p class="exc-title">팔굽혀펴기</p>
            <p class="exc-exp">세트 반복없이 단 1회의 초기 기록</p>
          </div>
          <div class="exc-count">
            <label>
              <input type="text" value="55">회
            </label>
          </div>
        </li>
        <li class="clearfix">
          <div class="event-img">
            <img src="http://img.sportsdiary.co.kr/sdapp/strength/icon-sit-up@3x.png" alt>
          </div>
          <div class="exc-cont">
            <p class="exc-title">윗몸 일으키기</p>
            <p class="exc-exp">세트 반복없이 단 1회의 초기 기록</p>
          </div>
          <div class="exc-count">
            <label>
              <input type="text" value="48">회
            </label>
          </div>
        </li>
      </ul>
    </div>
    <!-- E: exc-list -->
    <div class="container">
      <a href="#" class="btn-full" onclick="SaveData(); return false;">기록 저장</a>
    </div>
  </div>
  <!-- E : sub -->

  <!-- S: footer -->
  <div class="footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
  </form>
</body>
