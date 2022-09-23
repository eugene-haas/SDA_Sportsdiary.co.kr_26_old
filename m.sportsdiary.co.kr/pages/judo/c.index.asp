<header class="m_header">
   <h1 class="ir">유도 메인</h1>
</header>
<div class="m_banner">
   <a class="m_banner__link" href="#a">
      <img src="/images/common/banner/banner_1.png" alt="경기기록실">
   </a>
</div>
<div class="m_search">
   <div class="m_space">
      <div class="m_search-box m_space__flex-1">
         <label class="ir" for="">선수 이름 검색</label>
         <input class="m_search-box__input" type="search" placeholder="선수 이름을 입력 후 검색하세요.">
         <button class="m_search-box__btn" type="button">검색</button>
      </div>
   </div>
</div>
<div class="m_board">
   <div class="m_board__header">
      <h2 class="m_board__header__title">대회일정</h2>
      <button type="button" @click="goList()" class="m_board__header__more">더보기</button>
      <!-- <a href="/pages/judo/game/list.asp" class="m_board__header__more">더보기</a> -->
   </div>
   <ol>
      <a href="#a">
         <li class="m_board__list t_blank">
            <h3 class="m_board__list__title">제63회 전국여름철종별 유도대회-초등</h3>
         </li>
      </a>
      <a href="#a">
         <li class="m_board__list">
            <h3 class="m_board__list__title">경기운영 테스트 대회2</h3>
         </li>
      </a>
   </ol>
</div>
<div class="m_banner m_banner--md">
   <a class="m_banner__link" href="#a">
      <img src="/images/common/banner/banner_2.png" alt="경기기록실">
   </a>
</div>
<div class="m_board">
   <div class="m_board__header">
      <h2 class="m_board__header__title">대회 입상결과</h2>
      <a href="#a" class="m_board__header__more">더보기</a>
   </div>
   <ol>
      <a href="#a">
         <li class="m_board__list t_blank">
            <h3 class="m_board__list__title">제63회 전국여름철종별 유도대회-초등</h3>
         </li>
      </a>
      <a href="#a">
         <li class="m_board__list">
            <h3 class="m_board__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
         </li>
      </a>
      <a href="#a">
         <li class="m_board__list">
            <h3 class="m_board__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
         </li>
      </a>
   </ol>
</div>
<div class="m_tabs">
   <h2 class="m_tabs__tab s_active">
      <button class="m_tabs__tab__btn" type="button">SD뉴스</button>
   </h2>
   <h2 class="m_tabs__tab">
      <button class="m_tabs__tab__btn" type="button">공지사항</button>
   </h2>
</div>
<div class="m_board">
   <div class="m_board__header t_min">
      <a href="#a" class="m_board__header__more">더보기</a>
   </div>
   <ol>
      <a href="#a">
         <li class="m_board__list t_new">
            <h3 class="m_board__list__title">제63회 전국여름철종별 유도대회-초등</h3>
         </li>
      </a>
      <a href="#a">
         <li class="m_board__list">
            <h3 class="m_board__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
         </li>
      </a>
      <a href="#a">
         <li class="m_board__list">
            <h3 class="m_board__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
         </li>
      </a>
   </ol>
   <div class="m_board__view">
      <ul>
         <a href="#a" class="t_size-f">
            <li class="m_board__view__list">
               <div class="m_board__view__list__img">
                  <img src="" alt="">
               </div>
               <div class="m_board__view__list__con">
                  <h3><strong>2020 태국마스터즈</strong> 한국 대 일본전</h3>
               </div>
            </li>
         </a>
         <a href="#a" class="t_size-f">
            <li class="m_board__view__list">
               <div class="m_board__view__list__img">
                  <img src="" alt="">
               </div>
               <div class="m_board__view__list__con">
                  <h3><strong>2020 태국마스터즈</strong> 한국 대 일본전</h3>
               </div>
            </li>
         </a>
      </ul>
   </div>
</div>
<div class="m_banner m_banner--md">
   <a class="m_banner__link" href="#a">
      <img src="/images/common/banner/banner_2.png" alt="경기기록실">
   </a>
