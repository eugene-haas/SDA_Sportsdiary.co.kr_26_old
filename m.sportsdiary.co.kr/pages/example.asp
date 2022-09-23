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
         h1: '' // /include/header.asp 에서 사용
      }
   </script>
</head>

<body>
   <!--#include virtual="/include/body_before.asp"-->
   <div id="__WRAP" class="l_wrap">
      <!-- S: 헤더 영역 -->
      <!--#include virtual="/include/header.asp"-->
      <!-- E: 헤더 영역 -->
      <!-- S: 사이드메뉴 영역 -->
      <!--#include virtual="/include/aside.asp"-->
      <!-- E: 사이드메뉴 영역 -->
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <!--#include file="./c.index.asp"-->
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 공통 모달창 영역 -->
      <!--#include virtual="/include/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/include/body_after.asp"-->
</body>

</html>
