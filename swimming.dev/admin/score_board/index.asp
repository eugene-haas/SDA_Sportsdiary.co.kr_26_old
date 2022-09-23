<!--#include virtual="/score_board/include/asp_setting/index.asp"-->
<!--#include virtual="/score_board/include/ver.asp"-->
<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/score_board/include/head.asp"-->
      <script defer src="/score_board/js/pages/index.js<%=P_INDEX_VER%>"></script>
      <script>
         const g_page_props = {
         };
      </script>
   </head>
   <body>
      <!--#include virtual="/score_board/include/body_before.asp"-->
      <div class="l_wrap">
         <!-- S: 메인 영역 -->
         <main id="app" class="l_index" v-clock>
            <h1 class="l_index__title">경기채점시스템</h1>

            <!-- S: 모달창 영역 -->
            <!-- <section class="l_modal">
               <div class="l_modal__con">

               </div>
            </section> -->
            <!-- E: 모달창 영역 -->
         </main>
         <!-- E: 메인 영역 -->
         <!-- S: 공통 모달창 영역 -->
         <!--#include virtual="/score_board/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/score_board/include/body_after.asp"-->
   </body>
</html>
