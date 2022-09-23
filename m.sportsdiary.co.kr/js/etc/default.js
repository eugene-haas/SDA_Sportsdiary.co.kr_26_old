/* ===================================================================================
    스포츠 다이어리앱 전역 default 스크립트 파일

    1. console 단축 정의
    2. 페이지 변수 저장
    3. history 관리
    4. 360px 이하 화면 사이즈 지원
    5. window events
                                                                    By chansoo
	=================================================================================== */

// 1. console 단축 정의
const log = console.log;
const dir = console.dir;
const error = console.error;

// 2. 페이지 변수 저장
// -> pushState를 사용할 시 post form에 값이 사라지기에 localStorage로 임시 저장
const setParamsInLocalStorage = function(){
   if (g_page_no !== null || g_scrollTop !== null || JSON.stringify(g_search_obj) !== '{}' || JSON.stringify(g_etc_obj) !== '{}') {
      localStorage.setItem(location.pathname, JSON.stringify({
         g_page_no:g_page_no,
         g_scrollTop:g_scrollTop,
         g_search_obj:g_search_obj,
         g_etc_obj:g_etc_obj,
      }));
   } else {
      localStorage.removeItem(location.pathname);
   }
}


// 2. axios 통신 방식 정의
// Vue.prototype.$http = function(path, params, callback){
//    if (callback === undefined) {
//       callback = function(){};
//    }
//    if (typeof callback !== 'function') {
//       error('$http error : callback이 function이 아닙니다.');
//       return;
//    }
//    // 호출한 함수 이름 표시
//    let caller_str = (new Error().stack.split('at ') || [])[2];
//    if (caller_str) {
//       caller_str = String(caller_str).replace('bn', 'vm').replace('\n    ', '\n');
//    }
//    axios.post(path, params).then(function(res){
//       log(caller_str, res);
//       if (res.data.state !== "SUCCESS") {
//          error('통신 오류 : res.data.state != "SUCCESS"\n    패스   : ' + (path !== ""? path : '패스가 없습니다.'));
//          return;
//       }
//       callback.call(this, res);
//    }.bind(this)).catch(function(err){
//       error(err);
//       return;
//    });
// };
/* -----------------------------------------------------------------------------------
   사용법
   const path = '';
   const params = {};
   this.$http(path, params, function(res){
      //callback 내부에서 this(vm)사용 가능 합니다.
      log(res);
   });
----------------------------------------------------------------------------------- */

// 3. history 관리
// Vue.prototype.$setHistory = function(page_str, callback) {
//    if (typeof page_str !== 'string') {
//       error('$pushHistory error : page_str이 string이 아닙니다.');
//       return;
//    }
//    if (page_str === '') {// hash 지우기 this.$setHistory('');
//       history.replaceState({
//          page_str: ''
//       }, document.title, location.pathname);
//       return;
//    } else {
//       history.pushState({
//          page_str: page_str
//       }, document.title, location.pathname + '#' + page_str);
//
//       if (typeof callback !== 'function') {
//          error('$pushHistory error : callback이 function이 아닙니다.');
//          return;
//       }
//       // history back에 state를 더합니다.
//       // back했을때 callback이 대신 실행됩니다.
//       window.onpopstate = function(event) {
//          callback.call(this, event);
//       }.bind(this);
//       return;
//    }
// };

/* -----------------------------------------------------------------------------------
   사용법(/app/js/include/aside.js 참고)
   열때
   this.$setHistory('name', function(e){
      if (this.show === true) {
         this.closeAside();//닫는 함수 호출
      } else {
         history.back();//이미 닫혀있을때 처리
      }
   });
   닫을때
   this.$setHistory('');
----------------------------------------------------------------------------------- */

// 4. 360px 이하 화면 사이즈 지원
const setScreenWidth = function(){
   const el_l_wrap = document.querySelector('#__WRAP');
   if (el_l_wrap === null)return;
   const minWidth = el_l_wrap.clientWidth;
   if (window.outerWidth < minWidth) {
      el_l_wrap.style.height = (window.outerHeight * (minWidth / window.outerWidth)) +'px';
   } else {
      el_l_wrap.style.height = null;
   }
}

// 5. window events

window.addEventListener('load', (event) => {

   setScreenWidth();
   setParamsInLocalStorage();

   // 해쉬 지우기
   // var noHashURL = window.location.href.replace(/#.*$/, '');
   //  window.history.replaceState('', document.title, noHashURL)

});

