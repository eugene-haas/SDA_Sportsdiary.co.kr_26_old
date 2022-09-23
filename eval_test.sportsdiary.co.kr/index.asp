<!--#include virtual="/include/asp_setting/index.asp"-->

<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/include/head.asp"-->
   <script defer src="/js/index.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
   <script>
      const g_page_props = {};
   </script>
   <script>
      const agent = navigator.userAgent.toLowerCase();
      if ( (navigator.appName == 'Netscape' && agent.indexOf('trident') != -1) || (agent.indexOf("msie") != -1)) {
         window.location = '/ie.asp';
      } else {
         // ie가 아닐 경우
      }
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
            <div class="l_index__input-box">
               <label class="l_index__label" for="inputId">ID</label>
               <input ref="id" id="inputId" @keyup.enter="$refs.pw.focus()" v-model="inputId" class="l_index__input" type="text" placeholder="아이디를 입력하세요." />
            </div>
            <div class="l_index__input-box">
               <label class="l_index__label" for="inputPw">PASS</label>
               <input ref="pw" id="inputPw" @keyup.enter="reqLogin()" v-model="inputPw" class="l_index__input" type="password" placeholder="패스워드를 입력하세요." />
            </div>
            <button @click="reqLogin()" class="l_index__btn-login" type="button">
               로그인
            </button>
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
