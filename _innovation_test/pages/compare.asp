<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/innovation_test/include/head.asp"-->
      <script defer src="/innovation_test/js/pages/compare.js<%=P_COMPARE_VER%>"></script>
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
            <header class="l_header t_compare">
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
               <button onclick="history.back()" type="button" class="l_header__btn-close">닫기</a>
            </header>
            <!-- E: 헤더 영역 -->
            <div class="l_main__con">
               <div class="m_compare">
                  <div class="m_compare__header">
                     <h1 class="m_compare__header__title">평가 비교</h1>
                     <span class="m_compare__header__noti">2021년 7월 기준</span>
                  </div>
                  <div class="m_compare__con">
                     <div class="m_compare__con__info">
                        <div class="m_compare__con__info__sel-group">
                           <select v-model="sel_group_l" @change="handleChangeSelGroup()">
                              <option :value="null">종목 선택</option>
                              <option :value="1">대한축구협회</option>
                              <option :value="2">대한야구소프트볼협회</option>
                           </select>
                        </div>
                        <template v-if="sel_group_l !== null && sel_group_r !== null">
                           <h2 class="ir">{{getResLeft.name}}</h2>
                           <ol>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">1.비전전략(15)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_blue">{{getResLeft.score1}}</em> 점</strong>
                                    <span>({{getResLeft.sub1}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">2.조직운영(20)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_blue">{{getResLeft.score2}}</em> 점</strong>
                                    <span>({{getResLeft.sub2}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">3.주요사업(40)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_blue">{{getResLeft.score3}}</em> 점</strong>
                                    <span>({{getResLeft.sub3}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">4.단체자율성(15)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_blue">{{getResLeft.score4}}</em> 점</strong>
                                    <span>({{getResLeft.sub4}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">5.인권 및 윤리(10)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_blue">{{getResLeft.score5}}</em> 점</strong>
                                    <span>({{getResLeft.sub5}}/100)</span>
                                 </div>
                              </li>
                           </ol>
                        </template>
                     </div>
                     <div class="m_compare__con__chart">
                        <canvas v-show="sel_group_l !== null && sel_group_r !== null" id="compareChart" width="362" height="340"></canvas>
                     </div>
                     <div class="m_compare__con__info">
                        <div class="m_compare__con__info__sel-group">
                           <select v-model="sel_group_r" @change="handleChangeSelGroup()">
                              <option :value="null">종목 선택</option>
                              <option :value="1">대한축구협회</option>
                              <option :value="2">대한야구소프트볼협회</option>
                           </select>
                        </div>
                        <template v-if="sel_group_l !== null && sel_group_r !== null">
                           <h2 class="ir">{{getResRight.name}}</h2>
                           <ol>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">1.비전전략(15)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_orange">{{getResRight.score1}}</em> 점</strong>
                                    <span>({{getResRight.sub1}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">2.조직운영(20)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_orange">{{getResRight.score2}}</em> 점</strong>
                                    <span>({{getResRight.sub2}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">3.주요사업(40)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_orange">{{getResRight.score3}}</em> 점</strong>
                                    <span>({{getResRight.sub3}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">4.단체자율성(15)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_orange">{{getResRight.score4}}</em> 점</strong>
                                    <span>({{getResRight.sub4}}/100)</span>
                                 </div>
                              </li>
                              <li class="m_compare__con__info__list">
                                 <h3 class="m_compare__con__info__list__title">5.인권 및 윤리(10)</h3>
                                 <div class="m_compare__con__info__list__con">
                                    <strong><em class="t_orange">{{getResRight.score5}}</em> 점</strong>
                                    <span>({{getResLeft.sub5}}/100)</span>
                                 </div>
                              </li>
                           </ol>
                        </template>
                     </div>
                     <div v-if="sel_group_l === null || sel_group_r === null" class="m_compare__con__no-contents">
                        종목을 선택하시면 선택한 종목의 비교 데이터 조회가 가능합니다.
                     </div>
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
         <!--#include virtual="/innovation_test/include/modal.asp"-->
         <!-- E: 공통 모달창 영역 -->
      </div>
      <!--#include virtual="/innovation_test/include/body_after.asp"-->
   </body>
</html>
