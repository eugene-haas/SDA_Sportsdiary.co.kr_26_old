const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      now_date: new Date(),
      isMobile: mobilecheck(),
      init_info: g_etc_obj,
      header_info:  {
         cdbnm: null,
         cdcicon: null,
         cdc: null,
         cdcnm: null,
         jname: null,
      },
      game_list: [],
      sel_idx: null,
      sel_game: null,
      game_info: null,
      input_text: '',
   },
   created: function(){
      this.reqGameList();
   },
   mounted: function() {
      // window.onload = function(){
      //    const el_difficutyName = this.$refs.difficutyName;
      //    const maxWidth = 600;
      //    if (!el_difficutyName) return;
      //    if (maxWidth < el_difficutyName.clientWidth) {
      //       el_difficutyName.style.transform = 'translate(-50%,-50%) scale('+(maxWidth / el_difficutyName.clientWidth) + ')';
      //    } else {
      //       el_difficutyName.style.transform = null;
      //    }
      // }.bind(this)
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req game list
         ---------------------------------------------------------------------------------- */
      reqGameList: function(){
         const path = '/game_manager/ajax/api/api.SWIM_400'+header.user_info.C_CDA+'.asp';
         const params = {
            LIDX: this.init_info.lidx,
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
               alert('리스트 조회 실패');
               return;
            }
            this.header_info = {
               cdbnm: res.data.cdbnm,
               cdcicon: res.data.cdcicon,
               cdc: res.data.cdc,
               cdcnm: res.data.cdcnm,
               jname: res.data.jname,
               judgepartname: res.data.judgepartname,
               fullname: res.data.fullname,
            };
            this.game_list = cm_fn.copyObjEx(res.data.list, []);
            this.sel_idx = 0;
            this.reqGameInfo();
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            req game info
         ---------------------------------------------------------------------------------- */
      reqGameInfo: function(){
         if (this.getSelRIDX === null) {
            console.log("this.getSelRIDX === null");
            return;
         }
         const path = '/game_manager/ajax/api/api.SWIM_500'+header.user_info.C_CDA+'.asp';
         const params = {
            CDC: this.header_info.cdc,
            RIDX: this.getSelRIDX,
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
               alert('정보 조회 실패');
               return;
            }
            const game_info = cm_fn.copyObjEx(res.data.list[0], null);
            if (game_info.isdisabled === "Y") {
               this.resetInput();
               this.sel_idx = this.sel_idx + 1;
               if (this.sel_idx === this.game_list.length) {
                  alert('모든 입력이 완료되었습니다.');
                  window.location = '/game_manager/pages/list.asp';
                  return;
               }
               this.reqGameInfo();
               return;
            }
            if (game_info.roundstate !== "Y") {
               if (this.game_info === null) {
                  alert('아직 대기중입니다!');
               }
               this.game_info = null;
            } else {
               this.game_info = cm_fn.copyObjEx(res.data.list[0], null);
               // 심사정보 길이 scale 조정 작업 필요
            }
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            점수 저장
         ---------------------------------------------------------------------------------- */
      reqSaveinput: function(){
         if (this.input_text === '') {
            alert('점수를 입력해주세요!');
            return;
         }
         const path = '/game_manager/ajax/api/api.SWIM_600'+header.user_info.C_CDA+'.asp';
         const params = {
            LIDX: this.init_info.lidx,
            RIDX: this.getSelRIDX,
            MIDX: this.game_info.midx,
            RNO: this.game_info.r_roundno,
            SETVAL:Number(this.input_text),
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
               alert('점수 저장 실패');
               return;
            }
            if (this.game_list.length-1 === this.sel_idx) {
               alert('모든 입력이 완료되었습니다.');
               window.location = '/game_manager/pages/list.asp';
               return;
            }
            this.resetInput();
            this.sel_idx = this.sel_idx + 1;
            this.reqGameInfo();
         }.bind(this));
      },
      /* ----------------------------------------------------------------------------------
         심사정보 크기조절
         ---------------------------------------------------------------------------------- */
      setScaleOfDiffNm: function(){

      },
      /* ----------------------------------------------------------------------------------
         키입력
         ---------------------------------------------------------------------------------- */
      keydownInput: function(keyValue){
         const max = 10;
         const maxFirst_len = 2; // 정수 자릿수 제한
         const maxLast_len = 1; // 소수점 이후 자릿수 제한
         const max_len = maxFirst_len + maxLast_len + 1; // 전체길이
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
               ) return; // 최대 길이 체크
               str = str + keyValue;
               if (str.length === maxFirst_len) {
                  str = str + '.';
               }
               break;
            }
         }
         if (max < Number(str)) {
            str = String(max);
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
      /* ----------------------------------------------------------------------------------
         점수입력 모달창 초기화
         ---------------------------------------------------------------------------------- */
      getSelRIDX: function(){
         if (this.sel_idx === null || this.game_list.length === 0) return null;
         return this.game_list[this.sel_idx].r_idx;
      },
   }
});