window.addEventListener('resize', setScreenWidth);
window.addEventListener('DOMContentLoaded', setScreenWidth);
// 4. DragDown 검색창 event 설정 함수
// Vue.prototype.$setDragDown = function(element){
//    return function(){
//       if (element === undefined) {
//          return;
//       }
//       let dragDownBox = element.children[0];
//       let dragDownBtn = element.children[1];
//       let duration = 300;
//       let that = this;
//       let clientY_gab = 0;
//       let clientY = 0;
//       const max_height = dragDownBox.clientHeight;
//       const clientTop = getClientTop(element);
//       this.dragDown_obj.max_height = max_height;
//       this.dragDown_obj.height = 0;
//
//       function getClientTop(element){
//          return element.offsetTop + element.offsetParent.offsetParent.offsetTop;
//       }
//
//       function inOutQuad(n){
//          n *= 2;
//          if (n < 1) return 0.5 * n * n;
//          return - 0.5 * (--n * (n - 2) - 1);
//       }
//       dragDownBtn.addEventListener('mousedown', dragMouseDown);
//       dragDownBtn.addEventListener('touchstart', dragMouseDown);
//       dragDownBtn.addEventListener('click', clickDragElement.bind(this));
//       dragDownBtn.addEventListener('touchend', clickDragElement.bind(this));
//
//       function dragMouseDown(e) {
//          e = e || window.event;
//          if (e.cancelable) {
//             e.preventDefault();
//          }
//          that.dragDown_obj.isTouch = true;
//          that.dragDown_obj.isDraged = false;
//          if (e.changedTouches) {
//             e.clientY = e.changedTouches[0].clientY;
//          }
//          clientY = e.clientY;
//          document.addEventListener('mouseup', closeDragElement);
//          document.addEventListener('touchend', closeDragElement);
//          document.addEventListener('mousemove', elementDrag);
//          document.addEventListener('touchmove', elementDrag);
//       }
//       function elementDrag(e) {
//          if (Math.abs(clientY_gab) > 1) {
//             that.dragDown_obj.isDraged = true;
//          }
//          e = e || window.event;
//          // e.preventDefault();
//          if (e.changedTouches) {
//             e.clientY = e.changedTouches[0].clientY;
//          }
//          clientY_gab = e.clientY - clientY;
//          clientY = e.clientY;
//          let heightVal = 0;
//          if ((that.dragDown_obj.height + clientY_gab) < 0 || clientY < 20 + clientTop) {
//             heightVal = 0;
//             that.dragDown_obj.isOpen = false;
//          } else if ((that.dragDown_obj.height + clientY_gab) > max_height || clientY > dragDownBtn.offsetHeight + max_height + 20 + clientTop) {
//             heightVal = max_height;
//             that.dragDown_obj.isOpen = true;
//          } else {
//             heightVal = (that.dragDown_obj.height + clientY_gab);
//          }
//          that.dragDown_obj.height = heightVal;
//       }
//
//       function closeDragElement() {
//          let end = +new Date() + duration;
//          let current = null;
//          let remaining = null;
//          that.dragDown_obj.isTouch = false;
//          let progress = that.dragDown_obj.height/max_height;
//          if ( (that.dragDown_obj.height > 0 && that.dragDown_obj.height < max_height/3) ) {
//             function step() {
//                current = +new Date();
//                remaining = (end - duration*(1-progress)) - current;
//                if (remaining >= 0) {
//                   var rate = inOutQuad(remaining / duration);
//                   that.dragDown_obj.height = (max_height * rate);
//                } else {
//                   that.dragDown_obj.height = (max_height * 0);
//                   return;
//                }
//                window.requestAnimationFrame(step);
//             }
//             requestAnimationFrame(step);
//             that.dragDown_obj.isOpen = false;
//          } else if ( (that.dragDown_obj.height < max_height && that.dragDown_obj.height >= max_height/3) ) {
//             function step() {
//                current = +new Date();
//                remaining = (end - duration*progress) - current;
//                if (remaining >= 0) {
//                   var rate = 1 - inOutQuad(remaining / duration);
//                   that.dragDown_obj.height = (max_height * rate);
//                } else {
//                   that.dragDown_obj.height = (max_height * 1);
//                   return;
//                }
//                window.requestAnimationFrame(step);
//             }
//             requestAnimationFrame(step);
//             that.dragDown_obj.isOpen = true;
//          }
//          document.removeEventListener('mouseup', closeDragElement);
//          document.removeEventListener('touchend', closeDragElement);
//          document.removeEventListener('mousemove', elementDrag);
//          document.removeEventListener('touchmove', elementDrag);
//       }
//       function clickDragElement(){
//          let end = +new Date() + duration;
//          let current = null;
//          let remaining = null;
//          if (that.dragDown_obj.isDraged === true) {
//             return;
//          }
//          if (this.dragDown_obj.isOpen === false && that.dragDown_obj.height < 10) {
//             function step() {
//                current = +new Date();
//                remaining = end - current;
//                if (remaining >= 0) {
//                   var rate = 1 - inOutQuad(remaining / duration);
//                   this.dragDown_obj.height = (max_height * rate);
//                } else {
//                   this.dragDown_obj.height = (max_height * 1);
//                   this.dragDown_obj.isOpen = true;
//                   return;
//                }
//                window.requestAnimationFrame(step.bind(this));
//             }
//             requestAnimationFrame(step.bind(this));
//          } else if(this.dragDown_obj.isOpen === true && that.dragDown_obj.height > max_height-10){
//             function step() {
//                current = +new Date();
//                remaining = end - current;
//                if (remaining >= 0) {
//                   var rate = inOutQuad(remaining / duration);
//                   this.dragDown_obj.height = (max_height * rate);
//                } else {
//                   this.dragDown_obj.height = (max_height * 0);
//                   this.dragDown_obj.isOpen = false;
//                   return;
//                }
//                window.requestAnimationFrame(step.bind(this));
//             }
//             requestAnimationFrame(step.bind(this));
//          }
//       }
//    }.bind(this)();
// }
/* -----------------------------------------------------------------------------------
   사용법
   dragDown_obj: {
      isDraged: false,
      isOpen: false,
      isTouch: false,
      height: 'auto',
      max_height: null,
   },

   <div ref="dragDown" class="main__search t_drag-down">
      <div class="main__search__drag-down" :style="{height: dragDown_obj.height + 'px'}">
         검색 내용
      </div>
      <button class="main__search__btn-more" type="button">검색창 열기</button>
   </div>

----------------------------------------------------------------------------------- */
