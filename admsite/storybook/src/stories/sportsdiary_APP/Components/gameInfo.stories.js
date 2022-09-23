import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/gameInfo',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '대회 정보'
   },
   argTypes: {
    label: {
      description: '대회 정보입니다.',
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
      <div class="m_game_info main__con">
         <h2 class="ir">대회 정보</h2>
         <ul>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">대회명</dt>
                  <dd class="m_game_info__list__body">제63회 유도 협회장 전국 유도선수권대회</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">대회기간</dt>
                  <dd class="m_game_info__list__body">2020-07-25 ~2020-07-31</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">장소</dt>
                  <dd class="m_game_info__list__body">강원도 양구 실내체육관</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">주최</dt>
                  <dd class="m_game_info__list__body">대한유도회</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">주관</dt>
                  <dd class="m_game_info__list__body">강원도유도회, 양구군유도회</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">후원</dt>
                  <dd class="m_game_info__list__body">로렉스, 아디다스</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">협찬</dt>
                  <dd class="m_game_info__list__body">아디다스</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">참가신청</dt>
                  <dd class="m_game_info__list__body">2020-05-01 ~2020-06-30</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">경기종목</dt>
                  <dd class="m_game_info__list__body">중등부 / 고등부 / 대학부 / 일반부</dd>
               </dl>
            </li>
            <li class="m_game_info__list">
               <dl>
                  <dt class="m_game_info__list__head">기타사항</dt>
                  <dd class="m_game_info__list__body">---</dd>
               </dl>
            </li>
         </ul>
      </div>
  `
};
