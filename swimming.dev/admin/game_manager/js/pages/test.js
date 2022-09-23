const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      now_date: new Date(),
      match_list: [],
      match_info: {
         match_num: 18,
         winner: 0,//0:left, 1:right
         match_list: [
            {
               match_num: 16,
               winner: 0,//0:left, 1:right
               match_list: [
                  {
                     match_num: 12,
                     winner: 0,//0:left, 1:right
                     match_list: [
                        {
                           match_num: 4,
                           winner: 0,//0:left, 1:right
                           match_list: [
                              {
                                 match_num: 1,
                                 winner: 0,//0:left, 1:right
                              }
                           ]
                        },{
                           match_num: 5,
                           winner: 0,//0:left, 1:right
                        }
                     ]
                  },{
                     match_num: 13,
                     winner: 0,//0:left, 1:right
                  }
               ]
            },{
               match_num: 17,
               winner: 0,//0:left, 1:right
               match_list: [
                  {
                     match_num: 14,
                     winner: 0,//0:left, 1:right
                  },{
                     match_num: 15,
                     winner: 0,//0:left, 1:right
                  }
               ]
            }
         ]
      }
   },
   created: function(){
      // this.reqMatchList();
   },
   mounted: function() {
      // this.console();
   },
   methods: {
      getMatchList: function(match_list){
         const list = [];
         for (var i = 0; i < match_list.length; i++) {
            list.push(`
               <li>
                  ${match_list[i].match_num}
                  ${
                     match_list[i].match_list?
                     `<ol>
                        ${this.getMatchList(match_list[i].match_list)}
                     </ol>`:
                     ''
                  }
               </li>
            `)
         }
         return list.join('');
      }
   },
});
