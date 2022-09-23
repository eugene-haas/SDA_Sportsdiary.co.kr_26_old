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
<div class="m_search">
   <h2 class="ir">경기순서/현황 검색</h2>
   <!-- <h2 class="ir">대회 네비게이션</h2> -->
   <div class="m_space">
      <div class="m_select-box m_space__flex-1">
         <select>
            <option value="">개인/단체</option>
         </select>
      </div>
      <div class="m_check-box m_space__flex-1">
         <input class="m_check-box__input" type="checkbox">
         <label class="m_check-box__box" for=""></label>
         <label for="">종료 경기 표시</label>
      </div>
   </div>
</div>
<div class="m_tabs m_tabs--box">
   <h2 class="ir">경기장 탭</h2>
   <button class="m_tabs__tab" :class="{
      'm_tabs__tab--active': true
   }" type="button">제1경기장</button>
   <button class="m_tabs__tab" type="button">제2경기장</button>
   <button class="m_tabs__tab" type="button">제3경기장</button>
   <button class="m_tabs__tab" type="button">제4경기장</button>
</div>
<!-- S: 모달창 영역 -->
<transition name="modal">
   <section v-show="false" class="l_modal-layer" :class="{
      'l_modal-layer--ready': true,
   }">
      <div class="l_modal">
         <div class="l_modal__header">
            <h1></h1>
            <button type="button"></button>
         </div>
         <div class="l_modal__con">

         </div>
      </div>
   </section>
</transition>
<!-- E: 모달창 영역 -->
