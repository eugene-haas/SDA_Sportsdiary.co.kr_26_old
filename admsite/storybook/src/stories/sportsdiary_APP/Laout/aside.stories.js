import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/Layout/aside',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 레이아웃'
   }
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
   props: {
      h1: {
         default: text('title', '유도')
      },
      show: {
         default: boolean('open', args.show)
      },
      login: {
         default: boolean('open', args.login)
      },
      showMyinfo: {
         default: boolean('open', args.showMyinfo)
      }
   },
   methods: {
      closeAside: function(){
         console.log('closeAside');
         this.show = false;
      },
      openAside: function(){
         console.log('openAside');
         this.show = true;
      }
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   show: true,
   login: false,
   showMyinfo: false,
   template: `
      <div id="__WRAP" class="l_wrap">
         <!-- S: 헤더 영역 -->
         <header id="Header" class="l_header">
            <div class="l_header__links">
               <div class="l_header__links__box">
                  <button @click="historyBack()" class="l_header__links__box__btn" type="button">
                     <img src="http://sdmain.sportsdiary.co.kr/app/images/common/icon/header_back.svg" alt="닫기">
                  </button>
               </div>
               <h1 class="l_header__links__h1">
                  <span v-if="h1">{{h1}}</span>
                  <a v-else :href="'/app/pages/'+sports+'/index.asp'"><img class="l_header__links__h1__img" :src="'/app/images/logo/logo_'+sports+'.png'" :alt="sports_name"></a>
               </h1>
               <div class="l_header__links__box">
                  <button @click="openAside()" class="l_header__links__box__btn" type="button">
                     <img src="http://sdmain.sportsdiary.co.kr/app/images/common/icon/header_menu.svg" alt="메뉴 열기">
                  </button>
               </div>
            </div>
         </header>
         <!-- E: 헤더 영역 -->
         <!-- S: 사이드메뉴 영역 -->
         <aside @click.self="closeAside()" id="Aside" class="l_aside-layer" :class="{s_show:show}" v-clock>
            <section class="l_aside aside">
               <header class="aside__header">
                  <h1 class="ir">사이드 메뉴</h1>
                  <template v-if="!login">
                     <div class="aside__header__title">
                           <span class="aside__header__title__text"><strong>처음이신가요?</strong></span>
                           <span class="aside__header__title__text">회원가입을 해주세요.</span>
                     </div>
                     <div class="aside__header__utill">
                        <h3 class="ir">바로가기 아이콘</h3>
                        <a href="#a"><img src="" alt=""></a>
                        <button @click="closeAside()" type="button">
                           <img src="" alt="닫기">
                        </button>
                     </div>
                     <div class="aside__header__links">
                        <a class="aside__header__links__link t_white" href="/app/pages/main/account/login.asp">로그인</a>
                        <a class="aside__header__links__link" href="/app/pages/main/account/join.asp">회원가입</a>
                     </div>
                  </template>
                  <template v-else>
                     <div class="aside__header__profile">
                        <img class="aside__header__profile__ing" src="" alt="">
                     </div>
                     <div class="aside__header__title">
                           <span class="aside__header__title__text"><strong>홍길동</strong>님</span>
                           <span class="aside__header__title__text">일반</span>
                     </div>
                     <div class="aside__header__utill">
                        <h3 class="ir">바로가기 아이콘</h3>
                        <button @click="openMyinfo()" type="button"><img src="" alt="마이인포"></button>
                        <a href="#a"><img src="" alt=""></a>
                        <button @click="closeAside()" type="button">
                           <img src="" alt="닫기">
                        </button>
                     </div>
                  </template>
               </header>
               <nav class="aside__con">
                  <h2 class="ir">
                     앱 바로가기
                  </h2>
                  <!-- <button @click="openMyinfo()" type="button">
                     내정보보기
                  </button>
                  <button @click="javascript:window.location = '/app/pages/judo/player/record/profile.asp'" type="button">
                     선수전적
                  </button>
                  <button @click="javascript:window.location = '/app/pages/judo/player/record/winner.asp'" type="button">
                     입상현황
                  </button> -->
                  <ul ref="lnb">
                     <li v-for="(group, group_idx) in lnb_list" class="aside__con__list">
                        <button @click="toggleLnbGroup(group_idx)" :class="{s_open: group.isOpen}" class="aside__con__list__header">
                           <h3 class="aside__con__list__header__title">{{group.title}}</h3>
                        </button>
                        <div :style="{height: getHeight(group)}" class="aside__con__list__con">
                           <ul>
                              <a v-for="item in group.list" href="#a">
                                 <li class="aside__con__list__con__list">
                                    <h4 class="aside__con__list__con__list__title">{{item.title}}</h4>
                                    <!-- <span class="aside__con__list__con__list__notion">8</span> -->
                                 </li>
                              </a>
                           </ul>
                        </div>
                     </li>
                  </ul>
               </nav>
               <footer class="aside__footer">
                  <dl class="aside__footer__call">
                     <dt class="aside__footer__call__header">고객센터</dt>
                     <dd class="aside__footer__call__con">070-7439-8113</dd>
                  </dl>
                  <span class="aside__footer__noti">운영시간 09:00~18:00(점심시간 12:00~13:00)</span>
                  <!-- <span class="aside__footer__noti">WWW.sportsdiary.co.kr</span> -->
                  <span class="aside__footer__noti">www.sportsdiary.co.kr</span>
               </footer>
            </section>
            <section @click.self="closeMyinfo()" class="l_side-modal-layer" :class="{s_show: showMyinfo}">
               <div class="l_side-modal">
                  <header class="l_side-modal__header">
                     <button @click="closeMyinfo()" class="l_side-modal__header__btn" type="button">
                        <img src="" alt="myinfo 닫기">
                     </button>
                     <h2 class="l_side-modal__header__title">My Info</h2>
                     <button @click="closeAside()" class="l_side-modal__header__btn" type="button">
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
         </aside>

         <!-- E: 사이드메뉴 영역 -->

      </div>
  `
};
