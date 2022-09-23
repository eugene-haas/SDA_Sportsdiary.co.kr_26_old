import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/btn',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 버튼'
   },
   argTypes: {
    label: {
      description: '전체적으로 쓰이는 기본 버튼입니다.',
    },
  },
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
   props: {
      text: {
         default: text('Text', '확인')
      }
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   template: `
<button type="button" class="m_btn">
   {{text}}
</button>
  `
};
export const type_min = Template.bind({});
type_min.args = {
   template: `
<button type="btn" class="m_btn t_min">
   {{text}}
</button>
  `
};
