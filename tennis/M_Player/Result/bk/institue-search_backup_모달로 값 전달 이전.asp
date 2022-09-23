<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<%
  'check_login()
  SearchDate    = Request("SearchDate")  '조회일정
  GameTitleIDX  = Request("GameTitleIDX")  '대회IDX
  'EnterType    = Request.Cookies("EnterType")

  if GameTitleIDX="" then 
    GameTitleIDX="0"
  end if 
%>
  <link href='../css/library/fullcalendar.min.css' rel='stylesheet' />
  <link href='../css/library/fullcalendar.print.css' rel='stylesheet' media='print' />
  <script src="../js/library/jquery-1.12.2.min.js"></script>
  <script src="../js/library/jquery.easing.1.3.min.js"></script>
  <script src='../js/library/moment.min.js'></script>
  <script src='../js/library/fullcalendar.js'></script>
  <script src='../js/library/fullcalendar.min.js'></script>
  <script src='../js/library/ko.js'></script>

<script type="text/javascript">
    //페이지 호출과 동시에 달력을 호출한다.
    var defaultDate = "<%=SearchDate %>";
    var defidx = "<%=GameTitleIDX %>";    
    var referrer = document.referrer;
    if (referrer.indexOf("index") >= 0 && defidx != "") {
        history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + defaultDate + '&GameTitleIDX=' + defidx);
    }  

    var year ;
    var mon ;
    var events = [];

    $(document).ready(function () {
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

        /*현재 날자선택이 되지 않았다면 해당월 선택*/
        var now = new Date();
        if (defaultDate != "") { now = new Date(defaultDate); }
        year = now.getFullYear();
        mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
        var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();
        var chan_val = year + '-' + mon + '-' + day;
        NowDate = chan_val;
        $("#sel_year").val(year);
        $("#sel_month").val(mon);


        $('#btntoday').click(function () {
            $('#calendar').fullCalendar('today');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            year = yy(m);
            mon = mm(m);
            $("#sel_year").val(year);
            $("#sel_month").val(mon);
       history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + year+"-"+mon+"-01" );
        });

        $('#btnprev').click(function () {
            $('#calendar').fullCalendar('prev');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            year = yy(m);
            mon = mm(m);
            $("#sel_year").val(year);
            $("#sel_month").val(mon);
       history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + year+"-"+mon+"-01" );
        });

        $('#btnnext').click(function () {
            $('#calendar').fullCalendar('next');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            year = yy(m);
            mon = mm(m);
            $("#sel_year").val(year);
            $("#sel_month").val(mon);
       history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + year+"-"+mon+"-01" );
        });

        $('#sel_year').change(function () {
            $('#calendar').fullCalendar('gotoDate', $("#sel_year").val() + "-" + $("#sel_month").val());
        });

        $('#sel_month').change(function () {
            $('#calendar').fullCalendar('gotoDate', $("#sel_year").val() + "-" + $("#sel_month").val());
        });


        function yy(yy) {
            var month = yy.split('-');
            return month[0];
        }
        function mm(mm) {
            var month = mm.split('-');
            return month[1];
        }

        callCalendar(NowDate, defidx);


    });
     

