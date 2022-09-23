import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'KNSU/Style/Main/Tab',
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
   },
   data: function(){
      return {
         login_info: {
            department: "Master",
            department_code: "1",
            group_code: "1",
            gruop: "Master",
            id: "KUGMMaster",
            manager_seq: "3",
            name: "Master",
            pub_name: "관리자",
            sports: "",
            sports_code: "0",
         },
         aside_show: false,
         sel_tab: 0
      }
   },
   methods: {
   },
   mounted: function(){

   }
});

const header_str = `
<!-- S: 네비게이션 영역 -->
<nav id="nav" role="navigation" class="l_nav">
   <a class="l_nav__header">
      <img src="http://knsu.sportsdiary.co.kr/main/images/index/PM_1.svg" alt="">
      <h1>레슬링</h1>
   </a>
   <ul><li class="l_nav__list t_child s_on"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/nav/ico/PM_1.svg" alt=""> <a href="/main/page/PM/boo_manage/retirees.asp">부원관리</a> <ul><li class="l_nav__list__list s_on"><a href="/main/page/PM/boo_manage/retirees.asp"><span>부원현황</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/hurt_TM.asp"><span>부상-치료실</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/hurt.asp"><span>부상-외부진료</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/weight.asp"><span>체중</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/medical.asp"><span>외부진료</span></a></li></ul></li></ul>
   <h2 class="l_nav__h2"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/nav/nav_logo.svg" alt="한국체육대학교 로고"></h2>
</nav>
<!-- E: 네비게이션 영역 -->
<!-- S: 헤더 영역 -->
<header class="l_header clear">
  <button id="pageBack"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/ico_back.svg" alt="페이지 뒤로가기"></button>
  <h2><a href="#a"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/logo_KNSU.png" alt="한국체육대학교 로고"></a></h2>
  <button @click="" id="profile" type="button"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/ico_profile.svg" alt="마이 메뉴"></button>
</header>
<!-- E: 헤더 영역 -->
`
export const Main_Tab = Template.bind({});
Main_Tab.args = {
   template: `
<div class="__KNSU-wrap__">
   ${header_str}
   <div id="vue_app" class="l_wrap">
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__header">
               <h2>제목</h2>
            </div>
            <div class="main__tab t_gray">
               <h3><button @click="sel_tab = 1;" :class="{s_on:sel_tab == 1}" type="button">1번탭</button></h3>
               <h3><button @click="sel_tab = 2;" :class="{s_on:sel_tab == 2}" type="button">2번탭</button></h3>
               <h3><button @click="sel_tab = 3;" :class="{s_on:sel_tab == 3}" type="button">3번탭</button></h3>
            </div>
            <div class="main__con">
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 모달창 영역 -->
      <!-- E: 모달창 영역 -->
   </div>
</div>
  `
};
