<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/game_manager/include/head.asp"-->
      <script defer src="/game_manager/js/pages/list.js<%=P_LIST_VER%>"></script>
      <script>
         const g_page_props = {
            hideBack: true
         };
      </script>
   </head>
   <body>
      <!--#include virtual="/game_manager/include/body_before.asp"-->
      <div class="l_wrap">
         <object class="l_wrap__bg-wave" type="image/svg+xml" data="/game_manager/images/bg_wave.svg">
         </object>
         <!-- s: 헤더 영역 -->
         <!--#include virtual="/game_manager/include/header.asp"-->
         <!-- E: 헤더 영역 -->
         <!-- S: 메인 영역 -->
         <main id="app" class="l_main" v-clock>
            <header class="m_header">
               <h2 class="m_header__title">{{header.user_info && header.user_info.C_CDANM}}</h2>
               <span class="m_header__text">{{ now_date | dateFormat('yyyy-MM-dd') }}</span>
            </header>
            <div class="m_tbl-match">
               <table>
                  <tbody>
                     <tr v-for="(match, match_idx) in match_list">
                        <td>{{match.gameno}}</td>
                        <td class="t_title"><span :class="'m_match-type t_'+STRMAP_CDC_CODE[Number(match.CDC)]" >{{STRMAP_CDCICON[match.CDCICON]}}</span>{{match.CDCNM}}</td>
                        <td class="t_title">
                           <span class="m_tbl-match__text-wrap">{{match.CDBNM}}</span>
                        </td>
                        <td>
                           <button v-if="match_idx === 0" @click="goInput(match)" class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <!-- <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button @click="goInput()" class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr>
                     <tr class="t_platform-diving">
                        <td>1</td>
                        <td><span class="m_match-type t_S">S</span>스프링보오드</td>
                        <td>1M</td>
                        <td class="t_title">남자 유년부</td>
                        <td>
                           <button class="m_btn" type="button">심사하기</button>
                        </td>
                     </tr> -->
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
         <!--#include virtual="/game_manager/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/game_manager/include/body_after.asp"-->
   </body>
</html>
