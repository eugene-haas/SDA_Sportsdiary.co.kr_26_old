const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/

      cnt_info: null,
      eval_list: [],
      sel_eval: g_etc_obj.sel_eval || null,
      gun_list: [],
      sel_gun: g_etc_obj.sel_gun || null,
      rater_list: [],
      sel_rater: '',

      group_list: [],
      groupState_list: [],

      isAuthC: Header.user_info.aAUTH === 'C',//평가자 로그인
   },
   created: function() {
      this.initEvalList();
   },
   mounted: function() {
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            go input
         ---------------------------------------------------------------------------------- */
      goInput: function(path, group_info) {
         const pack = {};
         pack.etc_obj = {
            sel_gun: this.sel_gun,
            eval_table_idx: this.sel_eval,
            association_name: group_info.association_name,
            association_idx: group_info.association_idx,
            eval_group: group_info.eval_group,
            eval_group_cd: group_info.eval_group_cd,
         };
         cm_fn.goto_url(path, pack);
      },
      /* -----------------------------------------------------------------------------------
            init eval list
         ---------------------------------------------------------------------------------- */
      initEvalList: function() {
         let path = "/api/ajax/mgr_input/reg_list/reg_list_init.asp";
         let params = {};
         if (this.isAuthC) {
            path = "/api/ajax/mgr_input/eval_staff/reg_list/reg_list_init.asp";
            params = {
               eval_member_idx: String(Header.user_info.aIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.eval_list = cm_fn.copyObjEx(res.data.list_info, []);
            if (0 < this.eval_list.length && this.sel_eval === null) {
               this.sel_eval = this.eval_list[0].eval_table_idx;
            }
            this.reqTblData();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req table data
         ---------------------------------------------------------------------------------- */
      reqTblData: function() {
         let path = "/api/ajax/mgr_input/reg_list/reg_list.asp";
         let params = {
            eval_table_idx: this.sel_eval,
         };
         if (this.isAuthC) {
            path = "/api/ajax/mgr_input/eval_staff/reg_list/reg_list.asp";
            params = {
               eval_table_idx: this.sel_eval,
               eval_member_idx: String(Header.user_info.aIDX),
            };
         }
         axios.post(path, params).then(function(res) {
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("리스트 조회 실패");
               return;
            }
            this.cnt_info = cm_fn.copyObjEx(res.data.eval_info[0], {});
            this.gun_list = cm_fn.copyObjEx(res.data.group_info, []);
            if (0 < this.gun_list.length && this.sel_gun === null) {
               this.sel_gun = this.gun_list[0].eval_group_cd;
            }
            this.groupState_list = cm_fn.copyObjEx(res.data.eval_state_info, []);
            group_list = cm_fn.copyObjEx(res.data.association_info, []);

            for (let i = 0; i < group_list.length; i++) {
               const group_info = group_list[i];
               const groupState_info = this.groupState_list.find(function(obj){
                  return obj.association_idx === group_info.association_idx;
               }.bind(this));
               group_info.state_info = groupState_info;
            }

            this.group_list = group_list;

            this.rater_list = cm_fn.copyObjEx(res.data.member_info, []);

         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            군 변경 시 event
         ---------------------------------------------------------------------------------- */
      handleChangeGun: function() {
      },
      /* -----------------------------------------------------------------------------------
            버튼표시 글자
         ---------------------------------------------------------------------------------- */
      getBtnStr: function(state){
         switch (Number(state)) {
            case E_EVAL_STATE_READY:
               return '등록 하기';
            case E_EVAL_STATE_ING:
               return '등록중';
            case E_EVAL_STATE_END:
               return '완료 / 수정';
         }
      },
      /* -----------------------------------------------------------------------------------
            버튼표시 클래스 이름
         ---------------------------------------------------------------------------------- */
      getBtnClass: function(state){
         switch (Number(state)) {
            case E_EVAL_STATE_READY:
               return 'm_btn--primary-blue';
            case E_EVAL_STATE_ING:
               return 'm_btn--ing';
            case E_EVAL_STATE_END:
               return 'm_btn--complete';
         }
      },
   },
   computed: {
      /* -----------------------------------------------------------------------------------
            선택된 군의 협회들
         ---------------------------------------------------------------------------------- */
      getSelGroupList: function(){
         return this.group_list.filter(function(obj){
            return obj.eval_group_cd === this.sel_gun;
         }.bind(this));
      },
   }
});
