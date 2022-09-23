<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%

    check_login()

  SearchDate    = fInject(request("SearchDate"))  '조회일정
  GameTitleIDX  = fInject(request("GameTitleIDX"))  '대회IDX
%>
  <link href='../css/library/fullcalendar.min.css' rel='stylesheet' />
  <link href='../css/library/fullcalendar.print.css' rel='stylesheet' media='print' />
  <script src="../js/library/jquery-1.12.2.min.js"></script>
  <script src='../js/library/moment.min.js'></script>
  <script src='../js/library/fullcalendar.min.js'></script>
  <script src="../js/library/ko.js"></script>


<script>
//페이지 호출과 동시에 달력을 호출한다.
    $(document).ready(function () {
        var defaultDate = "<%=SearchDate %>";
       // if (defaultDate == "") { defaultDate = $.cookie('SearchDate'); }

        /*현재 날자선택이 되지 않았다면 해당월 선택*/
        var now = new Date();
        if (defaultDate != "") { now = new Date(defaultDate); }

        var year = now.getFullYear();
        var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
        var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();
        var chan_val = year + '-' + mon + '-' + day;

        NowDate = chan_val;
        defaultDate = chan_val;

        $(".month").text(mon + " 월");
        $(".year").val(year);


        $('#sche-list').on('hidden.bs.modal', function (e) {
            if (history.state == null) {

            } else {
                history.back();
            }
        });

        //document.cookie = "SearchDate=" + chan_val + "; path=/;";

        window.onpopstate = function (event) {
            $(".close").click();
            console.log("window.onpopstate");
            if (history.state == null) {

            } else {
                history.back();
            }
        };

        //닫기
        $(".btn-back").on({
            "click": function (e) {
                e.preventDefault();
                document.cookie = "SearchDate=; path=/;";
                document.cookie = "GameTitleIDX=; path=/;";

                if (document.referrer.indexOf("sportsdiary.co.kr") > 0) {
                    if (document.referrer.indexOf("train.asp") > 0) {
                        document.location.href = "../Main/index.asp";
                    } else {
                        history.back(-1);
                    }
                }
                else { document.location.href = "../Main/index.asp"; }
            }
        });


        $("#schecalendar").on({
            "click": function (e) {
                e.preventDefault();
                location.href = "../Schedule/sche-calendar.asp"; //?SearchDate=" + $(".year").val() + "-" + $('.month').text().replace("월", '').replace(/ /g, '') + "-" + "01";
            }
        });
        $("#schecalendarlist").on({
            "click": function (e) {
                e.preventDefault();
                location.href = "../Schedule/list.asp"; //?SearchDate=" + $(".year").val() + "-" + $('.month').text().replace("월", '').replace(/ /g, '') + "-" + "01";
            }
        });


        $('#my-today-button').click(function () {
            $('#calendar').fadeOut(200).fadeIn(200).fullCalendar('today');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);

            document.cookie = "SearchDate=" + m + "; path=/;";
        });

        $('.prev-btn').click(function () {
            $('#calendar').fadeOut(200).fadeIn(200).fullCalendar('prev');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);
            document.cookie = "SearchDate=" + m + "; path=/;";
        });

        $('.next-btn').click(function () {
            $('#calendar').fadeOut(200).fadeIn(200).fullCalendar('next');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);

            $(".year").val(year);
            $(".month").text(mon);
            document.cookie = "SearchDate=" + m + "; path=/;";
        });

        function yy(yy) {
            var month = yy.split('-');
            return month[0];
        }
        function mm(mm) {
            var month = mm.split('-');
            return month[1] + "월";
        }

        callCalendar(NowDate);
    });



