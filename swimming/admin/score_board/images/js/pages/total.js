const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      player_list: [],
      header_info: null,
      roundcnt: 0,
      pageNum: -1,
      pagePerCnt: 10,
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
         this.pageNum = -1;
         this.reqList();
         this.interval = setInterval(this.reqList, 1000 * 10);
      },
      /* -----------------------------------------------------------------------------------
            화면 멈춤
         ---------------------------------------------------------------------------------- */
      stopTimer: function(){
         this.pageNum = -1;
         this.player_list = [];
         this.header_info = null;
         clearInterval(this.interval);
      },
      /* -----------------------------------------------------------------------------------
            req 점수 리스트
         ---------------------------------------------------------------------------------- */
      reqList: function(){
         const path = "/score_board/ajax/api/api.SWIM_GAMETOTAL_E2.asp";
         const params = {
            TIDX: g_page_props.tidx,
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (res.data.result !== E_API_STATUS_SUCCESS) {
               alert(res.data.servermsg);
               return;
            }
            ++this.pageNum;
            this.roundcnt = cm_fn.copyObjEx(Number(res.data.roundcnt), 0);

            this.header_info = {
               CDBNM: res.data.CDBNM,
               CDCNM: res.data.CDCNM,
            };

            const player_list = cm_fn.copyObjEx(res.data.list, []);
            if (player_list.length <= (this.pageNum) * this.pagePerCnt) {
               this.pageNum = 0;
            }
            const list = player_list.filter(function(info, idx){
               return this.pageNum*this.pagePerCnt <= idx && idx < (this.pageNum+1)*this.pagePerCnt;
            }.bind(this));

            const list_len = list.length; // 부족한 만큼 null로 채우기
            for (var i = 0; i < this.pagePerCnt - list_len; i++) {
               list.push(null);
            }
            // this.player_list = list;
            this.setTransitionList(list);
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            차례차례 리스트 수정하기
         ---------------------------------------------------------------------------------- */
      setTransitionList: async function(list){
         const goWithTimeout = function(callback, time){
            return new Promise(function(resolve, reject){
               return setTimeout(function(){
                  callback();
                  resolve();
               }, time);
            });
         }
         const player_list_len = this.player_list.length;
         for (var i = 0; i < player_list_len; i++) {
            await goWithTimeout(function(){
               this.player_list.pop();
            }.bind(this), 200);
         }
         const list_len = list.length;
         for (var i = 0; i < list_len; i++) {
            await goWithTimeout(function(){
               this.player_list.push(list[i]);
            }.bind(this), 100);
         }
      }
   },
   computed: {
   }
});
