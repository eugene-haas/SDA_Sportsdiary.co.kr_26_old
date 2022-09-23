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
            <h1 class="m_header__title">
               평가보고서
               <template v-if="isAuthD">
                  - {{Header.user_info.aGrpNM}}
               </template>
            </h1>
         </div>
         <div class="m_space">
            <div class="m_select-box">
               <select @change="reqOptionData()" v-model="sel_eval">
                  <option v-for="eval_info in eval_list" :value="eval_info.eval_table_idx">{{eval_info.eval_title}}</option>
               </select>
            </div>
            <div v-if="!isAuthD" class="m_select-box">
               <select @change="handleChangeGun()" v-model="sel_gun">
                  <option v-for="gun_info in gun_list" :value="gun_info.eval_group_cd">{{gun_info.eval_group}}</option>
               </select>
            </div>
            <div v-if="!isAuthD" class="m_select-box">
               <select @change="reqReportData()"  v-model="sel_group">
                  <option v-for="group_info in getSetGroupList" :value="group_info.association_idx">{{group_info.association_name}}</option>
               </select>
            </div>
            <button @click="reqPrint()" class="m_btn m_space__right" type="button">
               <img src="/images/ico_print.svg" alt="">
               <span>출력하기</span>
            </button>
         </div>
         <div class="m_report">
            <div class="m_report__header">
               <h1 class="m_report__title">{{getSelGroupInfo && getSelGroupInfo.association_name}} 결과보고서</h1>
            </div>
            <div class="m_report-deduct">
               <h2 class="m_report-deduct__title">공정 및 인권 위반 사례</h2>
               <div class="m_report-deduct__con">
                  <span class="m_report-deduct__unit"></span>
                  <strong v-if="group_info && group_info.subtract_point !== '0'" class="m_report-deduct__value">-{{group_info.subtract_point}}</strong>
                  <strong v-else class="m_report-deduct__value">0</strong>
                  <span class="m_report-deduct__unit">점</span>
               </div>
            </div>
            <div class="m_report-box">
               <h2 class="m_report-box__title">혁신평가 총점</h2>
               <div class="m_report-chart">
                  <canvas id="totalChart" width="413" height="292"></canvas>
               </div>
            </div>
            <div class="m_report-box">
               <h2 class="m_report-box__title">지표별 원점수</h2>
               <div class="m_report-charts">
                  <div v-for="(cate_info, cate_idx) in cate_list" class="m_report-charts__chart m_report-charts__chart--col-3">
                     <h3 class="m_report-charts__title">
                        {{cate_info.eval_cate}}({{getStatisticsBasePoint(cate_idx)}})
                     </h3>
                     <canvas :id="'cateChart'+cate_info.eval_cate_cd" width="275" height="200"></canvas>
                  </div>
               </div>
            </div>
            <div class="m_report-box">
               <h2 class="m_report-box__title">총 평</h2>
               <div class="m_report-box__main">
                  <textarea class="m_report-box__contents" :value="group_info && group_info.total_desc" readonly>
                  </textarea>
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
