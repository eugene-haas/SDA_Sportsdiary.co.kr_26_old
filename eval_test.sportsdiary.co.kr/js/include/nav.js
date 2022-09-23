const nav = new Vue({
   el: "#nav",
   name: "nav",
   data: {
      nav_list: [],
      curPage: null,
      first_page: null,
   },
   created: function(){
      this.reqNavList();
   },
   methods: {
      /* -----------------------------------------------------------------------------------
            req nav
         ---------------------------------------------------------------------------------- */
      reqNavList: function(){
         if (!g_user_info) {
            console.log('로그인 정보가 없음');
            return;
         }
         const pathname = location.pathname;
         const path = "/api/ajax/menu/api.menu.asp";
         const params = {
            UIDX: g_user_info.aIDX,
         };
         axios.post(path, params).then(function(res){
            if (G_IS_DEV === true) log(res);
            if (res.data.errorcode !== E_API_ERRORCODE_SUCCESS) {
               alert("시스템 에러 - 관리자에게 문의 바랍니다.");
               return;
            }
            const nav_list = [];
            const nav_list1 = cm_fn.copyObjEx(res.data.list1, []);
            const nav_list2 = cm_fn.copyObjEx(res.data.list2, []);
            const nav_list3 = cm_fn.copyObjEx(res.data.list3, []);
            this.first_page = nav_list3.find(function(nav_obj){
               return nav_obj.Link
            }.bind(this)) || null;
            this.curPage = nav_list3.find(function(obj){
               return obj.Link === pathname;
            }.bind(this)) || false;
            if (this.curPage === false) {
               alert('권한이 없는 접근입니다.');
               location.replace('/');
               return;
            }

            for (let i = 0; i < nav_list1.length; i++) {
               const nav_info1 = nav_list1[i];
               const list2 = nav_list2.filter(function(obj){
                  return obj.RoleDetailGroup1 === nav_info1.RoleDetailGroup1;
               }.bind(this));
               for (let j = 0; j < list2.length; j++) {
                  const nav_info2 = list2[j];
                  const list3 = nav_list3.filter(function(obj){
                     return obj.RoleDetailGroup1 === nav_info1.RoleDetailGroup1
                        && obj.RoleDetailGroup2 === nav_info2.RoleDetailGroup2;
                  }.bind(this));

                  nav_info2.isActive = nav_info2.RoleDetailGroup2 === this.curPage.RoleDetailGroup2;
                  nav_info2.nav_list3 = list3;
                  nav_info2.PopupYN = list3[0].PopupYN;
                  nav_info2.Link = list3[0].Link;
                  nav_info2.children = [];
               }

               for (var j = 0; j < list2.length; j++) {
                  if (list2[j].Link !== '') continue;
                  for (var k = j+1; k < list2.length; k++) {
                     if (list2[k].RoleDetailGroup2Nm.includes("&nbsp;&nbsp;&nbsp; - ") === false) break;
                     list2[j].children.push(list2[k].Link);
                     if (list2[k].RoleDetailGroup2 === this.curPage.RoleDetailGroup2) {
                        list2[j].isActive = true;
                     }
                  }
               }


               nav_info1.isActive = nav_info1.RoleDetailGroup1 === this.curPage.RoleDetailGroup1;
               nav_info1.isHover = false;
               nav_info1.nav_list2 = list2;
               nav_info1.PopupYN = list2[0].PopupYN;
               nav_info1.Link = list2[0].Link;
               if (list2[0].Link === '' && list2[1]) {
                  nav_info1.Link = list2[1].Link;
               }
               nav_list.push(nav_info1);
            }

            this.nav_list = nav_list;
         }.bind(this));
      },
      /* -----------------------------------------------------------------------------------
            네비게이션 호버 효과
         ---------------------------------------------------------------------------------- */
      handleMouseOver: function(nav_info){
         nav_info.isHover = true;
      },
      /* -----------------------------------------------------------------------------------
            네비게이션 호버 효과
         ---------------------------------------------------------------------------------- */
      handleMouseLeave: function(nav_info){
         nav_info.isHover = false;
      },
   },
});
