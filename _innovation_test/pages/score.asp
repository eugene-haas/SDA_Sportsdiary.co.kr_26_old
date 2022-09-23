<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/innovation_test/include/head.asp"-->
      <script defer src="/innovation_test/js/pages/score.js<%=P_SCORE_VER%>"></script>
      <script>
         const g_page_props = {
            // hideBack: true
         };
      </script>
   </head>
   <body>
      <!--#include virtual="/innovation_test/include/body_before.asp"-->
      <div class="l_wrap">
         <!-- S: 메인 영역 -->
         <main id="app" class="l_main" v-clock>
            <!-- s: 헤더 영역 -->
            <header class="l_header">
               <button @click="sel_group === null?window.location.replace('/innovation_test/index.asp'):sel_group=null" type="button" class="l_header__btn-back">이전</button>
               <!-- <button @click="sel_group === null?window.location = '/innovation_test/index.asp':sel_group=null" type="button" class="l_header__btn-back">이전</button> -->
               <nav class="l_header__nav">
                  <button class="l_header__nav__btn s_on" type="button">
                     <strong class="l_header__nav__btn__title">가</strong>군
                  </button>
                  <button class="l_header__nav__btn" type="button">
                     <strong class="l_header__nav__btn__title">나</strong>군
                  </button>
                  <button class="l_header__nav__btn" type="button">
                     <strong class="l_header__nav__btn__title">다</strong>군
                  </button>
                  <button class="l_header__nav__btn" type="button">
                     <strong class="l_header__nav__btn__title">라</strong>군
                  </button>
                  <button class="l_header__nav__btn" type="button">
                     <strong class="l_header__nav__btn__title">마</strong>군
                  </button>
               </nav>
               <button @click="window.location = '/innovation_test/pages/report_compare.asp'" class="l_header__btn-compare" type="button">
                  비교분석
               </button>
            </header>
            <!-- E: 헤더 영역 -->
            <div class="l_main__con">
               <ul v-show="sel_group === null" class="m_sel-group">
                  <li v-for="(name, idx) in group_list" class="m_sel-group__list">
                     <button @click="reqGroup(idx)" class="m_sel-group__list__btn" type="button">
                        {{name}}
                     </button>
                  </li>
               </ul>
               <div v-show="sel_group !== null" class="m_score">
                  <div class="m_score__header">
                     <h1 class="m_score__header__title">대한축구협회</h1>
                     <div class="m_score__header__tabs">
                        <button v-for="(tab, tab_idx) in tab_list" @click="handleChangeTab(tab.value)" :class="{s_on: sel_tab === tab.value}" class="m_score__header__tabs__btn" type="button">
                           <template v-if="tab_idx !== 0">
                              {{tab_idx}}.
                           </template>
                           {{STRMAP_TYPE[tab.value]}}
                        </button>
                        <span :style="{transform: 'translate(' + (sel_tab*100) + '%, 0)'}" class="m_score__header__tabs__active-bar"></span>
                     </div>
                  </div>
                  <div class="m_score__con">
                     <div class="m_score__con__tbl">
                        <table>
                           <thead>
                              <tr>
                                 <th colspan="2" width="40%">평가항목</th>
                                 <th>획득점수</th>
                                 <th>가군평균</th>
                                 <th>전체평균</th>
                              </tr>
                           </thead>
                           <tbody>
                              <tr v-for="(info, info_idx) in getRes.cnt_list">
                                 <td>{{info_idx + 1}}. </td>
                                 <td class="t_title" v-if="sel_tab === E_TYPE_ALL"><em>{{STRMAP_TYPE[info.type]}}</em>({{STRMAP_TYPE_SCORE[info.type]}})</td>
                                 <td class="t_title" v-else><em>{{STRMAP_TYPE_BUSINESS[info.type]}}</em>({{STRMAP_TYPE_BUSINESS_SCORE[info.type]}})</td>
                                 <td>
                                    <strong>
                                       <em class="t_blue">{{info.score}}</em>점
                                    </strong>
                                    <span>({{info.subScore}}/100)</span>
                                 </td>
                                 <td>
                                    <strong>
                                       <em class="t_orange">{{info.gunScore}}</em>점
                                    </strong>
                                    <span>({{info.subGunScore}}/100)</span>
                                 </td>
                                 <td>
                                    <strong>
                                       <em>{{info.totalScore}}</em>점
                                    </strong>
                                    <span>({{info.subTotalScore}}/100)</span>
                                 </td>
                              </tr>
                           </tbody>
                        </table>
                     </div>
                     <div class="m_score__con__view">
                        <div v-show="sel_tab === 0" class="m_score__con__view__chart-all">
                           <canvas width="400" height="400" id="totalChart"></canvas>
                        </div>
                        <div v-show="sel_tab !== 0" class="m_score__con__view__chart">
                           <div class="m_score__con__view__chart__legends">
                              <dl class="m_score__con__view__chart__legends__info">
                                 <dt class="m_score__con__view__chart__legends__info__head">대한축구협회</dt>
                                 <dd class="m_score__con__view__chart__legends__info__body">
                                    <span class="ir">파란색</span>
                                 </dd>
                              </dl>
                              <dl class="m_score__con__view__chart__legends__info">
                                 <dt class="m_score__con__view__chart__legends__info__head">가군평균</dt>
                                 <dd class="m_score__con__view__chart__legends__info__body">
                                    <span class="ir">파란색</span>
                                 </dd>
                              </dl>
                              <dl class="m_score__con__view__chart__legends__info">
                                 <dt class="m_score__con__view__chart__legends__info__head">전체평균</dt>
                                 <dd class="m_score__con__view__chart__legends__info__body">
                                    <span class="ir">파란색</span>
                                 </dd>
                              </dl>
                           </div>
                           <div class="m_score__con__view__chart__con">
                              <canvas width="200" height="200" id="detailChart01"></canvas>
                           </div>
                           <div class="m_score__con__view__chart__con">
                              <canvas width="200" height="200" id="detailChart02"></canvas>
                           </div>
                           <div class="m_score__con__view__chart__con t_bar">
                              <canvas width="450" height="150" id="detailBarChart"></canvas>
                              <table>
                                 <thead>
                                    <tr>
                                       <th width="12.5%"><span>적정성(5)</span></th>
                                       <th width="12.5%"><span>성과 및 관리(7)</span></th>
                                       <th width="12.5%"><span>적정성(7)</span></th>
                                       <th width="12.5%"><span>성과 및 관리(11)</span></th>
                                       <th width="12.5%"><span>적정성(2)</span></th>
                                       <th width="12.5%"><span>성과 및 관리(3)</span></th>
                                       <th width="12.5%"><span>적정성(3)</span></th>
                                       <th width="12.5%"><span>성과 및 관리(2)</span></th>
                                    </tr>
                                    <tr>
                                       <th colspan="2">생활체육 활성화(12점)</th>
                                       <th colspan="2">전문체육 활성화(18점)</th>
                                       <th colspan="2">학교체육 활성화(5점)</th>
                                       <th colspan="2">선순환체계(5점)</th>
                                    </tr>
                                 </thead>
                              </table>
                           </div>
                        </div>
                     </div>
                  </div>
               </div>
               <div class="l_main__con__btns">
                  <button @click="window.location = '/innovation_test/pages/report.asp'" class="l_main__con__btns__btn" type="button">
                     <img src="/innovation_test/images/ico_report.svg" alt="">
                     평가보고서
                  </button>
                  <button @click="window.location = '/innovation_test/pages/compare.asp'" class="l_main__con__btns__btn t_white" type="button">
                     <img src="/innovation_test/images/ico_compare.svg" alt="">
                     평가 비교
                  </button>
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
         <!--#include virtual="/innovation_test/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/innovation_test/include/body_after.asp"-->
   </body>
</html>
