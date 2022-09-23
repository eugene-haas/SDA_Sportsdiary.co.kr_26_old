<!--#include virtual="/score_board/include/asp_setting/index.asp"-->
<!--#include virtual="/score_board/include/ver.asp"-->
<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/score_board/include/head.asp"-->
      <script defer src="/score_board/js/pages/total.js<%=P_TOTAL_VER%>"></script>
      <%
         'Cookies_billBoard
         Set oJSONoutput = JSON.Parse( join(array(Cookies_billBoard)) )
         cda =  oJSONoutput.get("C_CDA")
         tidx = oJSONoutput.get("C_TIDX")
         tname = oJSONoutput.get("C_TNAME")
      %>
      <script>
         const g_page_props = {
            cda:"<%=cda%>",
            tidx:"<%=tidx%>",
            tname:"<%=tname%>",
         };
      </script>
   </head>
   <body>
      <!--#include virtual="/score_board/include/body_before.asp"-->
      <div class="l_wrap">
         <!-- S: 메인 영역 -->
         <main id="app" class="l_main" v-clock>
            <h1 class="ir">스코어 종합</h1>
            <div @click="document.body.requestFullscreen()" class="m_fullscreen-guard">
               전체화면 보기
            </div>
            <div class="m_total-rank">
               <div class="m_total-rank__header">
                  <template v-if="header_info">
                     {{header_info.CDCNM}} / {{header_info.CDBNM}}
                  </template>
               </div>
               <table>
                  <thead>
                     <tr>
                        <th width="120px">Rank</th>
                        <th>Team</th>
                        <th width="240px">Name</th>
                        <th width="191px">Total</th>
                        <th v-for="score in roundcnt" width="154px">{{score}}R</th>
                     </tr>
                  </thead>
                  <tbody ref="tblTbody" name="list-fade" is="transition-group">
                     <tr v-for="(info, info_idx) in player_list" :key="info_idx">
                        <template v-if="info === null">
                           <td></td>
                           <td></td>
                           <td></td>
                           <td></td>
                           <td v-for="score in roundcnt"></td>
                        </template>
                        <template v-else>
                           <td>
                              <span v-if="info.ranking" class="m_total-rank__ranking">{{info.ranking}}</span>
                              <span v-else>-</span>
                           </td>
                           <td>{{info.team}}</td>
                           <td>{{info.name.split(',').join(', ')}}</td>
                           <td><strong class="m_total-rank__total-score">{{Number(info.record) / 100}}</strong></td>
                           <td v-for="score in Number(info.roundcnt)">{{Number(info.roundscore.split(',')[score-1]) / 100}}</td>
                        </template>
                     </tr>
                  </tbody>
               </table>
            </div>


            <!-- S: 모달창 영역 -->
            <!-- <section class="l_modal">
               <div class="l_modal__con">

               </div>
            </section> -->
            <!-- E: 모달창 영역 -->
         </main>
         <!-- E: 메인 영역 -->
         <!-- S: 공통 모달창 영역 -->
         <!--#include virtual="/score_board/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/score_board/include/body_after.asp"-->
   </body>
</html>
