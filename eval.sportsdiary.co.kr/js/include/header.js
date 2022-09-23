const Header = new Vue({
   name: "header",
   el: "#header",
   data: {
      user_info: g_user_info || null
   },
   created: function(){
      if (this.user_info === null) {
         alert("허용되지 않은 접근입니다.");
         return location.replace('/');
      }
   },
   mounted: function() {
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req login
         ---------------------------------------------------------------------------------- */
      reqLogout: function(){
         const path = "/api/ajax/login/api.logout.asp";
         const params = {};
         axios.post(path, params).then(function(res){
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("시스템 에러 - 관리자에게 문의 바랍니다.");
               return;
            }
            location.replace('/');
         });
      },
   },
});
