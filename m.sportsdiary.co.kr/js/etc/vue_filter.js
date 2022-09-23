/* ===================================================================================
    스포츠 다이어리앱 전역 vue filter
                                                                    By chansoo
	=================================================================================== */
// yyyy-MM-dd -> 'yyyy년 MM월 dd일'
// 2020-08-26 -> '2020년 8월 26일'
Vue.filter('displayDate', function(val) {
   let strDate = "";
   let aryDate = [];
   if (!val) return "";
   aryDate = val.slice(0, 10).split("-");
   if (aryDate.length != 3) return "";

   strDate = utx.sprintf("{0}년 {1}월 {2}일", aryDate[0], aryDate[1].replace(/(^0+)/, ''), aryDate[2].replace(/(^0+)/, ''));
   return strDate;
});
