<!DOCTYPE html>
<html lang="ko">

<head>
   <!-- #include file='../include/head.asp' -->
   <link rel="stylesheet" href="../css/fonts.css">
   <link rel="stylesheet" href="../css/index_test.css?ver=0.1.4">
   <style media="screen">
      html, body{height:100%;}
   </style>
</head>

<body>
   <div class="l_preview">
      <button onclick="history.back()" class="l_preview__btn-close" type="button">
         <img src="http://img.sportsdiary.co.kr/images/SD/preview/btn-close.png" alt="">
      </button>
      <img src="http://img.sportsdiary.co.kr/images/SD/preview/wrestling.png" alt="">
   </div>
   <script>
   function setScreenWidth(){
      let el_l_wrap = document.querySelector('body');
      const minWidth = el_l_wrap.clientWidth;

      if (window.outerWidth < minWidth) {
         if (el_l_wrap) {
            el_l_wrap.style.transform = "scale("+(window.outerWidth / minWidth)+")";
            el_l_wrap.style.height = (window.outerHeight * (minWidth / window.outerWidth)) +'px';
            el_l_wrap.style.overflow = "hidden";
         }
      } else {
         if (el_l_wrap) {
            el_l_wrap.style.transform = null;
            el_l_wrap.style.height = null;
            el_l_wrap.style.overflow = null;
         }
      }
   }
   setScreenWidth();
   $(window).bind("orientationchange", function(e) {
      location.reload();
   });
   </script>
</body>

</html>
