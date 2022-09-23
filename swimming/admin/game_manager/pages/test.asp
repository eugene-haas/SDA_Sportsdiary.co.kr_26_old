<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/game_manager/include/head.asp"-->
      <script defer src="/game_manager/js/pages/test.js<%=P_LIST_VER%>"></script>
      <script>
         const g_page_props = {
            hideBack: true
         };
      </script>
   </head>
   <body>
      <!--#include virtual="/game_manager/include/body_before.asp"-->
      <div class="l_wrap">
         <object class="l_wrap__bg-wave" type="image/svg+xml" data="/game_manager/images/bg_wave.svg">
         </object>
         <!-- s: 헤더 영역 -->
         <!--#include virtual="/game_manager/include/header.asp"-->
         <!-- E: 헤더 영역 -->
         <!-- S: 메인 영역 -->
         <main id="app" class="l_main" v-clock>
            <ol ref="body">
            </ol>
            <!-- S: 모달창 영역 -->
            <!-- <section class="l_modal">
               <div class="l_modal__con">

               </div>
            </section> -->
            <!-- E: 모달창 영역 -->

         </main>
         <!-- E: 메인 영역 -->
         <!-- S: 공통 모달창 영역 -->
         <!--#include virtual="/game_manager/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/game_manager/include/body_after.asp"-->
   </body>
</html>
