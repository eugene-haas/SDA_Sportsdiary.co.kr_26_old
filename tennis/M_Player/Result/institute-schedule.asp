<!-- S: config -->
<!-- #include file="../include/config.asp" -->
<!-- E: config -->
<!--  <link href='../css/library/fullcalendar.min.css' rel='stylesheet' />
  <link href='../css/library/fullcalendar.print.css' rel='stylesheet' media='print' />-->
  <!-- calendar 대응 -->
<!--  <script src="../js/library/jquery-1.12.2.min.js"></script>
  <script src='../js/library/moment.min.js'></script>
  <script src='../js/library/fullcalendar.min.js'></script>
  <script src="../js/library/ko.js"></script>
</head>-->
<%

    'check_login()


  SearchDate    = fInject(request("SearchDate"))  '조회일정
  GameTitleIDX  = fInject(request("GameTitleIDX"))  '대회IDX
  PlayerReln      =  decode(Request.Cookies("PlayerReln"),0)

  if GameTitleIDX="" then
    GameTitleIDX=0
  end if
%>
<script type="text/javascript">

    $(document).ready(function () {
        var defaultReln = "<%=PlayerReln %>";
        var defaultDate = "<%=SearchDate %>";
        var defidx = <%=GameTitleIDX %>;
        if (defidx=="") {
             document.cookie = "GameTitleIDX=0; path=/;";
        }else {
             document.cookie = "GameTitleIDX="+defidx+"; path=/;";
        }

          document.cookie = "SearchDate="+defaultDate+"; path=/;";


        var now = new Date();
        if (defaultDate != "") { now = new Date(defaultDate ); }

           console.log(defaultDate);

        var year = now.getFullYear();
        var mon = (now.getMonth() + 1) > 9 ? '' + (now.getMonth() + 1) : '0' + (now.getMonth() + 1);
        var day = now.getDate() > 9 ? '' + now.getDate() : '0' + now.getDate();
        var chan_val = year + '-' + mon + '-' + day;

        $(".year").val(year);
        $('.year').text(year + '년');

        $('#institutesearch').click(function () {
            location.href="institute-search.asp";
        });
        $('#instituteschedule').click(function () {
            location.href="institute-schedule.asp";
        });

        $(".btn-back").on("click", function () {
         lolocation.href("../main/index.asp");
            //document.cookie = "SearchDate=; path=/;";
            document.cookie = "GameTitleIDX=; path=/;";
        });

        $(".prev-btn").on({
            "click": function (e) {
                e.preventDefault();
                var stat = $('.year').text().replace(" ", "").replace(/ /g, '').replace('년', '');
                var num = parseInt(stat, 10);
                num--;
                if (num <= 0) {
                    alert('더이상 줄일수 없습니다.');
                    num = 1;
                }
                $(".year").val(num);
                $('.year').text(num + '년');
                document.cookie = "GameTitleIDX=0; path=/;";
                idx(chan_val);
            }
        });

        $(".next-btn").on({
            "click": function (e) {
                e.preventDefault();
                var stat = $('.year').text().replace(" ", "").replace(/ /g, '').replace('년', '');
                var num = parseInt(stat, 10);
                num++;
                if (num <= 0) {
                    alert('더이상 줄일수 없습니다.');
                    num = 1;
                }
                $(".year").val(num);
                $('.year').text(num + '년');
                document.cookie = "GameTitleIDX=0; path=/;";
                idx(chan_val);
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
                $('.year').text(year + '년');
                document.cookie = "GameTitleIDX=0; path=/;";
                idx(chan_val);
            }
        });


        var GameTitleIDX_cookie = "";
        if (getCookie("GameTitleIDX") != "") {
            GameTitleIDX_cookie = getCookie("GameTitleIDX");
        } else {
            setCookie("GameTitleIDX", 0, 1);
            GameTitleIDX_cookie = 0;
        }



         idx(defaultDate);
         /*
        //데이터 조회 일괄 처리
        $.ajax({
            url: "institute-schedule_JSON.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                id: "GameTitleIDX",
                GameDay: $(".year").val()
            },
            success: function (retDATA) {
                // accordion 수정 17.03.20
                // tgRotateOn();  main.js 에서 작성
                 DATA_GameTitleIDX(retDATA);
            }, error: function (xhr, status, error) {
                alert(status + "오류발생! - 시스템관리자에게 문의하십시오!" + error);
            }
        });
        */
    });

    // 쿠키 가져오기
    function getCookie(cName) {
        cName = cName + '=';
        var cookieData = document.cookie;
        var start = cookieData.indexOf(cName);
        var cValue = '';
        if (start != -1) {
            start += cName.length;
            var end = cookieData.indexOf(';', start);
            if (end == -1) end = cookieData.length;
            cValue = cookieData.substring(start, end);
        }
        return unescape(cValue);
    }

    function idx(defaultDate) {
        var GameTitleIDX_cookie = "";
        var defaultReln ="<%=PlayerReln %>";
        if (getCookie("GameTitleIDX") != "") {
            GameTitleIDX_cookie = getCookie("GameTitleIDX");
        } else {
            setCookie("GameTitleIDX", 0, 1);
            GameTitleIDX_cookie = 0;
        }
        //데이터 조회 일괄 처리
        $.ajax({
            url: "institute-schedule_JSON.asp",
            type: 'POST',
            dataType: 'html',
            data: {
                id: "GameTitleIDX",
                GameDay: $(".year").val()
            },
            success: function (retDATA) {
                DATA_GameTitleIDX(retDATA,defaultDate,defaultReln);
            }, error: function (xhr, status, error) {
               	if (error!='') {
					alert ("조회중 에러발생 - 시스템관리자에게 문의하십시오!"+' ['+xhr+']'+' ['+status+']'+' ['+error+']');
				}
            }
        });
    }



    //화면그리기
    function DATA_GameTitleIDX(data,defaultDate,defaultReln) {

        var retDATA = data;

        if (retDATA == "]") {
            $(".sche-section").contents().remove();
            $("#GameTitleIDX").contents().remove();
            $("#GameTitleIDX").append("<option value='0'  selected='selected'> :: 대회명을 선택하세요 :: </option>");
            alert("대회 정보가 없습니다.");

        } else {

            var retDATAobj = eval(retDATA);
            var len = retDATAobj.length;

            $(".sche-section").contents().remove();
            $("#GameTitleIDX").contents().remove();
            $("#GameTitleIDX").append("<option value='0'  selected='selected'> :: 대회명을 선택하세요 :: </option>");
            //체크 이미지
            var GameTitleIDX = "";
            var GameTitleName = "";
            var GameSMM = "";
            var apprend_contents = "";
            var sectionC = 0;

            for (var i = 0; i < len; i++) {
                GameTitleIDX = retDATAobj[i].GameTitleIDX;
                GameTitleName = retDATAobj[i].GameTitleName;

                if (getCookie("GameTitleIDX") == GameTitleIDX) {
                    $("#GameTitleIDX").append("<option value='" + GameTitleIDX + "'selected='selected'>" + GameTitleName + "  </option>");
                    sectionC = GameSMM;
                } else {
                    $("#GameTitleIDX").append("<option value='" + GameTitleIDX + "'>" + GameTitleName + " </option>");
                }

                if (GameSMM != retDATAobj[i].GameSMM) {
                    apprend_contents = "<div class='schedule-header "+ retDATAobj[i].GameSYY +"-"+ retDATAobj[i].GameSMM +"-01' tabindex=1><h2><span>" + retDATAobj[i].GameSMM + "</span>월</h2> </div>";
                    $(".sche-section").append(apprend_contents);
                }

                var GameDate = retDATAobj[i].GameSYY + "년 " + retDATAobj[i].GameSMM + "월 " + retDATAobj[i].GameSDD + "일( " + retDATAobj[i].GameSNM + " )   ";
                if (retDATAobj[i].GameS != retDATAobj[i].GameE) {
                    var GameDate = GameDate + " ~ "
                    if (retDATAobj[i].GameSYY != retDATAobj[i].GameEYY) { GameDate = GameDate + retDATAobj[i].GameEYY + "년 "; }
                    if (retDATAobj[i].GameSMM != retDATAobj[i].GameEMM) { GameDate = GameDate + retDATAobj[i].GameEMM + "월 "; }
                    GameDate = GameDate + retDATAobj[i].GameEDD + "일 ( " + retDATAobj[i].GameENM + " ) ";
                }

                var GameRcvDate = retDATAobj[i].GameRcvDateSyy + "년 " + retDATAobj[i].GameRcvDateSmm + "월 " + retDATAobj[i].GameRcvDateSdd + "일(" + retDATAobj[i].GameRcvDateSName + ") ";
                if (retDATAobj[i].GameRcvDateS != retDATAobj[i].GameRcvDateE) {
                    var GameRcvDate = GameRcvDate + " ~ "
                    if (retDATAobj[i].GameRcvDateSyy != retDATAobj[i].GameRcvDateEyy) { GameRcvDate = GameRcvDate + retDATAobj[i].GameRcvDateEyy + "년 "; }
                    if (retDATAobj[i].GameRcvDateSmm != retDATAobj[i].GameRcvDateEmm) { GameRcvDate = GameRcvDate + retDATAobj[i].GameRcvDateEmm + "월 "; }
                    GameRcvDate = GameRcvDate + retDATAobj[i].GameRcvDateEdd + "일 (" + retDATAobj[i].GameRcvDateEName + ") ";
                }

                $(".sche-section").append("<dl id='section" + GameTitleIDX + "' class='panel panel-default' tabindex=0></dl>");
                apprend_contents = "<div id='div_" + retDATAobj[i].GameTitleIDX + "'></div>";
                apprend_contents = apprend_contents + "<dt class='panel-title'>"
                apprend_contents = apprend_contents + "<a data-toggle='collapse' data-parent='#sche-sect' href='.collapse" + GameTitleIDX + "' aria-expanded='true' aria-controls='collapse" + GameTitleIDX + "' class='collapsed'"
                apprend_contents = apprend_contents + " onClick=headerClickCookie("+ GameTitleIDX+",'"+ retDATAobj[i].GameS+"')>";

                apprend_contents = apprend_contents + "<span>[D" + retDATAobj[i].GameDday + "]</span>";
                apprend_contents = apprend_contents + "<span>" + GameTitleName + "</span>";

                apprend_contents = apprend_contents + "<span class='icon-slide'><img src='http://img.sportsdiary.co.kr/sdapp/institute/schedule/slide-title@3x.png' alt=''></span> ";
                apprend_contents = apprend_contents + "<input type='hidden'  id='in_" + GameTitleIDX + "' value='" + retDATAobj[i].GameSMM + "'>";
                apprend_contents = apprend_contents + "</a>";
                apprend_contents = apprend_contents + "</dt>";


                apprend_contents = apprend_contents + "<dd id='collapse" + GameTitleIDX+"' class='sch-item-def collapse" + GameTitleIDX + " collapse'  role='tabpanel' >";
                apprend_contents = apprend_contents + " <div class='panel-body' >";

                apprend_contents = apprend_contents + "<dl class='schedule-item'> <dt class='place'><span class='icon'></span>대회장소</dt>";
                apprend_contents = apprend_contents + "<dd>" + retDATAobj[i].GameArea + "</dd>";
                apprend_contents = apprend_contents + "</dl>";

                var btndisabled = ""
                var btndisabled_a = ""
                var BtnColor ="style='background-color:"+retDATAobj[i].color+"'";


                apprend_contents = apprend_contents + "<dl class='schedule-item'> <dt class='term'><span class='icon'></span>대회기간</dt>";
                apprend_contents = apprend_contents + "<dd>" + GameDate + "  (" + retDATAobj[i].Gamediff + " 일간)</dd>";
                apprend_contents = apprend_contents + "</dl>";

                apprend_contents = apprend_contents + "<dl class='schedule-item'> <dt class='request'><span class='icon'></span>대회참가신청</dt>";
                apprend_contents = apprend_contents + "<dd>" + GameRcvDate + "  (" + retDATAobj[i].GameRcvDateSdiff + " 일간)</dd>";
                apprend_contents = apprend_contents + "</dl>";

                apprend_contents = apprend_contents + "<div class='sch-btn-list clearfix' >";
                //apprend_contents = apprend_contents + "<span>" + retDATAobj[i].GameDday + btndisabled_a + " </span>";

                apprend_contents = apprend_contents + "<a href='./match-sch.asp?GameTitleIDX=" + GameTitleIDX + "' id='GameTitleIDX" + retDATAobj[i].GameTitleIDX + "_1' class='btn'  "+BtnColor+ " >대회일정표</a>";
                if (retDATAobj[i].MatchYN == "N") {
                    btndisabled = "disabled='true'";
                }
                apprend_contents = apprend_contents + "<a href='../tournament/tourney.asp?GameTitleIDX=" + GameTitleIDX + "&GameTitleName=" + GameTitleName + "' id='GameTitleIDX" + retDATAobj[i].GameTitleIDX + "_2' class='btn' " + btndisabled +" "+BtnColor+  " >대진표보기</a>";

                if (retDATAobj[i].GameDday <= -1) {
                    btndisabled_a = "disabled='true'";
                }
                if (defaultReln=="R" || defaultReln=="K" || defaultReln=="") {
                apprend_contents = apprend_contents + "<a href='../MatchDiary/match-diary.asp?GameTitleIDX=" + GameTitleIDX + "' id='GameTitleIDX" + retDATAobj[i].GameTitleIDX + "_3' class='btn' " + btndisabled_a +" "+BtnColor+  " >대회일지작성</a>";
                }

                apprend_contents = apprend_contents + "</div>";

                apprend_contents = apprend_contents + " </div>";
                apprend_contents = apprend_contents + "</dd>";


                //                 case "1": //대회일정
                //                page_move = "./match-sch.asp?GameTitleIDX=" + GameTitleIDX + "&GameTitleName=" + GameTitleName;
                //                break;
                //            case "2": //대진표
                //                page_move = "../tournament/tourney.asp?GameTitleIDX=" + GameTitleIDX + "&GameTitleName=" + GameTitleName;
                //                break;
                //            case "3": //대회일지 작성
                //                page_move = "../MatchDiary/match-diary.asp?GameTitleIDX=" + GameTitleIDX + "&GameTitleName=" + GameTitleName;
                //                break;

                // apprend_contents = "";
                // apprend_contents+= "<dt class='panel-title'>";
                // apprend_contents+= "  <a data-toggle='collapse' data-parent='.sche-section' href='.collapse"+GameTitleIDX+"'>";
                // apprend_contents+= "    <span>[D" + retDATAobj[i].GameDday + "]</span>";
                // apprend_contents+= "    <span>" + GameTitleName + "</span>";
                // apprend_contents+= "  </a>";
                // apprend_contents+= "</dt>";
                // apprend_contents+= "<dd class='sch-item-def collapse" + GameTitleIDX + " collapse'>";
                // apprend_contents+= "  <div class='panel-body'>";
                // apprend_contents+= "  <dl class='schedule-item'>";
                // apprend_contents+= "    <dt class='place'><span class='icon'></span>대회장소";
                // apprend_contents+= "    </dt>";
                // apprend_contents+= "  </dl>";
                // apprend_contents+= "  </div>";
                // apprend_contents+= "</dd>";

                $("#section" + GameTitleIDX).append(apprend_contents);
                GameSMM = retDATAobj[i].GameSMM;

                $("#section" + GameTitleIDX).attr("tabindex", i);

            }
            $("#div_" + $("#GameTitleIDX").val()).siblings('.collapse' + $("#GameTitleIDX").val()).addClass('in').css({
                'height': '100%'
            });

            $("#div_" + $("#GameTitleIDX").val()).siblings('.panel-title a').click(function () {
                $(this).parents('.panel').find('dd.collapse').toggle();
            });

            $("#section" + $("#GameTitleIDX").val()).focus();

            if (defaultDate!="") {
             $(".schedule-header." + defaultDate).focus();
                }


            // 2017-01-01
          //  console.log(defaultDate);
        }
    }

    function headerClickCookie(id,Sdate) {
         document.cookie = "GameTitleIDX="+id+"; path=/;";
         document.cookie = "SearchDate="+Sdate+"; path=/;";
         $("#GameTitleIDX").val(id);
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
			alert('등록된 현장스케치가 없습니다.....');
			return;
		 }
	  }
	});

}


