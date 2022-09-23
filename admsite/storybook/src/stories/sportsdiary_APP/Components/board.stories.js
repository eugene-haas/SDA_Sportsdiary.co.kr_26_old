import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/board',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '보드 형태의 레이아웃'
   },
   argTypes: {
    label: {
      description: '제목 - 내용 형태로 다양하게 쓰입니다.',
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
      <div class="m_board main__con">
         <div class="m_board__header">
            <h2 class="m_board__header__title">대회 입상결과</h2>
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
      </div>
  `
};

export const type_view = Template.bind({});
type_view.args = {
   template: `
      <div class="m_board main__con">
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
  `
};
