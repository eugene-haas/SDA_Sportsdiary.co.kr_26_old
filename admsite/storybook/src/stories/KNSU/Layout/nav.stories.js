import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'KNSU/Style/Layout/Nav',
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
      title_text: {
         default: text('title_text', args.defaultTitle)
      },

   },
   data: function(){
      return {
      }
   },
   methods: {
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   defaultTitle: '레슬링',
   template: `
<div class="__KNSU-wrap__">
   <!-- S: 네비게이션 영역 -->
   <nav id="nav" role="navigation" class="l_nav">
      <a class="l_nav__header">
         <img src="http://knsu.sportsdiary.co.kr/main/images/index/PM_1.svg" alt="">
         <h1>{{ title_text }}</h1>
      </a>
      <ul><li class="l_nav__list t_child s_on"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/nav/ico/PM_1.svg" alt=""> <a href="/main/page/PM/boo_manage/retirees.asp">부원관리</a> <ul><li class="l_nav__list__list s_on"><a href="/main/page/PM/boo_manage/retirees.asp"><span>부원현황</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/hurt_TM.asp"><span>부상-치료실</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/hurt.asp"><span>부상-외부진료</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/weight.asp"><span>체중</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/medical.asp"><span>외부진료</span></a></li></ul></li></ul>
      <h2 class="l_nav__h2"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/nav/nav_logo.svg" alt="한국체육대학교 로고"></h2>
   </nav>
   <!-- E: 네비게이션 영역 -->
</div>
  `
};
