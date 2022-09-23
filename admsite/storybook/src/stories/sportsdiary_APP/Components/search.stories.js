import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/search',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 검색창'
   },
   argTypes: {
    label: {
      description: '전체적으로 쓰이는 기본 검색창입니다.',
    },
  },
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
   props: {
      text: {
         default: text('Text', '')
      }
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   text: '',
   template: `
      <div class="m_search main__con">
         <div class="m_search__row">
            <div class="m_search-box t_size-f">
               <label class="ir" for="">대회명 검색</label>
               <input v-model="text" type="search" placeholder="대회명으로 검색하세요.">
               <button type="button">검색</button>
            </div>
         </div>
         <div class="m_search__row">
            <div class="m_select-box t_size-f">
               <label class="ir" for="">년도 선택</label>
               <select>
                  <option value=""></option>
               </select>
            </div>
            <div class="m_select-box t_size-f2">
               <label class="ir" for="">주최 기관 선택</label>
               <select>
                  <option value=""></option>
               </select>
            </div>
         </div>
      </div>
  `
};
