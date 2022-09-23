
  <title>테스트사이트</title>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=3" />
  <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1" />
  <meta name="apple-mobile-web-app-title" content="스포츠다이어리" />
  <meta name="format-detection" content="telephone=no" />
  <meta http-equiv="Cache-Control" content="No-Cache" />
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="pragma" content="no-store" />
  <meta http-equiv="Expires" content="-1" />


<%'  <link rel="stylesheet" href="http://swimming.sportsdiary.co.kr/pub/bootstrap-4.3.1-dist/css/bootstrap.min.css">%>
  <!-- Font Awesome -->
<%'  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">%>
  <!-- Ionicons -->
<%'  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">%>
  <!-- Theme style -->
<%'  <link rel="stylesheet" href="http://swimming.sportsdiary.co.kr/dist/css/AdminLTE.min.css">%>

    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/default.css">
    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/Player_info.css?ver=0.1.1">

  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/NanumGothic.css">
  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/NotoKR.css">
  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/fontawesome-all.css">
  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/font-awesome.min.css">

  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/jquery/jquery.webui-popover.min.css">
  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/bxslider/jquery.bxslider.min.css">

  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/initialize.css?ver=0.2" />
  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/css/mgpd.css?ver=0.2" />

  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/SD/sd-common-module.css?0.1" />
  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/SD/sd-common.css?0.4" />


  <link href="/css/jquery-ui.min.css" rel="stylesheet" type="text/css" />

  <link href="http://img.sportsdiary.co.kr/lib/fullcalendar/fullcalendar.min.css" rel="stylesheet" />
  <link href="http://img.sportsdiary.co.kr/lib/fullcalendar/fullcalendar.print.css" rel="stylesheet" media="print" />
  <link rel="stylesheet" href="/css/sw_style.min.css?ver=0.0.7">


  <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css">
  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>

  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>

  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/jquery/jquery-migrate-1.4.1.min.js"></script>
  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/jquery/jquery.easing.1.3.min.js"></script>
  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/jquery/jquery.webui-popover.min.js"></script>
  <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/bxslider/jquery.bxslider.min.js"></script>

  <script type="text/javascript" src="http://img.sportsdiary.co.kr/SD/sd-common-module.js"></script>
  <script type="text/javascript" src="http://img.sportsdiary.co.kr/SD/sd-common.js"></script>

  <script src="/js/sw.js?ver=0.0.1"></script>
  <script src="http://swimming.sportsdiary.co.kr/pub/js/swimming/utill.js?v=190820"></script>


  <script src="http://img.sportsdiary.co.kr/lib/moment/moment.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/fullcalendar/fullcalendar.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/locale/locale-all.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/vue.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/vue-cookies.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/axios.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/vue/lodash.min.js"></script>






<script src="/js/jquery-ui.min.js"></script>

<%'  <script src="http://swimming.sportsdiary.co.kr/pub/bootstrap-4.3.1-dist/js/bootstrap.min.js"></script>%><!-- Bootstrap 3.3.6 -->


  <!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=UA-137374003-3"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', 'UA-137374003-3');
</script>

<script type="text/javascript">
<!--
//클릭위치로 돌려놓기
$(document).ready(function(){


	$('html, body').animate({scrollTop : localStorage.getItem('scrollpostion')}, 400);
	$(document).click(function(event){
		window.toriScroll = $(document).scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		console.log(window.toriScroll);
	});


//	$("#sc_body").scrollTop(localStorage.getItem('scrollpostion'));
//	$("#sc_body").click(function(event){
//		window.toriScroll = $("#sc_body").scrollTop();
//		localStorage.setItem('scrollpostion',window.toriScroll);
//		//console.log(window.toriScroll);
//	});
});
//-->
</script>
