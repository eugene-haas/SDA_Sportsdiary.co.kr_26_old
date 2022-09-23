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
<div class="m_game-info">
   <h2 class="ir">대회 정보</h2>
   <ul>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">대회명</dt>
            <dd class="m_game-info__list__body">제63회 유도 협회장 전국 유도선수권대회</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">대회기간</dt>
            <dd class="m_game-info__list__body">2020-07-25 ~2020-07-31</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">장소</dt>
            <dd class="m_game-info__list__body">강원도 양구 실내체육관</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">주최</dt>
            <dd class="m_game-info__list__body">대한유도회</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">주관</dt>
            <dd class="m_game-info__list__body">강원도유도회, 양구군유도회</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">후원</dt>
            <dd class="m_game-info__list__body">로렉스, 아디다스</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">협찬</dt>
            <dd class="m_game-info__list__body">아디다스</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">참가신청</dt>
            <dd class="m_game-info__list__body">2020-05-01 ~2020-06-30</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">경기종목</dt>
            <dd class="m_game-info__list__body">중등부 / 고등부 / 대학부 / 일반부</dd>
         </dl>
      </li>
      <li class="m_game-info__list">
         <dl>
            <dt class="m_game-info__list__head">기타사항</dt>
            <dd class="m_game-info__list__body">---</dd>
         </dl>
      </li>
   </ul>
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
