   <div id="Aside" v-clock>
      <transition name="modal">
         <aside v-show="show" @click.self="history.back()" class="l_aside-layer">
            <section class="l_aside">
               <header class="l_aside__header">
                  <h1 class="ir">사이드 메뉴</h1>
                  <template v-if="false">
                     <div class="l_aside__header__title">
                        <span class="l_aside__header__title__text"><strong>처음이신가요?</strong></span>
                        <span class="l_aside__header__title__text">회원가입을 해주세요.</span>
                     </div>
                     <div class="l_aside__header__util">
                        <h3 class="ir">바로가기 아이콘</h3>
                        <a href="#a"><img src="" alt=""></a>
                        <button @click="history.back()" type="button">
                           <img src="" alt="닫기">
                        </button>
                     </div>
                     <div class="l_aside__header__links">
                        <a class="l_aside__header__links__link l_aside__header__links__link--login" href="/pages/main/account/login.asp">로그인</a>
                        <a class="l_aside__header__links__link" href="/pages/main/account/join.asp">회원가입</a>
                     </div>
                  </template>
                  <template v-else>
                     <div class="l_aside__header__profile">
                        <img class="l_aside__header__profile__img" src="" alt="">
                     </div>
                     <div class="l_aside__header__title">
                        <span class="l_aside__header__title__text"><strong>홍길동</strong>님</span>
                        <span class="l_aside__header__title__text">일반</span>
                     </div>
                     <div class="l_aside__header__util">
                        <h3 class="ir">바로가기 아이콘</h3>
                        <button @click="openMyinfo()" type="button"><img src="" alt="마이인포"></button>
                        <a href="#a"><img src="" alt=""></a>
                        <button @click="history.back()" type="button">
                           <img src="" alt="닫기">
                        </button>
                     </div>
                  </template>
               </header>
               <nav class="l_aside__con">
                  <h2 class="ir">
                     앱 바로가기
                  </h2>
                  <!-- <button @click="openMyinfo()" type="button">
               내정보보기
            </button>
            <button @click="javascript:window.location = '/pages/judo/player/record/profile.asp'" type="button">
            선수전적
         </button>
         <button @click="javascript:window.location = '/pages/judo/player/record/winner.asp'" type="button">
         입상현황
      </button> -->
                  <ul ref="lnb">
                     <li v-for="(group, group_idx) in lnb_list" class="l_aside__con__list">
                        <button @click="toggleLnbGroup(group_idx)" :class="{'l_aside__con__list__header--open': group.isOpen}" class="l_aside__con__list__header">
                           <h3 class="l_aside__con__list__header__title">{{group.title}}</h3>
                        </button>
                        <div :style="{height: getHeight(group)}" class="l_aside__con__list__con">
                           <ul>
                              <a v-for="item in group.list" href="#a">
                                 <li class="l_aside__con__list__con__list">
                                    <h4 class="l_aside__con__list__con__list__title">{{item.title}}</h4>
                                    <!-- <span class="l_aside__con__list__con__list__notion">8</span> -->
                                 </li>
                              </a>
                           </ul>
                        </div>
                     </li>
                     <!-- <li class="aside__con__list">
         <button href="#a" class="aside__con__list__header">
         <h3>대회정보</h3>
      </button>
      <div class="aside__con__list__con">
      <ul>
      <a href="#a">
      <li class="aside__con__list__con__list">
      <h4 class="aside__con__list__con__list__title">대회일정/결과</h4>
      <span class="aside__con__list__con__list__notion">8</span>
   </li>
</a>
<a href="#a">
   <li class="aside__con__list__con__list">
      <h4 class="aside__con__list__con__list__title">선수전적</h4>
      <span class="aside__con__list__con__list__notion">8</span>
   </li>
</a>
<a href="#a">
   <li class="aside__con__list__con__list">
      <h4 class="aside__con__list__con__list__title">경기기록실</h4>
      <span class="aside__con__list__con__list__notion">8</span>
   </li>
</a>
<a href="#a">
   <li class="aside__con__list__con__list">
      <h4 class="aside__con__list__con__list__title">대회영상 모음</h4>
      <span class="aside__con__list__con__list__notion">8</span>
   </li>
