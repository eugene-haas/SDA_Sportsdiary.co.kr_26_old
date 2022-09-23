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
            <h1 class="m_header__title">배점점수, 평가의견, 총평등록</h1>
         </div>
         <div class="m_space">
            <div class="m_select-box m_select-box--wide">
               <select @change="reqTblData()" v-model="sel_eval">
                  <option v-for="eval_info in eval_list" :value="eval_info.eval_table_idx">{{eval_info.eval_title}}</option>
               </select>
            </div>
            <div class="m_select-box">
               <select @change="handleChangeGun()" v-model="sel_gun">
                  <option v-for="gun_info in gun_list" :value="gun_info.eval_group_cd">{{gun_info.eval_group}}</option>
               </select>
            </div>
            <div v-if="cnt_info" class="m_status m_space__right">
               <dl class="m_status__con">
                  <dt class="m_status__head">평가범주</dt>
                  <dd class="m_status__body">
                     <span class="m_status__number">{{cnt_info.cnt_cate}}</span>
                     개
                  </dd>
               </dl>
               <dl class="m_status__con">
                  <dt class="m_status__head">평가항목</dt>
                  <dd class="m_status__body">
                     <span class="m_status__number">{{cnt_info.cnt_subcate}}</span>
                     개
                  </dd>
               </dl>
               <dl class="m_status__con">
                  <dt class="m_status__head">지표항목</dt>
                  <dd class="m_status__body">
                     <span class="m_status__number">{{cnt_info.cnt_item}}</span>
                     개
                  </dd>
               </dl>
               <dl class="m_status__con">
                  <dt class="m_status__head">총점</dt>
                  <dd class="m_status__body">
                     <span class="m_status__number">{{cnt_info.sum_point}}</span>
                     <span class="m_status__unit-score">점</span>
                  </dd>
               </dl>
            </div>
         </div>
         <div class="m_tbl-list">
            <table class="m_tbl-list__table">
               <thead>
                  <tr class="m_tbl-list__row m_tbl-list__row--head">
                     <th width="6%" class="m_tbl-list__title">
                        No.
                     </th>
                     <th width="10%" class="m_tbl-list__title">
                        군 구분
                     </th>
                     <th width="35%" class="m_tbl-list__title">
                        종목단체명
                     </th>
                     <th width="13%" class="m_tbl-list__title">
                        점수 등록
                     </th>
                     <th width="13%" class="m_tbl-list__title">
                        평가의견 등록
                     </th>
                     <th v-if="!isAuthC" width="13%" class="m_tbl-list__title">
                        총평 등록
                     </th>
                     <th width="10%" class="m_tbl-list__title">
                        등록일
                     </th>
                  </tr>
               </thead>
               <tbody>
                  <tr v-for="group_info in getSelGroupList" class="m_tbl-list__row">
                     <td class="m_tbl-list__item m_tbl-list__item--order">
                        <span class="m_tbl-list__text">{{group_info.idx}}</span>
                     </td>
                     <td class="m_tbl-list__item">
                        <span class="m_tbl-list__text">{{group_info.eval_group}}</span>
                     </td>
                     <td class="m_tbl-list__item">
                        <span class="m_tbl-list__text">{{group_info.association_name}}</span>
                     </td>
                     <td class="m_tbl-list__item">
                        <button @click="goInput('/pages/evaluation/score/index.asp', group_info)" class="m_btn m_btn--center"
                        :class="getBtnClass(group_info.state_info.point_state)"
                        type="button">{{getBtnStr(group_info.state_info.point_state)}}</button>
                     </td>
                     <td class="m_tbl-list__item">
                        <button @click="goInput('/pages/evaluation/review/index.asp', group_info)" class="m_btn m_btn--center"
                        :class="getBtnClass(group_info.state_info.desc_state)" type="button">{{getBtnStr(group_info.state_info.desc_state)}}</button>
                     </td>
                     <td v-if="!isAuthC" class="m_tbl-list__item">
                        <button @click="goInput('/pages/evaluation/review_total/index.asp', group_info)" class="m_btn m_btn--center"
                        :class="getBtnClass(group_info.state_info.total_desc_state)" type="button">{{getBtnStr(group_info.state_info.total_desc_state)}}</button>
                     </td>
                     <td class="m_tbl-list__item">
                        <span class="m_tbl-list__text">{{group_info.reg_date | dateFormat('yyyy.MM.dd')}}</span>
                     </td>
                  </tr>
               </tbody>
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
