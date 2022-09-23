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
<div class="m_tabs" :class="{
   'm_tabs--box': sel_info !== null
}">
   <h2 class="ir">명단 타입 탭</h2>
   <a href="/pages/judo/game/info/attend_list/type/index.asp" class="m_tabs__tab">종목별</a>
   <a href="/pages/judo/game/info/attend_list/group/index.asp" class="m_tabs__tab m_tabs__tab--active">단체별</a>
</div>
<div v-if="sel_info === null" class="m_search m_search--box">
   <h2 class="ir">단체별 참가자 명단 검색</h2>
   <!-- <h2 class="ir">대회 네비게이션</h2> -->
   <div class="m_space">
      <div class="m_select-box m_space__flex-1">
         <select>
            <option value="">지역선택</option>
         </select>
      </div>
      <div class="m_search-box m_space__flex-2">
         <input class="m_search-box__input" type="search">
         <button class="m_search-box__btn" type="button">
            <img src="" alt="검색">
         </button>
      </div>
   </div>
</div>
<div v-if="sel_info === null" class="m_card">
   <div class="m_card__header">
      <h2>출전</h2>
   </div>
   <ul>
      <a href="#a">
         <li class="m_card__list">
            <h3 class="m_card__list__title">서울보라매초등학교</h3>
            <span class="m_card__list__text"><strong class="m_card__list__text__cnt">23</strong> 팀</span>
         </li>
      </a>
      <a href="#a">
         <li class="m_card__list">
            <h3 class="m_card__list__title">서울보라매초등학교</h3>
            <span class="m_card__list__text"><strong class="m_card__list__text__cnt">23</strong> 팀</span>
         </li>
      </a>
      <a href="#a">
         <li class="m_card__list">
            <h3 class="m_card__list__title">서울보라매초등학교</h3>
            <span class="m_card__list__text"><strong class="m_card__list__text__cnt">23</strong> 팀</span>
         </li>
      </a>
      <a href="#a">
         <li class="m_card__list">
            <h3 class="m_card__list__title">서울보라매초등학교</h3>
            <span class="m_card__list__text"><strong class="m_card__list__text__cnt">23</strong> 팀</span>
         </li>
      </a>
   </ul>
</div>
<div v-else class="m_card">
   <div class="m_card__header">
      <button class="m_card__header__btn" type="button">
         <img src="" alt="리스트로 이동">
      </button>
      <h2 class="m_card__header__title">서울보라매초등학교</h2>
      <span class="m_card__header__text">23 명</span>
   </div>
   <div class="m_tbl">
      <table class="m_tbl__table">
         <thead>
            <tr class="m_tbl__table__thead-tr">
               <th class="m_tbl__table__thead-th">번호</th>
               <th class="m_tbl__table__thead-th">선수</th>
               <th class="m_tbl__table__thead-th"></th>
            </tr>
         </thead>
         <tbody>
            <tr class="m_tbl__table__tbody-tr">
               <td class="m_tbl__table__tbody-td">1</td>
               <td class="m_tbl__table__tbody-td m_tbl__table__tbody-td--name">길수민</td>
               <td class="m_tbl__table__tbody-td">
                  <button type="button">
                     <img src="" alt="새창으로 이동">
                  </button>
               </td>
            </tr>
            <tr class="m_tbl__table__tbody-tr m_tbl__table__tbody-tr--bg">
               <td class="m_tbl__table__tbody-td">2</td>
               <td class="m_tbl__table__tbody-td m_tbl__table__tbody-td--name">최예진</td>
               <td class="m_tbl__table__tbody-td">
                  <button type="button">
                     <img src="" alt="새창으로 이동">
                  </button>
               </td>
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
