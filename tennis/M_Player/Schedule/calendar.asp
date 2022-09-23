<!DOCTYPE html>
<html>

  <head>
    <link rel="stylesheet" type="text/css" href="../css/bootstrap.min.css">
    <!--<link rel="stylesheet" type="text/css" href="../css/TrainingCalendar_main.less.css" class="main-less">-->
    <link rel="stylesheet" href="../css/library/calendar.css">

    
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no">

	<script src="../xdk/init-dev.js"></script>
    <script type="application/javascript" src="../js/library/jquery-1.12.2.min.js"></script>
    <script type="application/javascript" src="../js/bootstrap.min.js"></script>
    <script type="application/javascript" src="../js/marginal-position.min.js"></script>
    <script type="text/javascript" src="../js/ko-KR.js"></script>    
    <script type="application/javascript" src="../js/TrainingCalendar_user_scripts.js"></script>
	

    <script>
      var ProSetIndex=function(id,gubun){
        var defer = $.Deferred();

        if (gubun == "Training"){
          localStorage.setItem("TrainDay",id);
          localStorage.setItem("TapIndex","1");
          localStorage.setItem("Calendar","Y");
        } else if (gubun == "Game") {
          localStorage.setItem("GameDay",id);          
          localStorage.setItem("TapIndex","3");
          localStorage.setItem("Calendar","Y");
        } else if (gubun == "ExeGame") {          
          localStorage.setItem("ExeDay",id);
          localStorage.setItem("TapIndex","2");
          localStorage.setItem("Calendar","Y");
        } else if (gubun == "Injury") {
          localStorage.setItem("InjuryDay",id);
          localStorage.setItem("Calendar","Y");
        } else {
          localStorage.setItem("Calendar","N");
        }

        defer.resolve(gubun);
        return defer.promise();
      }


      function calllink(id,gubun)
      {

        var Procalllink=$.when(ProSetIndex(id,gubun));
        Procalllink.done(function(gubun) {
          if (gubun == "Training"){
            location.href="TrainingView.html";
          } else if (gubun == "ExeGame"){
            location.href="ExeGameView.html";
          } else if (gubun == "Game"){
            location.href="GameView.html";
          } else if (gubun == "Injury"){
            location.href="InjuryView.html";
          } else {

          }
        });

      }


      function onLoad() {
        document.addEventListener("deviceready", onDeviceReady, false);
        //달력페이지 초기 로드시에 메인으로 탭 설정.   SSG 20160608
        localStorage.setItem("TapIndex","0");
      }

      function onDeviceReady() {
        document.addEventListener("backbutton", onBackKey, false);
      }

      function onBackKey() {

        if ($('.uib_w_3').hasClass('in')) {
            $('.uib_w_3').modal('hide');
        } else {

          var userAgent = navigator.userAgent || navigator.vendor || window.opera;
          if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i) || userAgent.match(/iPod/i)) {
              // IOS DEVICE
              history.go(-1);
          } else if (userAgent.match(/Android/i)) {
              // ANDROID DEVICE
              navigator.app.backHistory();
          } else {
              // EVERY OTHER DEVICE
              history.go(-1);
          }
        }
      }
 
    </script>

  </head>

  <body onload="onLoad()">

    <div class="upage" id="mainpage">
      <div class="upage-outer">
        <div class="uib-header header-bg container-group inner-element uib_w_1" data-uib="layout/header" data-ver="0">
          <h2></h2>
          <div class="widget-container wrapping-col single-centered"></div>
          <div class="widget-container content-area horiz-area wrapping-col left">
            <span style="font-weight:bold;color:#ffffff;padding:10px" class="uib_w_2">
              <!-- <img src="images/arr.png" style="margin-right:10px;width:30px"> -->SD달력</span>
          </div>
          <div class="widget-container content-area horiz-area wrapping-col right">
  
          </div>
        </div>
        <div class="upage-content ac0 content-area vertical-col left" id="page_39_69">

          <div class="page-header" style="margin-top:0px">

            <div class="pull-right form-inline">
              <div class="btn-group">
                <button class="btn btn-primary" data-calendar-nav="prev">이전달</button>
                <button class="btn btn-warning" data-calendar-nav="today">오늘</button>
                <button class="btn btn-primary" data-calendar-nav="next">다음달</button>
              </div>
              <!--
              <div class="btn-group">
                <button class="btn btn-warning" data-calendar-view="year">Year</button>
                <button class="btn btn-warning active" data-calendar-view="month">Month</button>
                <button class="btn btn-warning" data-calendar-view="week">Week</button>
                <button class="btn btn-warning" data-calendar-view="day">Day</button>
              </div>
              -->
            </div>
            <h3 id="YearMonth" style="font-size:20px;margin-left:5px"></h3>
          </div>

          <div class="row" style="margin-left:5px;margin-right:5px;margin-top:0px">
            <div class="span9">
              <div id="calendar"></div>
            </div>
            <div class="span3">
              <h4>정보</h4>
              <ul id="eventlist" class="nav nav-list" style="font-size:12px;"></ul>
            </div>
          </div>

        </div>
      </div>

    </div>
    <!--
    <script type="text/javascript" src="components/jquery/jquery.min.js"></script>
    -->
    <script type="text/javascript" src="../js/underscore-min.js"></script>
    <!--<script type="text/javascript" src="components/bootstrap2/js/bootstrap.min.js"></script>-->
    <script type="text/javascript" src="../js/jstz.min.js"></script>
    <!--
    <script type="text/javascript" src="js/language/ko-KR.js"></script>
    -->
    <script type="text/javascript" src="../js/calendar.js"></script>
    
  </body>

</html>