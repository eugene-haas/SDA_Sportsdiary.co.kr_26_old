const header = new Vue({
   name: "header",
   el: "#header",
   data: {
      user_info: g_user_info || null
   },
   created: function(){
      window.onload = function(){
         const el_title = this.$refs.title;
         const maxWidth = 600;
         if (!el_title) return;
         if (maxWidth < el_title.clientWidth) {
            el_title.style.transform = 'translate(-50%,-50%) scale('+(maxWidth / el_title.clientWidth) + ')';
         } else {
            el_title.style.transform = null;
         }
      }.bind(this)
   },
   mounted: function() {
   },
   methods: {
      /* ----------------------------------------------------------------------------------
         로그아웃 버튼
         ---------------------------------------------------------------------------------- */
      reqLogout: function(){
         const path = "/game_manager/ajax/api/api.SWIM_200.asp";
         const params = {
         };
         axios.post(path, params).then(function(res){
            log(res);
            if (res.data.result !== E_API_STATUS_SUCCESS) {
               alert('로그아웃 실패')
               return;
            }
            window.location = "/game_manager/index.asp";
         }.bind(this));
      },
   },
});
