<!-- http://sdmain.sportsdiary.co.kr/app/pages/judo/player/record/profile.asp : 실제 페이지 위치 -->
<div id="vue_app" class="l_main__app">
   <section class="main">
      <!-- <header class="main__header">
         <h1>선수전적</h1>
      </header> -->
      <div ref="dragDown" class="main__search t_drag-down">
         <div class="main__search__drag-down" :style="{height: dragDown_obj.height + 'px'}">
            <div class="main__search__drag-down__row">
               <div class="m_select-box t_small">
                  <label for=""></label>
                  <select>
                     <option value=""></option>
                  </select>
               </div>
               <div class="m_select-box t_flex">
                  <label for=""></label>
                  <select>
                     <option value=""></option>
                  </select>
               </div>
            </div>
            <div class="m_search-box t_btn">
               <label class="ir" for="">즐겨찾기 한 선수명 혹은 대회명 검색</label>
               <input type="search" placeholder="즐겨찾기 한 선수명 혹은 대회명 검색">
               <button type="button">조회</button>
            </div>
         </div>
         <button class="main__search__btn-more" type="button">검색창 열기</button>
      </div>
   </section>
   <!-- S: 모달창 영역 -->
   <section @click.self="closeModalProfile()" class="l_modal-layer" :class="{s_show: modal_profile.show}">
      <div class="l_modal t_bottom">

      </div>
   </section>
   <!-- E: 모달창 영역 -->
   <!-- S: 푸터 영역 -->
   <!--#include virtual="/app/include/footer.asp"-->
   <!-- E: 푸터 영역 -->
</div>
<!-- S: vue_app 스크립트 영역 -->
<script src="/app/js/pages/judo/player/record/profile.js"></script>
<!-- E: vue_app 스크립트 영역 -->
