<!DOCTYPE html>
<html lang="ko" dir="ltr">
   <head>
      <!--#include virtual="/game_manager/include/head.asp"-->
   </head>
   <body>
      <%
         'Cookies_billBoard
         Set oJSONoutput = JSON.Parse( join(array(Cookies_billBoard)) )
         cda =  oJSONoutput.get("C_CDA")
         tidx = oJSONoutput.get("C_TIDX")
         tname = oJSONoutput.get("C_TNAME")
      %>
      라운드경기결과

         <main id="app" class="l_main" v-clock>

<%=cda%>/<%=tidx%>/<%=tname%><br><br><br><br>


               <table>
                  <tbody>
                     <div v-for="(match, match_idx) in matchresult_list">
                        <div v-for="(value, key) in match">{{key}} : {{value}}</div>
                     </div>
                  </tbody>
               </table>



         </main>


   
<script>
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
      matchresult_list: [],
   },
   created: function(){
      this.reqMatchResult();
   },
   mounted: function() {
      // this.console();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req match list
         ---------------------------------------------------------------------------------- */
      reqMatchResult: function(){
         const path = '/game_manager/ajax/api/api.SWIM_GAMEROUND_E2.asp';
         const params = {
            TIDX: <%=tidx%>,
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (String(res.data.result) !== E_API_STATUS_SUCCESS) {
               alert('리스트 조회 실패');
               return;
            }
            this.matchresult_list = cm_fn.copyObjEx(res.data.list, []);
         }.bind(this));
      },

   },
});
</script>
   
   
   </body>
</html>