</div>
<!-- <div class="m_board">
<div class="m_board__header">
<h2 class="m_board__header__title">SD 뉴스</h2>
<button @click="openModalProfile()" type="button">더보기</button>
</div>
<ol>
   <li class="m_board__olist">
      <a href="#a" class="m_board__olist__link">
         <span class="m_board__olist__link__state">결과보기</span>
         <h3 class="m_board__olist__link__title">경기운영 테스트 대회2</h3>
      </a>
   </li>
   <li class="m_board__olist">
      <a href="#a" class="m_board__olist__link">
         <span class="m_board__olist__link__state">D-36</span>
         <h3 class="m_board__olist__link__title">경기운영 테스트 대회2</h3>
      </a>
   </li>
   <li class="m_board__olist">
      <a href="#a" class="m_board__olist__link">
         <span class="m_board__olist__link__state">D-36</span>
         <h3 class="m_board__olist__link__title">경기운영 테스트 대회2</h3>
      </a>
   </li>
</ol>
</div>
<div class="m_board">
   <div class="m_board__header">
      <h2 class="m_board__header__title">공지사항</h2>
      <button @click="openModalProfile()" type="button">더보기</button>
   </div>
   <ol>
      <li class="m_board__olist">
         <a href="#a" class="m_board__olist__link">
            <span class="m_board__olist__link__state">결과보기</span>
            <h3 class="m_board__olist__link__title">경기운영 테스트 대회2</h3>
         </a>
      </li>
      <li class="m_board__olist">
         <a href="#a" class="m_board__olist__link">
            <span class="m_board__olist__link__state">D-36</span>
            <h3 class="m_board__olist__link__title">경기운영 테스트 대회2</h3>
         </a>
      </li>
      <li class="m_board__olist">
         <a href="#a" class="m_board__olist__link">
            <span class="m_board__olist__link__state">D-36</span>
            <h3 class="m_board__olist__link__title">경기운영 테스트 대회2</h3>
         </a>
      </li>
   </ol>
</div> -->

<!-- S: 모달창 영역 -->
<transition name="modal">
   <section v-show="modal_gameInfo.show" @click.self="closeModalGameInfo()" class="l_modal-layer" :class="{
      'l_modal-layer--ready': true,
   }">
      <div class="l_modal t_radius t_cover">
         <header class="l_modal__header">
            <h1 class="l_modal__header__title">대회정보</h1>
            <button @click="closeModalGameInfo()" class="l_modal__header__btn" type="button">닫기</button>
         </header>
         <div class="modal">
            <div class="modal__header">
               <h2 class="modal__header__title">[취소]2020 Jeju Cup International Judo Tournament</h2>
               <span class="modal__header__notion">2020년 12월 01일(화) ~ 04일(금)</span>
            </div>
            <ul class="modal__con">
               <li class="m_info">
                  <dl class="m_info__info">
                     <dt class="m_info__info__header">장소</dt>
                     <dd class="m_info__info__con">한라체육관</dd>
                  </dl>
               </li>
               <li class="m_info">
                  <dl class="m_info__info">
                     <dt class="m_info__info__header">기간</dt>
                     <dd class="m_info__info__con">2020년 12월 01일(화) ~ 04일(금) (4일간)</dd>
                  </dl>
               </li>
               <li class="m_info">
                  <dl class="m_info__info">
                     <dt class="m_info__info__header">참가신청</dt>
                     <dd class="m_info__info__con">-년-월-일() ~ -일() (0일간)</dd>
                  </dl>
               </li>
            </ul>
            <nav class="modal__nav">
               <ul>
                  <li class="modal__nav__list">
                     <a href="#a" class="modal__nav__list__btn">대회요강</a>
                  </li>
                  <li class="modal__nav__list">
                     <a href="#a" class="modal__nav__list__btn">참가자 명단</a>
                  </li>
                  <li class="modal__nav__list">
                     <a href="#a" class="modal__nav__list__btn s_disabled">참가자신청 현황</a>
                  </li>
                  <li class="modal__nav__list">
                     <a href="#a" class="modal__nav__list__btn s_disabled">대회 일정표</a>
                  </li>
                  <li class="modal__nav__list">
                     <a href="#a" class="modal__nav__list__btn s_disabled">대진표</a>
                  </li>
                  <li class="modal__nav__list">
                     <a href="#a" class="modal__nav__list__btn s_disabled">경기순서/현황(Live경기영상)</a>
                  </li>
                  <li class="modal__nav__list">
                     <a href="#a" class="modal__nav__list__btn s_disabled">대회결과</a>
                  </li>
               </ul>
            </nav>
         </div>
      </div>
   </section>
</transition>
<!-- E: 모달창 영역 -->
