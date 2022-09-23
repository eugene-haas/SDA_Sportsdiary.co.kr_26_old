<div class="m_search m_search--box">
   <div class="m_space">
      <div class="m_check-box">
         <input type="checkbox">
         <label class="m_check-box__box" for=""></label>
         <label for="">엘리트</label>
      </div>
      <div class="m_check-box">
         <input type="checkbox">
         <label class="m_check-box__box" for=""></label>
         <label for="">생활체육</label>
      </div>
      <button class="m_space__right" type="button">
         <img src="" alt="검색으로 대회 찾기">
      </button>
      <button type="button">
         <img src="" alt="리스트로 보기">
      </button>
      <button type="button">
         <img src="" alt="캘린더로 보기">
      </button>
   </div>
   <!-- <div v-if="!show_cal" class="m_search__row">
      <div class="m_search-box t_size-f">
         <label class="ir" for="">대회명 검색</label>
         <input type="search" placeholder="대회명으로 검색하세요.">
         <button type="button">검색</button>
      </div>
   </div>
   <div v-if="!show_cal" class="m_search__row">
      <div class="m_select-box t_size-f">
         <label class="ir" for="">년도 선택</label>
         <select>
            <option value=""></option>
         </select>
      </div>
      <div class="m_select-box t_size-f2">
         <label class="ir" for="">주최 기관 선택</label>
         <select>
            <option value=""></option>
         </select>
      </div>
   </div>
   <div class="m_search__row">
      <div class="m_check-box">
         <label for="">엘리트</label>
         <input type="checkbox">
         <label for=""></label>
      </div>
      <div class="m_check-box">
         <label for="">생활체육</label>
         <input type="checkbox">
         <label for=""></label>
      </div>
      <div class="m_search__row__right">
         <button class="m_search__row__right__btn" type="button">
            <img src="" alt="리스트로 보기">
         </button>
         <button class="m_search__row__right__btn" type="button">
            <img src="" alt="달력으로 보기">
         </button>
      </div>
   </div> -->
</div>
<div class="m_search">
   <div v-show="!show_cal" class="m_space">
      <div class="m_search-box m_space__flex-1">
         <input class="m_search-box__input" type="search">
         <button class="m_search-box__btn" type="button">
            <img src="" alt="검색">
         </button>
      </div>
   </div>
   <div v-show="!show_cal" class="m_space">
      <div class="m_select-box m_space__flex-1">
         <select>
            <option value="">2021</option>
         </select>
      </div>
      <div class="m_select-box m_space__flex-2">
         <select>
            <option value="">추최 협회 전체</option>
         </select>
      </div>
   </div>
</div>
<template v-if="!show_cal">
   <div class="m_tab-list" :style="{borderColor: getSelTab.color}">
      <button v-for="tab in tab_list" class="m_tab-list__tab" :class="{
         'm_tab-list__tab--active': sel_tab === tab.idx,
      }" :style="{background: sel_tab === tab.idx?tab.color:''}" type="button">
         {{tab.name}}
      </button>
   </div>
   <div class="m_game-list">
      <h2 class="ir">대회 목록</h2>
      <ol>
         <a href="/pages/judo/game/info/index.asp">
            <li class="m_game-list__list">
               <div class="m_game-list__list__header">
                  <strong class="m_game-list__list__header__state">진행중</strong>
                  <span class="m_game-list__list__header__date">6월 17일 ~ 6월 23일</span>
               </div>
               <span class="m_game-list__list__type">생활체육</span>
               <h3 class="m_game-list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
               <span class="m_game-list__list__place">천안시 유관순체육관</span>
            </li>
         </a>
         <a href="#a">
            <li class="m_game-list__list">
               <div class="m_game-list__list__header">
                  <strong class="m_game-list__list__header__state">진행중</strong>
                  <span class="m_game-list__list__header__date">6월 17일 ~ 6월 23일</span>
               </div>
               <span class="m_game-list__list__type">생활체육</span>
               <h3 class="m_game-list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
               <span class="m_game-list__list__place">천안시 유관순체육관</span>
            </li>
         </a>
         <a href="#a">
            <li class="m_game-list__list">
               <div class="m_game-list__list__header">
                  <strong class="m_game-list__list__header__state">진행중</strong>
                  <span class="m_game-list__list__header__date">6월 17일 ~ 6월 23일</span>
               </div>
               <span class="m_game-list__list__type">생활체육</span>
               <h3 class="m_game-list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
               <span class="m_game-list__list__place">천안시 유관순체육관</span>
            </li>
         </a>
         <a href="#a">
            <li class="m_game-list__list">
               <div class="m_game-list__list__header">
                  <strong class="m_game-list__list__header__state">진행중</strong>
                  <span class="m_game-list__list__header__date">6월 17일 ~ 6월 23일</span>
               </div>
               <span class="m_game-list__list__type">생활체육</span>
               <h3 class="m_game-list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
               <span class="m_game-list__list__place">천안시 유관순체육관</span>
            </li>
         </a>
      </ol>
   </div>
</template>
<div v-show="show_cal" class="m_cal">
   <div v-if="calendar" class="m_cal__header">
      <button @click="calendar.prev()" class="m_cal__header__btn" type="button">
         <i class="xi-angle-left"></i>
         <span class="ir">이전 달로 이동</span>
      </button>
      <div class="m_cal__header__date">
         <span>{{getCurDate().getFullYear()}}년</span>
         <span>{{getCurDate().getMonth() +1}}월</span>
      </div>
      <button @click="calendar.next()" class="m_cal__header__btn" type="button">
         <i class="xi-angle-right"></i>
         <span class="ir">다음 달로 이동</span>
      </button>
      <button @click="calendar.today()" class="m_cal__header__btn t_blue" type="button">오늘</button>
   </div>
   <div ref="calender" class="m_cal__con">

   </div>
   <ul class="m_cal__footer">
      <li>
         대한유도회
      </li>
      <li>
         초중고연맹
      </li>
      <li>
         대학연맹
      </li>
      <li>
         시도대회
      </li>
      <li>
         대한유도회(체전)
      </li>
   </ul>
</div>
<div class="m_banner m_banner--md">
   <a class="m_banner__link" href="#a">
      <img src="/app/images/common/banner/banner_2.png" alt="경기기록실">
   </a>
</div>

<!-- S: 모달창 영역 -->
<transition name="modal">
   <section v-show="madal_gameInfo.show" class="l_modal-layer" :class="{
      'l_modal-layer--ready': true,
   }">
      <div class="l_modal t_top">
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
