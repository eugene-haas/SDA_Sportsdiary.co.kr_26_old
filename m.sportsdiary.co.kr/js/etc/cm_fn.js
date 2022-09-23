/* ===================================================================================
    스포츠 다이어리앱 전역 유틸 함수
    js 유틸함수는 모두 여기서 관리하세요.
                                                                    By chansoo
	=================================================================================== */
const cm_fn = {};

/* ----------------------------------------------------------------------------------
      copy object
   ----------------------------------------------------------------------------------- */
cm_fn.copyObj = function(obj) {
   let copy = {};
   if (Array.isArray(obj)) {
      copy = obj.slice().map((v) => {
         return cm_fn.copyObj(v);
      });
   } else if (typeof obj === 'object' && obj !== null) {
      for (let attr in obj) {
         if (obj.hasOwnProperty(attr)) {
            copy[attr] = cm_fn.copyObj(obj[attr]);
         }
      }
   } else {
      copy = obj;
   }
   return copy;
}

/* ----------------------------------------------------------------------------------
      copy ajax call 값 전용
      defaultVal에 기본값을 넣어준다.
      cm_fn.copyObjEx(obj: any, defaultVal: any);
   ----------------------------------------------------------------------------------- */
cm_fn.copyObjEx = function(obj, defaultVal) {
   let copy = defaultVal || {};
   if (obj === '' || obj === undefined || obj === null) {
      return copy;
   }

   return cm_fn.copyObj(obj);
}

/* -----------------------------------------------------------------------------------
		  copyDate - yyyy-MM-dd 형식의 문자열을 새로운 date 객체로 만들어서 반환
		---------------------------------------------------------------------------------- */
cm_fn.copyDate = function(dateStr){
	if (dateStr === '') return null;
	const dateArr = dateStr.split('-');
	return new Date(dateArr[0], Number(dateArr[1])-1, dateArr[2]);
}

/* -----------------------------------------------------------------------------------
		  getDateDiff - 두 날짜 간의 차이 일수 반환
		---------------------------------------------------------------------------------- */
cm_fn.getDateDiff = function(start_date, end_date){
	const dateDiff = Math.ceil(Math.abs(end_date - start_date)/(1000*3600*24));
	return dateDiff;
}

/* -----------------------------------------------------------------------------------
		  object -> 쿼리스트링으로 변환
		---------------------------------------------------------------------------------- */
cm_fn.getQueryString = function(obj){
	if (obj === null) return '';
	return Object.entries(obj).map(e => e.join('=')).join('&');
}

/* ----------------------------------------------------------------------------------
   글자수 제한 ex): oninput="cm_fn.checkMaxLength(110)"
   maxLength보다 넘어가면 maxLength만큼 자르기
----------------------------------------------------------------------------------- */
cm_fn.checkMaxLength = function(maxLength) {
   const thisEl = window.event.target;
   if (thisEl.value.length >= maxLength) {
      thisEl.value = thisEl.value.slice(0,maxLength);
   }
   return;
};


/* ----------------------------------------------------------------------------------
   페이지 이동

   const path = '/app/index.asp';
   let pack = {};
   pack.page_num = 3;          //페이징
   pack.scrollTop = 20;       //스크롤 값
   pack.search_obj = {        //검색관련 데이터
      text: '',            // 검색창
      sel_year: 0,         // 년도 선택
      sel_type: 0          // 기타...
   };
   pack.etc_obj = {};         //자유롭게 사용
   cm_fn.goto_url(path: string, pack: object);
----------------------------------------------------------------------------------- */
cm_fn.goto_url = function(path, pack) {
   if (typeof path !== "string") {
      error('cm_fn.goto_url error : path가 string이 아닙니다.');
      return;
   }
   localStorage.removeItem(location.pathname);
   pack = pack||{};
   let f = document.ssform; //폼 name

   f.p.value = JSON.stringify(pack);
   f.action = path;
   f.method = "post"; //POST방식
   f.submit();
}
