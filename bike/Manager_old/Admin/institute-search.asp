<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%

  check_login()

  SearchDate    = fInject(request("SearchDate"))  '조회일정
  GameTitleIDX  = fInject(request("GameTitleIDX"))  '대회IDX

  if GameTitleIDX="" then 
  GameTitleIDX=0
  end if

'	response.Write request.Cookies("SportsGb")
%>
  <link href='../css/library/fullcalendar.min.css' rel='stylesheet' />
  <link href='../css/library/fullcalendar.print.css' rel='stylesheet' media='print' />
  <script src="../js/library/jquery-1.12.2.min.js"></script>
  <script src="../js/library/jquery.easing.1.3.min.js"></script>
  <script src='../js/library/moment.min.js'></script>
  <script src='../js/library/fullcalendar.js'></script>
  <script src='../js/library/fullcalendar.min.js'></script>
  <script src='../js/library/ko.js'></script>

<script> 
//페이지 호출과 동시에 달력을 호출한다.
    $(document).ready(function () {
        var defaultDate = "<%=SearchDate %>";
        var defidx = <%=GameTitleIDX %>;
        if (defidx=="") {
            document.cookie = "GameTitleIDX=0; path=/;";
        }else {
             document.cookie = "GameTitleIDX="+defidx+"; path=/;";
        }
        
        window.onpopstate = function (event) {
            $(".close").click();
             console.log("window.onpopstate"); 
             if (history.state == null) {

            } else {
                history.back();
            }
        };
        
        $('#sche-list').on('shown.bs.modal', function (e) {
            console.log("shown.bs.modal sche-list");
        });
            
        $('#sche-list').on('hidden.bs.modal', function (e) {
            console.log("sche-list hidden.bs.modal");
            if (history.state == null) {

            } else {
                history.back();
            }
        });
        
        $(".btn-back").on("click", function () {
            document.cookie = "SearchDate=; path=/;";
            document.cookie = "GameTitleIDX=; path=/;";
            //location.href("../main/index.asp");
        });


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

 

        $('#institutesearch').click(function () {
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);
            
            document.cookie = "SearchDate="+m+"; path=/;";
            location.href="institute-search.asp?SearchDate="+m;
        });
        $('#instituteschedule').click(function () {
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);
            
            document.cookie = "SearchDate="+m+"; path=/;";
            location.href="institute-schedule.asp?SearchDate="+m;
        });

        $('#my-today-button').click(function () {
            $('#calendar').fadeOut(200).fadeIn(200).fullCalendar('today');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);
            document.cookie = "GameTitleIDX=; path=/;";
            document.cookie = "SearchDate="+m+"; path=/;";
        });

        $('#my-prev-button').click(function () {
            $('#calendar').fadeOut(200).fadeIn(200).fullCalendar('prev');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);
            $(".year").val(year);
            $(".month").text(mon);
            
             document.cookie = "GameTitleIDX=; path=/;";
            document.cookie = "SearchDate="+m+"; path=/;";

        });

        $('#my-next-button').click(function () {
            $('#calendar').fadeOut(200).fadeIn(200).fullCalendar('next');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            var year = yy(m);
            var mon = mm(m);

            $(".year").val(year);
            $(".month").text(mon);  
             document.cookie = "GameTitleIDX=; path=/;";
            document.cookie = "SearchDate="+m+"; path=/;";
            
        });

        function yy(yy) {
            var month = yy.split('-');
            return month[0];
        }
        function mm(mm) {
            var month = mm.split('-');
            return month[1] + "월";
        }

        callCalendar(NowDate,defidx);

    }); 


function callCalendar(defaultDate,defidx){
    document.cookie = "SearchDate="+defaultDate+"; path=/;";
    $('#calendar').fullCalendar({
        locale: 'ko',
        header: {
            left: '',
            center: '',
            right: ''
        },
        defaultDate: defaultDate,
        buttonIcons: false, // show the prev/next text
        weekNumbers: false,
        fixedWeekCount: false,
        navLinks: false, // can click day/week names to navigate views
        editable: false,
        eventLimit: false, // allow "more" link when too many events 더보기 메뉴 비활성화 
        events: "institute-search_json.asp",
        eventOrder: "title",
        loading: function (calEvent, jsEvent, view) {
          if (calEvent == false) {
            document.cookie = "GameTitleIDX="+defidx+"; path=/;";
                document.cookie = "SearchDate="+defaultDate+"; path=/;";
            //$(".fc-sat").css('background-color', '#eeefF9');
            $(".fc-sat").css('border-color', '#ddd4F9');
            $(".fc-sat").css('color', 'blue');

            //$(".fc-sun").css('background-color', '#FFF9F7');
            $(".fc-sun").css('border-color', '#ffd8F8');
            $(".fc-sun").css('color', 'red');

            $('.fc-day-grid-event').attr('data-toggle', 'modal');
            $('.fc-day-grid-event').attr('data-target', '#sche-list');
          }
        },
        eventClick: function (calEvent, jsEvent, view) {
            document.cookie = "GameTitleIDX="+calEvent.id+"; path=/;";
            document.cookie = "SearchDate="+calEvent.start.format()+"; path=/;";
            
            history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate='+calEvent.start.format()+'&GameTitleIDX='+calEvent.id);

            $.ajax({
                url: "../select/institute_select.asp",
                type: 'POST',
                dataType: 'html',
                data: { 
                        GameTitleIDX: calEvent.id 
                        , Crs_color: calEvent.color
                    },
                success: function (retDATA) {
                    $(this).css('border-color', 'red');
                    $("#modal-dialog").html(retDATA);
                }, error: function (xhr, status, error) {
                    	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
                }
            });
        }
    });

}


