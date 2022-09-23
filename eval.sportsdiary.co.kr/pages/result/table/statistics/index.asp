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
      .m_tabs,
      .m_btn{display:none;}
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
         <div class="m_header m_header--no-margin">
            <h1 class="m_header__title">통계 - {{init_obj.association_name}}</h1>
            <button @click="goList()" class="m_btn m_btn--primary" type="button">
               <img src="/images/ico_list.svg" alt="">
               평가지표 결과 보기
            </button>
            <button @click="reqPrint()" class="m_btn" type="button">
               <img src="/images/ico_print.svg" alt="">
               출력하기
            </button>
         </div>
         <div class="m_tabs">
            <button v-for="cate_info in getTabList" ref="tabs" @click="handleChangeTab(cate_info.eval_cate_cd)" class="m_tabs__btn" :class="{
             'm_tabs__btn--active': cate_info.eval_cate_cd === sel_cate,
                }" type="button">
                <span><template v-if="cate_info.eval_cate_cd !== E_TYPE_ALL">{{cate_info.eval_cate_order}}.</template>{{cate_info.eval_cate}}</span>
             </button>
            <span :style="tabBarStyle" class="m_tabs__active-bar"></span>
         </div>
         <div ref="chartWrap" class="m_statistics">
            <div ref="chartTbl" class="m_statistics-tbl">
               <table class="m_statistics-tbl__table">
                  <thead class="m_statistics-tbl__thead">
                     <tr>
                        <th class="m_statistics-tbl__title" colspan="2" width="40%">평가항목</th>
                        <th class="m_statistics-tbl__title">획득점수</th>
                        <th class="m_statistics-tbl__title">{{init_obj.eval_group}}군평균</th>
                        <th class="m_statistics-tbl__title">전체평균</th>
                     </tr>
                  </thead>
                  <tbody>
                     <tr v-if="sel_cate === E_TYPE_ALL" v-for="(cate_info, cate_idx) in cate_list">
                        <td class="m_statistics-tbl__td m_statistics-tbl__td--title">
                           <span class="m_statistics__text">
                              {{ cate_info.eval_cate_order }}.
                           </span>
                        </td>
                        <td class="m_statistics-tbl__td m_statistics-tbl__td--title">
                           <span class="m_statistics__text">
                              <strong class="m_statistics__text m_statistics__text--title">{{ cate_info.eval_cate }}</strong>
                              ({{ cate_info.base_point }})
                           </span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong class="m_statistics__text m_statistics__text--default">{{ cate_info.point_assoc }}</strong>
                              점
                           </span>
                           <span class="m_statistics__text m_statistics__text--sub">({{ cate_info.percent_assoc }}/100)</span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong class="m_statistics__text m_statistics__text--gun">{{ cate_info.point_group }}</strong>
                              점
                           </span>
                           <span class="m_statistics__text m_statistics__text--sub">({{ cate_info.percent_group }}/100)</span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong>{{ cate_info.point_total }}</strong>
                              점
                           </span>
                           <span class="m_statistics__text m_statistics__text--sub">({{ cate_info.percent_total }}/100)</span>
                        </td>
                     </tr>
                     <tr v-if="sel_cate === E_TYPE_ALL && deduct_info !== null">
                        <td colspan="2" class="m_statistics-tbl__td m_statistics-tbl__td--title">
                           <span class="m_statistics__text">
                              <strong class="m_statistics__text m_statistics__text--title">{{ deduct_info.eval_item }}</strong>
                           </span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong v-if="deduct_info && deduct_info.point_assoc !== '0'" class="m_statistics__text m_statistics__text--default">-{{ deduct_info.point_assoc }}</strong>
                              <strong v-else class="m_statistics__text m_statistics__text--default">0</strong>
                              점
                           </span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong v-if="deduct_info && deduct_info.point_group !== '0'" class="m_statistics__text m_statistics__text--gun">-{{ deduct_info.point_group }}</strong>
                              <strong v-else class="m_statistics__text m_statistics__text--gun">0</strong>
                              점
                           </span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong v-if="deduct_info && deduct_info.point_total !== '0'">-{{deduct_info.point_total}}</strong>
                              <strong v-else >0</strong>
                              점
                           </span>
                        </td>
                     </tr>
                     <tr v-else-if="getSelCateInfo !== null" v-for="(sub_info, sub_idx) in getSelCateInfo.subcate_list">
                        <td class="m_statistics-tbl__td m_statistics-tbl__td--title">
                           <span class="m_statistics__text">
                              {{ sub_info.eval_cate_order }}.{{ sub_info.eval_subcate_order }}
                           </span>
                        </td>
                        <td class="m_statistics-tbl__td m_statistics-tbl__td--title">
                           <span class="m_statistics__text">
                              <strong class="m_statistics__text m_statistics__text--title">{{ sub_info.eval_subcate }}</strong>
                              ({{ sub_info.base_point }})
                           </span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong class="m_statistics__text m_statistics__text--default">{{ sub_info.point_assoc }}</strong>
                              점
                           </span>
                           <span class="m_statistics__text m_statistics__text--sub">({{ sub_info.percent_assoc }}/100)</span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong class="m_statistics__text m_statistics__text--gun">{{ sub_info.point_group }}</strong>
                              점
                           </span>
                           <span class="m_statistics__text m_statistics__text--sub">({{ sub_info.percent_group }}/100)</span>
                        </td>
                        <td class="m_statistics-tbl__td">
                           <span class="m_statistics__text m_statistics__text--con">
                              <strong>{{ sub_info.point_total }}</strong>
                              점
                           </span>
                           <span class="m_statistics__text m_statistics__text--sub">({{ sub_info.percent_total }}/100)</span>
                        </td>
                     </tr>
                  </tbody>
               </table>
            </div>
            <div ref="chart" class="m_statistics__view">
               <div v-show="sel_cate === E_TYPE_ALL" class="m_statistics-chart-all">
                  <canvas width="400" height="400" id="totalChart"></canvas>
               </div>
               <div v-show="sel_cate !== E_TYPE_ALL" class="m_statistics-chart-wrap">
                  <div class="m_statistics-legends">
                     <dl class="m_statistics-legends__info">
                        <dt class="m_statistics-legends__head">
                           {{init_obj.association_name}}
                        </dt>
                        <dd class="m_statistics-legends__body">
                           <span class="ir">파란색</span>
                        </dd>
                     </dl>
                     <dl class="m_statistics-legends__info">
                        <dt class="m_statistics-legends__head">
                           {{init_obj.eval_group}}군평균
                        </dt>
                        <dd class="m_statistics-legends__body m_statistics-legends__body--gun">
                           <span class="ir">주황색</span>
                        </dd>
                     </dl>
                     <dl class="m_statistics-legends__info">
                        <dt class="m_statistics-legends__head">
                           전체평균
                        </dt>
                        <dd class="m_statistics-legends__body m_statistics-legends__body--total">
                           <span class="ir">회색</span>
                        </dd>
                     </dl>
                  </div>
                  <div v-show="getSelCateInfo && getSelCateInfo.subcate_list.length === 1" class="m_statistics-chart m_statistics-chart--one">
                     <canvas width="350" height="200" id="detailBarChart01Wide"></canvas>
                  </div>
                  <div v-show="getSelCateInfo && getSelCateInfo.subcate_list.length === 2" class="m_statistics-chart">
                     <canvas width="240" height="200" id="detailBarChart01"></canvas>
                  </div>
                  <div v-show="getSelCateInfo && getSelCateInfo.subcate_list.length === 2" class="m_statistics-chart">
                     <canvas width="240" height="200" id="detailBarChart02"></canvas>
                  </div>
                  <div v-show="getSelCateInfo && getSelCateInfo.subcate_list.length >= 3" class="m_statistics-chart">
                     <canvas width="240" height="200" id="detailChart01"></canvas>
                  </div>
                  <div v-show="getSelCateInfo && getSelCateInfo.subcate_list.length >= 3" class="m_statistics-chart">
                     <canvas width="240" height="200" id="detailChart02"></canvas>
                  </div>
                  <div class="m_statistics-chart m_statistics-chart--bar">
                     <canvas width="450" height="150" id="detailBarChart"></canvas>
                     <table v-if="getSelCateInfo" class="m_statistics-chart--bar__table">
                        <thead>
                           <tr>
                              <template v-for="subcate_info in getSelCateInfo.subcate_list">
                                 <th v-for="item_info in subcate_info.item_list" :width="(100/getTotalItemCnt) + '%'" class="m_statistics-chart--bar__title-sub">
                                    <span class="m_statistics-chart--bar__text-sub">
                                       {{item_info.eval_cate_order}}.
                                       {{item_info.eval_subcate_order}}.
                                       {{item_info.eval_item_order}}.
                                       <template v-if="item_info.showType">
                                          ({{item_info.eval_type}})
                                       </template>
                                    </span>
                                 </th>
                              </template>
                           </tr>
                           <tr>
                              <th v-for="subcate_info in getSelCateInfo.subcate_list" :colspan="subcate_info.item_list.length" class="m_statistics-chart--bar__title">{{subcate_info.eval_subcate}}({{subcate_info.base_point}}점)</th>
                           </tr>
                        </thead>
                     </table>
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