</a>
<a href="#a">
   <li class="aside__con__list__con__list">
      <h4 class="aside__con__list__con__list__title">SDA TV</h4>
      <span class="aside__con__list__con__list__notion s_active">8</span>
   </li>
</a>
</ul>
</div>
</li>
<li class="aside__con__list">
   <button href="#a" class="aside__con__list__header">
      <h3>자료실</h3>
   </button>
   <div class="aside__con__list__con">
      <ul>
         <a href="#a">
            <li class="aside__con__list__con__list">
               <h4 class="aside__con__list__con__list__title">SD 뉴스</h4>
               <span class="aside__con__list__con__list__notion">8</span>
            </li>
         </a>
         <a href="#a">
            <li class="aside__con__list__con__list">
               <h4 class="aside__con__list__con__list__title">SD 칼럼</h4>
               <span class="aside__con__list__con__list__notion">8</span>
            </li>
         </a>
         <a href="#a">
            <li class="aside__con__list__con__list">
               <h4 class="aside__con__list__con__list__title">단체정보 조회</h4>
               <span class="aside__con__list__con__list__notion">8</span>
            </li>
         </a>
         <a href="#a">
            <li class="aside__con__list__con__list">
               <h4 class="aside__con__list__con__list__title">공지사항</h4>
               <span class="aside__con__list__con__list__notion">8</span>
            </li>
         </a>
         <a href="#a">
            <li class="aside__con__list__con__list">
               <h4 class="aside__con__list__con__list__title">팀 공지사항</h4>
               <span class="aside__con__list__con__list__notion">8</span>
            </li>
         </a>
      </ul>
   </div>
</li>
<li class="aside__con__list">
   <button class="aside__con__list__header">
      <h3>고객지원 </h3>
   </button>
   <div class="aside__con__list__con">
      <ul>
         <a href="#a">
            <li class="aside__con__list__con__list">
               <h4 class="aside__con__list__con__list__title">자주하는 질문</h4>
            </li>
         </a>
         <a href="#a">
            <li class="aside__con__list__con__list">
               <h4 class="aside__con__list__con__list__title">QnA</h4>
            </li>
         </a>
      </ul>
   </div>
</li> -->
                  </ul>
               </nav>
               <footer class="l_aside__footer">
                  <dl class="l_aside__footer__call">
                     <dt class="l_aside__footer__call__header">고객센터</dt>
                     <dd class="l_aside__footer__call__con">070-7439-8113</dd>
                  </dl>
                  <span class="l_aside__footer__noti">운영시간 09:00~18:00(점심시간 12:00~13:00)</span>
                  <!-- <span class="l_aside__footer__noti">WWW.sportsdiary.co.kr</span> -->
                  <span class="l_aside__footer__noti">www.sportsdiary.co.kr</span>
               </footer>
            </section>
         </aside>
      </transition>
      <transition name="modal">
         <section v-show="madal_myinfo.show" @click.self="history.back()" class="l_side-modal-layer">
            <div class="l_side-modal">
               <header class="l_side-modal__header">
                  <button @click="history.back()" class="l_side-modal__header__btn" type="button">
                     <img src="" alt="myinfo 닫기">
                  </button>
                  <h2 class="l_side-modal__header__title">My Info</h2>
                  <button @click="history.back();history.back();" class="l_side-modal__header__btn" type="button">
                     <img src="" alt="사이드 메뉴 닫기">
                  </button>
               </header>
               <nav class="l_side-modal__nav">
                  <ul>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">마이 페이지</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">나의 훈련일정</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">나의 통계</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">메모리</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">나의 메모장</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">지도자 상담</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">훈련일지</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">대회일지</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">체력측정</h3>
                        </li>
                     </a>
                     <a href="#a">
                        <li class="l_side-modal__nav__list">
                           <h3 class="l_side-modal__nav__list__title">부상정보</h3>
                        </li>
                     </a>
                  </ul>
               </nav>
            </div>
         </section>
      </transition>
   </div>


   <script defer src="/js/include/aside.js<%=INCLUDE_ASIDE_VER%>"></script>
