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
            <h1 class="m_header__title">평가의견 등록 / {{eval_info && eval_info.association_name}} ( {{eval_info && eval_info.eval_title}} )</h1>
            <button @click="goList()" class="m_btn" type="button">
               <img src="/images/ico_result.svg" alt="">
               목록으로
            </button>
            <button @click="reqCancelReview()" :disabled="isChangeValue === false" class="m_btn m_btn--sub m_btn--icon" type="button">
               <img v-show="isChangeValue === true" src="/images/ico_cancel.svg" alt="">
               <img v-show="isChangeValue === false" src="/images/ico_cancel_gray.svg" alt="">
               취소
            </button>
            <button @click="reqSaveReview()" :disabled="isChangeValue === false" class="m_btn m_btn--primary-blue m_btn--icon" type="button">
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
         <div class="m_review m_review--input">
            <template v-for="(cate_info, cate_idx) in getShowCateList()">
               <h2 class="m_review__cate">{{cate_info.eval_cate_order}}.{{cate_info.eval_cate}}</h2>
               <template v-for="(subcate_info, subcate_idx) in getShowSubCateList(cate_info)">
                  <h3 class="m_review__title">
                     {{subcate_info.eval_cate_order}}.{{subcate_info.eval_subcate_order}} {{subcate_info.eval_subcate}}
                  </h3>
                  <template v-for="(typeItem_info, typeItem_idx) in getShowTypeItemList(subcate_info)">
                     <h4 class="m_review__title-sub">
                        {{typeItem_info.eval_cate_order}}.{{typeItem_info.eval_subcate_order}}.{{typeItem_info.eval_item_order}}. {{typeItem_info.eval_item}}
                     </h4>
                     <textarea oninput="cm_fn.checkMaxLength(256)" class="m_review__contents" v-model="getSelRaterInfo.input_obj[typeItem_info.item_type_idx]"></textarea>
                  </template>
               </template>
            </template>
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
