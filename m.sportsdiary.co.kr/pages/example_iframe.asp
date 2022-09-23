<!--#include virtual="/app/include/settings.asp"-->
<!-- http://sdmain.sportsdiary.co.kr/app/pages/example_iframe.asp : 실제 페이지 위치 -->
<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/app/include/head.asp"-->
   <script>
      <%=initscriptstr%>
      /* ==================================================================================
         각각의 페이지 설정 옵션
      ================================================================================== */
      const g_page_option = {
         h1: '' // /app/include/header.asp 에서 사용
      }
   </script>
</head>

<body>
   <form name="ssform">
      <input type="hidden" name="p">
   </form>
   <!--#include virtual="/app/include/body_before.asp"-->
   <div id="__WRAP" class="l_wrap">
      <!-- S: 헤더 영역 -->
      <!--#include virtual="/app/include/header.asp"-->
      <!-- E: 헤더 영역 -->
      <!-- S: 사이드메뉴 영역 -->
      <!--#include virtual="/app/include/aside.asp"-->
      <!-- E: 사이드메뉴 영역 -->
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <!-- 무조건 content는 "./BODY/c.{filename}.asp"에서 가져올 것 -->
         <!--#include file="./BODY/c.example_iframe.asp"-->
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 공통 모달창 영역 -->
      <!--#include virtual="/app/include/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/app/include/body_after.asp"-->
</body>

</html>
