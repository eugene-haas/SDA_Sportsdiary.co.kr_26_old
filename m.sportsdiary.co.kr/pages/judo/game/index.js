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
      show_cal: false,
      sel_tab: 1,
      tab_list: [
         {
            name: '전체',
            idx: 1,
            color: '#1a4c96',
         },{
            name: '진행',
            idx: 2,
            color: '#ee9b0b',
         },{
            name: '예정',
            idx: 3,
            color: '#388e70',
         },{
            name: '완료',
            idx: 4,
            color: '#a3a6ab',
         },
      ],
      // -----------------------------------------------------------------------
      calendar: null,
   },
   created: function() {},
   mounted: function() {
      this.inItCal();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
              캘린더 생성
           ---------------------------------------------------------------------------------- */
      inItCal: function(){
         if(!this.$refs.calender)return;
         this.calendar = new FullCalendar.Calendar(this.$refs.calender, {
            initialView: 'dayGridMonth',
            headerToolbar: false,
            dayCellContent: function(date) {
               return date.dayNumberText.replace('일', '');
            },
            droppable: false,
            events: []
         });
         this.calendar.render();
         this.calendar.addEventSource([
            {
               id: 'a',
               title: 'my event',
               start: '2021-02-01',
               end: '2021-03-01'
            }
         ]);
      },
      /* -----------------------------------------------------------------------------------
              캘린더 날짜 얻기
           ---------------------------------------------------------------------------------- */
      getCurDate: function() {
         return this.calendar.currentData.currentDate;
      },
      /* -----------------------------------------------------------------------------------
              메인페이지로 이동
           ---------------------------------------------------------------------------------- */
      console: function() {
         log('console');
         const path = 'http://sdmain.sportsdiary.co.kr/sdmain/ajax/Login_OK.asp';
         const params = {
            UserID: 'chansoo1280',
            UserPass: '1234qwer',
            saveid: 'Y'
         };
         this.$http(path, params, function(res) {
            log(this.text)
         });
      },
   },
   computed: {
      getSelTab: function(){
         return this.tab_list.find(function(tab){
            return this.sel_tab === tab.idx;
         }.bind(this));
      },
   }
});
