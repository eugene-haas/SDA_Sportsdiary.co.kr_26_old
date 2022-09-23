<!--#include virtual="/include/asp_setting/index.asp"-->
<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/include/head.asp"-->
   <script defer src="./index.js"></script>
   <script>
      /* ==================================================================================
         각각의 페이지 설정 옵션
      ================================================================================== */
      const g_page_option = {
         h1: '' // /include/layouts/header.asp 에서 사용
      }
   </script>
</head>

<body>
   <!--#include virtual="/include/body_before.asp"-->
   <div id="__WRAP" class="l_wrap">
      <!-- S: 헤더 영역 -->
      <!--#include virtual="/include/layouts/header.asp"-->
      <!-- E: 헤더 영역 -->
      <!-- S: gnb 영역 -->
      <nav class="l_gnb">
         <ul>
            <li class="l_gnb__ulist">
               <a href="#a" class="l_gnb__ulist__link">
                  배드민턴
               </a>
            </li>
            <li class="l_gnb__ulist">
               <a href="/pages/judo/index.asp" class="l_gnb__ulist__link">
                  유도
               </a>
            </li>
            <li class="l_gnb__ulist">
               <a href="#a" class="l_gnb__ulist__link">
                  테니스
               </a>
            </li>
            <li class="l_gnb__ulist">
               <a href="#a" class="l_gnb__ulist__link">
                  승마
               </a>
            </li>
            <li class="l_gnb__ulist">
               <a href="#a" class="l_gnb__ulist__link">
                  수영
               </a>
            </li>
         </ul>
      </nav>

      <!-- E: gnb 영역 -->
      <!-- S: 사이드메뉴 영역 -->
      <!--#include virtual="/include/layouts/aside.asp"-->
      <!-- E: 사이드메뉴 영역 -->
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div id="vue_app" class="l_main__app">
            <!-- S: 모달창 영역 -->
            <!-- <section class="l_modal-layer">
               <div class="l_modal">

               </div>
            </section> -->
            <!-- E: 모달창 영역 -->
            <!-- S: 푸터 영역 -->
            <!--#include virtual="/include/layouts/footer.asp"-->
            <!-- E: 푸터 영역 -->
         </div>
         <!-- S: vue_app 스크립트 영역 -->
         <script src="/js/pages/index.js"></script>
         <!-- E: vue_app 스크립트 영역 -->
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 공통 모달창 영역 -->
      <!--#include virtual="/include/layouts/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/include/body_after.asp"-->
</body>

</html>
