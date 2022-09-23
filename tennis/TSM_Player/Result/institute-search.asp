<!DOCTYPE html>
<html lang="ko">
<head>
  <!-- #include file="../include/head.asp" -->
  <!-- #include file="../include/config.asp" -->

  <%
    'check_login()
    SearchDate    = Request("SearchDate")  '조회일정
    GameTitleIDX  = Request("GameTitleIDX")  '대회IDX
    'EnterType   	= Request.Cookies("EnterType")

    if GameTitleIDX="" then
      GameTitleIDX="0"
    end if
  %>

  <%

    iLIUserID = Request.Cookies("SD")("UserID")
    iLIMemberIDX = Request.Cookies(SportsGb)("MemberIDX")
    iLIMemberIDXd = decode(iLIMemberIDX,0)
    iLISportsGb = SportsGb

  	LocateIDX_1 = "12"
  	'LocateIDX_2 = "10"
  	LocateIDX_3 = "13"

  %>

  <script type="text/javascript">
    //페이지 호출과 동시에 달력을 호출한다.
    var weekdaySt = new Array('일', '월', '화', '수', '목', '금', '토');
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
            if (history.state == null) {} else { history.back(); }
        };

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
        });

        $('#btnprev').click(function () {
            $('#calendar').fullCalendar('prev');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            year = yy(m);
            mon = mm(m);
            $("#sel_year").val(year);
            $("#sel_month").val(mon);
        });

        $('#btnnext').click(function () {
            $('#calendar').fullCalendar('next');
            var calendar = $('#calendar').fullCalendar('getDate');
            var m = calendar.format();
            year = yy(m);
            mon = mm(m);
            $("#sel_year").val(year);
            $("#sel_month").val(mon);
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


    function callCalendar_enter() {
      var v_EnterType = $(this).val();
  	  $('#calendar').fullCalendar('removeEventSources'); //https://fullcalendar.io/docs/removeEventSources 참조
  	  $('#calendar').fullCalendar("addEventSource", "/pub/ajax/reqTennis.asp?REQ=25&typeSq=app&gp="+v_EnterType); //0전체 1kata 2 sd랭킹
    }


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
                    // $('.fc-day-grid-event').attr('data-toggle', 'modal');
                    // $('.fc-day-grid-event').attr('data-target', '#sche-list');
                    if (defidx > 0) {

                        var obj = {};
                        obj.CMD = 23;
                        obj.GameTitleIDX = defidx;
                        // modalSetting("sche-list", obj, "/pub/ajax/reqTennis.asp");
                        // $("#aTcommit").click();

                        document.getElementById("GameTitleIDX").value = defidx;
                        history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + defaultDate + '&GameTitleIDX=' + defidx);
                        defidx = "";
                    }
                }
            },
            eventClick: function (calEvent, jsEvent, view) {
                history.pushState({ page: 1, name: '팝업' }, '', '?SearchDate=' + calEvent.start.format() + '&GameTitleIDX=' + calEvent.id);
                defidx = calEvent.id;
                localStorage.setItem("GameTitleIDX", calEvent.id);
                localStorage.setItem("GameTitleName", calEvent.title);
                localStorage.setItem("EnterType", calEvent.EnterType);
                localStorage.setItem("T_TeamGb", calEvent.teamgb);
                localStorage.setItem("T_TeamGbNM", calEvent.teamgbnm);

                var obj = {};
                obj.CMD = 23;
                obj.GameTitleIDX = calEvent.id;
				obj.EnterType = calEvent.EnterType;

                modalSetting("sche-list", obj, "/pub/ajax/reqTennis.asp");

                $('#sche-list').modal('show');
            }
        });
        //일정

		  $('#calendar').fullCalendar("addEventSource", "/pub/ajax/reqTennis.asp?REQ=25&typeSq=app&gp=&kk="); //0전체 1kata 2 sd랭킹
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
                var GameSdateStr = jsondata[i].sdate;
                var GameEdate = jsondata[i].edate.split("-");
                var GameEdateStr = jsondata[i].edate;
                var GameRcvSdate = jsondata[i].GameRcvDateS.split("-");
                var GameRcvSdateStr = jsondata[i].GameRcvDateS;

                var GameRcvEdate = jsondata[i].GameRcvDateE.split("-");
                var GameRcvEdateStr = jsondata[i].GameRcvDateE;

			 //라이브체크 있는지?
			 var livechk = jsondata[0].gubun; //3이 있으면 본선 진출자가 있음...진행여부는 모름...


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

                weekdaySt = new Array('일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일');

                var dayS = new Date(GameSdateStr).getDay();
                var dayLabelS = weekdaySt[dayS];
                var dayE = new Date(GameEdateStr).getDay();
                var dayLabelE = weekdaySt[dayE];

                var RcvdayS = new Date(GameRcvSdateStr).getDay();
                var RcvdayLabelS = weekdaySt[RcvdayS];

                var RcvdayE = new Date(GameRcvEdateStr).getDay();
                var RcvdayLabelE = weekdaySt[RcvdayE];

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
                    $("#GameRcvDatS").html("");
                    $(".request").hide();
                }



                //참가신청 노출 허용 체크

                //예선 노출 허용 체크

                //본선 진행 체크
                //stateNo : 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
                //gubun : 0 예선 1 예선대진표완료 2본선진출 3 본선대진표완료 4본선대진완료

                //ViewYN : 참가신청 노출여부 Y:노출 N:비노출
                //MatchYN : 대진표App,TeamManager노출여부
                var stgEnterType = localStorage.getItem("EnterType");

			  if ( obj.EnterType == "S") { //SD랭킹전 //대회요강
                    $("#btnGameSum").show();
				  if (Number(livechk) > 2){
	                  $("#btnLive").show();
				  }
				  else{
	                  $("#btnLive").hide();
				  }

			  } else {
                    $("#btnGameSum").hide();
                  $("#btnLive").hide();
                }


			  if ( obj.EnterType == "S") { //SD랭킹전 //대회요강
				  if (jsondata[i].ViewYN == "Y") {
					  $("#btnTryRequest").show();
				  } else {
					  $("#btnTryRequest").hide();
				  }
			  }
			  else{
				  $("#btnTryRequest").hide();
			  }


                if (jsondata[i].MatchYN == "Y") {
                    $("#btnTotalTourney").prop("href", "javascript:btnLink('TotalTourney');").show();
                }
                else {
                    $("#btnTotalTourney").prop("href", "javascript:alert('준비중 입니다.');").show();
                }

                if (jsondata[i].sketch_gb > 0) {
    				        $("#StadiumSketch").show();
                }
                else {
    				        $("#StadiumSketch").hide();
                }


               // $("#btnLive").hide();


                // 기간 조회 (일정)
                $("#GameDate_detail").html("");
                var obja = {};
                obja.CMD = 24;
                obja.GameTitleIDX = obj.GameTitleIDX;
				obja.EnterType  = obj.EnterType; //루키테니스구분
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
                            GameDayW = jsondata_sub[i].GameDay;
                            GameTime = jsondata_sub[i].GameTime;
                            dayS = new Date(GameDayW).getDay();
                            weekdaySt = new Array('일', '월', '화', '수', '목', '금', '토');
                            dayLabelS = weekdaySt[dayS];

                            if (GameTime != "") {
                                GameTimeStr = GameTime.split(":");
                                GameTime = GameTimeStr[0] + "시";

                                if (GameTimeStr[1] != "00") {
                                    GameTime += " " + GameTimeStr[1] + "분"
                                }
                            }

                            if (GameDayStr != "" + GameDay[1] + "월 " + GameDay[2] + "일 " + dayLabelS + " " + GameTime + "") {
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
          //case "summary" : url += "gamesummary.asp?tidx=" + localStorage.getItem("GameTitleIDX");$(location).attr('href', url);break;
		case "summary" : url = "../result/rookieTennis_info.asp";$(location).attr('href', url);break;
			case "Live":
                //url += "live_score.asp";
			  localStorage.setItem('live', "ok");
			  url += "Totaltourney.asp";
                $(location).attr('href', url);
                break; //최초 디자인만 존재
            case "TryRequest":
                //url += "live_score.asp";
			  url = "http://rt.sportsdiary.co.kr/tnrequest/list.asp";
                $(location).attr('href', url);
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
            /*
    		case "sketch":
                if (localStorage.getItem("GameTitleIDX") == "4" || localStorage.getItem("GameTitleIDX") == "6" || localStorage.getItem("GameTitleIDX") == "1"){
                    url = "./stadium_sketch.asp";
                    $(location).attr('href', url);
                }
                else{
                    url = "javascript:alert('서비스 준비 중 입니다.')";
                    $(location).attr('href', url);
                }
                break;
            */
            default:

                break;
        }
    }

    function stadium_sketch(){


    	var GameTitleIDX = localStorage.getItem("GameTitleIDX");
        var stgEnterType = localStorage.getItem("EnterType");

        document.getElementById("GameTitleIDX").value =  localStorage.getItem("GameTitleIDX");

        //var strAjaxUrl = "stadium_sketch_ajax.asp?GameTitleIDX="+ GameTitleIDX;
        var strAjaxUrl = "stadium_sketch_ajax.asp";

    	//location.href= strAjaxUrl
    	//return;

    	$.ajax({
    	  url: strAjaxUrl,
    	  type: 'POST',
    	  dataType: 'html',
    	  data: {
    		 GameTitleIDX  : GameTitleIDX,
    		 sitegubun  : stgEnterType
    	  },
    	  success: function(retDATA) {

            //console.log(retDATA);

    		 if (retDATA > 0){
                $('#GameTitleIDX').val(GameTitleIDX);
                $('#SiteGubun').val(stgEnterType);
    			$('form[name=frm]').attr('action','./stadium_sketch.asp');
                $('form[name=frm]').submit();

                /*
                document.frm.action="stadium_sketch.asp"
    			document.frm.submit();
                */
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
</head>
<body>
<div class="l m_bg_f5f5f5">

  <!-- #include file = "../include/gnb.asp" -->

  <div class="l_header">
    <div class="m_header s_sub">
      <!-- #include file="../include/header_back.asp" -->
      <h1 id="aaaaa" class="m_header__tit">대회일정/결과</h1>
      <!-- #include file="../include/header_gnb.asp" -->
    </div>

    <!-- S: main banner 01 -->
    <%
      imType = "1"
      imSportsGb = "tennis"
      imLocateIDX = LocateIDX_1

      LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
      'response.Write "LSQL="&LSQL&"<br>"
      'response.End

      Set LRs = DBCon6.Execute(LSQL)
      If Not (LRs.Eof Or LRs.Bof) Then
    %>
    <div class="major_banner">
      <div class="banner banner_<%=LRs("LocateGb")%> carousel">
          <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
          <!-- #include file="../include/banner_Include.asp" -->
          </div>
        </div>
    </div>
    <%
      End If
      LRs.close
    %>
    <!-- E: main banner 01 -->
  </div>

  <!-- S: main -->
  <div class="l_content m_scroll main [ _content _scroll ]">

    <form name="frm" id="frm" method="post">
      <input type="hidden" id="GameTitleIDX" name="GameTitleIDX">
      <input type="hidden" id="SiteGubun" name="SiteGubun"><!-- SD랭킹은 S -->

      <!-- S: calendar -->
      <div class="sd-calendar-container">

        <!-- S: calendar-header -->
        <div class="sd-calendar-header">
          <!-- S: line-1 -->
          <div class="line-1">
            <div class="select-list">
              <button id="btnprev" class="prev-btn" type="button">&lt;</button>
              <div class="date">
                <select id="sel_year" name="" class="year">
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


    		  <div class="line-3 clearfix">
            <div class="enter-type">
              <input type="radio" id="EnterType_D" name="EnterType" value="" hidden="" checked="" onchange="callCalendar_enter.call(this);">
              <label for="EnterType_D">전체</label>
              <input type="radio" id="EnterType_E" name="EnterType" value="K" hidden="" onchange="callCalendar_enter.call(this);">
              <label for="EnterType_E">KATA대회</label>
              <input type="radio" id="EnterType_A" name="EnterType" value="S" hidden="" onchange="callCalendar_enter.call(this);">
              <label for="EnterType_A">SD랭킹전</label>
            </div>
            <ul>
              <!-- <li><a id="institutesearch"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-calendar-on@3x.png" alt="달력보기"></a></li>
              <li><a id="instituteschedule"><img src="http://img.sportsdiary.co.kr/sdapp/institute/icon-list-off@3x.png" alt="리스트보기"></a></li> -->
            </ul>
          </div>


        </div>
        <!-- E: calendar-header -->


        <!-- S: 달력 추가 할 container -->
        <div id='calendar' class="sd-calendar-body"></div>
        <!-- E: 달력 추가 할 container -->

      </div>
      <!-- E: calendar -->

    	<div class="sd-calendar-footer">
    	   <div class="te-calendar-legend"> <span>KATA대회</span> <span>SD랭킹전</span> </div>
    	</div>
    </form>

  </div>
  <!-- E: main -->

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
          <!-- S: main banner 03 -->
          <%
            imType = "1"
            imSportsGb = "tennis"
            imLocateIDX = LocateIDX_3

            LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
            'response.Write "LSQL="&LSQL&"<br>"
            'response.End

            Set LRs = DBCon6.Execute(LSQL)
            If Not (LRs.Eof Or LRs.Bof) Then
          %>
            <div class="major_banner">
              <div class="banner banner_<%=LRs("LocateGb")%> carousel">
                <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
                <!-- #include file="../include/banner_Include.asp" -->
                </div>
              </div>
            </div>
            <%
              End If
              LRs.close
            %>

          <!-- E: main banner 03 -->

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

			<a href="javascript:btnLink('summary');" class="btn btn-normal btn-live-score" id="btnGameSum" >대회요강</a>
			<a href="javascript:btnLink('Live');" class="btn btn-normal btn-live-score" id="btnLive" >Live Score</a>
              <a href="javascript:btnLink('TryRequest');" class="btn" id="btnTryRequest"  >참가신청</a>

              <a href="javascript:btnLink('TotalTourney');" class="btn" id="btnTotalTourney"  >대진표 보기</a>
              <!--<a href="javascript:btnLink('TryRound');" class="btn" id="btnTryRound"  >예선</a>
              <a href="javascript:btnLink('TournRound');" class="btn" id="btnTournRound"  >본선</a>-->
              <a href="javascript:stadium_sketch();" class="btn" id="StadiumSketch" >현장스케치</a>
            </div>
          </div>
          <!-- E: pop -->
        </div>
        <!-- E: modal-body -->
      </div>
    </div>
  </div>
  <!-- E: sche-list modal -->

  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
  <script>
    // 대회정보 모달 안 슬라이더
    var sche_list_fg = true;
    $('#sche-list').on('shown.bs.modal', function (event) {
      if(sche_list_fg){
        sche_list_fg = false;
        var $bxSlider = $('#sche-list').find('.bxslider');
        $bxSlider.each(function(index,element){
          var slider = $(element).bxSlider({
            pager: false,
            auto: true,
            pause: 3000,
            width: "auto",
            control:true,
            onSlideAfter: function() {
                slider.stopAuto();
                slider.startAuto();
            }
          });
        });
      }
    });
  </script>

</div>
</body>
</html>
<% AD_DBClose() %>
<!-- #include file="../Library/sub_config.asp" -->