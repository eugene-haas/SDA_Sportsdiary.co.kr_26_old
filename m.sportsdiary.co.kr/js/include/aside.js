/* -----------------------------------------------------------------------------------
      수정 이력
    · 2021-01-06(날짜) : M1(수정 코드)
        : 수정사유 by chansoo
        : 삭제함수 : 없음
        : 수정함수 : getStrRegionInfo
   ----------------------------------------------------------------------------------- */
let Aside = new Vue({
   name: 'Aside',
   el: "#Aside",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/
      madal_myinfo: {
         show:false,
      },
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      show: false,
      lnb_list: []
      // -----------------------------------------------------------------------

   },
   created: function(){
      // /app/include/head_sports 각 종목의 lnb 리스트
      const lnb_list = window.g_lnb_list||[];
      for (var i = 0; i < lnb_list.length; i++) {
         if(lnb_list[i].show === true){
            lnb_list[i].isOpen = true;
         } else {
            lnb_list[i].isOpen = false;
         }
      }
      this.lnb_list = lnb_list;
   },
   mounted: function() {

   },
   methods: {
      /* -----------------------------------------------------------------------------------
              사이드바 열기
           ---------------------------------------------------------------------------------- */
      openAside: function() {
         const page_str = 'Aside'
         history.pushState({
            page_str: page_str
         }, document.title, location.pathname + '#' + page_str);

         window.onpopstate = function(e){
            if (this.show === true) {
               this.closeAside();
            }
         }.bind(this);
         this.show = true;
      },
      /* -----------------------------------------------------------------------------------
              사이드바 닫기
           ---------------------------------------------------------------------------------- */
      closeAside: function() {
         this.show = false;
         this.madal_myinfo.show = false;
      },
      /* -----------------------------------------------------------------------------------
              lnb 메뉴 열고 닫기
           ---------------------------------------------------------------------------------- */
      toggleLnbGroup: function(idx){
         window.navigator.vibrate(1);
         this.lnb_list[idx].isOpen = !this.lnb_list[idx].isOpen;
      },

      /* -----------------------------------------------------------------------------------
              네정보 보기 열기
           ---------------------------------------------------------------------------------- */
      openMyinfo: function() {
         const page_str = 'Aside/Myinfo'
         history.pushState({
            page_str: page_str
         }, document.title, location.pathname + '#' + page_str);
         window.onpopstate = function(e){
            if (this.madal_myinfo.show === true) {
               this.closeMyinfo();
            }
         }.bind(this);
         this.madal_myinfo.show = true;
      },
      /* -----------------------------------------------------------------------------------
              네정보 보기 닫기
           ---------------------------------------------------------------------------------- */
      closeMyinfo: function() {
         window.onpopstate = function(e){
            if (this.show === true) {
               this.closeAside();
            }
         }.bind(this);
         this.madal_myinfo.show = false;
      },
      getHeight: function(obj){
         if(obj.list.length === 0)return 'auto'
         if(obj.isOpen === true){
            return (obj.list.length * 44) + 'px'
         } else {
            return 0
         }
      },
   },
});
