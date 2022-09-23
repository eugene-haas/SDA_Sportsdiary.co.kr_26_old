const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      now_date: new Date(),
      isMobile: true,
      init_info: g_etc_obj,
      header_info:  {
         cdbnm: null,
         cdcicon: null,
         cdc: null,
         cdcnm: null,
         jname: null,
      },
      game_list: [],
      sel_game: null,
      input_text: '',
   },
   created: function(){
      this.reqGameList();
   },
   mounted: function() {
      this.isMobile = mobilecheck();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req game list
         ---------------------------------------------------------------------------------- */
      reqGameList: function(){
         const path = '/game_manager/ajax/api/api.SWIM_400.asp';
         const params = {
            LIDX: this.init_info.lidx,
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
               alert('리스트 조회 실패')
               return;
            }
            this.header_info = {
               cdbnm: res.data.cdbnm,
               cdcicon: res.data.cdcicon,
               cdc: res.data.cdc,
               cdcnm: res.data.cdcnm,
               jname: res.data.jname,
               judgepartname: res.data.judgepartname,
            };
            this.game_list = cm_fn.copyObjEx(res.data.list, []);
            this.sel_game = this.game_list[0] && this.game_list[0].r_idx || null;
         }.bind(this));
      },
      //
      // /* ----------------------------------------------------------------------------------
      //    점수입력 모달창 확인
      //    ---------------------------------------------------------------------------------- */
      // okModal_input: function(){
      //    const path = '/game_manager/ajax/api/api.SWIM_600.asp';
      //    const params = {
      //       LIDX: this.init_info.lidx,
      //       RIDX: this.modal_input.sel_game,
      //       MIDX: this.modal_input.inputScore_info.midx,
      //       RNO: this.modal_input.inputScore_info.r_roundno,
      //       SETVAL:Number(this.input_text),
      //    };
      //    axios.post(path, params).then(function(res){
      //       log(res);
      //       if (String(res.data.result) !== "0") {
      //          alert('점수입력 실패')
      //          return;
      //       }
      //       this.game_list.splice(this.modal_input.sel_idx, 1);
      //       this.closeModal_input();
      //    }.bind(this));
      // },
      /* ----------------------------------------------------------------------------------
         키입력
         ---------------------------------------------------------------------------------- */
      keydownInput: function(keyValue){
         const maxFirst_len = 1;
         const maxLast_len = 1;
         const max_len = maxFirst_len + maxLast_len + 1;
         let str = this.input_text;
         switch (keyValue) {
            case E_KEY_BACKSPACE: {
               str = str.slice(0, -1);
               break;
            }
            case E_KEY_DOT: {
               if (max_len <= str.length) return;
               if (str.indexOf('.') !== -1) return;
               if (str.length === 0) {
                  str = str + '0';
               }
               str = str + '.';
               break;
            }
            default: {
               if (max_len <= str.length) return;
               const str_list = str.split('.');
               if (
                  (str_list.length === 1 && maxFirst_len <= str_list[0].length) ||
                  (str_list.length === 2 && maxLast_len <= str_list[1].length)
               ) return;
               str = str + keyValue;
               if (str.length === maxFirst_len) {
                  str = str + '.';
               }
               break;
            }
         }
         this.input_text = str;
      },
      /* ----------------------------------------------------------------------------------
         점수입력 모달창 초기화
         ---------------------------------------------------------------------------------- */
      resetInput: function(){
         this.input_text = '';
      },
   },
   computed: {
      getInputScoreInfo: function(){
         return this.game_list.find(function(game){
            return this.sel_game === game.r_idx;
         }.bind(this)) || {}
      }
   }
});
