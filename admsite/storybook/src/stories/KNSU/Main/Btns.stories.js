import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'KNSU/Style/Main/Btn',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: 'main__btns',
      status: 'stable', // stable | beta | deprecated
      docs: {
        description: {
            component: `
* 메인 버튼 박스 스타일 입니다.
* 보통 콘텐츠의 맨 밑에 위치합니다.
* 하위에 .btn 버튼들을 위치시킵니다.
            `
        }
    },
   }
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
});
export const Main_Btns = Template.bind({});
Main_Btns.args = {
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__btns">
               <button class="btn t_white-dark t_right" type="button">취소</button>
               <button class="btn t_check-2" type="button">저장</button>
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};

export const Type_Side = Template.bind({});
Type_Side.parameters = {
  docs: {
      description: {
          story: `
* t_left와 t_right를 사용해서 양옆으로 정렬할 수 있습니다.
          `
        }
    },
};
Type_Side.args = {
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__btns">
               <button class="btn t_left" type="button">왼쪽 버튼</button>
               <button class="btn t_white-dark t_right" type="button">취소</button>
               <button class="btn t_check-2" type="button">저장</button>
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};
