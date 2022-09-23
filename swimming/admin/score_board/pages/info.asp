<!--#include virtual="/score_board/include/asp_setting/index.asp"-->
<!--#include virtual="/score_board/include/ver.asp"-->
<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/score_board/include/head.asp"-->
      <script defer src="/score_board/js/pages/info.js<%=P_INFO_VER%>"></script>
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
            <h1 class="ir">라운드 정보</h1>
            <div @click="document.body.requestFullscreen()" class="m_fullscreen-guard">
               전체화면 보기
            </div>
            <div class="m_round-info" v-if="player_info">
               <div class="m_round-info__header">
                  <strong class="m_round-info__header__round">{{player_info.roundno}}</strong>
                  <div class="m_round-info__header__group-info">
                     <span class="m_round-info__header__group-info__text">{{player_info.CDBNM}}</span>
                     <span class="m_round-info__header__group-info__text t_blue">{{player_info.CDCNM}}</span>
                  </div>
               </div>
               <div class="m_round-info__con">
                  <span class="m_round-info__con__order"><strong class="m_round-info__con__order__num">{{player_info.orderno}}</strong>번</span>
                  <div class="m_round-info__con__name">
                     <span class="m_round-info__con__name__title">{{player_info.names}}</span>
                     <span class="m_round-info__con__name__team">{{player_info.team}}</span>
                  </div>
                  <div class="m_round-info__con__info" :class="{'t_no-score': isBeforeStart === true}">
                     <span class="m_round-info__con__info__diff-num">{{player_info.div_divdifficulty}}</span>
                     <span class="m_round-info__con__info__dive-num">{{player_info.div_divno}}{{player_info.div_posture}}</span>
                  </div>
               </div>
               <div v-show="isBeforeStart === false" class="m_round-info__score">
                  <ul class="m_round-info__score__list-wrap">
                     <li v-for="judge in Number(player_info.judgecnt)" class="m_round-info__score__list">{{Number(player_info["jumsu" + judge]) / 10}}</li>
                  </ul>
                  <div class="m_round-info__score__total">
                     <span class="m_round-info__score__total__text">{{Number(player_info.roundscore) / 100}}</span>
                  </div>
               </div>
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
