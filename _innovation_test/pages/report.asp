<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/innovation_test/include/head.asp"-->
      <script defer src="/innovation_test/js/pages/report.js<%=P_REPORT_VER%>"></script>
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
               <button @click="history.back()" type="button" class="l_header__btn-back">이전</button>
               <span class="l_header__title">평가보고서</span>
            </header>
            <!-- E: 헤더 영역 -->
            <div class="l_main__con t_report">
               <div class="m_report">
                  <div class="m_report__header">
                     <h1 class="m_report__header__title">대한축구협회 결과보고서</h1>
                  </div>
                  <div class="m_report__con t_col-1">
                     <h2 class="m_report__con__title">대한축구협회 주요사항</h2>
                     <div class="m_report__con__main t_cover">
                        <p>대한축구협회의 주요 업적 및 사업 내용은 다음과 같다</p>
                     </div>
                  </div>
                  <div class="m_report__con t_col-1">
                     <h2 class="m_report__con__title">혁신평가 총점</h2>
                     <div class="m_report__con__chart">
                        <canvas id="totalChart" width="413" height="292"></canvas>
                     </div>
                  </div>
                  <div class="m_report__con">
                     <h2 class="m_report__con__title">지표별 원점수</h2>
                     <div class="m_report__con__charts">
                        <div class="m_report__con__charts__chart t_col-3">
                           <h3 class="m_report__con__charts__chart__title">비전전략(15)</h3>
                           <canvas id="typeChart1" width="275" height="200"></canvas>
                        </div>
                        <div class="m_report__con__charts__chart t_col-3">
                           <h3 class="m_report__con__charts__chart__title">조직운영(20)</h3>
                           <canvas id="typeChart2" width="275" height="200"></canvas>
                        </div>
                        <div class="m_report__con__charts__chart t_col-3">
                           <h3 class="m_report__con__charts__chart__title">주요사업(40)</h3>
                           <canvas id="typeChart3" width="275" height="200"></canvas>
                        </div>
                        <div class="m_report__con__charts__chart t_col-3">
                           <h3 class="m_report__con__charts__chart__title">단체자율성(15)</h3>
                           <canvas id="typeChart4" width="275" height="200"></canvas>
                        </div>
                        <div class="m_report__con__charts__chart t_col-3">
                           <h3 class="m_report__con__charts__chart__title">인권 및 윤리(10)</h3>
                           <canvas id="typeChart5" width="275" height="200"></canvas>
                        </div>
                     </div>
                  </div>
                  <div class="m_report__con">
                     <h2 class="m_report__con__title">총 평</h2>
                     <div class="m_report__con__main">
                        <p>-대한축구협회를 보게 되면 전체적으로 평균보다 높게 나타났음을 알 수 있다. <br>-대한축구협회는 인권 및 윤리 부분에서 낮게 나타났음을 알 수 있다. <br>-대한축구협회는 79개 종목단체 중 5등으로 나타났으며, 가군 종목단체 17개 종목단체 중 3등으로 나타났다.</p>
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
