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
              <span class="deco-icon"><img src="http://img.sportsdiary.co.kr/sdapp/strength/icon_hand@3x.png" alt=""></span><span>유연성 측정 가이드 팁 보기</span>
              <span class="img-round"><span class="caret"></span>
            </h3>
          </a>
        </div>
        <!-- E: tip-title -->
      </div>
      <!-- E: list-bu-navy-wrap -->
      <!-- S: tip-cont -->
      <div class="tip-cont container collapse">
        <p class="tip-txt">신체의 유연성과 밸런스를 측정합니다.</p>
        <h4 class="l-bar">측정순서</h4>
        <h5 class="list-title">윗몸 앞으로 굽히기(체전굴)</h5>
        <ul class="user-guide">
          <li><span class="number-list">1</span>바닥에 앉을 때 다리를 곧게 펴고 앉습니다.</li>
          <li><span class="number-list">2</span>양손을 위로 올려 머리를 가운데에 둡니다.</li>
          <li><span class="number-list">3</span>반동을 주지않고 천천히 윗몸을 앞으로 굽히면서 두손의 손 끝은 다리를 가볍게 스치면서 곧게 내려 폅니다.</li>
          <li><span class="number-list">4</span>윗몸이 최대한으로 굽혀졌을 때 손끝이 내려간 거리를 잽니다.</li>
          <li><span class="number-list">5</span>이때 가운데 손가락으로 재고 3초간 상체와 두팔을 고정시 키고, 머리는 양팔 사이로 넣습니다.</li>
          <li><span class="number-list">6</span>총 2회 실시하며 가장 좋은 기록을 잽니다.</li>
        </ul>
<!--         <h4 class="muscle-sub-title"><img src="../images/strength/muscle-sub-title@3x.png" alt="벤치프레스 측정기준"></h4> -->
        <!-- S: muscle-way -->
        <div class="muscle-way power container">
<!--           <ul class="way-list">
            <li>
              <h5>1</h5>
              <p>벤치 위에 누워 어깨넓이보다 약간 넓게 그립을 잡는다.</p>
            </li>
            <li>
              <h5>2</h5>
              <p>바벨을 들어 팔이 완전히 다 펴질 때까지 들어올린다.</p>
              <span>※준비동작</span>
            </li>
            <li>
              <h5>3</h5>
              <p>명치를 최대한 끌어올린다는 느낌과 함께 팔꿈치를 구부려 바가 가슴의 중앙 부분에 올 수 있도록 내린다. <span class="orangy">※팔꿈치는 바깥쪽을 향하여 내리며, 이때 팔꿈치와 손목은 바와 수직선상에 있을 수 있도록 자세에 신경 쓰도록 합니다.</span>
              </p>
            </li>
            <li>
              <h5>4</h5>
              <p>가슴 근육을 수축시키면서 팔이 완전히 다 펴질 때까지 바벨을 들어 올립니다.</p>
              <span>※3~4번 동작이 이루어져야 측정이 인정됩니다.</span>
            </li>
          </ul>
          <div class="way-img">
            <img src="../images/strength/muscles-way-img@3x.png" alt="근력 운동 방법">
          </div> -->
          <img src="http://img.sportsdiary.co.kr/sdapp/strength/flexi-1@3x.png" alt="">
        </div>
        <!-- E: muscle-way -->

        <h5 class="list-title">윗몸 뒤로 젖히기(체후굴)</h5>
        <ul class="user-guide">
          <li><span class="number-list">1</span>피검자가 엎드려서 양손을 허리뒤로 열중쉬어 자세를 취합니다.</li>
          <li><span class="number-list">2</span>보조자가 대퇴부 위치에서 무릎 위쪽을 잡아주는 역할을 합 니다.</li>
          <li><span class="number-list">3</span>피검자는 엎드린 상태에서 최대한 윗몸을 뒤로 젖히면서 턱 을 위로 내밉니다.(윗몸을 뒤로 젖힐 때 반동을 써서는 안 됨)</li>
          <li><span class="number-list">4</span>매트 또는 바닥에서부터 하약골(턱아래) 부분까지 수직거리 를 잽니다.</li>
          <li><span class="number-list">5</span>총 2회 실시하며 가장 좋은 기록을 잽니다.(자로 재도 무관 합니다.)</li>
        </ul>
<!--         <h4 class="muscle-sub-title"><img src="../images/strength/muscle-sub-title@3x.png" alt="벤치프레스 측정기준"></h4> -->
        <!-- S: muscle-way -->
        <div class="muscle-way container">
<!--           <ul class="way-list">
            <li>
              <h5>1</h5>
              <p>벤치 위에 누워 어깨넓이보다 약간 넓게 그립을 잡는다.</p>
            </li>
            <li>
              <h5>2</h5>
              <p>바벨을 들어 팔이 완전히 다 펴질 때까지 들어올린다.</p>
              <span>※준비동작</span>
            </li>
            <li>
              <h5>3</h5>
              <p>명치를 최대한 끌어올린다는 느낌과 함께 팔꿈치를 구부려 바가 가슴의 중앙 부분에 올 수 있도록 내린다. <span class="orangy">※팔꿈치는 바깥쪽을 향하여 내리며, 이때 팔꿈치와 손목은 바와 수직선상에 있을 수 있도록 자세에 신경 쓰도록 합니다.</span>
              </p>
            </li>
            <li>
              <h5>4</h5>
              <p>가슴 근육을 수축시키면서 팔이 완전히 다 펴질 때까지 바벨을 들어 올립니다.</p>
              <span>※3~4번 동작이 이루어져야 측정이 인정됩니다.</span>
            </li>
          </ul>
          <div class="way-img">
            <img src="../images/strength/muscles-way-img@3x.png" alt="근력 운동 방법">
          </div> -->
          <img src="http://img.sportsdiary.co.kr/sdapp/strength/flexi-2@3x.png" alt>
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
            <img src="http://img.sportsdiary.co.kr/sdapp/strength/icon-flexi-1@3x.png" alt>
          </div>
          <div class="exc-cont">
            <p class="exc-title">윗몸 앞으로 굽히기(체전굴)</p>
            <p class="exc-exp">총 2세트 중 최고 기록</p>
          </div>
          <div class="exc-count">
            <label>
              <input type="text" value="38">회
            </label>
          </div>
        </li>
        <li class="clearfix">
          <div class="event-img">
            <img src="http://img.sportsdiary.co.kr/sdapp/strength/icon-flexi-2@3x.png" alt>
          </div>
          <div class="exc-cont">
            <p class="exc-title">윗몸 뒤로 젖히기(체후굴)</p>
            <p class="exc-exp">총 2세트 중 최고 기록</p>
          </div>
          <div class="exc-count">
            <label>
              <input type="text" value="26">회
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
