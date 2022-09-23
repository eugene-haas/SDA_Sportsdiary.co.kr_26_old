import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'KNSU/Style/Main/Tbl',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '기본 레이아웃'
   }
};
const Template = (args, {argTypes}) => ({
   props: Object.keys(argTypes),
   components: {},
   template: args.template,
   props: {
   },
   data: function(){
      return {
         login_info: {
            department: "Master",
            department_code: "1",
            group_code: "1",
            gruop: "Master",
            id: "KUGMMaster",
            manager_seq: "3",
            name: "Master",
            pub_name: "관리자",
            sports: "",
            sports_code: "0",
         },
         aside_show: false,
         sel_tab: 0
      }
   },
   methods: {
   },
   mounted: function(){

   }
});

const header_str = `
<!-- S: 네비게이션 영역 -->
<nav id="nav" role="navigation" class="l_nav">
   <a class="l_nav__header">
      <img src="http://knsu.sportsdiary.co.kr/main/images/index/PM_1.svg" alt="">
      <h1>레슬링</h1>
   </a>
   <ul><li class="l_nav__list t_child s_on"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/nav/ico/PM_1.svg" alt=""> <a href="/main/page/PM/boo_manage/retirees.asp">부원관리</a> <ul><li class="l_nav__list__list s_on"><a href="/main/page/PM/boo_manage/retirees.asp"><span>부원현황</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/hurt_TM.asp"><span>부상-치료실</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/hurt.asp"><span>부상-외부진료</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/weight.asp"><span>체중</span></a></li><li class="l_nav__list__list"><a href="/main/page/PM/boo_manage/medical.asp"><span>외부진료</span></a></li></ul></li></ul>
   <h2 class="l_nav__h2"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/nav/nav_logo.svg" alt="한국체육대학교 로고"></h2>
</nav>
<!-- E: 네비게이션 영역 -->
<!-- S: 헤더 영역 -->
<header class="l_header clear">
  <button id="pageBack"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/ico_back.svg" alt="페이지 뒤로가기"></button>
  <h2><a href="#a"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/logo_KNSU.png" alt="한국체육대학교 로고"></a></h2>
  <button @click="" id="profile" type="button"><img src="http://knsu.sportsdiary.co.kr/main/images/common/include/ico_profile.svg" alt="마이 메뉴"></button>
</header>
<!-- E: 헤더 영역 -->
`

export const Main_Tbl = Template.bind({});
Main_Tbl.args = {
   template: `
<div class="__KNSU-wrap__">
   ${header_str}
   <div id="vue_app" class="l_wrap">
      <!-- S: 메인 영역 -->
      <main id="content" class="l_main">
         <div class="main">
            <div class="main__header">
               <h2>제목</h2>
            </div>
            <div class="main__con">
               <div class="tbl-box t_h558">
                  <table class="tbl" id="id_tbMember_list">
                     <thead>
                        <tr>
                           <th>
                           </th>
                           <th><button class="s_descending" type="button" @click="">이름</button></th>
                           <th><button class="" type="button" @click="">학년</button></th>
                           <th>성별</th>
                        </tr>
                     </thead>
                     <tbody class="t_retirees">
                        <tr class="s_checked">
                           <td>
                              <div class="chek-box t_one">
                                 <input type="checkbox" id="id_chk_1" checked>
                                 <label for="id_chk_1"></label>
                              </div>
                              <label for="id_chk_1" class="t_cover"></label>
                           </td>
                           <th>test1</th>
                           <td>test2</td>
                           <td>test3</td>
                        </tr>
                        <tr>
                           <td>
                              <div class="chek-box t_one">
                                 <input type="checkbox" id="id_chk_2">
                                 <label for="id_chk_2"></label>
                              </div>
                              <label for="id_chk_2" class="t_cover"></label>
                           </td>
                           <th>test1</th>
                           <td>test2</td>
                           <td>test3</td>
                        </tr>
                        <tr>
                           <td>
                              <div class="chek-box">
                                 <input type="checkbox" id="id_chk_3">
                                 <label for="id_chk_3"></label>
                              </div>
                              <label for="id_chk_3" class="t_cover"></label>
                           </td>
                           <th>test1</th>
                           <td>test2</td>
                           <td>test3</td>
                        </tr>
                     </tbody>
                  </table>
               </div>

               <div class="main__con__paging">
                  <button type="button" @click="goPageFirst()"><strong class="ir-text">맨 앞으로</strong></button>
                  <button type="button" @click="goPagePrev()"><strong class="ir-text">이전</strong></button>
                  <ul class="clear">
                     <template v-if="page_max <= page_block">
                        <!-- 페이지 max값이 한번에 표시 할수 있는 숫자보다 작을때 -->
                        <li class="main__con__paging__list" v-for="(page, key) in page_max" :class="{s_on:page_no == page}"><button type="button" @click="goPage(page)">{{page}}</button></li>
                     </template>
                     <template v-else-if="page_s + page_block > page_max">
                        <!-- 제일 마지막 페이지 ( 페이지 max값까지의 count가 page_block 보다 작을때 )  -->
                        <li class="main__con__paging__list" v-for="(page, key) in page_max-(page_s-1)" :class="{s_on:page_no == page_s+(page-1)}"><button type="button" @click="goPage(page_s+(page-1))">{{page_s+(page-1)}}</button></li>
                     </template>
                     <template v-else>
                        <li class="main__con__paging__list" v-for="(page, key) in page_block" :class="{s_on:page_no == page_s+(page-1)}"><button type="button" @click="goPage(page_s+(page-1))">{{page_s+(page-1)}}</button></li>
                     </template>
                  </ul>
                  <button class="" type="button" @click="goPageNext()"><strong class="ir-text">다음</strong></button>
                  <button class="" type="button" @click="goPageLast()"><strong class="ir-text">맨 마지막으로</strong></button>
                  </button>
               </div>
            </div>
         </div>
      </main>
      <!-- E: 메인 영역 -->
      <!-- S: 모달창 영역 -->
      <!-- E: 모달창 영역 -->
   </div>
</div>
  `
};
