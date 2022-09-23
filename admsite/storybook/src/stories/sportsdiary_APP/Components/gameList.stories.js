import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/gameList',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '대회 목록'
   },
   argTypes: {
    label: {
      description: '대회 목록입니다.',
    },
  },
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
   props: {
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   template: `
      <div class="m_game_list main_con">
         <h2 class="ir">대회 목록</h2>
         <ol>
            <a href="#a">
               <li class="m_game_list__list">
                  <span class="m_game_list__list__date">6월 17일 ~ 6월 23일</span>
                  <h3 class="m_game_list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
                  <div class="m_game_list__list__state">
                     <span class="m_game_list__list__state__text">생활체육</span>
                     예정
                  </div>
                  <span class="m_game_list__list__place">천안시 유관순체육관</span>
               </li>
            </a>
            <a href="#a">
               <li class="m_game_list__list">
                  <span class="m_game_list__list__date">6월 17일 ~ 6월 23일</span>
                  <h3 class="m_game_list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
                  <div class="m_game_list__list__state">
                     <span class="m_game_list__list__state__text">생활체육</span>
                     예정
                  </div>
                  <span class="m_game_list__list__place">천안시 유관순체육관</span>
               </li>
            </a>
            <a href="#a">
               <li class="m_game_list__list">
                  <span class="m_game_list__list__date">6월 17일 ~ 6월 23일</span>
                  <h3 class="m_game_list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
                  <div class="m_game_list__list__state">
                     <span class="m_game_list__list__state__text">생활체육</span>
                     예정
                  </div>
                  <span class="m_game_list__list__place">천안시 유관순체육관</span>
               </li>
            </a>
            <a href="#a">
               <li class="m_game_list__list">
                  <span class="m_game_list__list__date">6월 17일 ~ 6월 23일</span>
                  <h3 class="m_game_list__list__title">2020 전국학교대항 유도선수권대회-대학</h3>
                  <div class="m_game_list__list__state">
                     <span class="m_game_list__list__state__text">생활체육</span>
                     예정
                  </div>
                  <span class="m_game_list__list__place">천안시 유관순체육관</span>
               </li>
            </a>
         </ol>
      </div>
  `
};
