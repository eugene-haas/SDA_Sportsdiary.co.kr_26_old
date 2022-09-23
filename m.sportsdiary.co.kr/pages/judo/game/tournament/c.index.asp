<div class="m_tabs">
   <h2 class="ir">대진표 타입 선택</h2>
   <button class="m_tabs__tab" :class="{
      'm_tabs__tab--active': true
   }" type="button">대진표 보기</button>
   <button class="m_tabs__tab" type="button">리스트 보기</button>
</div>
<h2 class="ir">메달 결과</h2>
<ol class="m_medal">
   <li>
      <h3>박제동</h3>
   </li>
</ol>
<div class="m_tournament l_main__flex-1">
   <h2 class="ir">대진표</h2>
   <div v-if="false" class="m_league">
      <table>
         <thead>
            <tr>
               <th>제1조</th>
               <th v-for="info in player_list">{{info.user_name}}</th>
               <th>결과</th>
               <th>순위</th>
            </tr>
         </thead>
         <tbody>
            <tr v-for="info in player_list">
               <th>{{info.user_name}}</th>
               <th v-for="inner_info in player_list">
                  <template v-if="info.playerIdx !== inner_info.playerIdx">
                     {{info.user_name}} vs {{inner_info.user_name}}
                  </template>
                  <template v-else>
                     no match
                  </template>
               </th>
               <td>{{info.win_cnt}}</td>
               <td>{{info.ranking}}</td>
            </tr>
         </tbody>
      </table>
   </div>
   <div v-if="true" ref="Tournament" class="m_tournament__con">
      <ol>
         <li class="m_tour-list t_left">
            <ol class="m_tour-list__con">
               <li class="m_tour-list">
                  <ol class="m_tour-list__con">
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                  </ol>
                  <div class="m_tour-list__header">
                     1
                  </div>
               </li>
               <li class="m_tour-list">
                  <ol class="m_tour-list__con">
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                  </ol>
                  <div class="m_tour-list__header">
                     2
                  </div>
               </li>
            </ol>
            <div class="m_tour-list__header">
               5
            </div>
         </li>
         <li class="m_tour-list t_right">
            <ol class="m_tour-list__con">
               <li class="m_tour-list">
                  <ol class="m_tour-list__con">
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                  </ol>
                  <div class="m_tour-list__header">
                     3
                  </div>
               </li>
               <li class="m_tour-list">
                  <ol class="m_tour-list__con">
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                     <li class="m_tour-list">
                        <div class="m_tour-list__player">

                        </div>
                     </li>
                  </ol>
                  <div class="m_tour-list__header">
                     4
                  </div>
               </li>
            </ol>
            <div class="m_tour-list__header">
               6
            </div>
         </li>
      </ol>
      <div class="m_tournament__con__main">
         7
      </div>
   </div>
</div>
<!-- S: 모달창 영역 -->
<!-- <section class="l_modal-layer" :class="{s_show: madal_gameInfo.show}">
   <div class="l_modal t_top">
      <div class="l_modal__header">
         <h1></h1>
         <button type="button"></button>
      </div>
      <div class="l_modal__con">

      </div>
   </div>
</section> -->
<!-- E: 모달창 영역 -->
