<!--#include virtual="/include/asp_setting/index.asp"-->

<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/include/head.asp"-->
   <script defer src="/js/index.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
   <script>
      const g_page_props = {};
   </script>
</head>

<body>
   <!--#include virtual="/include/body_before.asp"-->
   <div class="l_wrap">
      <!-- S: 메인 영역 -->
      <main id="app" class="l_index" v-clock>
         <div class="l_index__con">
            <h1 class="l_index__title">
               <img src="/images/logo.svg" alt="Evaluation Management System">
            </h1>
            <span class="l_index__noti">구글 크롬 또는 MS Edge 브라우저로 접속해주세요.</span>
            <p class="l_index__ie">
               <span>이용에 불편을 드린 점 양해 부탁드립니다. </span>
               <span>MS사의 익스플로러 지원 중단 및 웹호완성 문제로 익스플로러는 지원되지 않습니다. </span>
               <span>구글 크롬 브라우저를 이용하여 접속해주시기 바랍니다. </span>
            </p>
            <img src="/images/logo_SD.svg" alt="스포츠다이어리">
         </div>
         <!-- S: 모달창 영역 -->
         <!-- <section class="l_modal">
               <div class="l_modal__con">

               </div>
            </section> -->
         <!-- E: 모달창 영역 -->
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 공통 모달창 영역 -->
      <!--#include virtual="/include/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/include/body_after.asp"-->
</body>

</html>
