import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/selectBox',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 선택창'
   },
   argTypes: {
    label: {
      description: '전체적으로 쓰이는 기본 선택창입니다.',
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
            <div class="m_select-box">
               <label class="ir" for="">주최 기관 선택</label>
               <select>
                  <option value="">1</option>
                  <option value="">2</option>
                  <option value="">3</option>
               </select>
            </div>
  `
};
