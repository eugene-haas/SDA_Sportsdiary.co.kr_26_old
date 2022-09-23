const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      player_info: {},
      interval: null,
   },
   created: function(){
   },
   mounted: function() {
      document.body.addEventListener('fullscreenchange', function (event) {
        if (document.fullscreenElement) {
          this.startTimer();
        } else {
          this.stopTimer();
        }
     }.bind(this));
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            화면 시작
         ---------------------------------------------------------------------------------- */
      startTimer: function(){
         this.reqInfo();
         this.interval = setInterval(this.reqInfo, 1000 * 10);
      },
      /* -----------------------------------------------------------------------------------
            화면 멈춤
         ---------------------------------------------------------------------------------- */
      stopTimer: function(){
         this.player_info = null;
         clearInterval(this.interval);
      },
      /* -----------------------------------------------------------------------------------
            req 라운드 정보
         ---------------------------------------------------------------------------------- */
      reqInfo: function(){
         const path = "/score_board/ajax/api/api.SWIM_GAMEROUND_E2.asp";
         const params = {
            TIDX: g_page_props.tidx,
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (res.data.result !== E_API_STATUS_SUCCESS) {
               alert(res.data.servermsg);
               return;
            }
            this.player_info = cm_fn.copyObjEx(res.data.list[0], {});
         }.bind(this));
      },
   },
   computed: {
      isBeforeStart: function(){
         if (this.player_info === null || this.player_info.judgecnt === undefined) return false;
         for (var i = 0; i < this.player_info.judgecnt; i++) {
            if (this.player_info["jumsu" + (i+1)] !== null)return false;
         }
         return true;
      }
   }
});
