
import Vue from 'vue'
// yyyy-MM-dd -> 'yyyy년 MM월 dd일'
// 2020-08-26 -> '2020년 8월 26일'
Vue.filter('displayDate', function(val) {
    let strDate = "";
    let aryDate = [];
    if (!val) return "";
    aryDate = val.slice(0, 10).split("-");
    if (aryDate.length != 3) return "";
 
    strDate = utx.sprintf("{0}년 {1}월 {2}일", aryDate[0], Number(aryDate[1]), Number(aryDate[2]));
    return strDate;
 });
 
 Vue.filter('dateFormat', function(dateStr, formatStr, defaultStr) {
    const val = new Date(dateStr);
    if (!(val instanceof Date && !isNaN(val))) {  // d.valueOf() could also work
       return '-';
    }
    if (!dateStr && defaultStr) {
       return defaultStr;
    }
    return val.format(formatStr);
 });
 
 // number, fill_cnt -> number의 앞부분을 fill_cnt만큼 0으로 채운다.
 // 123, 6 -> '000123'
 Vue.filter('fillZero', function(val, fill_cnt) {
    let value = String(val);
    let result = '';
    const val_len = value.length;
    for (var i = 0; i < fill_cnt - val_len; i++) {
       result = '0' + result;
    }
    result = result + value;
    return result;
 });
 
 // 2000 -> '2,000'+lastStr
 // 0 -> lastStr
 Vue.filter('displayComma', function(val, lastStr) {
    if (lastStr == undefined) lastStr = '';
    if (!val) return lastStr;
    val = Number(val);
    return String(val).replace(/\B(?=(\d{3})+(?!\d))/g, ",") + lastStr;
 });
 
 /* ===================================================================================
     전화번호 view 000-0000-0000
     =================================================================================== */
 Vue.filter('display_phone', function(val) {
    const phone = val.replace(/-/g, "");
    return phone.replace(/(^02.{0}|^01.{1}|[0-9]{3})([0-9]+)([0-9]{4})/, "$1-$2-$3");
 });
 