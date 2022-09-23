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
         <div class="m_header m_header--no-margin">
            <h1 class="m_header__title">총평 등록 / {{eval_info && eval_info.association_name}} ( {{eval_info && eval_info.eval_title}} )</h1>
            <button @click="goList()" class="m_btn" type="button">
               <img src="/images/ico_result.svg" alt="">
               목록으로
            </button>
            <button @click="reqCancelReviewTotalData()" :disabled="isChangeValue === false" class="m_btn m_btn--sub m_btn--icon" type="button">
               <img v-show="isChangeValue === true" src="/images/ico_cancel.svg" alt="">
               <img v-show="isChangeValue === false" src="/images/ico_cancel_gray.svg" alt="">
               취소
            </button>
            <button @click="reqSaveReviewTotalData()" :disabled="isChangeValue === false" class="m_btn m_btn--primary-blue m_btn--icon" type="button">
               <img src="/images/ico_write.svg" alt="">
               등록
            </button>
         </div>
         <div class="m_review-total">
            <h2 class="m_review-total__title m_review-total__title--sub">{{init_info.association_name}} 평가 결과</h2>
            <div class="m_review-total__box">
               <div class="m_statistics-tbl m_review-total__tbl">
                  <table class="m_statistics-tbl__table">
                     <thead class="m_statistics-tbl__thead">
                        <tr>
                           <th class="m_statistics-tbl__title" colspan="2" width="40%">평가항목</th>
                           <th class="m_statistics-tbl__title">획득점수</th>
                           <th class="m_statistics-tbl__title">{{init_info.eval_group}}군평균</th>
                           <th class="m_statistics-tbl__title">전체평균</th>
                        </tr>
                     </thead>
                     <tbody>
                        <tr v-for="(cate_info, cate_idx) in cate_list">
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
                        <tr v-if="deduct_info">
                           <td colspan="2" class="m_statistics-tbl__td m_statistics-tbl__td--title">
                              <span class="m_statistics__text">
                                 <strong class="m_statistics__text m_statistics__text--title">{{ deduct_info.eval_item }}</strong>
                              </span>
                           </td>
                           <td class="m_statistics-tbl__td">
                              <span class="m_statistics__text m_statistics__text--con">
                                 <strong v-if="deduct_info && deduct_info.point_assoc !== '0'" class="m_statistics__text m_statistics__text--default">-{{deduct_info.point_assoc}}</strong>
                                 <strong v-else class="m_statistics__text m_statistics__text--default">0</strong>
                                 점
                              </span>
                           </td>
                           <td class="m_statistics-tbl__td">
                              <span class="m_statistics__text m_statistics__text--con">
                                 <strong v-if="deduct_info && deduct_info.point_group !== '0'" class="m_statistics__text m_statistics__text--gun">-{{deduct_info.point_group}}</strong>
                                 <strong v-else class="m_statistics__text m_statistics__text--gun">0</strong>
                                 점
                              </span>
                           </td>
                           <td class="m_statistics-tbl__td">
                              <span class="m_statistics__text m_statistics__text--con">
                                 <strong v-if="deduct_info && deduct_info.point_total !== '0'">-{{deduct_info.point_total}}</strong>
                                 <strong v-else>0</strong>
                                 점
                              </span>
                           </td>
                        </tr>
                     </tbody>
                  </table>
               </div>
            </div>
            <h2 class="m_review-total__title">총평 입력하기</h2>
            <div class="m_review-total__box m_review-total__box--focus">
               <textarea oninput="cm_fn.checkMaxLength(1024)" v-model="total_desc" class="m_review-total__textarea"></textarea>
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
