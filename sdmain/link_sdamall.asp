<!-- #include file='./include/head.asp' -->
<!-- #include file="./include/config.asp"-->
<!DOCTYPE html>
<html lang="ko">
<head>
<%
' response.Redirect  "start.asp"
%>


<script>



$(document).ready(function () {


  setTimeout(function () {
    $("#goMall").trigger("touch");
    // $("#goMall").trigger("touchstart");
    // $("#goMall").trigger("touchend");
    // $("#goMall").trigger("tab");
    // $("#goMall").trigger("touchevent");
  }, 1000);
  // alert('sportsdiary://urlblank=http://www.naver.com');
  // alert('sportsdiary://urlblank=http://www.naver.com');
})

// setTimeout(function() { $("#goMall").click(); }, 3000)
// window.open("http://www.sdamall.co.kr/");

// location.href="http://www.sdamall.co.kr/";
</script>
</head>
<body>
  <!-- <div>
    <a href="javascript:;" onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/tube.asp');" class="link_medium" id="goMall">test</a>
  </div> -->
  <p>
  	<a href="http://www.sdamall.co.kr/" onclick="alert('sportsdiary://urlblank=http://www.sdamall.co.kr/')" class="btn-right" id="goMall" target="_blank">ios&안드 새창</a>
  </p>

  <div>
    <a href="javascript:window.location.reload();">새로고침</a>
  </div>
</body>
