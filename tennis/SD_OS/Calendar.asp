<!-- #include virtual = "/pub/header.tennis.asp" -->
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennis/html.head.asp" -->
    <style>
      #calendar {max-width: 100%; margin: 0 auto;}
      .fc h2 {font-size: 20px;}
      .fc-sun {color: #FF0000;}
      .fc-sat {color: blue;}
    </style>
    <!-- custom css -->
    <script src="lib/moment.min.js"></script>
    <script src="js/fullcalendar.min.js"></script>
    <script src="js/language/ko.js"></script>
    
    <script>
      if ('addEventListener' in document) {
          document.addEventListener('DOMContentLoaded', function() {
              FastClick.attach(document.body);
          }, false);
      }
      function onLoad() {
        document.addEventListener("deviceready", onDeviceReady, false);
      }
      function onDeviceReady() {
        document.addEventListener("backbutton", onBackKey, false);
      }
      function onBackKey() {
        var userAgent = navigator.userAgent || navigator.vendor || window.opera;
        if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i) || userAgent.match(/iPod/i)) {
            // IOS DEVICE
          location.href="index.asp";
        } else if (userAgent.match(/Android/i)) {
            // ANDROID DEVICE
          location.href="index.asp";
        } else {
            // EVERY OTHER DEVICE
          location.href="index.asp";
        }
      }


     
      $(document).ready(function() {
        if (localStorage.getItem("IntroIndex") == "3"){
          $("#DP_Title_Left").html("경기운영본부 /&nbsp;");
        }
        else if(localStorage.getItem("IntroIndex") == "2"){
          $("#DP_Title_Left").html("대회별 결과 보기 /&nbsp;");
        }
        else if(localStorage.getItem("IntroIndex") == "5"){
          $("#DP_Title_Left").html("경기운영본부 /&nbsp;");
        }
        else{
          $("#DP_Title_Left").html("경기스코어 입력 /&nbsp;");
        }


        var that = this;
        if(!this.todayDate) {
            this.todayDate = new Date();
        }
        var varSportsGb = localStorage.getItem("SportsGb");
        localStorage.setItem("BackPage","");
        $('#calendar').fullCalendar({
          editable: true,
          height:678,
          lang: 'ko',
          eventLimit: true, // allow "more" link when too many events
          events: { 
			url: '/pub/ajax/reqTennis.asp?REQ=4',
            error: function() { 
              $('#script-warning').show(); 
              $('#AppBody').oLoader('hide');
            },
            complete : function() {
              // $('#AppBody').oLoader('hide'); //로딩바
            }
          },
          eventClick: function(event) {
            localStorage.setItem("GameTitleIDX",event.id);
            localStorage.setItem("GameTitleName",event.title);
            localStorage.setItem("EnterType",event.EnterType);
			//var tiebreakstartscore = event.cfg.substr(0,1); //타이브레이크 시작스코어
			//var startscore =  event.cfg.substr(1,1);  //시작점수 메뉴에서 다시 가져와서 설정해주자.
			//var deucecheck = event.cfg.substr(1,1); //0 하지 않음 1 체크
			//localStorage.setItem("CFG",JSON.stringify({"TIESC":tiebreakstartscore, "STARTSC":0, "DEUCECHK":deucecheck,"GIDX":event.id,"GTITLENM":event.title, "ETYPE":event.EnterType}));
            
            var IntroIndex = localStorage.getItem("IntroIndex");
            //메인에서 운영본부 클릭했을때
            if (IntroIndex == "3"){
              location.href = "operating-state.asp";
            }
            else if(IntroIndex == "2"){
              location.href = "RGameResultList.asp";
            }
            else if(IntroIndex == "5"){
              location.href = "stadium-state.asp";
            }
            else{
              location.href = "RGameList.asp";
            }
          }
        });
      });

      $(document).ajaxStart(function() {
        apploading("AppBody", "일정 조회 중 입니다.");
      });

      $(document).ajaxStop(function() {
        $('#AppBody').oLoader('hide');
     });
  
    </script>
</head>
<body onload="onLoad()" id="AppBody">

<!-- #include virtual = "/pub/html/tennis/html.top.asp" -->

<!-- S: main -->
<div class="main container-fluid">
	<!-- #include file = "./body/calendar.body.asp" -->
</div>
 <!-- E: main -->

<!-- #include virtual = "/pub/html/tennis/html.footer.asp" -->	
 <script src="js/main.js"></script>
</body>
</html>