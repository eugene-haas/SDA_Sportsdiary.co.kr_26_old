import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/Layout/header',
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
         default: text('title', args.defaultTitle)
      }
   },
   methods: {
      historyBack: function(){
         console.log('historyBack')
      },
      openAside: function(){
         console.log('openAside')
      }
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   defaultTitle: '',
   template: `
      <div id="__WRAP" class="l_wrap">
         <!-- S: 헤더 영역 -->
         <header id="Header" class="l_header">
            <div class="l_header__links">
               <div class="l_header__links__box">
                  <button @click="historyBack()" class="l_header__links__box__btn" type="button">
                     <i class="xi-angle-left"></i>
                  </button>
               </div>
               <h1 class="l_header__links__h1">
                  <span v-if="h1">{{h1}}</span>
                  <a v-else href="#a"><img class="l_header__links__h1__img" src="http://img.sportsdiary.co.kr//images/SD/logo/logo_@3x.png" alt="스포츠 다이어리"></a>
               </h1>
               <div class="l_header__links__box">
                  <button class="l_header__links__box__btn" type="button">
                     <i class="xi-bars"></i>
                  </button>
               </div>
            </div>
         </header>
         <!-- E: 헤더 영역 -->
      </div>
  `
};
export const type_judo = Template.bind({});
type_judo.args = {
   defaultTitle: '유도',
   template: `
      <div id="__WRAP" class="l_wrap">
         <!-- S: 헤더 영역 -->
         <div class="l_header__links">
            <div class="l_header__links__box">
               <button @click="historyBack()" class="l_header__links__box__btn" type="button">
                  <img src="http://sdmain.sportsdiary.co.kr/app/images/common/icon/header_back.svg" alt="닫기">
               </button>
            </div>
            <h1 class="l_header__links__h1">
               <span v-if="h1">{{h1}}</span>
               <a v-else :href="'/app/pages/'+sports+'/index.asp'"><img class="l_header__links__h1__img" :src="'http://sdmain.sportsdiary.co.kr/app/images/logo/logo_'+sports+'.png'" :alt="sports_name"></a>
            </h1>
            <div class="l_header__links__box">
               <button @click="openAside()" class="l_header__links__box__btn" type="button">
                  <img src="http://sdmain.sportsdiary.co.kr/app/images/common/icon/header_menu.svg" alt="메뉴 열기">
               </button>
            </div>
         </div>
         <!-- E: 헤더 영역 -->
      </div>
  `
};
