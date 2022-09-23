import {withKnobs, text, boolean, select} from "@storybook/addon-knobs";
export default {
   title: 'KNSU/Style/Components/Btn',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: 'btn',
      status: 'stable', // stable | beta | deprecated
      docs: {
        description: {
            component: `
* 기본 버튼 박스 스타일 입니다.
* 전체적으로 쓰입니다.
* 다양한 타입이 있습니다.
            `
        }
    },
   }
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   props: {
      type: {
         default: select('Type', {
               Default: '',
               t_check: 't_check',
               "t_check-2": 't_check-2',
              t_dark: 't_dark',
              "t_white-red": 't_white-red',
              "t_white-dark": 't_white-dark',
              t_disabled: 't_disabled',
           }, '')
      },
      text: {
         default: text('Text', '확인')
      }
   },
   template: args.template,
});
export const Main_Btns = Template.bind({});
Main_Btns.args = {
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <button :class="'btn ' + type" type="button">{{text}}</button>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};

export const Type_Min = Template.bind({});
Type_Min.parameters = {
  docs: {
      description: {
          story: `
* 작은 버전 버튼입니다.
          `
        }
    },
};
Type_Min.args = {
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <button :class="'btn t_min ' + type" type="button">{{text}}</button>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};
