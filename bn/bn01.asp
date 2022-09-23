<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
    <meta name="apple-mobile-web-app-title" content="이엠파워" />
    <meta name="format-detection" content="telephone=no" />
    
    <meta name="mobile-web-app-capable" content="yes">
    <meta name="apple-mobile-web-app-capable" content="yes">

    <title>이엠파워</title>
    
    <script src="http://img.sportsdiary.co.kr/lib/vue/vue.min.js"></script>
    <style>
      body{margin:0;padding:0;}
      .ibarea{font-size:0;}
      .ibarea>*{display:inline-block;vertical-align:top;}
      .tab_wrap{font-size:0;}
      .tab_wrap button{width:25%;height:38px;line-height:38px;font-size:15px;color:#444;font-weight:bold;border:none;background-color:#fff;outline:none;}
      .tab_wrap button.on{color:#005895;border-bottom:2px solid #1390d4;}
      .show_wrap{}
      .tabshow{}
      .tabshow .img, .tabshow img{width:100%;font-size:0;}
      .tabshow a{display:block;font-size:0;}
      .tabshow .ibarea a{display:inline-block;}
      .ibarea.df{display:flex;}
    </style>
  </head>
  <body>
    <div id="empower">
      <div class="tab_wrap ibarea">
        <button v-bind:class="{on:tabno==1}" @click="tabno=1">업체소개</button>
        <button v-bind:class="{on:tabno==2}" @click="tabno=2">서울삼성점</button>
        <button v-bind:class="{on:tabno==3}" @click="tabno=3">서울서교점</button>
        <button v-bind:class="{on:tabno==4}" @click="tabno=4">인천삼산점</button>
      </div>
      <div class="show_wrap">
        <div class="tabshow" v-if="tabno==1">
          <div class="img"><img src="img/tab11.jpg" alt=""></div>
          <div class="img"><img src="img/tab12.jpg" alt=""></div>
          <div class="img"><img src="img/tab13.jpg" alt=""></div>
          <div class="img"><img src="img/tab14.jpg" alt=""></div>
          <a href="http://jins-empower.co.kr/default/" target="_blank" class="img"><img src="img/tab15b.jpg" alt=""></a>
          <div class="img"><img src="img/tab16.jpg" alt=""></div>
        </div>
        <div class="tabshow" v-if="tabno==2">
          <div class="img"><img src="img/tab21.jpg" alt=""></div>
          <div class="img"><img src="img/tab22.jpg" alt=""></div>
          <div class="ibarea df">
            <a href="tel:02-554-2960"><img src="img/tab23b.jpg" alt=""></a>
            <a href="http://jins-empower.co.kr/default/" target="_blank"><img src="img/tab24b.jpg" alt=""></a>
          </div>
          <div class="img"><img src="img/tab25.jpg" alt=""></div>
          <div class="img"><img src="img/tab26.jpg" alt=""></div>
        </div>
        <div class="tabshow" v-if="tabno==3">
          <div class="img"><img src="img/tab31.jpg" alt=""></div>
          <div class="img"><img src="img/tab32.jpg" alt=""></div>
          <div class="ibarea df">
            <a href="tel:02-322-2855"><img src="img/tab33b.jpg" alt=""></a>
            <a href="http://jins-empower.co.kr/default/" target="_blank"><img src="img/tab34b.jpg" alt=""></a>
          </div>
          <div class="img"><img src="img/tab35.jpg" alt=""></div>
          <div class="img"><img src="img/tab36.jpg" alt=""></div>
        </div>
        <div class="tabshow" v-if="tabno==4">
          <div class="img"><img src="img/tab41.jpg" alt=""></div>
          <div class="img"><img src="img/tab42.jpg" alt=""></div>
          <div class="ibarea df">
            <a href="tel:032-505-2855"><img src="img/tab43b.jpg" alt=""></a>
            <a href="http://jins-empower.co.kr/default/" target="_blank"><img src="img/tab44b.jpg" alt=""></a>
          </div>
          <div class="img"><img src="img/tab45.jpg" alt=""></div>
          <div class="img"><img src="img/tab46.jpg" alt=""></div>
        </div>
      </div>
    </div>

    <script>
      var emp=new Vue({
        el:"#empower",
        data:{
          tabno:1,
        }
      });
    </script>
  </body>
</html>
