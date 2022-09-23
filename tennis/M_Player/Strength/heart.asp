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
              <span class="deco-icon"><img src="http://img.sportsdiary.co.kr/sdapp/strength/icon_hand@3x.png" alt=""></span><span>심폐지구력 측정 가이드 팁 보기</span>
              <span class="img-round"><span class="caret"></span></span>
            </h3>
          </a>
        </div>
        <!-- E: tip-title -->
      </div>
      <!-- E: list-bu-navy-wrap -->
      <!-- S: tip-cont -->
      <div class="tip-cont container collapse">
        <p class="tip-txt">정해진 속도 내에 반복해서 달릴 수 있는 최대의 횟수를 측정 합니다.</p>
        <h4 class="l-bar">측정순서</h4>
        <ul class="user-guide heart">
          <li><span class="number-list">1</span>10M 거리의 양쪽 끝을 테이프 혹은 별도로 표시합니다.</li>
          <li><span class="number-list">2</span>출발신호 관리자가 별도로 출발신호를 울립니다.</li>
          <li><span class="number-list">3</span>편도 달리기와 편도 달리기 사이의 시간은 현장에서 조절하 여 정하고, 점점 쉬는 구간의 시간을 줄여나갑니다.</li>
          <li><span class="number-list">4</span>매번 편도 10M를 먼저 도착한 사람은 다음 출발신호가 울 릴 때까지 대기하고, 다시 출발신호가 울리면 반대쪽 라인 끝을 향해 달립니다.</li>
          <li><span class="number-list">5</span>왕복하는 동안 정해진 주기에 따라 속도가 빨라집니다.</li>
          <li><span class="number-list">6</span>정해는 횟수 없이 무한반복되고, 최후 1인이 남을 때 검사는 종료 됩니다.</li>
          <li><span class="number-list orangy">7</span>반복되는 구간별로 출발신호에 따t라오지 못하여 지목받는 사람은 본인의 종료된 마지막 횟수를 기록합니다.(편도 횟수로 기록)</li>
        </ul>
        <h4 class="muscle-sub-title"><img src="http://img.sportsdiary.co.kr/sdapp/strength/heart-sub-title@3x.png" alt="셔틀런 측정기준"></h4>
        <!-- S: muscle-way -->
        <div class="muscle-way container">
          <img src="http://img.sportsdiary.co.kr/sdapp/strength/shuttle-run@3x.png" alt>
        </div>
        <!-- E: muscle-way -->
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
            <img src="http://img.sportsdiary.co.kr/sdapp/strength/icon-shuttle-run@3x.png" alt>
          </div>
          <div class="exc-cont">
            <p class="exc-title">10M 왕복 달리기(셔틀런)</p>
            <p class="exc-exp">정해진 속도에 따라 최대로 달린 편도 횟수</p>
          </div>
          <div class="exc-count">
            <label>
              <input type="text" value="30">회
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
