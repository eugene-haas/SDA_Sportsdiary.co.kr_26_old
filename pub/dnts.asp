<!doctype html>

<html lang="ko">

<head>

<title>[앱연결]</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="format-detection" content="telephone=no" />
<script type="text/javascript" src="http://code.jquery.com/jquery-latest.min.js"></script>
<script type="text/javascript">

$(document).ready(function(){

var openAt = new Date,
    uagentLow = navigator.userAgent.toLocaleLowerCase(),
    chrome25,
    kitkatWebview;


$("body").append("<iframe id='iframeField'></iframe>");

$("#iframeField").hide();
 

//setTimeout( function() {
//	if (new Date - openAt < 4000) {
//		if (uagentLow.search("android") > -1) {
//			$("#iframeField").attr("src","market://details?id=com.sportsdiary.player.sportsdiaryplayer");
//		} 
//		else if (uagentLow.search("iphone") > -1) {
//			location.replace("https://itunes.apple.com/kr/app/%EC%8A%A4%ED%8F%AC%EC%B8%A0%EB%8B%A4%EC%9D%B4%EC%96%B4%EB%A6%AC/id1218138494?mt=8");
//		}
//	}
//}, 1000);


if(uagentLow.search("android") > -1){
	chrome25 = uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25;
	//kitkatWebview = uagentLow.indexOf("naver") != -1  uagentLow.indexOf("daum") != -1;

	//if (chrome25 && !kitkatWebview){
	if (chrome25 ){
alert(1);
		document.location.href = "intent://#Intent;scheme;package=com.sportsdiary.player.sportsdiaryplayer;S.browser_fallback_url=https://play.google.com/store/apps/details?id=com.sportsdiary.player.sportsdiaryplayer;end";

//		document.location.href = "intent://www.sdmembers.co.kr/mobile/#Intent;scheme=http;package=com.sportsdiary.player.sportsdiaryplayer;S.browser_fallback_url=https://play.google.com/store/apps/details?id=com.sportsdiary.player.sportsdiaryplayer;end";
//		document.location.href = "intent://com.sportsdiary.player.sportsdiaryplayer#Intent;scheme=app;package=com.sportsdiary.player.sportsdiaryplayer;end";
		//location.href = "intent://www.sdmembers.co.kr/mobile/#Intent;scheme=http;package=com.android.chrome;end";	
	
	} else{
		$(body).append(chrome25);
		$("#iframeField").attr("src", 'sportsdiaryplayer://applink?param=value');
	}
}

else if(uagentLow.search("iphone") > -1){
	//$("#iframeField").attr("src", 'nhn://applink?param=value');
}

})

</script>

</head>
<body>

</body>
</html>


<%Response.end%>













<!DOCTYPE html>
<html>
<head>
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="apple-mobile-web-app-title" content="스포츠다이어리" />
  <meta name="format-detection" content="telephone=no" />


    <title>Using iframe - Launch App with page loading</title>
  <script src="/bike/M_player/js/library/jquery-3.1.1.min.js"></script>

<script type="text/javascript">
<!--

//$(function() {
//  updateAndroidMarketLinks();
//  // some more core here ... 
//
//		function updateAndroidMarketLinks(){
//		
//			if( /Android/i.test(navigator.userAgent)) {
//				location.href= "market://details?id=com.sportsdiary.player.sportsdiaryplayer";
//			} else if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
//				location.href = "https://itunes.apple.com/kr/app/%EC%8A%A4%ED%8F%AC%EC%B8%A0%EB%8B%A4%EC%9D%B4%EC%96%B4%EB%A6%AC/id1218138494?mt=8";
//			}	
//
//
//
//				//		var ua = navigator.userAgent.toLowerCase();
//				//		if (0 <= ua.indexOf("android")) {
//				//		  // we have android
//				//		  $("a[href^='http://market.android.com/']").each(function() {
//				//			this.href = this.href.replace(/^http:\/\/market\.android\.com\//,
//				//			  "market://");
//				//		  });
//		}
//
//
//});



function dn(){
	if( /Android/i.test(navigator.userAgent)) {
		//location.href= "market://details?id=com.sportsdiary.player.sportsdiaryplayer";
				location.href="intent://applink?param=value#Intent;scheme=soribada30;package=com.sportsdiary.player.sportsdiaryplayer;end";
	} else if (/iPhone|iPad|iPod/i.test(navigator.userAgent)) {
		location.href = "https://itunes.apple.com/kr/app/%EC%8A%A4%ED%8F%AC%EC%B8%A0%EB%8B%A4%EC%9D%B4%EC%96%B4%EB%A6%AC/id1218138494?mt=8";
	}	
}

-->


//if(uagentLow.search("chrome") > -1 && navigator.appVersion.match(/Chrome\/\d+.\d+/)[0].split("/")[1] > 25){
//    document.location.href = "intent://applink?param=value#Intent;scheme=soribada30;package=com.soribada.android;end";
//}else{
//    $("#____sorilink____").attr("src", 'soribada30://applink?param=value');
//}



var userAgent = navigator.userAgent;

//alert(/Android/i.test(navigator.userAgent));

//if (userAgent.match(/android/)) {
if(/Android/i.test(navigator.userAgent)){

	//if (userAgent.match(/Chrome/)) {
	if (/Chrome/i.test(navigator.userAgent)) {
         // 안드로이드의 크롬에서는 intent만 동작하기 때문에 intent로 호출해야함
         setTimeout(function() {
			  //location.href = "intent://커스텀스킴주소#Intent; scheme=스킴; action=..;category=..; package=com.sportsdiary.player.sportsdiaryplayer; end;";
			  location.href="intent://applink?param=value#Intent;scheme=soribada30;package=com.sportsdiary.player.sportsdiaryplayer;end";
         }, 1000);

    } else {
        // 크롬 이외의 브라우저들
        setTimeout(
           function() {
              if ((new Date()).getTime() - visitedAt < 2000) {
                 location.href = "{마켓 주소}";
              }
          }, 500);
          var iframe = document.createElement('iframe');
          iframe.style.visibility = 'hidden';
          iframe.src = '{커스텀 스킴 주소}';
          document.body.appendChild(iframe);
          document.body.removeChild(iframe); // back 호출시 캐싱될 수 있으므로 제거
     }
}



</script>
</head>
<body>



<br><br><br>
&nbsp;&nbsp;&nbsp;<a href="javascript:dn()" style="font-size:20px;">--palysotore--</a>
 <a href="javascript:dn()" target="_blank" style="display:none"  id="hiddenbtn">go</a> <!-- <input type="hidden" onclick="dn()" id="hiddenbtn"> -->




<script type="text/javascript">
<!--
	//$("#hiddenbtn").click();
	//setTimeout("dn()", 1000);
//-->
</script>
</body>
</html>