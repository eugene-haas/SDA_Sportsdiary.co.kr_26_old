<!--#include virtual="/include/asp_setting/index.asp"-->
<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/include/head.asp"-->
   <!--#include virtual="/include/head_sports/judo.asp"-->
   <script defer src="./index.js<%=JUDO_GAME_LIST_VER%>"></script>
   <script>
      /* ==================================================================================
         각각의 페이지 설정 옵션
      ================================================================================== */
      const g_page_option = {
         h1: '제63회 유도협회 장기 전국 유도선수권대회', // /include/header.asp 에서 사용
         isInfo: true,
         backPath: '/pages/judo/game/index.asp',
      }
   </script>
</head>

<body>
   <!--#include virtual="/include/body_before.asp"-->
   <div id="__WRAP" class="l_wrap">
      <!-- S: 헤더 영역 -->
      <!--#include virtual="/include/layouts/header.asp"-->
      <!-- E: 헤더 영역 -->
      <!-- S: 메인 영역 -->
      <main id="vue_app" class="l_main" v-clock>
         <!--#include file="./c.index.asp"-->
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 푸터 영역 -->
      <!--#include virtual="/include/layouts/footer.asp"-->
      <!-- E: 푸터 영역 -->
      <!-- S: 공통 모달창 영역 -->
      <!--#include virtual="/include/layouts/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/include/body_after.asp"-->
</body>

</html>
