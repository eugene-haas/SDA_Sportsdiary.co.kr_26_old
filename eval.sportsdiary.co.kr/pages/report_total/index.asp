<!--#include virtual="/include/asp_setting/index.asp"-->

<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/include/head.asp"-->
   <script defer src="./index.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
   <script>
      const g_page_props = {
      };
   </script>
   <style type="text/css" media="print">
      .l_main{background:#fff!important;}
   </style>
</head>

<body>
   <!--#include virtual="/include/body_before.asp"-->
   <div class="l_wrap">
      <!-- S: 네비게이션 영역 -->
      <!--#include virtual="/include/nav.asp"-->
      <!-- E: 네비게이션 영역 -->
      <!-- S: 헤더 영역 -->
      <!--#include virtual="/include/header.asp"-->
      <!-- E: 헤더 영역 -->
      <!-- S: 메인 영역 -->
      <main id="app" class="l_main" v-clock>
         <div class="m_header">
            <h1 class="m_header__title">종목군 종합 평가</h1>
         </div>
         <div class="m_space">
            <div class="m_select-box">
               <select @change="reqEvalData()" v-model="sel_eval">
                  <option v-for="eval_info in eval_list" :value="eval_info.eval_table_idx">{{eval_info.eval_title}}</option>
               </select>
            </div>
            <button @click="window.print();" class="m_btn m_space__right" type="button">
               <img src="/images/ico_print.svg" alt="">
               <span>출력하기</span>
            </button>
         </div>
         <div class="m_report">
            <div class="m_report__header">
               <h1 class="m_report__title">
                  {{getSelEvalInfo && getSelEvalInfo.eval_title}} / 종목군 종합 평가
               </h1>
            </div>
            <div class="m_report-box">
               <h2 class="m_report-box__title">군별 비교분석</h2>
               <div class="m_report-view">
                  <div class="m_report-view__con">
                     <h2 class="m_report-view__title">종합</h2>
                     <canvas id="totalChart" class="m_report-view__chart" width="360" height="260"></canvas>
                  </div>
                  <div v-for="cate_info in cate_list" class="m_report-view__con">
                     <h2 class="m_report-view__title">{{cate_info.eval_cate}}({{cate_info.base_point}})</h2>
                     <canvas :id="'cateChart'+cate_info.eval_cate_cd" width="360" height="250"></canvas>
                  </div>
                  <div class="m_report-view__con m_report-view__con--deduct">
                     <h2 class="m_report-view__title">공정 및 인권 위반 사례(-α)</h2>
                     <canvas id="deductChart" class="m_report-view__chart" width="844" height="180"></canvas>
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
      <!--#include virtual="/include/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/include/body_after.asp"-->
</body>

</html>
