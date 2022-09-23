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

      raterSelect_list: [],
      sel_raterSelect: null,

      cate_list: [],
      subcate_list: [],
      typeItem_list: [],
      rater_list: [],

      desc_list: [],

      isAuthC: Header.user_info.aAUTH === 'C',//평가자 로그인
   },
   created: function() {
      this.initReview();
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
      initReview: function(){
         let path = "/api/ajax/mgr_input/reg_data/reg_desc_init.asp";
         let params = {
            eval_table_idx: this.init_info.eval_table_idx,
            association_idx: this.init_info.association_idx,
         };
         if (this.isAuthC) {
            path = "/api/ajax/mgr_input/eval_staff/reg_data/reg_desc_init.asp";
            params = {
               eval_table_idx: this.init_info.eval_table_idx,
               association_idx: this.init_info.association_idx,
               eval_group_cd: this.init_info.eval_group_cd,
               eval_member_idx: String(Header.user_info.aIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.eval_info = cm_fn.copyObjEx(res.data.eval_title_info[0], {});

            this.cate_list = cm_fn.copyObjEx(res.data.cate_info, []);
            this.subcate_list = cm_fn.copyObjEx(res.data.subcate_info, []);
            this.typeItem_list = cm_fn.copyObjEx(res.data.item_type_info, []);
            this.rater_list = cm_fn.copyObjEx(res.data.member_item_info, []);
            const raterSelect_list = cm_fn.copyObjEx(res.data.member_info, []);
            if (this.isAuthC) {
               raterSelect_list.push({
                  eval_member: Header.user_info.aNM,
                  eval_member_idx: String(Header.user_info.aIDX),
                  idx: null,
               });
            }
            for (var i = 0; i < raterSelect_list.length; i++) {
               raterSelect_list[i].cate_obj = {};
               raterSelect_list[i].input_obj = {};
               raterSelect_list[i].tempInput_obj = {};
            }
            if (0 < raterSelect_list.length) {
               this.sel_raterSelect = raterSelect_list[0].eval_member_idx;
            }
            this.raterSelect_list = raterSelect_list;

            const review_list = cm_fn.copyObjEx(res.data.desc_info, []);
            for (var i = 0; i < review_list.length; i++) {
               review_list[i].eval_desc = cm_fn.htmlDecode(review_list[i].eval_desc);
            }
            this.desc_list = review_list;

            this.cate_list = this.getSetCateList();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            저장
         ---------------------------------------------------------------------------------- */
      reqSaveReview: function(){
         const eval_descs = [];
         const item_idxs = [];

         for (const key in this.getSelRaterInfo.input_obj) {
            if (this.getSelRaterInfo.input_obj[key] === '') {
               alert("의견을 모두 입력해주세요.");
               return;
            }
            eval_descs.push(this.getSelRaterInfo.input_obj[key].replaceAll('|', ''));
            item_idxs.push(key);
         }

         const path = "/api/ajax/mgr_input/reg_data/reg_desc.asp";
         const params = {
            eval_table_idx: this.init_info.eval_table_idx,
            association_idx: this.init_info.association_idx,
            eval_member_idx: this.getSelRaterInfo.eval_member_idx,
            eval_descs: eval_descs.join("|"),
            item_idxs: item_idxs.join(","),
         };
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               if (res.data.errorcode === E_DESC_NOT_AUTHIRITY) {
                  alert("권한 없음");
                  return;
               }
               if (res.data.errorcode === E_DESC_NOT_ASSOCIATION) {
                  alert("미등록 협회");
                  return;
               }
               if (res.data.errorcode === E_DESC_MISSMATCH_DATA) {
                  alert("측정 항목이 올바르지 않습니다.");
                  return;
               }
               if (res.data.errorcode === E_DESC_MISSMATCH_DATA_CNT) {
                  alert("평가의견과 평가 항목의 갯수가 틀립니다.");
                  return;
               }

               alert("등록 실패");
               return;
            }
            AlertModal.showModal("등록되었습니다.");
            const selRaterSelect_info = this.getSelRaterInfo;
            selRaterSelect_info.tempInput_obj = cm_fn.copyObjEx(selRaterSelect_info.input_obj, []);
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            취소
         ---------------------------------------------------------------------------------- */
      reqCancelReview: function(){
         AlertModal.showModal("취소되었습니다.");
         const selRaterSelect_info = this.getSelRaterInfo;
         selRaterSelect_info.input_obj = cm_fn.copyObjEx(selRaterSelect_info.tempInput_obj, []);
      },
      /* -----------------------------------------------------------------------------------
            cate_list > subcate_list > typeItem_list > rater_list 인 배열 생성
         ---------------------------------------------------------------------------------- */
      getSetCateList: function(){
         const cate_list_temp = cm_fn.copyObjEx(this.cate_list, []);
         const subcate_list_temp = cm_fn.copyObjEx(this.subcate_list, []);
         const typeItem_list_temp = cm_fn.copyObjEx(this.typeItem_list, []);
         const rater_list_temp = cm_fn.copyObjEx(this.rater_list, []);
         const list = [];
         const cate_list = cate_list_temp.filter(function(obj){
            return obj.eval_group_cd === this.init_info.eval_group_cd;
         }.bind(this));
         const cate_len = cate_list.length;
         for (let i = 0; i < cate_len; i++) {
            const cate_info = cate_list[i];
            const subcate_list = subcate_list_temp.filter(function(obj){
               return obj.eval_group_cd === this.init_info.eval_group_cd
                  && obj.eval_cate_cd === cate_info.eval_cate_cd;
            }.bind(this));
            const subcate_len = subcate_list.length;
            for (let j = 0; j < subcate_len; j++) {
               const subcate_info = subcate_list[j];
               const typeItem_list = typeItem_list_temp.filter(function(obj){
                  return obj.eval_group_cd === this.init_info.eval_group_cd
                     && obj.eval_cate_cd === cate_info.eval_cate_cd
                     && obj.eval_subcate_cd === subcate_info.eval_subcate_cd;
               }.bind(this));
               const typeItem_len = typeItem_list.length;
               for (let k = 0; k < typeItem_len; k++) {
                  const typeItem_info = typeItem_list[k];

                  const rater_list = rater_list_temp.filter(function(obj){
                     return obj.item_type_idx === typeItem_info.item_type_idx;
                  }.bind(this));
                  for (let l = 0; l < rater_list.length; l++) {
                     const rater_info = rater_list[l];
                     rater_info.score = 0;
                     const raterSelect_info = this.raterSelect_list.find(function(obj){
                        return obj.eval_member_idx === rater_info.eval_member_idx;
                     }.bind(this)) || null;
                     if (raterSelect_info === null) continue;
                     const cate_obj = raterSelect_info.cate_obj;
                     cate_obj[cate_info.eval_cate_cd] = cate_obj[cate_info.eval_cate_cd] || {};

                     const subcate_obj = raterSelect_info.cate_obj[cate_info.eval_cate_cd];
                     subcate_obj[subcate_info.eval_subcate_cd] = subcate_obj[subcate_info.eval_subcate_cd] || {};

                     const typeItem_obj = subcate_obj[subcate_info.eval_subcate_cd];
                     typeItem_obj[typeItem_info.item_type_idx] = true;
                     const desc_info = this.desc_list.find(function(obj){
                        return obj.item_type_idx === typeItem_info.item_type_idx
                        && obj.eval_member_idx === rater_info.eval_member_idx;
                     }.bind(this)) || null;
                     const desc = desc_info?desc_info.eval_desc:"";

                     this.$set(raterSelect_info.input_obj, typeItem_info.item_type_idx, desc);
                     this.$set(raterSelect_info.tempInput_obj, typeItem_info.item_type_idx, desc);
                  }

                  typeItem_info.rater_list = rater_list;
               }
               subcate_info.typeItem_list = typeItem_list;
            }
            cate_info.subcate_list = subcate_list;
            list.push(cate_info);
         }
         return list;
      },
      /* -----------------------------------------------------------------------------------
            보여야하는 행 여부
         ---------------------------------------------------------------------------------- */
      isShowRow: function(typeItem_info){
         if (this.getSelRaterInfo === null || !this.getSelRaterInfo.input_list) {
            return false;
         }
         return this.getSelRaterInfo.input_list.find(function(obj){
            return obj.item_type_idx === typeItem_info.item_type_idx;
         }) || false;
      },
      /* -----------------------------------------------------------------------------------
            선택된 평가자 cate리스트
         ---------------------------------------------------------------------------------- */
      getShowCateList: function(){
         return this.cate_list.filter(function(obj){
            return this.getSelRaterInfo.cate_obj[obj.eval_cate_cd];
         }.bind(this)) || [];
      },
      /* -----------------------------------------------------------------------------------
            선택된 평가자 subcate리스트
         ---------------------------------------------------------------------------------- */
      getShowSubCateList: function(cate_info){
         const list =  cate_info.subcate_list.filter(function(obj){
            return this.getSelRaterInfo.cate_obj[obj.eval_cate_cd]
               && this.getSelRaterInfo.cate_obj[obj.eval_cate_cd][obj.eval_subcate_cd];
         }.bind(this)) || [];
         return list
      },
      /* -----------------------------------------------------------------------------------
            선택된 평가자 typeitem리스트
         ---------------------------------------------------------------------------------- */
      getShowTypeItemList: function(subcate_info){
         return subcate_info.typeItem_list.filter(function(obj){
            return this.getSelRaterInfo.cate_obj[obj.eval_cate_cd]
               && this.getSelRaterInfo.cate_obj[obj.eval_cate_cd][obj.eval_subcate_cd]
               && this.getSelRaterInfo.cate_obj[obj.eval_cate_cd][obj.eval_subcate_cd][obj.item_type_idx];
         }.bind(this)) || [];
      },
   },
   computed: {
      /* -----------------------------------------------------------------------------------
            선택된 평가자 정보
         ---------------------------------------------------------------------------------- */
      getSelRaterInfo: function(){
         return this.raterSelect_list.find(function(obj){
            return obj.eval_member_idx === this.sel_raterSelect;
         }.bind(this)) || null;
      },
      /* -----------------------------------------------------------------------------------
            평가의견 수정 여부
         ---------------------------------------------------------------------------------- */
      isChangeValue: function(){
         const selRaterSelect_info = this.getSelRaterInfo;
         if (selRaterSelect_info === null) return false;
         for (const key in selRaterSelect_info.input_obj) {
            if (selRaterSelect_info.input_obj[key] !== selRaterSelect_info.tempInput_obj[key]) {
               return true;
            }
         }
         return false;
      },
   },
});
