const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      eval_info: null,
      init_info: g_etc_obj || {},
      cate_list: [],
      deduct_info: null,
      total_desc: '',
      tempTotal_desc: '',
   },
   created: function() {
      this.initReviewTotalData();
   },
   mounted: function() {
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            목록으로
         ---------------------------------------------------------------------------------- */
      goList: function(){
         cm_fn.goto_url("/pages/evaluation/index.asp", {
            etc_obj: {
               sel_gun: this.init_info.sel_gun,
               sel_eval: this.init_info.eval_table_idx,
            },
         });
      },
      /* -----------------------------------------------------------------------------------
            기본적인 데이터 세팅
         ---------------------------------------------------------------------------------- */
      initReviewTotalData: function(){
         const path = '/api/ajax/mgr_input/reg_data/reg_total_desc_init.asp';
         const params = {
            eval_table_idx: this.init_info.eval_table_idx,
            association_idx: this.init_info.association_idx,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert('정보 조회 실패');
               return;
            }
            this.eval_info = cm_fn.copyObjEx(res.data.eval_title_info[0], {});
            this.cate_list = cm_fn.copyObjEx(res.data.statistics_info, []);
            this.deduct_info = cm_fn.copyObjEx(res.data.subtract_info[0], null);
            this.total_desc = cm_fn.htmlDecode(cm_fn.copyObjEx(res.data.total_desc_info[0], {}).total_eval_desc || '');
            this.tempTotal_desc = this.total_desc;
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            등록하기
         ---------------------------------------------------------------------------------- */
      reqSaveReviewTotalData: function(){
         if (this.total_desc === '') {
            alert('총평을 입력해주세요.');
            return;
         }
         const path = '/api/ajax/mgr_input/reg_data/reg_total_desc.asp';
         const params = {
            eval_table_idx: this.init_info.eval_table_idx,
            association_idx: this.init_info.association_idx,
            eval_member_idx: Header.user_info.aIDX,
            eval_desc: this.total_desc,
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               if (res.data.errorcode === E_TOTAL_DESC_NOT_AUTHIRITY) {
                  alert('권한이 없습니다.');
                  return;
               }
               if (res.data.errorcode === E_TOTAL_DESC_NOT_ASSOCIATION) {
                  alert('미등록된 협회입니다.');
                  return;
               }
               alert('등록 실패');
               return;
            }
            alert('등록이 완료되었습니다.');
            this.goList();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            취소하기
         ---------------------------------------------------------------------------------- */
      reqCancelReviewTotalData: function(){
         AlertModal.showModal("취소되었습니다.");
         this.total_desc = this.tempTotal_desc;
      },
   },
   computed: {
      /* -----------------------------------------------------------------------------------
            평가의견 수정 여부
         ---------------------------------------------------------------------------------- */
      isChangeValue: function(){
         if (this.tempTotal_desc !== this.total_desc) {
            return true;
         }
         return false;
      },
   }
});
