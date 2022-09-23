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
            <h1 class="m_header__title">
               군별 결과
               <template v-if="isAuthD">
                  - {{Header.user_info.aGrpNM}}
               </template>
            </h1>
         </div>
         <div class="m_space">
            <div class="m_select-box">
               <select @change="reqTblData()" v-model="sel_eval">
                  <option v-for="eval_info in eval_list" :value="eval_info.eval_table_idx">{{eval_info.eval_title}}</option>
               </select>
            </div>
            <div v-if="!isAuthD" class="m_select-box">
               <select @change="handleChangeGun()" v-model="sel_gun">
                  <option v-for="gun_info in gun_list" :value="gun_info.eval_group_cd">{{gun_info.eval_group}}</option>
               </select>
            </div>
            <div v-if="!isAuthD" class="m_select-box">
               <select @change="reqScoreData()"  v-model="sel_group">
                  <option v-for="group_info in getSetGroupList" :value="group_info.association_idx">{{group_info.association_name}}</option>
               </select>
            </div>
            <button @click="goStatistics()" class="m_btn m_btn--primary-blue m_btn--icon m_space__right" type="button">
               <img src="/images/ico_statistics.svg" alt="">
               <span>통계</span>
            </button>
            <button @click="openModal_review()" class="m_btn m_btn--sub" type="button">
               <img src="/images/ico_comment.svg" alt="">
               <span>평가점수 의견</span>
            </button>
            <button @click="reqPrint()" class="m_btn" type="button">
               <img src="/images/ico_print.svg" alt="">
               <span>출력하기</span>
            </button>
         </div>
         <div ref="tbl" class="m_tbl">
            <table class="m_tbl__table">
               <caption class="m_tbl__caption">
                  {{getSelEvalInfo && getSelEvalInfo.eval_title}} | {{getSelGroupInfo && getSelGroupInfo.eval_group + "군"}} | {{getSelGroupInfo && getSelGroupInfo.association_name}}
               </caption>
               <thead class="m_tbl__thead">
                  <tr class="m_tbl__row m_tbl__row--head">
                     <th width="15%" class="m_tbl__th">평가 범주</th>
                     <th width="22%" class="m_tbl__th">평가 항목</th>
                     <th width="13%" class="m_tbl__th">지표 항목</th>
                     <th v-if="!isAuthC && !isAuthD" width="25%" class="m_tbl__th">평가자</th>
                     <th width="10%" class="m_tbl__th">구분</th>
                     <th width="15%" class="m_tbl__th">배점</th>
                  </tr>
               </thead>
               <tbody class="m_tbl__tbody">
                  <template v-for="(cate_info, cate_idx) in getSelCateList">
                     <template v-for="(subcate_info, subcate_idx) in cate_info.subcate_list">
                        <tr v-for="(typeItem_info, typeItem_idx) in subcate_info.typeItem_list" class="m_tbl__row">
                           <th v-if="subcate_idx === 0 && typeItem_idx === 0" :rowspan="cate_info.typeItem_cnt" class="m_tbl__item">
                              <span class="m_tbl__text m_tbl__text--title">
                                 {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_cate}}
                                 <span v-if="!isAuthC" class="m_tbl__score">({{cate_info.sum_point}})</span>
                              </span>
                           </th>
                           <th v-if="typeItem_idx === 0" :rowspan="subcate_info.typeItem_list.length" class="m_tbl__item m_tbl__item--head">
                              <span class="m_tbl__text">
                                 {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_subcate_order}} {{typeItem_info.eval_subcate}}
                                 <span v-if="!isAuthC" class="m_tbl__score">({{subcate_info.sum_point}})</span>
                              </span>
                           </th>
                           <th class="m_tbl__item m_tbl__item--head">
                              <span class="m_tbl__text">
                                 {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_subcate_order}}.{{typeItem_info.eval_item_order}}.
                                 <span class="m_tbl__score">({{typeItem_info.sum_point === '0'?'- α':typeItem_info.sum_point}})</span>
                              </span>
                           </th>
                           <th v-if="!isAuthC && !isAuthD" class="m_tbl__item">
                              <span class="m_tbl__text">
                                 {{getRaterNames(typeItem_info.rater_list, " / ")}}
                              </span>
                           </th>
                           <th class="m_tbl__item">
                              <span class="m_tbl__text">{{typeItem_info.sum_point === '0'? '- α':typeItem_info.eval_type}}</span>
                           </th>
                           <td class="m_tbl__item">
                              <span class="m_tbl__text m_tbl__text--score" :class="{m_tbl__score: typeItem_info.sum_point === '0'}">{{getScore(typeItem_info.item_type_idx, typeItem_info.sum_point === '0') || '-'}}</span>
                           </td>
                        </tr>
                     </template>
                     <tr v-if="!isAuthC" class="m_tbl__row m_tbl__row--total-sub">
                        <th class="m_tbl__item">
                           <span class="m_tbl__text m_tbl__text--title">소계</span>
                        </th>
                        <th class="m_tbl__item">
                           <span class="m_tbl__text m_tbl__text--total-sub">{{cate_info.sum_point}}</span>
                        </th>
                        <th class="m_tbl__item">
                           <span class="m_tbl__text"></span>
                        </th>
                        <th v-if="!isAuthC && !isAuthD" class="m_tbl__item">
                           <span class="m_tbl__text"></span>
                        </th>
                        <th class="m_tbl__item">
                           <span class="m_tbl__text"></span>
                        </th>
                        <td class="m_tbl__item">
                           <span class="m_tbl__text m_tbl__text--score-total-sub">{{getTotalScore(cate_info.eval_cate_cd)}}</span>
                        </td>
                     </tr>
                  </template>
               </tbody>
               <tfoot v-if="!isAuthC" class="m_tbl__tfoot">
                  <tr class="m_tbl__row m_tbl__row--total">
                     <th class="m_tbl__item">
                        <span class="m_tbl__text m_tbl__text--total-head">총계</span>
                     </th>
                     <td class="m_tbl__item">
                        <span class="m_tbl__text m_tbl__text--total">100</span>
                     </td>
                     <td class="m_tbl__item">
                     </td>
                     <td v-if="!isAuthD" class="m_tbl__item">
                     </td>
                     <td class="m_tbl__item">
                     </td>
                     <td class="m_tbl__item">
                        <span class="m_tbl__text m_tbl__text--score-total">{{getTotalScore("total")}}</span>
                     </td>
                  </tr>
               </tfoot>
            </table>
         </div>
         <!-- S: 모달창 영역 -->
         <transition name="modal">
            <section v-if="modal_review.show" class="l_modal">
               <div class="l_modal__con m_modal-wrap-comment">
                  <header class="l_modal__header">
                     <h1 class="l_modal__title">평가점수 의견 - {{getSelGroupInfo.association_name}}</h1>
                     <button @click="closeModal_review()" class="l_modal__btn-close" type="button">
                        <img src="/images/ico_close.svg" alt="평가자 정보 모달창 닫기">
                     </button>
                  </header>
                  <div class="m_space">
                     <div class="m_select-box">
                        <select v-model="modal_review.sel_cate">
                           <option value="">전체</option>
                           <option v-for="cate_info in getSelCateList" :value="cate_info.eval_cate_cd">{{cate_info.eval_cate_order}}. {{cate_info.eval_cate}}</option>
                        </select>
                     </div>
                     <button @click="reqPrintReview()" class="m_btn m_space__right" type="button">
                        <img src="/images/ico_print.svg" alt="">
                        출력하기
                     </button>
                  </div>
                  <div class="m_review">
                     <template v-for="cate_info in getSelCateListOfReviewModal">
                        <h2 class="m_review__cate m_review__cate--sm">
                           {{cate_info.eval_cate_order}}. {{cate_info.eval_cate}}
                        </h2>
                        <template v-for="subcate_info in cate_info.subcate_list">
                           <h3 class="m_review__title m_review__title--sm">{{subcate_info.eval_cate_order}}.{{subcate_info.eval_subcate_order}} {{subcate_info.eval_subcate}}</h3>
                           <div v-for="typeItem_info in subcate_info.typeItem_list" v-if="Number(typeItem_info.eval_type_cd) === E_EVAL_TYPE_ABSOLUTE" class="m_review__item">
                              <div class="m_space">
                                 <h4 class="m_review__title-sub m_review__title-sub--sm">
                                    {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_subcate_order}}.{{typeItem_info.eval_item_order}} {{typeItem_info.eval_item}}
                                 </h4>
                                 <span v-if="!isAuthC && !isAuthD" class="m_review__info m_space__right">
                                    평가 : <span class="m_review__text">{{getRaterNames(typeItem_info.rater_list, ", ")}}</span>
                                 </span>
                              </div>
                              <p v-for="desc_info in getReview(typeItem_info.item_type_idx)" class="m_review__contents m_review__contents--p">{{desc_info.eval_desc}}</p>
                              <p v-if="getReview(typeItem_info.item_type_idx).length === 0" class="m_review__contents m_review__contents--p">
                                 미등록
                              </p>
                           </div>
                        </template>
                     </template>
                  </div>
               </div>
            </section>
         </transition>
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
