<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
  SearchDate    = fInject(request("SearchDate"))  '조회일정
  GameTitleIDX  = fInject(request("GameTitleIDX"))  '대회IDX
   
%>
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
 var defaultDate = "<%=SearchDate %>";

        /*현재 날자선택이 되지 않았다면 해당월 선택*/
        var now = new Date();
        if (defaultDate != "") { now = new Date(defaultDate); }

        var year = now.getFullYear();
        var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
        var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();
        var chan_val = year + '-' + mon + '-' + day;

        NowDate = chan_val;

        $(".month").text(mon + " 월");
        $(".year").val(year);

        $('#my-today-button').click(function () {
            $('#calendar').fullCalendar('today');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);
        });

        $('.prev-btn').click(function () {
            $('#calendar').fullCalendar('prev');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);
        });

        $('.next-btn').click(function () {
            $('#calendar').fullCalendar('next');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);

            $(".year").val(year);
            $(".month").text(mon);
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
      eventOrder: ["propA","-title"],
      loading: function () {
          $(".fc-sat").css('background-color', '#eeefF9');
          $(".fc-sat").css('border-color', '#ddd4F9');
          $(".fc-sat").css('color', 'blue');

          $(".fc-sun").css('background-color', '#FFF9F7');
          $(".fc-sun").css('border-color', '#ffd8F8');
          $(".fc-sun").css('color', 'red');
      },
      eventClick: function (calEvent, jsEvent, view) {
          var checkDay = moment(calEvent.start).format("YYYY-MM-DD");
          $.ajax({
              url: "sche-calendar-select.asp",
              type: 'POST',
              dataType: 'html',
              data: {
                  checkDay: checkDay
                  ,idx:calEvent.id
              },
              success: function (retDATA) {
                  $(this).css('border-color', 'red');
                  $("#sche-dialog").html(retDATA);
              }, error: function (xhr, status, error) {
                  alert("오류발생! - 시스템관리자에게 문의하십시오!");
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
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1>나의 일정/달력</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
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
            <li><a href="sche-calendar.asp"><img src="../images/institute/icon-calendar-on@3x.png" alt="달력보기"></a></li>
            <li><a href="list.asp"><img src="../images/institute/icon-list-off@3x.png" alt="리스트보기"></a></li>
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
        <!-- S: modal-schedule01 훈련 계획 -->
        <div class="modal-schedule01">
          <!-- S: modal-body -->
          <div class="modal-body">
            <h5 class="tit-blue-radius">훈련</h5>
            <dl class="modal-train-list">
              <dt>새벽</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>오전</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>오후</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-red">
                    <p>도복훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>야간</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
          </div>
          <!-- E: modal-body -->
        </div>
        <!-- E: modal-schedule01 훈련 계획 -->
        <!-- S: modal-schedule02 훈련 종료 -->
        <div class="modal-schedule02">
          <div class="modal-body">
            <h5 class="tit-blue-radius">훈련</h5>
            <h6 class="tit-graybox">
              <i class="fa fa-check-circle" aria-hidden="true"></i>
              <strong>훈련참석(정상참석)</strong>
            </h6>
            <dl class="modal-train-list">
              <dt>새벽</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>오전</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>오후</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-red">
                    <p>도복훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>야간</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <a href="../Train/train.asp" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 상세보기</a>
        </div>
        <!-- E: modal-schedule02 훈련 종료 -->
            </div>
        <!-- S: modal-schedule03 부상 및 일부참석 -->
        <div class="modal-schedule03">
          <div class="modal-body">
            <h5 class="tit-blue-radius">훈련</h5>
            <h6 class="tit-graybox">
              <i class="fa fa-check-circle" aria-hidden="true"></i>
              <strong>훈련참석(일부참석)</strong>
              <span>사유 : 부상(좌/어깨)</span>
            </h6>
            <dl class="modal-train-list">
              <dt>새벽</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>오전</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>오후</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-red">
                    <p>도복훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list">
              <dt>야간</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <a href="../Train/train.asp" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 상세보기</a>
            <h5 class="tit-green-radius">체력</h5>
            <dl class="modal-strength-list">
              <dt>근력</dt>
              <dd>: 스쿼트 30kg/벤치프레스 26kg</dd>
              <dt>근파워(순발력)</dt>
              <dd>: 제자리 멀리뛰기 38cm/서전트82cm</dd>
              <dt>유연성</dt>
              <dd>: 윗몸 앞으로 굽히기 30cm/ 윗몸 뒤로 젖히기 26cm)</dd>
              <dt>민첩성</dt>
              <dd>: 사이드스텝 36회</dd>
              <dt>근지구력</dt>
              <dd>: 팔굽혀펴기 55회/윗몸일으키기 48회)</dd>
              <dt>협응력(밸런스)</dt>
              <dd>: 눈감고 외발서기 40초</dd>
              <dt>심폐지구력</dt>
              <dd>:10m 왕복 달리기 34회</dd>
            </dl>
            <a href="../Strength/index.asp" target="blank" class="btn-modal-strength"><span class="ic-modal-strength"></span>체력측정 상세보기</a>
          </div>
        </div>
        <!-- E: modal-schedule03 부상 및 일부참석 -->
        <!-- S: modal-schedule04 (03과 같음) -->
        <!-- 넘김 -->
        <!-- E: modal-schedule04 (03과 같음) -->

        <!-- S: modal-schedule05 개인훈련  -->
        <div class="modal-schedule05">
          <div class="modal-body">
            <h5 class="tit-line-through">훈련</h5>
            <h6 class="tit-graybox">
              <i class="fa fa-times-circle" aria-hidden="true"></i>
              <strong>훈련불참</strong>
              <span>사유 : 수업참석</span>
            </h6>
            <dl class="modal-train-list disabled">
              <dt>새벽</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list disabled">
              <dt>오전</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list disabled">
              <dt>오후</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-red">
                    <p>도복훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list disabled">
              <dt>야간</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <h5 class="tit-orange-radius">개인</h5>
            <dl class="modal-train-list">
              <dt>야간</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>2시간</p>
                  </li>
                  <li>
                    <p>언덕 스피드</p>
                    <p>30분</p>
                  </li>
                  <li>
                    <p>운동장 조깅</p>
                    <p>1시간</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <a href="../Train/train.asp" class="btn-modal-train"><span class="ic-modal-train"></span>훈련일지 상세보기</a>
          </div>
        </div>
        <!-- E: modal-schedule05 개인훈련  -->

        <!-- S: modal-schedule06 대회 -->
        <div class="modal-schedule06">
          <div class="modal-body">
            <h5 class="tit-line-through">훈련</h5>
            <h6 class="tit-graybox">
              <i class="fa fa-times-circle" aria-hidden="true"></i>
              <strong>훈련불참</strong>
              <span>사유 : 대회참석(전지)</span>
            </h6>
            <dl class="modal-train-list disabled">
              <dt>새벽</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list disabled">
              <dt>오전</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list disabled">
              <dt>오후</dt>
              <dd>
                <ul>
                  <li>AWAY(다른팀 체육관이나 운동장)</li>
                  <li class="bg-red">
                    <p>도복훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <dl class="modal-train-list disabled">
              <dt>야간</dt>
              <dd>
                <ul>
                  <li>HOME(우리 체육관이나 운동장)</li>
                  <li class="bg-blue">
                    <p>체력훈련</p>
                    <p>5시30분~7시30분</p>
                  </li>
                  <li>
                    <p>준비운동</p>
                    <p>20분 x 1SET</p>
                  </li>
                  <li>
                    <p>써키트 트레이닝</p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>인터벌 트레이닝 </p>
                    <p>30분 x 1SET</p>
                  </li>
                  <li>
                    <p>스피드(50m,70m,100m)</p>
                    <p>40분 x 1SET</p>
                  </li>
                </ul>
              </dd>
            </dl>
            <h5 class="tit-marine-radius">대회</h5>
            <div class="tourney-info">
              <h6>제 16회 제주컵 유도대회</h6>
              <p>
                <span class="medal gold">금메달</span>
                <span>개인전</span>
                <span>고등부</span>
                <span>남자 -66kg</span>
              </p>
              <p>
                <span class="medal silver">은메달</span>
                <span>개인전</span>
                <span>고등부</span>
                <span>남자 -66kg</span>
              </p>
              <p>
                <span class="medal bronze">동메달</span>
                <span>개인전</span>
                <span>고등부</span>
                <span>남자 -66kg</span>
              </p>
              <!--// 수상하지 못했을 경우에는 대회명만 노출
              <p>
                <span class="medal silver">은메달</span>
                <span>개인전</span>
                <span>고등부</span>
                <span>남자 -66kg</span>
              </p>
              <p>
                <span class="medal bronze">동메달</span>
                <span>개인전</span>
                <span>고등부</span>
                <span>남자 -66kg</span>
              </p>
              -->
            </div>
            <a href="sche-match.asp" class="btn-modal-match"><span class="ic-modal-match"></span>대회일지 상세보기</a>
          </div>
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
