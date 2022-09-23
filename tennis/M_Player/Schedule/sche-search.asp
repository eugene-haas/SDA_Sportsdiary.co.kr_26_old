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
<script>
//페이지 호출과 동시에 달력을 호출한다.
$(document).ready(function() {
	callCalendar('');
});

function callCalendar(defaultDate){
	/*현재 날자선택이 되지 않았다면 해당월 선택*/
	var now = new Date();
	var year= now.getFullYear();
	var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
	var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
	var chan_val = year + '-' + mon + '-' + day;

	if(defaultDate==""){
//		NowDate = chan_val;
		NowDate = "2016-12-01";
	}else{
		NowDate = defaultDate;
	}


$('#calendar').fullCalendar({
      lang: 'ko',
      header: {
        // left: 'prev,prevYear,nextYear,next, custom1, custom2',
        // center: 'title',
        // right: 'month,agendaWeek,agendaDay,listWeek'
        left: '',
        center: '',
        right: ''
      },
      defaultDate: NowDate,
      navLinks: true, // can click day/week names to navigate views
      editable: true,
      eventLimit: false, // allow "more" link when too many events 더보기 메뉴 비활성화
      events: [
				{
          title: '동해시유도대회',
          start: '2016-12-01',
					//제목설정     title: '행사일정',
					//시작일설정   start: '2016-12-01',
					//종료일설정   end  : '2016-12-01',
					//배경색상변환 color: 'red'
        },
        {
          title: 'Long Event',
          start: '2016-12-07',
          end: '2016-12-10'
        },
        {
          id: 999,
          title: 'Repeating Event',
          start: '2016-12-09T16:00:00'
        },
        {
          id: 999,
          title: 'Repeating Event',
          start: '2016-12-16T16:00:00'
        },
        {
          title: 'Conference',
          start: '2016-12-11',
          end: '2016-12-13'
        },
        {
          title: 'Meeting',
          start: '2016-12-12T10:30:00',
          end: '2016-12-12T12:30:00'
        },
        {
          title: 'Lunch',
          start: '2016-12-12T12:00:00'
        },
        {
          title: 'Meeting',
          start: '2016-12-12T14:30:00'
        },
        {
          title: 'Happy Hour',
          start: '2016-12-12T17:30:00'
        },
        {
          title: 'Dinner',
          start: '2016-12-12T20:00:00'
        },
        {
          title: 'Birthday Party',
          start: '2016-12-13T07:00:00'
        },
        {
          title: 'Click for Google',
          url: 'http://google.com/',
          start: '2016-12-28'
        }

      ]
    });
}

