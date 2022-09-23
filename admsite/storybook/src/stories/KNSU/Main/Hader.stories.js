import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'KNSU/Style/Main/Header',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: 'main__header',
      status: 'stable', // stable | beta | deprecated
      docs: {
        description: {
            component: `
* 메인 헤더 스타일 입니다.
* 각페이지의 콘텐츠 맨 위에 위치합니다.
* h2태그의 값은 nav에서 데이터 받아와서 설정합니다.
   - /KNSU/tablet/main/js/include/nav.js 참고
* 개별적인 세팅을 원한다면 .js_fix 추가하세요.
            `
        }
    },
   }
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
   props: {
      h2: {
         default: text('h2', args.defaultH2)
      },
   },
   data: function(){
      return {
         sel_tab: 0
      }
   },
   methods: {
   },
   mounted: function(){

   }
});

export const Default = Template.bind({});
Default.args = {
   defaultH2: '제목',
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__header">
               <h2>{{h2}}</h2>
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};
export const Type_Right = Template.bind({});
Type_Right.parameters = {
  docs: {
      description: {
          story: `
* 오른쪽으로 붙은 헤더 영역입니다.
          `
        }
    },
};
Type_Right.args = {
   defaultH2: '제목',
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__header">
               <h2>{{h2}}</h2>
               <div class="main__header__right">
                  <div class="main__header__right__status">
                     <span class="t_date">2021-01-01</span>
                     <span>전체 <em>12</em> </span>
                     <span>현재 <em>3</em> </span>
                     <span>휴학 <em>3</em> </span>
                     <span>은퇴 <em>6</em> </span>
                  </div>
                  <button class="btn t_white-dark" type="button" @click="">헤더 버튼1</button>
                  <button class="btn t_check t_dark" type="button" @click="">헤더 버튼2</button>
               </div>
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};
export const Type_Center = Template.bind({});
Type_Center.parameters = {
  docs: {
      description: {
          story: `
* 가운데에 위치한 헤더 영역입니다.
          `
        }
    },
};
Type_Center.args = {
   defaultH2: '제목',
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__header">
               <h2>{{h2}}</h2>
               <div class="main__header__center t_date">
                  <button class="t_arr" @click="" type="button">
                     <img src="http://knsu.sportsdiary.co.kr/main/images/common/arr_date_s_on.svg" alt="">
                  </button>
                  <button @click="" class="t_calender s_on" type="button">2021-01-01 ~ 2021-01-01</button>
                  <button class="t_arr" @click="" type="button">
                     <img src="http://knsu.sportsdiary.co.kr/main/images/common/arr_date_s_on.svg" alt="">
                  </button>
               </div>
               <div class="main__header__right">
                  <div class="tab-box">
                     <button class="tab" type="button" id="tab_1_M">3개월</button>
                     <button class="tab" type="button" id="tab_2_M">1개월</button>
                     <button class="tab s_on" type="button" id="tab_3_M">1개월</button>
                  </div>
               </div>
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};

export const Type_Fixed = Template.bind({});
Type_Fixed.parameters = {
  docs: {
      description: {
          story: `
* 상단 고정된 헤더 영역입니다.(t_fixed)
          `
        }
    },
};
Type_Fixed.args = {
   defaultH2: '제목',
   template: `
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__header t_fixed">
               <h2>신체조성참가 명단 / 수영</h2>
               <div class="main__header__center">
                  <div class="main__header__center__status">
                     <span>전체<em>12</em></span>
                     <span>참가<em class="t_blue">2</em></span>
                     <span>불참<em class="t_red">3</em></span>
                  </div>
               </div>
               <div class="main__header__right">
                  <button type="button" class="btn t_white-dark" @click="">취소</button>
                  <button type="button" class="btn t_check-2" @click="">저장</button>
               </div>
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
  `
};
