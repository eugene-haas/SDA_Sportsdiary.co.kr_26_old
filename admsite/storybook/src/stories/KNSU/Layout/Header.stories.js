import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'KNSU/Style/Layout/Header',
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
      }
   },
   methods: {
      openAside: function(){
         console.log('openAside');
         this.aside_show = true;
      },
      closeAside: function(){
         console.log('closeAside');
         this.aside_show = false;
      },
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   template: `
<div class="__KNSU-wrap__">
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
     <button @click="openAside()" id="profile" type="button"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/ico_profile.svg" alt="마이 메뉴"></button>
   </header>
   <aside id="aside" class="l_aside" :class="{s_show:aside_show}">
     <button @click="closeAside()" class="l_aside__btn-close" type="button">
       <img src="http://knsu.sportsdiary.co.kr/main/images/common/include/aside_btn_close.svg" alt="마이 메뉴 닫기">
     </button>
     <div class="l_aside__header clear">
       <div class="l_aside__header__img">
         <img src="http://knsu.sportsdiary.co.kr/main/images/common/include/aside_header_ico_profile.svg" alt="프로필 사진">
       </div>
       <span class="l_aside__header__location">{{login_info.department}}</span>
       <h2>{{login_info.name}}</h2>
       <h3 v-if="login_info.group_code == 5">관리자님</h3>
     </div>
     <div class="l_aside__main">
       <button @click="modal_aside.showModal()" class="t_red" type="button">관리자 정보수정</button>
       <button @click="logout()" type="button">로그아웃</button>
     </div>
     <div class="l_aside__footer">
       <img src="http://knsu.sportsdiary.co.kr/main/images/common/include/logo_KNSU.svg" alt="한국체육대학교 로고">
     </div>
   </aside>
   <!-- E: 헤더 영역 -->
</div>
  `
};

export const Show_Back = Template.bind({});
Show_Back.args = {
   template: `
<div class="__KNSU-wrap__">
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
     <button style="opacity:1;pointer-events:auto;cursor:pointer;" id="pageBack"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/ico_back.svg" alt="페이지 뒤로가기"></button>
     <h2><a href="#a"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/logo_KNSU.png" alt="한국체육대학교 로고"></a></h2>
     <button @click="openAside()" id="profile" type="button"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/ico_profile.svg" alt="마이 메뉴"></button>
   </header>
   <aside id="aside" class="l_aside" :class="{s_show:aside_show}">
     <button @click="closeAside()" class="l_aside__btn-close" type="button">
       <img src="http://knsu.sportsdiary.co.kr/main/images/common/include/aside_btn_close.svg" alt="마이 메뉴 닫기">
     </button>
     <div class="l_aside__header clear">
       <div class="l_aside__header__img">
         <img src="http://knsu.sportsdiary.co.kr/main/images/common/include/aside_header_ico_profile.svg" alt="프로필 사진">
       </div>
       <span class="l_aside__header__location">{{login_info.department}}</span>
       <h2>{{login_info.name}}</h2>
       <h3 v-if="login_info.group_code == 5">관리자님</h3>
     </div>
     <div class="l_aside__main">
       <button @click="modal_aside.showModal()" class="t_red" type="button">관리자 정보수정</button>
       <button @click="logout()" type="button">로그아웃</button>
     </div>
     <div class="l_aside__footer">
       <img src="http://knsu.sportsdiary.co.kr/main/images/common/include/logo_KNSU.svg" alt="한국체육대학교 로고">
     </div>
   </aside>
   <!-- E: 헤더 영역 -->
</div>
  `
};
