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
<div class="m_tabs">
   <h2 class="ir">명단 타입 탭</h2>
   <button class="m_tabs__tab" :class="{
      'm_tabs__tab--active': true
   }" type="button">종목별</button>
   <button class="m_tabs__tab" type="button">선수별</button>
</div>
<div class="m_search m_search--box">
   <h2 class="ir">대진표 검색</h2>
   <!-- <h2 class="ir">대회 네비게이션</h2> -->
   <div class="m_space">
      <div class="m_select-box m_space__flex-2">
         <select>
            <option value="">부서 선택</option>
         </select>
      </div>
      <div class="m_select-box m_space__flex-1">
         <select>
            <option value="">체급</option>
         </select>
      </div>
   </div>
</div>
<ul class="m_list-wrap l_main__flex-1">
   <a href="/pages/judo/game/tournament/index.asp">
      <li class="m_list">
         <h3 class="m_card__list__title">남자 단체전 대학부</h3>
         <span class="m_card__list__text"><strong class="m_card__list__text__cnt">23</strong> 팀</span>
      </li>
   </a>
   <a href="#a">
      <li class="m_list">
         <h3 class="m_card__list__title">남자 단체전 대학부</h3>
         <span class="m_card__list__text"><strong class="m_card__list__text__cnt">23</strong> 팀</span>
      </li>
   </a>
   <a href="#a">
      <li class="m_list">
         <h3 class="m_card__list__title">남자 단체전 대학부</h3>
         <span class="m_card__list__text"><strong class="m_card__list__text__cnt">23</strong> 팀</span>
      </li>
   </a>

</ul>
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