function callCalendar(defaultDate,defidx){
    $('#calendar').fullCalendar({
        locale: 'ko',
        header: {
            left: '',
            center: '',
            right: ''
        },
        defaultDate: defaultDate,
        buttonIcons: false, // show the prev/next text
        fixedWeekCount: false,
        weekNumbers: false,
        navLinks: false, // can click day/week names to navigate views
        editable: false,
        eventLimit: false, // allow "more" link when too many events 더보기 메뉴 비활성화 
        eventOrder: "title",
        loading: function (calEvent, jsEvent, view) {
            if (calEvent == false) {
                $(".fc-sat").css('border-color', '#ddd4F9');
                $(".fc-sat").css('color', 'blue');
                $(".fc-sun").css('border-color', '#ffd8F8');
                $(".fc-sun").css('color', 'red');
                $('.fc-day-grid-event').attr('data-toggle', 'modal');
                $('.fc-day-grid-event').attr('data-target', '#sche-list');
                if (defidx > 0) {
                    var obj = {};
                    obj.CMD = 23;
                    obj.GameTitleIDX = defidx;

                    modalSetting("sche-list", obj, "/pub/ajax/reqTennis.asp");
                    $("#aTcommit").click();
                    document.getElementById("GameTitleIDX").value = defidx;
                    history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + defaultDate + '&GameTitleIDX=' + defidx);
          defidx="";
                }

            }

        },
        eventClick: function (calEvent, jsEvent, view) {
            document.getElementById("GameTitleIDX").value = calEvent.id;
            history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + calEvent.start.format() + '&GameTitleIDX=' + calEvent.id);
            defidx = calEvent.id;
            // asp 파라미터 json 변환 
            // obj             
            //  If InStr(REQ, "CMD") >0 then
            //  Set oJSONoutput = JSON.Parse(REQ)
            //    CMD = oJSONoutput.CMD
            //  Else
            //    CMD = REQ
            //  End if

            localStorage.setItem("GameTitleIDX", calEvent.id);
            localStorage.setItem("GameTitleName", calEvent.title);
            localStorage.setItem("EnterType", calEvent.EnterType);

            var obj = {};
            obj.CMD = 23;
            obj.GameTitleIDX = calEvent.id;

            modalSetting("sche-list", obj, "/pub/ajax/reqTennis.asp");
        }
    });
    //일정 
    $('#calendar').fullCalendar("addEventSource", "/pub/ajax/reqTennis.asp?REQ=25&typeSq=app");



}

