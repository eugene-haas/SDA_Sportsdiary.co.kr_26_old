import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/tab',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 탭'
   },
   argTypes: {
    label: {
      description: '전체적으로 쓰이는 기본 탭입니다.',
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
      <div class="m_tabs main__con">
         <h2 class="m_tabs__tab s_active">
            <button class="m_tabs__tab__btn" type="button">SD뉴스</button>
         </h2>
         <h2 class="m_tabs__tab">
            <button class="m_tabs__tab__btn" type="button">공지사항</button>
         </h2>
      </div>
  `
};
export const type_list = Template.bind({});
type_list.args = {
   template: `
      <div class="m_tabs main__con t_list">
         <h2 class="m_tabs__tab s_active">
            <button class="m_tabs__tab__btn" type="button">전체</button>
         </h2>
         <h2 class="m_tabs__tab">
            <button class="m_tabs__tab__btn" type="button">진행</button>
         </h2>
         <h2 class="m_tabs__tab">
            <button class="m_tabs__tab__btn" type="button">예정</button>
         </h2>
         <h2 class="m_tabs__tab">
            <button class="m_tabs__tab__btn" type="button">완료</button>
         </h2>
      </div>
  `
};
export const type_info = Template.bind({});
type_info.args = {
   template: `
      <div class="m_tabs main__con t_info">
         <h2 class="m_tabs__tab s_active">
            <button class="m_tabs__tab__btn" type="button">개인전</button>
         </h2>
         <h2 class="m_tabs__tab">
            <button class="m_tabs__tab__btn" type="button">단체전</button>
         </h2>
      </div>
  `
};
