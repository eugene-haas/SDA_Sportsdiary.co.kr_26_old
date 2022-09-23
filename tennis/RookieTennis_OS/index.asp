<!-- #include virtual = "/pub/header.RookieTennis.asp" -->
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookieTennis/html.head.asp" -->
<script type="text/javascript">
      var onLoad=function(){
        document.addEventListener("deviceready", onDeviceReady, false);
		//2017-08-12 최승규 전체제거 추가
		localStorage.clear();
        localStorage.setItem("SportsGb","tennis");
      }
      
      function onDeviceReady() {
        document.addEventListener("backbutton", onBackKey, false);
      }

      function onBackKey() {
        navigator.notification.confirm('종료하시겠습니까?', onBackKeyResult, '스포츠다이어리', '예, 아니오');
      }
      
      function onBackKeyResult(index) {
        navigator.app.exitApp(); 
      }
//-->
</script>
</head>
<body onload="onLoad()" id="AppBody">
<!-- S: main -->
<div class="main">
	<!-- #include file = "./body/index.body.asp" -->
</div>
 <!-- E: main -->

<!-- #include file = "./body/pop.loginchk.asp" -->
<!-- #include file = "./body/pop.idpwdchk.asp" -->

<!-- #include virtual = "/pub/html/Rookietennis/html.footer.asp" -->	
 <script src="js/main.js"></script>
</body>
</html>