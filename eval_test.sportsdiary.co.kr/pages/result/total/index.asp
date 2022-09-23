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
            <h1 class="m_header__title">전체 결과</h1>
         </div>
         <div class="m_space">
            <div class="m_select-box">
               <select @change="reqTotalTblData()" v-model="sel_eval">
                  <option v-for="eval_info in eval_list" :value="eval_info.eval_table_idx">{{eval_info.eval_title}}</option>
               </select>
            </div>
            <button @click="reqPrint()" class="m_btn m_space__right" type="button">
               <img src="/images/ico_print.svg" alt="">
               <span>출력하기</span>
            </button>
         </div>
         <div ref="tbl" class="m_tbl">
            <table class="m_tbl__table">
               <caption class="m_tbl__caption">{{getSelEvalInfo && getSelEvalInfo.eval_title}}</caption>
               <thead class="m_tbl__thead">
                  <tr class="m_tbl__row m_tbl__row--head">
                     <th rowspan="3" class="m_tbl__th">평가 범주</th>
                     <th rowspan="3" class="m_tbl__th">평가 항목</th>
                     <th rowspan="3" class="m_tbl__th">지표 항목</th>
                     <th colspan="12" class="m_tbl__th">군별 배점</th>
                  </tr>
                  <tr class="m_tbl__row m_tbl__row--head">
                     <th v-for="gun_info in getSetGunList" :colspan="gun_info.type_list.length" class="m_tbl__th">{{gun_info.eval_group}}</th>
                  </tr>
                  <tr class="m_tbl__row m_tbl__row--head">
                     <template v-for="gun_info in getSetGunList">
                        <th v-for="type_info in gun_info.type_list" class="m_tbl__th">{{type_info.eval_type}}</th>
                     </template>
                  </tr>
               </thead>
               <tbody class="m_tbl__tbody">
                  <template v-for="(cate_info, cate_idx) in cate_list">
                     <template v-for="(subcate_info, subcate_idx) in cate_info.subcate_list">
                        <tr v-for="(item_info, item_idx) in subcate_info.item_list" class="m_tbl__row">
                           <th v-if="subcate_idx === 0 && item_idx === 0" :rowspan="cate_info.item_len" class="m_tbl__item">
                              <span class="m_tbl__text m_tbl__text--title">
                                 {{item_info.eval_cate_order}}.{{item_info.eval_cate}}
                                 <span class="m_tbl__score">({{cate_info.sum_point}})</span>
                              </span>
                           </th>
                           <th v-if="item_idx === 0" :rowspan="subcate_info.item_list.length" class="m_tbl__item m_tbl__item--head">
                              <span class="m_tbl__text">
                                 {{item_info.eval_cate_order}}.{{item_info.eval_subcate_order}} {{item_info.eval_subcate}}
                                 <span class="m_tbl__score">({{subcate_info.sum_point}})</span><template v-if="subcate_info.sum_point !== subcate_info.sum_point5">, <br>
                                 </template>
                              </span>
                              <span v-if="subcate_info.sum_point !== subcate_info.sum_point5" class="m_tbl__text">
                                 마군<span class="m_tbl__score">({{subcate_info.sum_point5}})</span>
                              </span>
                           </th>
                           <th class="m_tbl__item m_tbl__item--head">
                              <span class="m_tbl__text">
                                 {{item_info.eval_cate_order}}.{{item_info.eval_subcate_order}}.{{item_info.eval_item_order}}
                                 <span class="m_tbl__score">({{item_info.sum_point === '0'?'- α':item_info.sum_point}})</span>
                              </span>
                           </th>
                           <template v-for="(gun_info, gun_idx) in getSetGunList">
                              <td v-for="type_info in gun_info.type_list" :class="{'m_tbl__item--bg': gun_idx%2 === 1}" class="m_tbl__item">
                                 <span class="m_tbl__text m_tbl__text--score">
                                    {{getScore(item_info.eval_item_idx, gun_info.eval_group_cd, type_info.eval_type_cd, item_info.sum_point === '0') || "-"}}
                                 </span>
                              </td>
                           </template>
                        </tr>
                     </template>
                     <tr class="m_tbl__row m_tbl__row--total-sub">
                        <th class="m_tbl__item">
                           <span class="m_tbl__text m_tbl__text--title">소계</span>
                        </th>
                        <th class="m_tbl__item">
                           <span class="m_tbl__text m_tbl__text--total-sub">{{cate_info.sum_point}}</span>
                        </th>
                        <th class="m_tbl__item"></th>
                        <template v-for="(gun_info, gun_idx) in getSetGunList">
                           <td v-for="type_info in gun_info.type_list" :class="{'m_tbl__item--bg-sub': gun_idx%2 === 1}" class="m_tbl__item">
                              <span class="m_tbl__text m_tbl__text--title">{{cate_info.total_map[gun_info.eval_group_cd] && cate_info.total_map[gun_info.eval_group_cd][type_info.eval_type_cd]}}</span>
                           </td>
                        </template>
                     </tr>
                  </template>

               </tbody>
               <tfoot class="m_tbl__tfoot">
                  <tr class="m_tbl__row">
                     <th rowspan="2" class="m_tbl__item">
                        <span class="m_tbl__text m_tbl__text--total-head">총계</span>
                     </th>
                     <td rowspan="2" class="m_tbl__item">
                        <span class="m_tbl__text m_tbl__text--total-head">100</span>
                     </td>
                     <td rowspan="2" class="m_tbl__item"></td>
                     <template v-for="gun_info in getSetGunList">
                        <td v-for="type_info in gun_info.type_list" class="m_tbl__item m_tbl__item--total">
                           <span class="m_tbl__text m_tbl__text--total">{{getTotalScore(gun_info.eval_group_cd, type_info.eval_type_cd)}}</span>
                        </td>
                     </template>
                  </tr>
                  <tr class="m_tbl__row">
                     <template v-for="gun_info in getSetGunList">
                        <td :colspan="gun_info.type_list.length" class="m_tbl__item">
                           <span class="m_tbl__text m_tbl__text--total-lg">{{getTotalScore(gun_info.eval_group_cd, "total")}}</span>
                        </td>
                     </template>
                  </tr>
               </tfoot>
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
      <!--#include virtual="/include/modal.asp"-->
      <!-- E: 공통 모달창 영역 -->
   </div>
   <!--#include virtual="/include/body_after.asp"-->
</body>

</html>
