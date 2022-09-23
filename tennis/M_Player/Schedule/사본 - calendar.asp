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
            <img  src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMEAAAA8CAMAAADokC5pAAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2ZpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDoyNDFGNjg0RThEMzJFNjExOUQ4QUI2MUI1MjM2RTYxOSIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDo4NzY0RDQ3MjMyQkUxMUU2QjUzRUFDRDIwMkRFMkUyMSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDo4NzY0RDQ3MTMyQkUxMUU2QjUzRUFDRDIwMkRFMkUyMSIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChXaW5kb3dzKSI+IDx4bXBNTTpEZXJpdmVkRnJvbSBzdFJlZjppbnN0YW5jZUlEPSJ4bXAuaWlkOjI1MUY2ODRFOEQzMkU2MTE5RDhBQjYxQjUyMzZFNjE5IiBzdFJlZjpkb2N1bWVudElEPSJ4bXAuZGlkOjI0MUY2ODRFOEQzMkU2MTE5RDhBQjYxQjUyMzZFNjE5Ii8+IDwvcmRmOkRlc2NyaXB0aW9uPiA8L3JkZjpSREY+IDwveDp4bXBtZXRhPiA8P3hwYWNrZXQgZW5kPSJyIj8++7/+9QAAAvpQTFRF////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////FTeg+AAAAP10Uk5TAAECAwQFBgcICQoLDA0ODxAREhMUFRYXGBkaGxwdHh8gISIjJCUmJygpKissLS4vMDEyMzQ1Njc4OTo7PD0+P0BB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" style="height:38px;margin-right:10px"/>
            
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