</script>

<body>
<form name="frm" id="frm" method="post">
  <input type="hidden" id="GameTitleIDX" name="GameTitleIDX">
  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대회일정/결과</h1>
    <!-- #include file="../include/sub_header_gnb.asp" -->
  </div>
  <!-- #include file = "../include/gnb.asp" -->
  <!-- E: sub-header -->

  <div class="calendar">
    <!-- S: calendar-header -->
      <div class="calendar-header schedule-list container">
        <!-- S: line-1 -->
        <div class="line-1 clearfix institute">
          <div class="select-list clearfix">
            <button class="prev-btn" type="button">&lt;</button>
            <!-- <select name="" id class="year">
              <option value="">2016년</option>
              <option value="">2017년</option>
              <option value="">2018년</option>
            </select> -->
            <span class="year">2016년</span>
            <button class="next-btn" type="button">&gt;</button>
          </div>
          <button class="today-btn" type="button">오늘</button>
        </div>
        <!-- E: line-1 -->
        <!-- S: line-2 -->
        <div class="line-2">
          <select id="GameTitleIDX" name="GameTitleIDX">
            <option value="" selected>:: 대회명을 선택하세요 ::</option>
          </select>
        </div>
        <!-- E: line-2 -->
        <!-- S: line-3 -->
        <div class="line-3 clearfix">
          <ul class="clearfix">
            <li><a  id="institutesearch"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-calendar-off@3x.png" alt="달력보기"></a></li>
            <li><a id="instituteschedule"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-list-on@3x.png" alt="리스트보기"></a></li>
          </ul>
        </div>
        <!-- E: line-3 -->
      </div>
      <!-- E: calendar-header -->
  </div>
  <!-- S: main -->
  <div class="main inst-sche">
    <!-- S: schedule -->
    <div class="schedule">
      <section class="sche-section" id="sche-sect">
        <!-- S: 3월 -->
        <div class="schedule-header">
          <h2><span>03</span>월</h2>
        </div>
        <!-- S: panel -->
        <dl class="panel panel-default">
            <dt class="panel-title">
                <a data-toggle="collapse" data-parent=".sche-section" href=".collapse01" aria-expanded="true" aria-controls="collapse01" class="on">
                    <span>[D-113]</span>
                    <span>2016 추계 전국 남,여 중고등학교 유도연맹전</span>
                    <span class="icon-slide"><img src="http://img.sportsdiary.co.kr/sdapp/institute/slide-title@3x.png" alt></span>
                </a>
            </dt>
            <dd class="sch-item-def collapse01 collapse in" role="tabpanel">
                <div class="panel-body">
                    <dl class="schedule-item">
                        <dt class="place"><span class="icon"></span>대회장소</dt>
                        <dd>서울 체육관</dd>
                    </dl>
                    <dl class="schedule-item">
                        <dt class="term"><span class="icon"></span>대회기간</dt>
                        <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
                    </dl>
                    <dl class="schedule-item request">
                        <dt class="request"><span class="icon"></span>대회참가신청</dt>
                        <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
                    </dl>
                    <div class="sch-btn-list clearfix">
                        <button class="btn">대회일정표</button>
                        <button class="btn">참가신청/내역</button>
                        <button class="btn">대진표보기</button>
                    </div>
                    <!-- <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div> -->
                </div>
            </dd>
        </dl>
                <!-- E: panel -->
        <dl class="panel panel-default">
          <dt class="panel-title">
                        <a data-toggle="collapse" data-parent=".sche-section" href=".collapse02" aria-expanded="true" aria-controls="collapse02">
                            <span>[D-12]</span>
                            <span>2016 순천만 국가정원컵 전국 유도대회</span>
                            <span class="icon-slide"><img src="http://img.sportsdiary.co.kr/sdapp/institute/slide-title@3x.png" alt></span>
                        </a>
          </dt>
          <dd class="sch-item-def collapse02 collapse" role="tabpanel">
            <dl class="schedule-item">
              <dt class="place"><span class="icon"></span>대회장소</dt>
              <dd>서울 체육관</dd>
            </dl>
            <dl class="schedule-item">
              <dt class="term"><span class="icon"></span>대회기간</dt>
              <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
            </dl>
            <dl class="schedule-item request">
              <dt class="request"><span class="icon"></span>대회참가신청</dt>
              <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
            </dl>
            <div class="sch-btn-list clearfix">
              <button class="btn">대회일정표</button>
              <button class="btn">참가신청/내역</button>
              <button class="btn">대진표보기</button>
            </div>
            <!-- <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div> -->
          </dd>
        </dl>
          <!-- E: 3월 -->


          <!-- S: 4월 -->
        <div class="schedule-header">
          <h2><span>04</span>월</h2>
        </div>
        <!-- S: panel -->
        <dl class="panel panel-default">
          <dt class="panel-title">
                        <a data-toggle="collapse" data-parent=".sche-section" href=".collapse03" aria-expanded="true" aria-controls="collapse03">
                            <span>[D-113]</span>
                            <span>2016 추계 전국 남,여 중고등학교 유도연맹전</span>
                            <span class="icon-slide"><img src="http://img.sportsdiary.co.kr/sdapp/institute/slide-title@3x.png" alt></span>
                        </a>
                    </dt>
          <dd class="sch-item-def collapse03 collapse" role="tabpanel">
                        <div class="panel-body">
                            <dl class="schedule-item">
                                <dt class="place"><span class="icon"></span>대회장소</dt>
                                <dd>서울 체육관</dd>
                            </dl>
                            <dl class="schedule-item">
                                <dt class="term"><span class="icon"></span>대회기간</dt>
                                <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
                            </dl>
                            <dl class="schedule-item request">
                                <dt class="request"><span class="icon"></span>대회참가신청</dt>
                                <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
                            </dl>
                            <div class="sch-btn-list clearfix">
                                <button class="btn">대회일정표</button>
                                <button class="btn">참가신청/내역</button>
                                <button class="btn">대진표보기</button>
                            </div>
                            <!-- <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div> -->
                        </div>
          </dd>
                </dl>
                <!-- E: panel -->
        <!-- S: panel -->
        <dl class="panel panel-default">
          <dt class="panel-title">
                        <a data-toggle="collapse" data-parent=".sche-section" href=".collapse04" aria-expanded="true" aria-controls="collapse04">
                            <span>[D-12]</span>
                            <span>2016 순천만 국가정원컵 전국 유도대회</span>
                            <span class="icon-slide"><img src="http://img.sportsdiary.co.kr/sdapp/institute/slide-title@3x.png" alt></span>
                        </a>
          </dt>
          <dd class="sch-item-def collapse04 collapse" role="tabpanel">
                        <div class="panel-body">
                            <dl class="schedule-item">
                                <dt class="place"><span class="icon"></span>대회장소</dt>
                                <dd>서울 체육관</dd>
                            </dl>
                            <dl class="schedule-item">
                                <dt class="term"><span class="icon"></span>대회기간</dt>
                                <dd>2016년 3월 25일 ~ 28일 (3일간)</dd>
                            </dl>
                            <dl class="schedule-item request">
                                <dt class="request"><span class="icon"></span>대회참가신청</dt>
                                <dd>2016년 3월 11일 ~ 21일 (10일간)</dd>
                            </dl>
                            <div class="sch-btn-list clearfix">
                                <button class="btn">대회일정표</button>
                                <button class="btn">참가신청/내역</button>
                                <button class="btn">대진표보기</button>
                            </div>
                            <!-- <div class="sch-itemcon"><img src="../images/institute/schedule/icon-diary@3x.png" alt></div> -->
                        </div>
          </dd>
        </dl>
        <!-- E: panel -->
      <!-- E: 4월 -->
      </section>
    </div>
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

