<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/game_manager/include/head.asp"-->
      <script defer src="/game_manager/js/pages/index.js<%=P_INDEX_VER%>"></script>
      <script>
         const g_page_props = {
         };
      </script>
   </head>
   <body>
      <!--#include virtual="/game_manager/include/body_before.asp"-->
      <div class="l_wrap">
         <object class="l_wrap__bg-wave" type="image/svg+xml" data="/game_manager/images/bg_wave.svg">
         </object>
         <!-- S: 메인 영역 -->
         <main id="app" class="l_index" v-clock>
            <h1 class="l_index__title">경기채점시스템</h1>
            <span class="l_index__sub-title">Swimming Record System</span>
            <div class="l_index__login">
               <label class="ir" for="inputId">아이디 입력창</label>
               <input @keyup.enter="$refs.pw.focus()" v-model="inputId" id="inputId" class="l_index__login__input" type="text" placeholder="ID" autofocus>
               <label class="ir" for="inputPw">비밀번호 입력창</label>
               <input @keyup.enter="reqLogin()" v-model="inputPw" id="inputPw" ref="pw" class="l_index__login__input" type="password" placeholder="PASSWORD">
               <button @click="reqLogin()" class="l_index__login__btn-login" type="button">로그인</button>
            </div>
            <img class="l_index__logo" src="/game_manager/images/index/logo_swim.svg" alt="사단법인 대한수영연맹">
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
