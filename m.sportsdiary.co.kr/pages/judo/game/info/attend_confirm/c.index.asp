<nav class="m_slide-tabs">
   <h2 class="ir">대회 네비게이션</h2>
   <ul class="m_slide-tabs__con">
      <a v-for="tab in gameTab_list" :href="tab.path" :class="{'m_slide-tabs__con__tab--active': tab.idx === sel_gameTab}" class="m_slide-tabs__con__tab">
         <li>
            <h3>{{tab.name}}</h3>
         </li>
      </a>
   </ul>
</nav>
<div class="m_search l_main__flex-1">
   <h2 class="ir">이름 검색</h2>
   <!-- <h2 class="ir">대회 네비게이션</h2> -->
   <div class="m_space">
      <div class="m_search-box m_space__flex-1">
         <input class="m_search-box__input" type="search">
         <button class="m_search-box__btn" type="button">
            <img src="" alt="검색">
         </button>
      </div>
   </div>
   <div class="m_search__result">
      <div class="m_search__result__header">
         <h3>참가신청정보</h3>
      </div>
      <table class="m_search__result__tbl">
         <tbody>
            <tr class="m_search__result__tbl__row">
               <td>김권영(여)</td>
               <td>세경대학교</td>
            </tr>
         </tbody>
      </table>
   </div>
</div>
<!-- S: 모달창 영역 -->
<transition name="modal">
   <section v-show="false" class="l_modal-layer" :class="{
      'l_modal-layer--ready': true,
   }">
      <div class="l_modal l_modal--radius">
         <div class="l_modal__header">
            <h1 class="l_modal__header__title">참가정보</h1>
            <button type="button">
               <img src="" alt="닫기">
            </button>
         </div>
         <div class="l_modal__con">
            <div class="l_modal__con__info">
               <span>김권영(여)</span>
               <span>세경대학교</span>
            </div>
            <h3 class="l_modal__con__title">참가내역</h3>
            <div class="m_">
               <table>
                  <thead>
                     <tr>
                        <th>부서 및 구분</th>
                     </tr>
                  </thead>
                  <tbody>
                     <tr>
                        <td>여자대학부 - 개인전(-53Kg)</td>
                     </tr>
                     <tr>
                        <td>여자대학부 - 개인전(-53Kg)</td>
                     </tr>
                  </tbody>
               </table>
            </div>
         </div>
      </div>
   </section>
</transition>
<!-- E: 모달창 영역 -->
