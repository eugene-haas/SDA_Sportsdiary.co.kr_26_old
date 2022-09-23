const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      now_date: new Date(),
      match_list: [],
   },
   created: function(){
      this.reqMatchList();
   },
   mounted: function() {
      // this.console();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            go input
         ---------------------------------------------------------------------------------- */
      goInput: function(match){
         const path = '/game_manager/pages/input.asp';
         // if(header.user_info.C_CDA === "E2"){
         //    path = '/game_manager/pages/input_diving.asp';
         // }
         const pack = {};
         pack.etc_obj = {
            lidx: match.lidx,
         };
         cm_fn.goto_url(path, pack);
      },
      /* -----------------------------------------------------------------------------------
            req match list
         ---------------------------------------------------------------------------------- */
      reqMatchList: function(){
         const path = '/game_manager/ajax/api/api.SWIM_300.asp';
         const params = {
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
               alert('리스트 조회 실패');
               return;
            }
            this.match_list = cm_fn.copyObjEx(res.data.list, []);
         }.bind(this));
      },

   },
});
