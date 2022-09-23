/* ===================================================================================
    대한수영연맹 심판입력 시스템에서 사용하는 전역 Define
                                                                    By Chansoo

	 G_& 				: 		글로벌 변수
	 E_& 				: 		enumerate(열거형 상수값)
	 STRMAP_& 		: 		상수값에 맵핑되는 display용 문자열 객체

     - 변수명
	 &_list 			:		각 객체의 리스트
	 sel_& 			:		리스트에서 선택한 객체의 seq
	 &_info 			:		각 객체

	  - 객체 의미 맵
	 user 			: 		로그인한 유저

	 eval 			: 		혁신평가 하나 - 1년에 한번 정도로 생긴다.
	 gun				:		스포츠협회들의 군. 가, 나, 다, 라 등의 군으로 나눈다.
	 group 			: 		스포츠협회들

	 input			:		군별, 협회별 평가

	 cate				:		평가 법주, 각 협회마다 5가지 정도의 평가 범주를 가진다.
	 subcate			: 		평가 항목, 각 범주마다 다양한 항목을 가진다.
	 item				: 		평가 지표, 각 평가 항목마다 다양한 지표를 가진다.
	 type				:		평가 방식, 각 평가 지표마다 하나씩 평가 방식이 정해져있다.
	 typeItem		:		item별, type별로 세분화된 평가 객체 객체


	 rater			: 		평가자

	 score			: 		각 평가지표(typeItem)의 배점

	=================================================================================== */

	/* -----------------------------------------------------------------------------------
			global 변수
		----------------------------------------------------------------------------------- */
		const G_IS_DEV											= true; 		// 개발 여부 -> 전체 js 로그를 활성화합니다.
		// const G_START_YEAR									= 2019; 		// 측정 검색 범위(G_START_YEAR ~ currentYear)
		// const G_PAGE_MAX 										= 5;			// 페이지 그룹 개수(변경시 주의)
		// const G_PAGE_PER_CNT 								= 10;			// 전역 리스트 개수 변수
		// const G_PAGE_PER_CNT_MIN		 					= 7;			// 전역 리스트 개수 변수 - 화면 맞춤
		const G_MODAL_DURATION 								= 300;		// 전역 모달 duration 0.3초

		const iframeHead = `
		   <link rel="stylesheet" href="/css/fonts.css?ver=1.0.0.1<%=GLOBAL_VER%>" />
		   <link rel="stylesheet" href="/css/reset.css?ver=1.0.0.1<%=GLOBAL_VER%>" />
		   <link rel="stylesheet" href="/css/style.css?ver=1.0.0.1<%=GLOBAL_VER%>" />
		   <script>
		      if (!Element.prototype.hasOwnProperty('outerHeight')) {
		         Object.defineProperty(Element.prototype, 'outerHeight', {
		            'get': function(){
		               var height = this.clientHeight;
		               var computedStyle = window.getComputedStyle(this);
		               height += parseInt(computedStyle.marginTop, 10);
		               height += parseInt(computedStyle.marginBottom, 10);
		               height += parseInt(computedStyle.borderTopWidth, 10);
		               height += parseInt(computedStyle.borderBottomWidth, 10);
		               return height;
		            }
		         });
		      }
		   </script>
		`;

	/* -----------------------------------------------------------------------------------
			api res status
		----------------------------------------------------------------------------------- */
		const E_API_ERRORCODE_SUCCESS 					= "SUCCESS"; // 성공

	/* -----------------------------------------------------------------------------------
			평가상태
		----------------------------------------------------------------------------------- */
		const E_EVAL_STATE_READY							= 0;  // 등록하기
		const E_EVAL_STATE_END								= 1;  // 등록완료
		const E_EVAL_STATE_ING								= 2;  // 등록중

	/* -----------------------------------------------------------------------------------
			평가 타입 코드
		----------------------------------------------------------------------------------- */
		const E_EVAL_TYPE_ABSOLUTE							= 1;  // 정성
		const E_EVAL_TYPE_RELATIVE							= 2;  // 정량
		const E_EVAL_TYPE_DEDUCT							= 100;  // 감점

	/* -----------------------------------------------------------------------------------
			비교평가 위치
		----------------------------------------------------------------------------------- */
		const E_POS_LEFT										= 0;  // 왼쪽
		const E_POS_RIGHT										= 1;  // 오른쪽

	/* -----------------------------------------------------------------------------------
			통계 탭
		----------------------------------------------------------------------------------- */
		const E_TYPE_ALL										= 0;  // 전체

	/* -----------------------------------------------------------------------------------
			총평 등록 에러 코드
		----------------------------------------------------------------------------------- */
		const E_TOTAL_DESC_NOT_AUTHIRITY    			= "ERR_3001";			// 권한 없음
		const E_TOTAL_DESC_NOT_ASSOCIATION   			= "ERR_3002";			// 미등록 협회

	/* -----------------------------------------------------------------------------------
			평가의견 등록 에러 코드
		----------------------------------------------------------------------------------- */
		const E_DESC_NOT_AUTHIRITY    					= "ERR_3101";			// 권한 없음
		const E_DESC_NOT_ASSOCIATION   					= "ERR_3102";			// 미등록 협회
		const E_DESC_MISSMATCH_DATA   					= "ERR_3103";			// id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.
		const E_DESC_MISSMATCH_DATA_CNT 					= "ERR_3104";			// client에서 보낸 평가의견과 평가 항목의 갯수가 틀리다.
	/* -----------------------------------------------------------------------------------
			평가점수 등록 에러 코드
		----------------------------------------------------------------------------------- */
		const E_POINT_NOT_AUTHIRITY    					= "ERR_3201";			// 권한 없음
		const E_POINT_NOT_ASSOCIATION   					= "ERR_3202";			// 미등록 협회
		const E_POINT_MISSMATCH_DATA   					= "ERR_3203";			// id에 할당된 측정 항목과 client로 부터 받은 측정 항목이 다르다.
		const E_POINT_MISSMATCH_DATA_CNT 				= "ERR_3204";			// client에서 보낸 평가점수와 평가 항목의 갯수가 틀리다.
		const E_POINT_OVER_MAXPOINT 						= "ERR_3205";			// 평가 점수가 최대 평가 점수보다 높다.
