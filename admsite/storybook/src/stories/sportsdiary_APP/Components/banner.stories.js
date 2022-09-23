import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/banner',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 배너'
   },
   argTypes: {
    label: {
      description: '전체적으로 쓰이는 기본 배너입니다.',
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
      <div class="m_banner main__con">
         <a class="m_banner__link" href="#a">
            <img src="http://sdmain.sportsdiary.co.kr/app/images/common/banner/banner_1.png" alt="경기기록실">
         </a>
      </div>
  `
};
export const type_size_m = Template.bind({});
type_size_m.args = {
   template: `
      <div class="m_banner main__con t_size-m">
         <a class="m_banner__link" href="#a">
            <img src="http://sdmain.sportsdiary.co.kr/app/images/common/banner/banner_2.png" alt="경기기록실">
         </a>
      </div>
  `
};
