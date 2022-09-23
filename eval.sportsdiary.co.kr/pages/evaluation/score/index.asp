<!--#include virtual="/include/asp_setting/index.asp"-->

<!DOCTYPE html>
<html lang="ko" dir="ltr">

<head>
   <!--#include virtual="/include/head.asp"-->
   <script defer src="./index.js?ver=1.0.0.1<%=GLOBAL_VER%>"></script>
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
            <h1 class="m_header__title">점수 등록 / {{eval_info && eval_info.association_name}} ( {{eval_info && eval_info.eval_title}} )</h1>
            <button @click="goList()" class="m_btn" type="button">
               <img src="/images/ico_result.svg" alt="">
               목록으로
            </button>
            <button @click="reqCancelTblData()" :disabled="isChangeValue === false" class="m_btn m_btn--sub m_btn--icon" type="button">
               <img v-show="isChangeValue === true" src="/images/ico_cancel.svg" alt="">
               <img v-show="isChangeValue === false" src="/images/ico_cancel_gray.svg" alt="">
               취소
            </button>
            <button @click="reqSaveTblData()" :disabled="isChangeValue === false" class="m_btn m_btn--primary-blue m_btn--icon" type="button">
               <img src="/images/ico_write.svg" alt="">
               등록
            </button>
         </div>
         <div v-if="!isAuthC" class="m_space">
            <div class="m_select-box m_select-box--wide m_space__right" :class="{'m_select-box--disabled':isChangeValue === true}">
               <select v-model="sel_raterSelect" :disabled="isChangeValue === true">
                  <option v-for="rater_info in raterSelect_list" :value="rater_info.eval_member_idx">{{rater_info.eval_member}}</option>
               </select>
            </div>
         </div>
         <div class="m_wrap-fixed-tbl">
            <div class="m_tbl">
               <table class="m_tbl__table">
                  <thead class="m_tbl__thead">
                     <tr class="m_tbl__row m_tbl__row--head">
                        <th width="20%" class="m_tbl__th">
                           <div class="m_wrap-fixed-tbl__th">
                              평가 범주
                           </div>
                        </th>
                        <th width="20%" class="m_tbl__th">
                           <div class="m_wrap-fixed-tbl__th">
                              평가 항목
                           </div>
                        </th>
                        <th width="35%" class="m_tbl__th">
                           <div class="m_wrap-fixed-tbl__th">
                              평가 지표
                           </div>
                        </th>
                        <th width="10%" class="m_tbl__th">
                           <div class="m_wrap-fixed-tbl__th">
                              구분
                           </div>
                        </th>
                        <th width="15%" class="m_tbl__th">
                           <div class="m_wrap-fixed-tbl__th">
                              점수
                           </div>
                        </th>
                     </tr>
                  </thead>
                  <tbody class="m_tbl__tbody">
                     <template v-for="(cate_info, cate_idx) in getShowCateList()">
                        <template v-for="(subcate_info, subcate_idx) in getShowSubCateList(cate_info)">
                           <tr v-for="(typeItem_info, typeItem_idx) in getShowTypeItemList(subcate_info)" class="m_tbl__row">
                              <th v-if="subcate_idx === 0 && typeItem_idx === 0" :rowspan="getRowSpanOfCate(cate_info)" class="m_tbl__item">
                                 <span class="m_tbl__text m_tbl__text--title">
                                    {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_cate}}
                                 </span>
                              </th>
                              <th v-if="typeItem_idx === 0" :rowspan="getRowSpanOfSubCate(subcate_info)" class="m_tbl__item m_tbl__item--head">
                                 <span class="m_tbl__text">
                                    {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_subcate_order}} {{typeItem_info.eval_subcate}}
                                 </span>
                              </th>
                              <th class="m_tbl__item m_tbl__item--head">
                                 <span class="m_tbl__text">
                                    {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_subcate_order}}.{{typeItem_info.eval_item_order}}. {{typeItem_info.eval_item}}
                                    <span v-if="Number(typeItem_info.eval_type_cd) === E_EVAL_TYPE_DEDUCT" class="m_tbl__noti">
                                       ( [예시] -1점인 경우 1 )
                                    </span>
                                 </span>
                              </th>
                              <th class="m_tbl__item ">
                                 <span class="m_tbl__text">
                                    {{Number(typeItem_info.eval_type_cd) === E_EVAL_TYPE_DEDUCT ? '- α':typeItem_info.eval_type}}
                                 </span>
                              </th>
                              <td class="m_tbl__item m_tbl__item--input">
                                 <input class="m_tbl__input-score"
                                    :placeholder="
                                       Number(typeItem_info.eval_type_cd) === E_EVAL_TYPE_ABSOLUTE ?'정성값'
                                       :Number(typeItem_info.eval_type_cd) === E_EVAL_TYPE_RELATIVE ?'정량값'
                                       :'위반수'"
                                    :value="getSelRaterInfo.input_obj[typeItem_info.item_type_idx]"
                                    onClick="this.select();"
                                    @input="getSelRaterInfo.input_obj[typeItem_info.item_type_idx] = getScoreValue($event);"
                                    type="text">
                                 <!-- <input class="m_tbl__input-score"
                                    :placeholder="
                                       Number(typeItem_info.eval_type_cd) === E_EVAL_TYPE_ABSOLUTE ?'1~5 사이 정수'
                                       :Number(typeItem_info.eval_type_cd) === E_EVAL_TYPE_RELATIVE ?'정량값'
                                       :'위반수'"
                                    :value="getSelRaterInfo.input_obj[typeItem_info.item_type_idx]"
                                    onClick="this.select();"
                                    @input="getSelRaterInfo.input_obj[typeItem_info.item_type_idx] = getScoreValue($event);"
                                    type="text"> -->
                              </td>
                           </tr>
                        </template>
                     </template>
                  </tbody>
               </table>
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
