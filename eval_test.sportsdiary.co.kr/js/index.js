const vm = new Vue({
   el: "#app",
   data: {
      /* -----------------------------------------------------------------------
         모달 관련 변수
         ------------------------------------------------------------------------*/

      /* -----------------------------------------------------------------------
         메인 변수
         ------------------------------------------------------------------------*/
      inputId: "",
      inputPw: "",
   },
   created: function(){

   },
   mounted: function() {
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            권한이 있는 첫 메뉴로 가기
         ---------------------------------------------------------------------------------- */
      goIndex: function(aIDX){
         const path = "/api/ajax/menu/api.menu.asp";
         const params = {
            UIDX: aIDX,
         };
         axios.post(path, params).then(function(res){
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("시스템 에러 - 관리자에게 문의 바랍니다.");
               return;
            }
            const nav_list1 = cm_fn.copyObjEx(res.data.list1, []);
            const nav_list2 = cm_fn.copyObjEx(res.data.list2, []);
            const nav_list3 = cm_fn.copyObjEx(res.data.list3, []);
            const first_page = nav_list3.find(function(nav_obj){
               return nav_obj.Link;
            }.bind(this)) || null;
            if (first_page === null) {
               alert("시스템 에러 - 관리자에게 문의 바랍니다.");
               return;
            }
            cm_fn.goto_url(first_page.Link, {

            })
         });
      },
      /* -----------------------------------------------------------------------------------
            req login
         ---------------------------------------------------------------------------------- */
      reqLogin: function(){
         if (this.inputId === "") {
            alert("아이디를 입력해주세요.");
            this.$refs.id.focus();
            return;
         }
         if (this.inputPw === "") {
            alert("비밀번호를 입력해주세요.");
            this.$refs.pw.focus();
            return;
         }
         const path = "/api/ajax/login/api.login.asp";
         const params = {
            ID: this.inputId,
            PWD: this.inputPw,
         };
         axios.post(path, params).then(function(res){
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               if (res.data.errorcode === "ERR-2000") {
                  alert(res.data.servermsg);
                  return;
               }
               alert("시스템 에러 - 관리자에게 문의 바랍니다.");
               return;
            }
            this.goIndex(res.data.aIDX);
         }.bind(this));
      },
   },
});