function modalSetting(id,obj,url) {
    var List = $.when(mx_player.SendPacket(id, obj, url));
    List.done(function () {
        var htmldata = mx_player.ReceiveData.htmldata;
        var jsondata = mx_player.ReceiveData.jsondata;

        for (var i = 0; i < jsondata.length; i++) {
            $("#Gametitle").html(jsondata[i].GameTitleName);
            $("#gamearea").html(jsondata[i].GameArea);
      
            var GameSdate = jsondata[i].sdate.split("-");
            var GameEdate = jsondata[i].edate.split("-");
            var GameRcvSdate = jsondata[i].GameRcvDateS.split("-");
            var GameRcvEdate = jsondata[i].GameRcvDateE.split("-");


            var GameDateStrS = GameSdate[0] + "년 " + GameSdate[1] + "월 " + GameSdate[2] + "일 ";
            var GameDateStrE = "";


            if (GameSdate[0] != GameEdate[0]) {
                GameDateStrE += GameEdate[0] + "년 ";
            }

            if (GameSdate[1] != GameEdate[1]) {
                GameDateStrE += GameEdate[1] + "월 ";
            }

            if (GameSdate[2] != GameEdate[2]) {
                GameDateStrE += GameEdate[2] + "일 ";
            }

            var RcvGameDateStrS = GameRcvSdate[0] + "년 " + GameRcvSdate[1] + "월 " + GameRcvSdate[2] + "일 ";
            var RcvGameDateStrE = "";

            if (GameRcvSdate[0] != GameRcvEdate[0]) {
                RcvGameDateStrE += GameRcvEdate[0] + "년 ";
            }

            if (GameRcvSdate[1] != GameRcvEdate[1]) {
                RcvGameDateStrE += GameRcvEdate[1] + "월 ";
            }

            if (GameRcvSdate[2] != GameRcvEdate[2]) {
                RcvGameDateStrE += GameRcvEdate[2] + "일 ";
            }
            var weekdaySt = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');

            var dayS = new Date(GameSdate).getDay();
            var dayLabelS = weekdaySt[dayS].replace("요일", ""); ;

            var dayE = new Date(GameEdate).getDay();
            var dayLabelE = weekdaySt[dayE].replace("요일", ""); ;

            var RcvdayS = new Date(GameRcvSdate).getDay();
            var RcvdayLabelS = weekdaySt[RcvdayS].replace("요일", ""); ;

            var RcvdayE = new Date(GameRcvEdate).getDay();
            var RcvdayLabelE = weekdaySt[RcvdayE].replace("요일", ""); ;

            if (GameDateStrE != "") {
                GameDateStrE = " ~ " + GameDateStrE + " " + dayLabelE + " <span> ( " + jsondata[i].GameDif + "일간 ) </span> ";
            }
            if (RcvGameDateStrE != "") {
                RcvGameDateStrE = " ~ " + RcvGameDateStrE + " " + RcvdayLabelE + " <span> ( " + jsondata[i].GameRcvDif + " 일간 )</span> ";
            }

            if (GameSdate[0] == $("#sel_year").val()) {
                GameDateStrS = GameDateStrS.replace(GameSdate[0] + "년", "");
            }
            if (GameEdate[0] == $("#sel_year").val()) {
                GameDateStrE = GameDateStrE.replace(GameSdate[0] + "년", "");
            }


            if (GameRcvSdate[0] == $("#sel_year").val()) {
                RcvGameDateStrS = RcvGameDateStrS.replace(GameSdate[0] + "년", "");
            }
            if (GameRcvEdate[0] == $("#sel_year").val()) {
                RcvGameDateStrE = RcvGameDateStrE.replace(GameSdate[0] + "년", "");
            }

            if (GameDateStrS == "1900년 01월 01일 ") {
                $("#GameDate").html("");
                $("#Gamematchdate").html("");
            } else {
                $("#GameDate").html(GameDateStrS + " " + dayLabelS + GameDateStrE);
                $("#Gamematchdate").html(GameDateStrS + " " + dayLabelS + GameDateStrE);
            }

            if (RcvGameDateStrS == "1900년 01월 01일 ") {
                $("#GameRcvDatS").html("");
                $(".request").hide();
            } else {
                $("#GameRcvDatS").html(RcvGameDateStrS + " " + RcvdayLabelS + RcvGameDateStrE);
                $(".request").show();
            }



            //참가신청 노출 허용 체크

            //예선 노출 허용 체크

            //본선 진행 체크
            //stateNo : 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
            //gubun : 0 예선 1 예선대진표완료 2본선진출 3 본선대진표완료 4본선대진완료

            //ViewYN : 참가신청 노출여부 Y:노출 N:비노출
            //MatchYN : 대진표App,TeamManager노출여부

            if (jsondata[i].ViewYN == "Y") {
                $("#btnTryRequest").show();
            } else {
                $("#btnTryRequest").hide();
            }

            $("#btnLive").hide();
            $("#btnTryRequest").hide();

            /* 최승규 수정
            if (jsondata[i].MatchYN == "Y") {
            //예선 / 본선 대진표 버튼 상태 
            if (jsondata[i].stateNo <= 0) {
            $("#btnTryRound").hide();
            $("#btnTournRound").hide();
            } else if (jsondata[i].stateNo >= 1) {
            if (jsondata[i].stateNo >= 1) {
            $("#btnTryRound").show();
            } else {
            $("#btnTryRound").hide();
            }
            if (jsondata[i].stateNo >= 5) {
            $("#btnTournRound").show();
            } else {
            $("#btnTournRound").hide();
            }
            } else {
            $("#btnLive").hide();
            $("#btnTryRound").hide();
            $("#btnTournRound").hide();
            }

            //경기 진행중 Live Score 표시
            if (Number(jsondata[i].gameddays) <= 0 && Number(jsondata[i].gameddaye) >= 0) {
            // 본선 경기 진행 중일때 보임
            if (jsondata[i].stateNo == 5) {
            $("#btnLive").show();
            } else {
            $("#btnLive").hide();
            }
            }
            } else {
            $("#btnLive").hide();
            $("#btnTryRound").hide();
            $("#btnTournRound").hide();
            }
            */

            if (jsondata[i].MatchYN == "Y") {
                $("#btnTotalTourney").show();
            }
            else {
                $("#btnTotalTourney").hide();
            }


            $("#btnLive").hide();


            // 기간 조회 (일정) 
            $("#GameDate_detail").html("");
            var obja = {};
            obja.CMD = 24;
            obja.GameTitleIDX = obj.GameTitleIDX;
            var List_c = $.when(mx_player.SendPacket("", obja, "/pub/ajax/reqTennis.asp"));
            List_c.done(function () {
                var htmldata_sub = mx_player.ReceiveData.htmldata;
                var jsondata_sub = mx_player.ReceiveData.jsondata;
                var GameDay = "";
                var GameTime = "";
                var GameDayStr = "";
                var GameTimeStr = "";
                var GameContents = "";
                var str = "";

                for (var i = 0; i < jsondata_sub.length; i++) {
                    if (jsondata_sub[i].GameDay == "") {
                        dayS = "";
                        dayLabelS = "";
                        GameDayStr = "";
                    } else {
                        GameDay = jsondata_sub[i].GameDay.split("-");
                        GameTime = jsondata_sub[i].GameTime;
                        dayS = new Date(GameDay).getDay();
                        dayLabelS = weekdaySt[dayS].replace("요일","");

                        if (GameTime != "") {
                            GameTimeStr = GameTime.split(":");
                            GameTime = GameTimeStr[0] + "시";

                            if (GameTimeStr[1] != "00") {
                                GameTime += " " + GameTimeStr[1] + "분"
                            }
                        }

                        if (GameDayStr != "" + GameDay[1] + "월 " + GameDay[2] +"일 " + dayLabelS + " " + GameTime + "") {
                            if (GameDayStr !="") {
                                $("#GameDate_detail").append("<span>" + GameDayStr + " : " + GameContents + " </span>");
                            }
                            GameDayStr = "" + GameDay[1] + "월 " + GameDay[2] + "일 " + dayLabelS + " " + GameTime + "";
                            GameContents = jsondata_sub[i].TeamGbNm + "(" + jsondata_sub[i].LevelNm + ")";
                        } else {
                            GameContents += " , " + jsondata_sub[i].TeamGbNm + "(" + jsondata_sub[i].LevelNm + ")";
                        }
                    }
                }

                $("#GameDate_detail").append("<span>" + GameDayStr + " : " + GameContents + " </span>");
            });
        }
    });
}