<script type="text/javascript">

    $(document).on("click", ".btn", function (e) {
        e.preventDefault();
        var id = $(this).attr("id");
        var i_htef = $(this).attr("href");
        var GameTitleIDX = id.replace("GameTitleIDX", "").replace("_1", "").replace("_2", "").replace("_3", "");
        id = id.replace("GameTitleIDX", "").replace(GameTitleIDX, "").replace("_", "");
        document.cookie = "GameTitleIDX" + "=" + GameTitleIDX + "; path=/;";

        switch (id) {
            case "1": //대회일정
                page_move = "./match-sch.asp";
                break;
            case "2": //대진표
                 page_move = "../tournament/tourney.asp";
                break;
            case "3": //대회일지 작성
                page_move = "../MatchDiary/match-diary.asp";
                break;
        }

        $("#frm").attr("action", i_htef);
        $('#frm').submit();
    });

    /* */
    $(document).on("change", "#GameTitleIDX", function (e) {
        e.preventDefault();
        var IDX = $("#GameTitleIDX").val();
        var seid = $("#in_" + IDX).val();
        document.cookie = "GameTitleIDX" + "=" + $("#GameTitleIDX").val() + "; path=/;";

        $(".collapse").css({
            'height': '0'
        });

        $('dd.collapse').removeClass('in');

        $("#div_" + IDX).focus().siblings('.collapse' + IDX).addClass('in').css({
            'height': '100%'
        });

        $("#div_" + IDX).siblings('.panel-title a').click(function () {
            $(this).parents('.panel').find('dd.collapse').toggle();
        });

        $("#section" + $("#GameTitleIDX").val()).focus();
    });
</script>

  </form>

</body>