function callCalendar(defaultDate){
  /*현재 날자선택이 되지 않았다면 해당월 선택*/
  var now = new Date();
  var year= now.getFullYear();
  var mon = (now.getMonth()+1)>9 ? ''+(now.getMonth()+1) : '0'+(now.getMonth()+1);
  var day = now.getDate()>9 ? ''+now.getDate() : '0'+now.getDate();
  var chan_val = year + '-' + mon + '-' + day;

  if(defaultDate==""){
    NowDate = chan_val;
  }else{
    NowDate = defaultDate;
  }

  $('#calendar').fullCalendar({
      locale: 'ko',
      header: {
          // left: 'prev,prevYear,nextYear,next, custom1, custom2',
          // center: 'title',
          // right: 'month,agendaWeek,agendaDay,listWeek'
          left: '',
          center: '',
          right: ''
      },
      defaultDate: NowDate,
      fixedWeekCount: false,
      navLinks: false, // can click day/week names to navigate views
      editable: false,
      eventLimit: false, // allow "more" link when too many events 더보기 메뉴 비활성화
      eventOrder: ["propA", "-title"],
      loading: function () {
          //$(".fc-sat").css('background-color', '#eeefF9');
          $(".fc-sat").css('border-color', '#ddd4F9');
          $(".fc-sat").css('color', 'blue');

          //$(".fc-sun").css('background-color', '#FFF9F7');
          $(".fc-sun").css('border-color', '#ffd8F8');
          $(".fc-sun").css('color', 'red');
      },
      eventClick: function (calEvent, jsEvent, view) {
          var checkDay = calEvent.start.format("YYYY-MM-DD");
          console.log(calEvent);
          document.cookie = "GameTitleIDX=" + calEvent.id + "; path=/;";
          document.cookie = "SearchDate=" + checkDay + "; path=/;";
          history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + checkDay);
          $.ajax({
              url: "sche-calendar-select.asp",
              type: 'POST',
              dataType: 'html',
              data: {
                  checkDay: checkDay
                   , idx: calEvent.id
                   , Crs_color: calEvent.color
              },
              success: function (retDATA) {
                  $(this).css('border-color', 'red');
                  $("#sche-dialog").html(retDATA);
              }, error: function (xhr, status, error) {
                  if (error != '') {
                      alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                  }
              }
          });
          $('.fc-day-grid-event').attr('data-toggle', 'modal');
          $('.fc-day-grid-event').attr('data-target', '#sche-list');
      }
  });

  //일정
  $('#calendar').fullCalendar("addEventSource", "sche-calendar-json.asp");

}
</script>
<body>

  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>나의 훈련 일정</h1>
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
        <div class="line-1 clearfix institute">
          <div class="select-list clearfix">
            <button class="prev-btn" type="button">&lt;</button>
            <div class="date">
               <select name="" class="year"disabled="disabled">
                <option value="2010">2010년</option>
                <option value="2011">2011년</option>
                <option value="2012">2012년</option>
                <option value="2013">2013년</option>
                <option value="2014">2014년</option>
                <option value="2015">2015년</option>
                <option value="2016">2016년</option>
                <option value="2017">2017년</option>
                <option value="2018">2018년</option>
                <option value="2019">2019년</option>
                <option value="2020">2020년</option>
                <option value="2021">2021년</option>
                <option value="2022">2022년</option>
                <option value="2023">2023년</option>
                <option value="2024">2024년</option>
                <option value="2025">2025년</option>
                <option value="2026">2026년</option>
                <option value="2027">2027년</option>
                <option value="2028">2028년</option>
                <option value="2029">2029년</option>
                <option value="2030">2030년</option>
              </select>
              <span class="month">12월</span>
            </div>
            <button class="next-btn" type="button">&gt;</button>
          </div>
          <button id="my-today-button" class="today-btn" type="button">오늘</button>
        </div>
        <!-- E: line-1 -->
        <!-- S: line-2 -->
        <!--<div class="line-2">
          <select name="">
            <option value="" selected>:: 대회명을 선택하세요 ::</option>
            <option value="">2016 회장기 전국 유도대회</option>
            <option value="">2016 추계 전국 남,여 중고등학교 유도연맹전</option>
            <option value="">2016 추계 전국 남,여 대학교 유도연</option>
          </select>
        </div>-->
        <!-- E: line-2 -->
        <!-- S: line-3 -->
        <div class="line-3 clearfix">
          <ul class="clearfix">
            <li><a id="schecalendar"><img src="../images/institute/icon-calendar-on@3x.png" alt="달력보기"></a></li>
            <li><a id="schecalendarlist"><img src="../images/institute/icon-list-off@3x.png" alt="리스트보기"></a></li>
          </ul>
        </div>
        <!-- E: line-3 -->
      </div>
      <!-- E: calendar-header -->
      <!-- S: 달력 추가 할 container -->
      <div id="calendar"></div>
      <!-- E: 달력 추가 할 container -->
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

  <!-- S: modal-schedule01 계획값-->
  <div class="modal fade confirm-modal modal-schedule" id="sche-list" tabindex="-1" role="dialog" aria-hidden="true">
    <div class="modal-dialog" id="sche-dialog">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
          <h4 class="modal-title">2016년 12월 15일</h4>
        </div>

        <!-- E: modal-schedule06 대회 -->
        <div class="modal-footer">
          <button type="button" class="btn btn-gray" data-dismiss="modal">닫기</button>
        </div>
      </div>
    </div>
  </div>
  <!-- E: modal-schedule01 계획값 -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
  <script>
//    $(document).on('ready', function(){
//      $('.fc-day-grid-event').attr('data-toggle', 'modal');
//      $('.fc-day-grid-event').attr('data-target', '.modal-schedule');
//    })
  </script>
</body>
