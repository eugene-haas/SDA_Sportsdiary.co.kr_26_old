<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
 <%
   check_login()
      SearchDate    = fInject(request("SearchDate"))  '조회일정
  %>
  <link href='../css/library/fullcalendar.min.css' rel='stylesheet' />
  <link href='../css/library/fullcalendar.print.css' rel='stylesheet' media='print' />
  <!-- calendar 대응 -->
  <script src="../js/library/jquery-1.12.2.min.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        var defaultDate = "<%=SearchDate %>";
        var now = new Date();
        if (defaultDate != "") { now = new Date(defaultDate); }
        var year = now.getFullYear();
        var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
        var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();
        var chan_val = year + '-' + mon + '-' + day;

        $(".year").val(year);
        $('.month').text(mon + '월');



        $(".btn-back").on("click", function () {
            document.cookie = "SearchDate=; path=/;";
            document.cookie = "GameTitleIDX=; path=/;";
            location.href("../main/index.asp");
        });

        $("#schecalendar").on({
            "click": function (e) {
             e.preventDefault();
             location.href = "../Schedule/sche-calendar.asp?SearchDate=" + $(".year").val() + "-" + $('.month').text().replace("월", '').replace(/ /g, '') + "-" + "01";
            }
        });
        $("#schecalendarlist").on({
            "click": function (e) {
              e.preventDefault();
              location.href = "../Schedule/list.asp?SearchDate=" + $(".year").val() + "-" + $('.month').text().replace("월", '').replace(/ /g, '') + "-" + "01";
            }
        });

        $(".prev-btn").on({
            "click": function (e) {
                e.preventDefault();
                var d = new Date($(".year").val(), $('.month').text().replace("월", '').replace(/ /g, ''), "01");
                var yy = d.getFullYear();
                var mm = d.getMonth() - 1;
                if (mm <= 0) {
                    yy = yy - 1;
                    mm = mm + 12;
                }
                mm = (mm < 10) ? '0' + mm : mm;
                $(".year").val(yy);
                $('.month').text(mm + '월');
                document.cookie = "SearchDate=" + yy +"-"+mm+"-01; path=/;";
                dataDetaile($(".year").val() + "" + $('.month').text().replace("월", '').replace(/ /g, ''));
            }
        });

        $(".next-btn").on({
            "click": function (e) {
                e.preventDefault();
                var d = new Date($(".year").val(), $('.month').text().replace("월", '').replace(/ /g, ''), "01");
                var yy = d.getFullYear();
                var mm = d.getMonth() + 1; mm = (mm < 10) ? '0' + mm : mm;
                $(".year").val(yy);
                $('.month').text(mm + '월');
                document.cookie = "SearchDate=" + yy +"-"+mm+"-01; path=/;";
                dataDetaile($(".year").val() + "" + $('.month').text().replace("월", '').replace(/ /g, ''));
            }
        });

        $(".today-btn").on({
            "click": function (e) {
                e.preventDefault();
                var now = new Date();
                var year = now.getFullYear();
                var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
                var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();
                var chan_val = year + '-' + mon + '-' + day;
                $(".year").val(year);
                $('.month').text(mon + '월');
                document.cookie = "SearchDate=" + chan_val+"; path=/;";
                dataDetaile($(".year").val() + "" + $('.month').text().replace("월", '').replace(/ /g, ''));
            }
        });


        dataDetaile($(".year").val() +  $('.month').text().replace("월", '').replace(/ /g, ''));

        //document ready end
    });

    //상세조회
    function dataDetaile(yymm) {

        $(".btn-back").prop("disabled", true);
        $(".prev-back").prop("disabled", true);
        $(".next-back").prop("disabled", true);
        $("#schecalendar").prop("disabled", true);
        $("#schecalendarlist").prop("disabled", true);

        $.ajax({
            url: "list-select.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                checkDay: yymm + "01"
            },
            success: function (retDATA) {


                $("#my-schedule-list").html(retDATA)
                dataLoad(yymm + "01");


            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });
    }


    //데이터 조회
    function dataLoad(yymm) {
        $.ajax({
            url: "list-header-json.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                YYMM: yymm
            },
            success: function (retDATA) {
                //헤더
                DATA_SETTING(retDATA);

                $(".btn-back").attr("disabled", false);
                $(".prev-back").attr("disabled", false);
                $(".next-back").attr("disabled", false);
                $("#schecalendar").attr("disabled", false);
                $("#schecalendarlist").attr("disabled", false);


            }, error: function (xhr, status, error) {
                if (error != '') {
                    alert("조회중 에러발생 - 시스템관리자에게 문의하십시오!" + ' [' + xhr + ']' + ' [' + status + ']' + ' [' + error + ']');
                }
            }
        });
    }


    //화면 그리기
    function DATA_SETTING(DATA) {
        var retDATA = DATA;
        if (retDATA != "]") {
            var retDATAobj = eval(retDATA);
            var len = retDATAobj.length;

            for (var i = 0; i < len; i++) {
                var holdheader = "holdheader" + retDATAobj[i].titleid;
                switch (retDATAobj[i].className) {
                    case "match":
                        $("#" + holdheader).append(" <span class='mk-sqare mk-blue'>대</span>");
                        break;
                    case "attend-end":
                    case "attend":
                    case "no-attend":

                        if (retDATAobj[i].className == "attend") {
                            $("#" + holdheader).append(" <span class='mk-sqare mk-skyblue-line'>훈</span>");
                        }

                        if (retDATAobj[i].className == "no-attend") {
                            $("#" + holdheader).append(" <span class='mk-sqare mk-though '>훈</span>");
                        }

                        if (retDATAobj[i].className == "attend-end") {
                            $("#" + holdheader).append(" <span class='mk-sqare mk-skyblue'>훈</span>");
                        }

                        if (retDATAobj[i].bigo != "") {
                            $("#" + holdheader).append(" <span class='mk-sqare mk-red'>부</span>");
                        }

//
//.mk-blue {background:#318ebc; line-height:21px;}
//.mk-green {background:#64b636; line-height:21px;}
//.mk-orange {background:#d38b1a; line-height:21px;}
///*.mk-gray {background:#646464; line-height:17px;}*/
//.mk-red {background:#e53636; line-height:21px;}

///* 2017-02-22 add */
//.mk-skyblue {background:#0072d5; line-height:21px;}
//.mk-yellowgreen {background:#01a916; line-height:21px;}
//.mk-marine {background:#42c7da; line-height:21px;}
//.mk-gray {background:#939393; line-height:21px;}
//.mk-brown {background:#df8400; line-height:21px;}
//.mk-skyblue-line {color:#0072d5; width:16px; height:16px; border:1px solid #0072d5; line-height:21px;}
//.mk-though {text-decoration:line-through; color:#0072d5; width:16px; height:16px; border:1px solid #0072d5; line-height:21px;}


                        break;
                    case "practice":
                        $("#" + holdheader).append(" <span class='mk-sqare mk-orange'>개</span>");
                        break;
                    case "Stim":
                        $("#" + holdheader).append(" <span class='mk-sqare mk-yellowgreen'>체</span>");
                        break;
                }
            }
        }
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

  <div class="calendar">
    <!-- S: calendar-header -->
      <div class="calendar-header container">
        <!-- S: line-1 -->
        <div class="line-1 schedule clearfix institute">
          <div class="select-list clearfix">
            <button class="prev-btn" type="button">&lt;</button>
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
              <span class="month"> </span>
            </div>
            <button class="next-btn" type="button">&gt;</button>
          </div>
          <button class="today-btn" type="button" >오늘</button>
        </div>
        <!-- E: line-1 -->
        <!-- S: line-3 -->
        <div class="line-3 schedule clearfix">
          <ul class="clearfix">
           <!-- <li><a href="sche-calendar.asp"><img src="../images/institute/icon-calendar-off@3x.png" alt="달력보기"></a></li>
            <li><a href="list.asp"><img src="../images/institute/icon-list-on@3x.png" alt="리스트보기"></a></li>-->

            <li><a id="schecalendar"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-calendar-off@3x.png" alt="달력보기"></a></li>
            <li><a id="schecalendarlist"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-list-on@3x.png" alt="리스트보기"></a></li>
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
  <!-- S: my-schedule-list -->
      <div id="my-schedule-list" class="my-schedule-list custom-accord">

      </div>
      <!-- E: my-schedule-list -->
    <!--loop end -->
        <!-- E: schedule -->
    </div>
  <!-- E: main -->
  </div>
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
