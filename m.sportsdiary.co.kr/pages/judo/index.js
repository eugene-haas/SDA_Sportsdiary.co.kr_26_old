/* -----------------------------------------------------------------------------------
      수정 이력
    · 2021-01-06(날짜) : M1(수정 코드)
        : 수정사유 by chansoo
        : 삭제함수 : 없음
        : 수정함수 : getStrRegionInfo
   ----------------------------------------------------------------------------------- */
const vm = new Vue({
   el: "#vue_app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/
      modal_gameInfo: {
         show: false
      }
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/

      // -----------------------------------------------------------------------
   },
   created: function(){

   },
   mounted: function() {
   },
   methods: {
      // openModalGameInfo: function(){
      //    this.$setHistory('ModalProfile', function(e){
      //       if (this.modal_gameInfo.show === true) {
      //          this.closeModalGameInfo();
      //       } else {
      //          history.back();
      //       }
      //    });
      //    this.modal_gameInfo.show = true;
      // },
      // closeModalGameInfo: function(){
      //    this.$setHistory('');
      //    this.modal_gameInfo.show = false;
      // },
      goMain: function(){
         const path = '/index.asp';
         let pack = {};
         pack.page_no = 20;
         pack.scrollTop = 20;
         pack.search_obj = {};
         pack.etc_obj = {};
         cm_fn.goto_url(path, pack);
      },
      goList: function(){
         const path = '/pages/judo/game/index.asp';
         const pack = {};
         pack.page_no = 20;
         pack.scrollTop = 20;
         pack.search_obj = {};
         pack.etc_obj = {
            seq: 123123
         };
         cm_fn.goto_url(path, pack);
      },
   },
});
