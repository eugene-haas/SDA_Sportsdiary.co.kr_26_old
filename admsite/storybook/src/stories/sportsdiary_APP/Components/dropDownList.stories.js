import {withKnobs, text, boolean} from "@storybook/addon-knobs";
export default {
   title: 'sportsdiary_APP/Style/components/dropDownList',
   decorators: [withKnobs],
   parameters: {
      componentSubtitle: '펼쳐지는 리스트'
   },
   argTypes: {
    label: {
      description: '펼쳐지는 리스트입니다.',
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
      <div class="m_drop-down_list">
         <h2 class="ir">참가자 명단</h2>
         <ul>
            <li class="m_drop-down_list__list s_open">
               <div class="m_drop-down_list__list__header">
                  <h3 class="m_drop-down_list__list__header__title">남자 단체전 대학부</h3>
                  <span class="m_drop-down_list__list__header__sub">Total <strong>23</strong> 팀</span>
                  <button class="m_drop-down_list__list__header__more" type="button">상세보기</button>
               </div>
               <div class="m_drop-down_list__list__con" style="height:100px;">
                  <!-- (thead => 24px / tbody>tr => 34*n) -->
                  <div class="m_tbl-simple">
                     <table>
                        <thead class="m_tbl-simple__thead">
                           <tr>
                              <th>번호</th>
                              <th>소속</th>
                              <th></th>
                           </tr>
                        </thead>
                        <tbody class="m_tbl-simple__tbody">
                           <tr>
                              <td>1</td>
                              <th>공주대학교</th>
                              <td>
                                 <a href="#a">
                                    <img src="" alt="새창열기">
                                 </a>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
            </li>
            <li class="m_drop-down_list__list">
               <div class="m_drop-down_list__list__header">
                  <h3 class="m_drop-down_list__list__header__title">남자 단체전 대학부</h3>
                  <span class="m_drop-down_list__list__header__sub">Total <strong>23</strong> 팀</span>
                  <button class="m_drop-down_list__list__header__more" type="button">상세보기</button>
               </div>
               <div class="m_drop-down_list__list__con">
                  <div class="m_tbl-simple">
                     <table>
                        <thead>
                           <tr>
                              <th>번호</th>
                              <th>소속</th>
                              <th></th>
                           </tr>
                        </thead>
                        <tbody>
                           <tr>
                              <td>1</td>
                              <th>공주대학교</th>
                              <td>
                                 <a href="#a">
                                    <img src="" alt="새창열기">
                                 </a>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
            </li>
            <li class="m_drop-down_list__list">
               <div class="m_drop-down_list__list__header">
                  <h3 class="m_drop-down_list__list__header__title">남자 단체전 대학부</h3>
                  <span class="m_drop-down_list__list__header__sub">Total <strong>23</strong> 팀</span>
                  <button class="m_drop-down_list__list__header__more" type="button">상세보기</button>
               </div>
               <div class="m_drop-down_list__list__con">
                  <div class="m_tbl-simple">
                     <table>
                        <thead>
                           <tr>
                              <th>번호</th>
                              <th>소속</th>
                              <th></th>
                           </tr>
                        </thead>
                        <tbody>
                           <tr>
                              <td>1</td>
                              <th>공주대학교</th>
                              <td>
                                 <a href="#a">
                                    <img src="" alt="새창열기">
                                 </a>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
            </li>
            <li class="m_drop-down_list__list">
               <div class="m_drop-down_list__list__header">
                  <h3 class="m_drop-down_list__list__header__title">남자 단체전 대학부</h3>
                  <span class="m_drop-down_list__list__header__sub">Total <strong>23</strong> 팀</span>
                  <button class="m_drop-down_list__list__header__more" type="button">상세보기</button>
               </div>
               <div class="m_drop-down_list__list__con">
                  <div class="m_tbl-simple">
                     <table>
                        <thead>
                           <tr>
                              <th>번호</th>
                              <th>소속</th>
                              <th></th>
                           </tr>
                        </thead>
                        <tbody>
                           <tr>
                              <td>1</td>
                              <th>공주대학교</th>
                              <td>
                                 <a href="#a">
                                    <img src="" alt="새창열기">
                                 </a>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
            </li>
            <li class="m_drop-down_list__list">
               <div class="m_drop-down_list__list__header">
                  <h3 class="m_drop-down_list__list__header__title">남자 단체전 대학부</h3>
                  <span class="m_drop-down_list__list__header__sub">Total <strong>23</strong> 팀</span>
                  <button class="m_drop-down_list__list__header__more" type="button">상세보기</button>
               </div>
               <div class="m_drop-down_list__list__con">
                  <div class="m_tbl-simple">
                     <table>
                        <thead>
                           <tr>
                              <th>번호</th>
                              <th>소속</th>
                              <th></th>
                           </tr>
                        </thead>
                        <tbody>
                           <tr>
                              <td>1</td>
                              <th>공주대학교</th>
                              <td>
                                 <a href="#a">
                                    <img src="" alt="새창열기">
                                 </a>
                              </td>
                           </tr>
                        </tbody>
                     </table>
                  </div>
               </div>
            </li>
         </ul>
      </div>
  `
};
