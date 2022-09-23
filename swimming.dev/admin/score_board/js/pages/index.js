const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      inputId: '다이빙_1',
      inputPw: '1234',
   },
   created: function(){

   },
   mounted: function() {
      // this.console();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req login
         ---------------------------------------------------------------------------------- */
      reqLogin: function(){
         const path = "/score_board/ajax/api/api.SWIM_100.asp";
         const params = {
            inputId: this.inputId,
            inputPw: this.inputPw,
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (res.data.result !== E_API_STATUS_SUCCESS) {
               alert(res.data.servermsg);
               return;
            }
            window.location = "/score_board/pages/list.asp";
         });
      },
   },
});
