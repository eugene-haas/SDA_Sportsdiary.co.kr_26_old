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
      madal_gameInfo: {
         show: false,
      },
      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      sel_gameTab: 4,
      gameTab_list: g_gameTab_list || [],
   },
   created: function() {},
   mounted: function() {
   },
   methods: {
   },
   computed: {
   }
});