function btnLink(BtnId) {
    var url = "../tournament/";
    switch (BtnId) {
        case "Live":
            url += "live_score.asp";
            $(location).attr('href', url);
            break;
        case "TryRequest":
            url += "live_score.asp";
            break;
        case "TryRound":
            url += "tryround.asp";
            $(location).attr('href', url);
            break;
        case "TournRound":
            url += "tourney.asp";
            $(location).attr('href', url);
            break;
        case "TotalTourney":
            url += "Totaltourney.asp";
            $(location).attr('href', url);
            break;
        default:
            
            break;
    }
}

function stadium_sketch()
{

  var GameTitleIDX = document.getElementById("GameTitleIDX").value;
  var strAjaxUrl = "stadium_sketch_ajax.asp?GameTitleIDX="+ GameTitleIDX;
  //location.href= strAjaxUrl
  $.ajax({
    url: strAjaxUrl,
    type: 'POST',
    dataType: 'html',
    data: { 
     GameTitleIDX  : GameTitleIDX 
    },
    success: function(retDATA) {
      //alert(retDATA);
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
    <!-- S: banner -->
    <!-- <div class="banner banner_md no_mg">
      <div class="img_box">
        <img src="../images/public/banner_md@3x.png" alt="광고영역">
      </div>
    </div> -->
    <!-- E: banner -->
  
    <!-- S: calendar -->
    <div class="calendar">
      <!-- S: calendar-header -->
      <div class="calendar-header container">
        <!-- S: line-1 -->
        <div class="line-1 clearfix institute">
          <div class="select-list clearfix">
            <button id="btnprev" class="prev-btn" type="button">&lt;</button>
            <div class="date">
              <select id="sel_year" name="" class="year">
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
                <select id="sel_month" name="" class="month">
                <option value="01">01월</option> 
                <option value="02">02월</option> 
                <option value="03">03월</option> 
                <option value="04">04월</option> 
                <option value="05">05월</option> 
                <option value="06">06월</option> 
                <option value="07">07월</option> 
                <option value="08">08월</option> 
                <option value="09">09월</option> 
                <option value="10">10월</option> 
                <option value="11">11월</option> 
                <option value="12">12월</option> 
                </select>
            </div>
            <button id="btnnext"  class="next-btn" type="button">&gt;</button>
          </div>
          <button id="btntoday" class="today-btn" type="button">오늘</button>
          
        </div>
        <!-- E: line-1 -->
        <!-- S: line-2 -->

        <!-- E: line-2 -->
        <!-- S: line-3 -->
        <div class="line-3 clearfix">
  <!--          <select  id="EnterType" name="EnterType" class="clearfix" onchange="callCalendar_enter();">
            <option value="A">KATA</option> 
            </select>-->
            <!--<option value="">전체</option>-->
            <!--<option value="E">엘리트</option>-->
         <!-- <ul class="clearfix">
            <li><a id="institutesearch"><img src="../images/institute/icon-calendar-on@3x.png" alt="달력보기"></a></li>https://www.youtube.com/watch?v=e-7m6mu2v48
            <li><a id="instituteschedule" ><img src="../images/institute/icon-list-off@3x.png" alt="리스트보기"></a></li>
          </ul>-->
        </div>
        <!-- E: line-3 -->
      </div>
      <!-- E: calendar-header -->
      <!-- S: 달력 추가 할 container -->
      <div id='calendar'></div>
      <!-- E: 달력 추가 할 container -->

    </div>
    <!-- E: calendar -->
  </div>
  <!-- E: main -->
    </form> 
<button id="aTcommit" class="green_btn" data-toggle="modal" data-target="#sche-list"  style=" display:none;">모집요강</button>
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
        <h4 class="modal-title" id="myModalLabel">대회정보</h4>
      </div>
      <!-- S: modal-body -->
      <div class="modal-body">
        <!-- S: banner -->
        <!-- <div class="banner banner_md">
          <div class="img_box">
            <img src="../images/public/banner_md@3x.png" alt="광고영역">
          </div>
        </div> -->
        <!-- E: banner -->

        <!-- S: sche-title -->
        <div class="sche-title">
          <h2 id="Gametitle"></h2>
          <p class="match-term" id="Gamematchdate"></p>
        </div>
        <!-- E: sche-title -->
        <!-- S: pop -->
          <div class="pop">
           <dl class="schedule-item">
              <dt class="place"><span class="icon"></span>장소</dt>
              <dd id="gamearea"></dd>
            </dl>
            <dl class="schedule-item">
              <dt class="term"><span class="icon"></span>기간</dt>
              <dd id="GameDate">
              
              </dd>
                <div class="term" id=""></div> 
            </dl>
            <dl class="schedule-item">
              <dt class="term"><span class="icon"></span>일정</dt>
              <dd id="GameDate_detail"> </dd>
            </dl>
            <dl class="schedule-item request">
              <dt class="request"><span class="icon"></span>참가신청</dt>
              <dd  id="GameRcvDatS"></dd>
            </dl>
            <div class="sch-btn-list bluey clearfix">
              <a href="javascript:btnLink('Live');" class="btn btn-normal btn-live-score" id="btnLive" >Live Score</a>
              <a href="javascript:btnLink('TryRequest');" class="btn" id="btnTryRequest"  >참가신청정보</a>
              <a href="javascript:btnLink('TotalTourney');" class="btn" id="btnTotalTourney"  >대진표 보기</a>
              <!--<a href="javascript:btnLink('TryRound');" class="btn" id="btnTryRound"  >예선</a>
              <a href="javascript:btnLink('TournRound');" class="btn" id="btnTournRound"  >본선</a>-->
              <a href="javascript:stadium_sketch();" class="btn">현장스케치</a>
            </div>
          </div>
          <!-- E: pop -->
      </div>
      <!-- E: modal-body -->
    </div>
  </div>
  </div>
  <!-- E: sche-list modal -->

  <!-- S: bot-config -->
  <!-- #include file= "../include/bot_config.asp" -->
  <!-- E: bot-config -->
</body>
