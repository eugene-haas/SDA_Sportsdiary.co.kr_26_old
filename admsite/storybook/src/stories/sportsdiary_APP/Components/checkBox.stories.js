import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/checkBox',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 체크박스'
   },
   argTypes: {
    label: {
      description: '전체적으로 쓰이는 기본 체크박스입니다.',
    },
  },
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
   props: {
      isChecked: {
         default: boolean('isChecked', args.isChecked)
      }
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   isChecked: false,
   template: `
               <div class="m_check-box">
                  <input v-model="isChecked" id="check" type="checkbox">
                  <label for="check"></label>
               </div>
  `
};
export const type_label = Template.bind({});
type_label.args = {
   isChecked: false,
   template: `
               <div class="m_check-box">
                  <label for="check">엘리트</label>
                  <input v-model="isChecked" id="check" type="checkbox">
                  <label for="check"></label>
               </div>
  `
};
