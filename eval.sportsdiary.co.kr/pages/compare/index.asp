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
      @page {
         size:297mm 210mm!important; /*A4*/
         margin:0!important;
      }
      body{padding:44px 32px!important;background:#F8F9FB;}
      .l_wrap{position:relative;display:block;width:100%;height:100%;background:#EAEDF3;}
      .m_header,
      .m_space,
      .m_tabs,
      .m_btn{display:none;}
      .m_select-box:before{display:none;}
      .m_compare{width:auto;}
      .l_main{z-index:9999;position:fixed;top:50%;left:50%;width:1200px;transform:translate(-50%, -50%) scale(calc(1122.52 / 1380));transform-origin:center;justify-content: center;background:#EAEDF3;}
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
            <h1 class="m_header__title">종목 비교평가</h1>
         </div>
         <div class="m_space">
            <div class="m_select-box">
               <select @change="handleChangeGun()" v-model="sel_gun">
                  <option v-for="gun_info in gun_list" :value="gun_info.eval_group_cd">{{gun_info.eval_group}}</option>
               </select>
            </div>
            <button @click="reqPrint()" class="m_btn m_space__right" type="button">
               <img src="/images/ico_print.svg" alt="">
               <span>출력하기</span>
            </button>
         </div>
         <div class="m_compare">
            <div class="m_compare__info">
               <div class="m_compare__header">
                  <div class="m_select-box">
                     <select @change="reqGroupList(E_POS_LEFT)" v-model="leftCompare_info.sel_eval">
                        <option v-for="eval_info in eval_list" :value="eval_info.eval_table_idx">{{eval_info.eval_title}}</option>
                     </select>
                  </div>
                  <div class="m_select-box">
                     <select @change="handleChangeGroup(E_POS_LEFT)" v-model="leftCompare_info.sel_group">
                        <option :value="null">종목 선택</option>
                        <option v-for="group_info in getSetGroupList(leftCompare_info)" :value="group_info.association_idx">{{group_info.association_name}}</option>
                     </select>
                  </div>
               </div>
               <template v-if="leftCompare_info.statistics_list.length !== 0">
                  <h2 class="ir">{{getSetGroupInfo(leftCompare_info) && getSetGroupInfo(leftCompare_info).association_name}}</h2>
                  <ol>
                     <li v-for="statistics_info in leftCompare_info.statistics_list" class="m_compare-list">
                        <h3 class="m_compare-list__title">{{statistics_info.eval_cate_order}}.{{statistics_info.eval_cate}}({{statistics_info.base_point}})</h3>
                        <div class="m_compare-list__con">
                           <strong class="m_compare-list__score">
                              <em class="m_compare-list__num m_compare-list__num--left">{{statistics_info.point_assoc}}</em> 점
                           </strong>
                           <span class="m_compare-list__text">({{statistics_info.percent_assoc}}/100)</span>
                        </div>
                     </li>
                     <li v-if="leftCompare_info.deduct_info" class="m_compare-list">
                        <h3 class="m_compare-list__title">{{leftCompare_info.deduct_info.eval_item}}</h3>
                        <div class="m_compare-list__con">
                           <strong class="m_compare-list__score">
                              <em v-if="leftCompare_info.deduct_info && leftCompare_info.deduct_info.subtract_point !== '0'" class="m_compare-list__num m_compare-list__num m_compare-list__num--deduct">-{{leftCompare_info.deduct_info.subtract_point}}</em>
                              <em v-else class="m_compare-list__num m_compare-list__num m_compare-list__num--deduct">0</em>
                               점
                           </strong>
                        </div>
                     </li>
                  </ol>
               </template>
            </div>
            <div class="m_compare__chart">
               <canvas v-show="leftCompare_info.statistics_list.length !== 0 || rightCompare_info.statistics_list.length !== 0" id="compareChart" width="362" height="340"></canvas>
            </div>
            <div class="m_compare__info">
               <div class="m_compare__header">
                  <div class="m_select-box">
                     <select @change="reqGroupList(E_POS_RIGHT)" v-model="rightCompare_info.sel_eval">
                        <option v-for="eval_info in eval_list" :value="eval_info.eval_table_idx">{{eval_info.eval_title}}</option>
                     </select>
                  </div>
                  <div class="m_select-box">
                     <select @change="handleChangeGroup(E_POS_RIGHT)" v-model="rightCompare_info.sel_group">
                        <option :value="null">종목 선택</option>
                        <option v-for="group_info in getSetGroupList(rightCompare_info)" :value="group_info.association_idx">{{group_info.association_name}}</option>
                     </select>
                  </div>
               </div>
               <template v-if="rightCompare_info.statistics_list.length !== 0">
                  <h2 class="ir">{{getSetGroupInfo(rightCompare_info) && getSetGroupInfo(rightCompare_info).association_name}}</h2>
                  <ol>
                     <li v-for="statistics_info in rightCompare_info.statistics_list" class="m_compare-list">
                        <h3 class="m_compare-list__title">{{statistics_info.eval_cate_order}}.{{statistics_info.eval_cate}}({{statistics_info.base_point}})</h3>
                        <div class="m_compare-list__con">
                           <strong class="m_compare-list__score">
                              <em class="m_compare-list__num m_compare-list__num--right">{{statistics_info.point_assoc}}</em> 점
                           </strong>
                           <span class="m_compare-list__text">({{statistics_info.percent_assoc}}/100)</span>
                        </div>
                     </li>
                     <li v-if="rightCompare_info.deduct_info" class="m_compare-list">
                        <h3 class="m_compare-list__title">{{rightCompare_info.deduct_info.eval_item}}</h3>
                        <div class="m_compare-list__con">
                           <strong class="m_compare-list__score">
                              <em v-if="rightCompare_info.deduct_info && rightCompare_info.deduct_info.subtract_point !== '0'" class="m_compare-list__num m_compare-list__num m_compare-list__num--deduct">-{{rightCompare_info.deduct_info.subtract_point}}</em>
                              <em v-else class="m_compare-list__num m_compare-list__num m_compare-list__num--deduct">0</em>
                               점
                           </strong>
                        </div>
                     </li>
                  </ol>
               </template>
            </div>
            <div v-if="leftCompare_info.statistics_list.length === 0 && rightCompare_info.statistics_list.length === 0" class="m_compare__no-contents">
               종목을 선택하시면 선택한 종목의 비교 데이터 조회가 가능합니다.
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
