/* -----------------------------------------------------------------------------------
      수정 이력
    · 2021-01-06(날짜) : M1(수정 코드)
        : 수정사유 by chansoo
        : 삭제함수 : 없음
        : 수정함수 : getStrRegionInfo
   ----------------------------------------------------------------------------------- */

const header = new Vue({
   name: 'header',
   el: "#header",
   data: {
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      h1: g_page_option.h1 || '',
      sports: null,
      sports_name: null,
      backPath: g_page_option.backPath || null,
      isPopup: g_page_option.isPopup || false,
      isInfo: g_page_option.isInfo || false,
   },
   created: function(){
      if(location.pathname.indexOf('judo') !== -1){
         this.sports = 'judo';
         this.sports_name = '대한유도회'
      }
      window.onload = function(){
         const el_title = this.$refs.title;
         const el_container = this.$refs.container;
         const maxWidth = el_container.offsetWidth - 100;
         if (!el_title) return;
         if (maxWidth < el_title.clientWidth) {
            el_title.style.transform = 'translate(-50%,-50%) scale('+(maxWidth / el_title.clientWidth) + ')';
         } else {
            el_title.style.transform = null;
         }
      }.bind(this);
   },
   mounted: function() {

   },
   methods: {
      /* -----------------------------------------------------------------------------------
            뒤로가기 버튼
         ---------------------------------------------------------------------------------- */
      historyBack: function(){
         localStorage.removeItem(location.pathname);
         if (this.backPath !== null) {
            window.location = this.backPath;
            return;
         } else {
            history.back();
            return;
         }
      }
   },
});
