<!DOCTYPE html>
<html>

<head>
<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
  <link href='../css/library/fullcalendar.min.css' rel='stylesheet' />
  <link href='../css/library/fullcalendar.print.css' rel='stylesheet' media='print' />
  <!-- calendar 대응 -->
  <script src="../js/library/jquery-1.12.2.min.js"></script>
  <script src='../js/library/moment.min.js'></script>
  <script src='../js/library/fullcalendar.min.js'></script>
  <script src="../js/library/ko.js"></script>
</head>

<%
PlayerIDX =146


NowYear  = year(now)    '금년도
NowMonth = month(now)   '금월 
%>
<script type="text/javascript">



</script>

<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->+
    <h1>나의 일정</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
  <div class="calendar">
    <!-- S: calendar-header -->
      <div class="calendar-header container">
        <!-- S: line-1 -->
        <div class="line-1 schedule clearfix">
          <div class="select-list clearfix">
            <button class="prev-btn" type="button">&lt;</button>

            <select  name="year" class="year" >
              <option value="">2017년</option>
            </select>

            <span name="month" class="month">2월</span>
            <button class="next-btn" type="button">&gt;</button>
          </div>
          <button class="today-btn" type="button" >오늘</button>
        </div>
        <!-- E: line-1 -->
        <!-- S: line-3 -->
        <div class="line-3 schedule clearfix">
          <ul class="clearfix">
            <li><a href="calendar.html"><img src="../images/institute/icon-calendar-off@3x.png" alt="달력보기"></a></li>
            <li><a href="list.asp"><img src="../images/institute/icon-list-on@3x.png" alt="리스트보기"></a></li>
          </ul>
        </div>
        <!-- E: line-3 -->
      </div>
      <!-- E: calendar-header -->
  </div>
  <!-- S: main -->
  <div class="main">
    <!-- S: schedule -->
    <div class="schedule"> 
<!--
    loop start 
    
    
    달력 년월 
    
    sp : 
    
    년 / 월 / 일 스케쥴 상태값 적용 
    
    
     

   
-->


      <!-- S: 3일 -->
      <section>
        <div class="schedule-header sche-title">
          <h2><span>02</span>일</h2>
        </div>
        <!-- S: 훈련 -->
        <a href="http://sportsdiary.co.kr/M_Player/Schedule/sche-train.asp">
          <dl class="day-list  clearfix">
            <dt class="train"><span class="one-word">훈</span><span>[훈련]</span></dt>
            <dd>
              <p>훈련참석(정상)</p>
              <p class="detail">새벽훈련(1시간) 오전훈련(2시간)</p>
              <p class="detail">오후훈련(1시간 30분) 야간훈련(2시간 30분)</p>
            </dd>
          </dl>
        </a>
        <!-- E: 훈련 -->

        <!-- S: 부상 -->
        <a href="http://sportsdiary.co.kr/M_Player/Schedule/sche-injury.asp">
          <dl class="day-list clearfix">
            <dt class="injury"><span class="one-word">부</span><span>[부상]</span></dt>
            <dd>
              <p>훈련불참/부상</p>
            </dd>
          </dl>
        </a>
        <!-- E: 부상 -->

        <!-- S: 생리 -->
        <dl class="day-list clearfix">
          <dt class="period"><span class="one-word">생</span><span>[생리]</span></dt>
          <dd>
            <p>생리중/훈련참석</p>
          </dd>
        </dl>
        <!-- E: 생리 -->

        <!-- S: 연습 -->
        <!-- <a href="http://sportsdiary.co.kr/M_Player/Schedule/sche-match.asp">
          <dl class="day-list clearfix">
            <dt class="pract"><span class="one-word">연</span><span>[연습]</span></dt>
            <dd>
              <p>홍길동/승(한판)</p>
            </dd>
          </dl>
        </a> -->
        <!-- E: 연습 -->

        <!-- S: 체력 -->
        <a href="http://sportsdiary.co.kr/M_Player/Strength/muscles.asp">
          <dl class="day-list clearfix">
            <dt class="physical"><span class="one-word">체</span><span>[체력]</span></dt>
            <dd>
              <p>
                <span>근력</span>
                <span>근파워(순발력)</span>
                <span>유연성</span>
                <span>민첩성</span>
                <span>근지구력</span>
                <span>협응력(밸런스)</span>
                <span>심폐소지구력</span>
              </p>
            </dd>
          </dl>
        </a>
        <!-- E: 체력 -->

        <!-- S: 대회 -->
        <a href="http://sportsdiary.co.kr/M_Player/Schedule/sche-match.asp">
          <dl class="day-list clearfix">
            <dt class="match"><span class="one-word">대</span><span>[대회]</span></dt>
            <dd>
              <p>제16회 제주컵 유도대회</p>
            </dd>
          </dl>
        </a>
        <!-- E: 대회 -->

      </section>
      <!-- E: 3일 -->
      <!-- S: 4일 -->
      <section>
        <div class="schedule-header sche-title">
          <h2><span>04</span>일</h2>
        </div>
        <!-- S: 훈련 -->
        <a href="http://sportsdiary.co.kr/M_Player/Schedule/sche-train.asp">
          <dl class="day-list clearfix">
            <dt class="train"><span class="one-word">훈</span><span>[훈련]</span></dt>
            <dd>
              <p>훈련참석(정상)</p>
              <p class="detail">새벽훈련(1시간) 오전훈련(2시간)</p>
              <p class="detail">오후훈련(1시간 30분) 야간훈련(2시간 30분)</p>
            </dd>
          </dl>
        </a>
        <!-- E: 훈련 -->

        <!-- S: 체력 -->
        <a href="http://sportsdiary.co.kr/M_Player/Strength/muscles.asp">
          <dl class="day-list clearfix">
            <dt class="physical"><span class="one-word">체</span><span>[체력]</span></dt>
            <dd>
              <p>
                <span>근력</span>
                <span>근파워(순발력)</span>
                <span>유연성</span>
                <span>민첩성</span>
                <span>근지구력</span>
                <span>협응력(밸런스)</span>
                <span>심폐소지구력</span>
              </p>
            </dd>
          </dl>
        </a>
        <!-- E: 체력 -->

        <!-- S: 대회 -->
        <a href="http://sportsdiary.co.kr/M_Player/Schedule/sche-match.asp">
          <dl class="day-list clearfix">
            <dt class="match"><span class="one-word">대</span><span>[대회]</span></dt>
            <dd>
              <p>제16회 제주컵 유도대회</p>
            </dd>
          </dl>
        </a>
        <!-- E: 대회 -->
      </section>
      <!-- E: 4일  -->
    </div>
<!--
    loop end
-->
    <!-- E: schedule -->
   
  </div>
  <!-- E: main -->

  <!-- S: footer -->
  <div class="footer light-footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
</html>