function stadium_sketch(GameTitleIDX)
{

	//var GameTitleIDX = localStorage.getItem("GameTitleIDX");
	document.getElementById("GameTitleIDX").value =  GameTitleIDX
	var strAjaxUrl = "stadium_sketch_ajax.asp?GameTitleIDX="+ GameTitleIDX;
	//location.href= strAjaxUrl
	//return;
	$.ajax({
	  url: strAjaxUrl,
	  type: 'POST',
	  dataType: 'html',
	  data: { 
		 GameTitleIDX  : GameTitleIDX 
	  },
	  success: function(retDATA) {

		 if (retDATA > 0)
		 {
			document.frm.action="stadium_sketch.asp"
			document.frm.submit();
		 }
		 else
		 {
			alert('등록된 현장스케치가 없습니다.');
			return;
		 }
	  }
	});

}


</script>
<script type="text/javascript">

var defaultDate = "<%=SearchDate %>";
var defidx = <%=GameTitleIDX %>;    
var referrer = document.referrer;
if (referrer.indexOf("index") >= 0 && defidx !="") {
    history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate='+defaultDate+'&GameTitleIDX='+defidx);
    /*
    $.ajax({
        url: "../select/institute_select.asp",
        type: 'POST',
        dataType: 'html',
        data: { 
                GameTitleIDX:defidx  
            },
        success: function (retDATA) { 
            $("#modal-dialog").html(retDATA); 
            console.log($("#sche-list").html());
        }, error: function (xhr, status, error) {
            alert("오류발생! - 시스템관리자에게 문의하십시오!");
        }
    });
    */
}  

</script>
<body>
  <!-- S: sub-header -->
  <div class="sub-header flex">
    <!-- S: sub_header_arrow -->
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <!-- E: sub_header_arrow -->
    <h1 id="aaaaa">대회일정/결과</h1>
    <!-- S: sub_header_gnb -->
    <!-- #include file="../include/sub_header_gnb.asp" -->
    <!-- E: sub_header_gnb -->
  </div>
  <!-- E: sub-header -->
<form name="frm" id="frm" method="post">
  <input type="hidden" id="GameTitleIDX" name="GameTitleIDX">
  <!-- S: main -->
  <div class="main">
    <!-- S: calendar -->
    <div class="calendar">
      <!-- S: calendar-header -->
      <div class="calendar-header container">
        <!-- S: line-1 -->
        <div class="line-1 clearfix institute">
          <div class="select-list clearfix">
            <button id="my-prev-button" class="prev-btn" type="button">&lt;</button>
            <div class="date">
              <select name="" class="year" disabled="disabled">
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
              <!-- <span class="caret"></span> -->
              <span class="month"> </span>
            </div>
            <button id="my-next-button"  class="next-btn" type="button">&gt;</button>
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
            <li><a id="institutesearch"><img src="../images/institute/icon-calendar-on@3x.png" alt="달력보기"></a></li>
            <li><a id="instituteschedule" ><img src="../images/institute/icon-list-off@3x.png" alt="리스트보기"></a></li>
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
    </form>

  <!-- S: footer -->
  <div class="footer light-footer">
    <!-- S: bottom-menu -->
    <!-- #include file="../include/bottom_menu.asp" -->
    <!-- E: bottom-menu -->
  </div>
  <!-- E: footer -->
  <!-- S: sche-list modal -->
  <div class="sche-list modal fade confirm-modal" id="sche-list" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog" id="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
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
              <!--<a href="../MatchDiary/match-diary.asp" class="btn">대회일지작성</a>-->
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
  <div class="sche-table modal fade confirm-modal" id="sche-table" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"   >
  <div class="modal-dialog" id="modal_dialog_1">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true"><img src="../images/public/close-x@3x.png" alt="닫기"></span></button>
        <h4 class="modal-title" id="myModalLabel">대회일정표</h4>
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

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