</script>
</head>
<body>
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대회일정/결과</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <!-- S: main -->
  <div class="main">
    <!-- S: calendar -->
    <div class="calendar">
      <!-- S: calendar-header -->
      <div class="calendar-header container">
        <!-- S: line-1 -->
        <div class="line-1 clearfix">
          <div class="select-list clearfix">
            <button class="prev-btn" type="button">&lt;</button>
            <select name="" class="year">
              <option value="">2016년</option>
              <option value="">2017년</option>
              <option value="">2018년</option>
            </select>
            <span class="month">12월</span>
            <button class="next-btn" type="button">&gt;</button>
          </div>
          <button class="today-btn" type="button">오늘</button>
        </div>
        <!-- E: line-1 -->
        <!-- S: line-2 -->
        <div class="line-2">
          <select name="">
            <option value="" selected>:: 대회명을 선택하세요 ::</option>
            <option value="">2016 회장기 전국 유도대회</option>
            <option value="">2016 추계 전국 남,여 중고등학교 유도연맹전</option>
            <option value="">2016 추계 전국 남,여 대학교 유도연</option>
          </select>
        </div>
        <!-- E: line-2 -->
        <!-- S: line-3 -->
        <div class="line-3 clearfix">
          <ul class="clearfix">
            <li><a href="06-institute-search.html"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-calendar-off@3x.png" alt="달력보기"></a></li>
            <li><a href="06-institute-schedule.html"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-list-off@3x.png" alt="리스트보기"></a></li>
          </ul>
        </div>
        <!-- E: line-3 -->
      </div>
      <!-- E: calendar-header -->
      <!-- S: 달력 추가 할 container -->
      <div id='calendar'></div>
      <!-- E: 달력 추가 할 container -->

      <!-- S: pop -->
      <!-- <div class="pop">
       <dl class="schedule-item">
            <dt class="place"><span class="icon"></span>장소</dt>
            <dd>서울 체육관</dd>
          </dl>
          <dl class="schedule-item">
            <dt class="term"><span class="icon"></span>기간</dt>
            <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
          </dl>
          <dl class="schedule-item request">
            <dt class="request"><span class="icon"></span>참가신청</dt>
            <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
          </dl>
          <div class="sch-btn-list bluey clearfix">
            <a href="#" class="btn">대회일정표</a>
            <a href="#" class="btn">대진표보기</a>
            <a href="#" class="btn">대회일지작성</a>
          </div>
          <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div>
      </div>
      E: pop
      S: pop
      <div class="pop">
       <dl class="schedule-item">
            <dt class="place"><span class="icon"></span>장소</dt>
            <dd>서울 체육관</dd>
          </dl>
          <dl class="schedule-item">
            <dt class="term"><span class="icon"></span>기간</dt>
            <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
          </dl>
          <dl class="schedule-item request">
            <dt class="request"><span class="icon"></span>참가신청</dt>
            <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
          </dl>
          <div class="sch-btn-list greeny clearfix">
            <button class="btn" data-target="#sche-table" data-toggle="modal">대회일정표</button>
            <button class="btn">참가신청</button>
            <button class="btn">대진표보기</button>
          </div>
          <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div>
      </div>
      E: pop
      S: pop
      <div class="pop">
       <dl class="schedule-item">
            <dt class="place"><span class="icon"></span>장소</dt>
            <dd>서울 체육관</dd>
          </dl>
          <dl class="schedule-item">
            <dt class="term"><span class="icon"></span>기간</dt>
            <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
          </dl>
          <dl class="schedule-item request">
            <dt class="request"><span class="icon"></span>참가신청</dt>
            <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
          </dl>
          <div class="sch-btn-list browny clearfix">
            <button class="btn" data-target="#sche-table" data-toggle="modal">대회일정표</button>
            <button class="btn">참가신청</button>
            <button class="btn">대진표보기</button>
          </div>
          <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div>
      </div>
      E: pop
      S: pop
      <div class="pop">
       <dl class="schedule-item">
            <dt class="place"><span class="icon"></span>장소</dt>
            <dd>서울 체육관</dd>
          </dl>
          <dl class="schedule-item">
            <dt class="term"><span class="icon"></span>기간</dt>
            <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
          </dl>
          <dl class="schedule-item request">
            <dt class="request"><span class="icon"></span>참가신청</dt>
            <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
          </dl>
          <div class="sch-btn-list orangy clearfix">
            <button class="btn" data-target="#sche-table" data-toggle="modal">대회일정표</button>
            <button class="btn">참가신청</button>
            <button class="btn">대진표보기</button>
          </div>
          <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div>
      </div> -->
      <!-- E: pop -->
      <!-- S: img-cont -->
      <!-- <div class="img-cont">
        <img src="../images/institute/schedule-table.jpg" alt="일정표">
      </div> -->
      <!-- E: img-cont -->
    </div>
    <!-- E: calendar -->
  </div>
  <!-- E: main -->

  <!-- S: footer -->
  <div class="footer light-footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->

  <!-- S: sche-list modal -->
  <div class="sche-list modal fade confirm-modal" id="sche-list" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="../images/public/close-x@3x.png" alt="닫기"></span></button>
        <h4 class="modal-title" id="myModalLabel">대회일정</h4>
      </div>
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: sche-title -->
        <div class="sche-title">
          <h2>2016 제주컵 유도대회</h2>
          <p class="match-term">2016년11월26일(토)~30일(수)</p>
        </div>
        <!-- E: sche-title -->
        <!-- S: pop -->
          <div class="pop">
           <dl class="schedule-item">
              <dt class="place"><span class="icon"></span>장소</dt>
              <dd>서울 체육관</dd>
            </dl>
            <dl class="schedule-item">
              <dt class="term"><span class="icon"></span>기간</dt>
              <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
            </dl>
            <dl class="schedule-item request">
              <dt class="request"><span class="icon"></span>참가신청</dt>
              <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
            </dl>
            <div class="sch-btn-list bluey clearfix">
              <a href="./match-sch.asp" class="btn">대회일정표</a>
              <a href="../tournament/tourney.asp" class="btn">대진표보기</a>
              <a href="../MatchDiary/match-diary.asp" class="btn">대회일지작성</a>
            </div>
          </div>
          <!-- E: pop -->
      </div>
      <!-- E: modal-body -->
     <!--  <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div> -->
    </div>
  </div>
  </div>
  <!-- E: sche-list modal -->

  <!-- S: sche-table modal -->
  <div class="sche-table modal fade confirm-modal" id="sche-table" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><img src="../images/public/close-x@3x.png" alt="닫기"></span></button>
        <h4 class="modal-title" id="myModalLabel">일정표</h4>
      </div>
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: sche-title -->
        <div class="sche-title">
          <h2>2016 제주컵 유도대회</h2>
          <p class="match-term">2016년11월26일(토)~30일(수)</p>
        </div>
        <!-- E: sche-title -->
        <!-- S: stadium -->
        <div class="stadium">
          <p>경기장: 제주, 한라체육관</p>
        </div>
        <!-- E: stadium -->
        <!-- S: match-day -->
        <div class="match-day">
          <select name="">
            <option value="0">2016년 11월 27일(일)</option>
            <option value="1">2016년 11월 27일(일)</option>
            <option value="2">2016년 11월 27일(일)</option>
          </select>
        </div>
        <!-- E: match-day -->
        <!-- S: match-list -->
        <div class="match-list">
          <h3>[개인전]</h3>
          <!-- S: 체급 -->
          <dl>
           <dt>남중부(7체급)</dt>
           <dd>-45kg,-48kg,-51kg,-55kg,-60kg,-66kg,-73kg</dd>
          </dl>
          <!-- E: 체급 -->
          <!-- S: 체급 -->
          <dl>
            <dt>여중부(5체급)</dt>
            <dd>-42kg,-45kg,-48kg,-52kg,-57kg</dd>
          </dl>
          <!-- E: 체급 -->
          <!-- S: 체급 -->
          <dl>
            <dt>남고부(5체급)</dt>
            <dd>-55kg,-60kg,-66kg,-73kg,-81kg</dd>
          </dl>
          <!-- E: 체급 -->
          <!-- S: 체급 -->
          <dl>
            <dt>여고부(5체급)</dt>
            <dd>-45kg,-48kg,-52kg,-57kg,-63kg</dd>
          </dl>
          <!-- E: 체급 -->
        </div>
        <!-- E: match-list -->
        <!-- S: time-table -->
          <div class="time-table">
            <ul>
              <li class="clearfix">
                <span class="time">10:00 ~</span>
                <span class="cont">경기시작</span>
              </li>
              <li class="now clearfix">
                <span class="time">11:00 ~</span>
                <span class="cont">개회식</span>
              </li>
              <li class="clearfix">
                <span class="time">17:00 ~</span>
                <span class="cont">결승 및 시상식(예정)</span>
              </li>
              <li class="clearfix">
                <span class="time">17:00 ~ 17:30</span>
                <span class="cont">공식계체(11.28일 참가선수)</span>
              </li>
            </ul>
          </div>
          <!-- E: time-table -->
      </div>
      <!-- E: modal-body -->
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">닫기</button>
      </div>
    </div>
  </div>
</div>
  <!-- E: sche-table modal -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
  <script>
    $(document).on('ready', function(){
      $('.fc-day-grid-event').attr('data-toggle', 'modal');
      $('.fc-day-grid-event').attr('data-target', '#sche-list');
    })
  </script>
</body>
</html>
