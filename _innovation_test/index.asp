<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/innovation_test/include/head.asp"-->
      <script defer src="/innovation_test/js/pages/index.js<%=P_INDEX_VER%>"></script>
      <script>
         const g_page_props = {
         };
      </script>
   </head>
   <body>
      <!--#include virtual="/innovation_test/include/body_before.asp"-->
      <div class="l_wrap">
         <!-- S: 메인 영역 -->
         <main id="app" class="l_index" v-clock>
            <div class="l_index__con">
               <div class="l_index__con__sel-type">
                  <span class="l_index__con__sel-type__text">- 선택</span>
                  <div class="l_index__con__sel-type__radio">
                     <input id="type01" v-model="sel_type" :value="1" type="radio">
                     <label class="t_box" for="type01"></label>
                     <label for="type01">실무위원회</label>
                  </div>
                  <div class="l_index__con__sel-type__radio">
                     <input id="type02" v-model="sel_type" :value="2" type="radio">
                     <label class="t_box" for="type02"></label>
                     <label for="type02">평가위원회</label>
                  </div>
                  <div class="l_index__con__sel-type__radio">
                     <input id="type03" v-model="sel_type" :value="3" type="radio">
                     <label class="t_box" for="type03"></label>
                     <label for="type03">종목단체</label>
                  </div>
               </div>
               <div class="l_index__con__login">
                  <h1 class="l_index__con__login__title">체육단체 혁신평가</h1>
                  <div class="l_index__con__login__input">
                     <label class="l_index__con__login__input__label" for="inputId">ID</label>
                     <input id="inputId" v-model="inputId" class="l_index__con__login__input__body" type="text" placeholder="아이디를 입력하세요.">
                  </div>
                  <div class="l_index__con__login__input">
                     <label class="l_index__con__login__input__label" for="inputPw">PASS</label>
                     <input id="inputPw" v-model="inputPw" class="l_index__con__login__input__body" type="text" placeholder="패스워드를 입력하세요.">
                  </div>
                  <button @click="window.location = '/innovation_test/pages/score.asp'" class="l_index__con__login__btn-login" type="button">로그인</button>
               </div>
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
         <!--#include virtual="/innovation_test/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/innovation_test/include/body_after.asp"-->
   </body>
</html>
