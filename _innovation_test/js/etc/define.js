/* ===================================================================================
    대한수영연맹 심판입력 시스템에서 사용하는 전역 Define
                                                                    By Chansoo

		G_- : 글로벌 변수
		E_- : enumerate(열거형 상수값)
		STRMAP_ : 상수값에 맵핑되는 display용 문자열 객체
	=================================================================================== */

	/* -----------------------------------------------------------------------------------
			global 변수
		----------------------------------------------------------------------------------- */
		const G_IS_DEV											= true; 		// 개발 여부
		// const G_START_YEAR									= 2019; 		// 측정 검색 범위(G_START_YEAR ~ currentYear)
		// const G_PAGE_MAX 										= 5;			// 페이지 그룹 개수(변경시 주의)
		// const G_PAGE_PER_CNT 								= 10;			// 전역 리스트 개수 변수
		// const G_PAGE_PER_CNT_MIN		 					= 7;			// 전역 리스트 개수 변수 - 화면 맞춤
		const G_MODAL_DURATION 								= 300;		// 전역 모달 duration 0.3초

	/* -----------------------------------------------------------------------------------
			api cmd define
		----------------------------------------------------------------------------------- */
		//Server.Execute ("/game_manager/ajax/api/api.SWIM_" & CMD & ".asp")
		// const E_API_PATH 										= "/game_manager/ajax/reqSwim.asp";
		// const E_API_CMD_LOGIN								= 100;		// 로그인  (CMD , inputId,  inputPw)
		// const E_API_CMD_LOGOUT								= 200;		// 로그아웃 (CMD)
		// const E_API_CMD_MATCHLIST							= 300;		// 종목리스트 (CMD)
		// const E_API_CMD_GAMELIST							= 400;		// 경기진행리스트 (CMD, LIDX)

	/* -----------------------------------------------------------------------------------
			api res status
		----------------------------------------------------------------------------------- */
		const E_API_STATUS_SUCCESS 						= "0"; // 성공

	/* -----------------------------------------------------------------------------------
			평가항목
		----------------------------------------------------------------------------------- */
		const E_TYPE_ALL 										= 0;  // 평가항목 전체
		const E_TYPE_VISION 									= 1;  // 비전전략(15)
		const E_TYPE_ORG 										= 2;  // 조직운영(20)
		const E_TYPE_BUSINESS 								= 3;  // 주요사업(40)
		const E_TYPE_AUTONOMY 								= 4;  // 단체자율성(15)
		const E_TYPE_ETHICS 									= 5;  // 인원 및 윤리(10)

		// STRMAP_TYPE[code]로 사용
		const STRMAP_TYPE = {
			[E_TYPE_ALL]										: "전체",
			[E_TYPE_VISION]									: "비전전략",
			[E_TYPE_ORG]										: "조직운영",
			[E_TYPE_BUSINESS]									: "주요사업",
			[E_TYPE_AUTONOMY]									: "단체자율성",
			[E_TYPE_ETHICS]									: "인원 및 윤리",
		};
		Object.freeze(STRMAP_TYPE); // 객체 고정

		// STRMAP_TYPE_SCORE[code]로 사용
		const STRMAP_TYPE_SCORE = {
			[E_TYPE_VISION]									: "15",
			[E_TYPE_ORG]										: "20",
			[E_TYPE_BUSINESS]									: "40",
			[E_TYPE_AUTONOMY]									: "15",
			[E_TYPE_ETHICS]									: "10",
		};
		Object.freeze(STRMAP_TYPE_SCORE); // 객체 고정


	/* -----------------------------------------------------------------------------------
			평가항목
		----------------------------------------------------------------------------------- */
		const E_TYPE_BUSINESS_LIFE							= 1;  // 생활체육(12)
		const E_TYPE_BUSINESS_PRO							= 2;  // 전문체육(18)
		const E_TYPE_BUSINESS_SCHOOL						= 3;  // 학교체육(5)
		const E_TYPE_BUSINESS_VIRTUOUS					= 4;  // 선순환 체계(5)

		// STRMAP_TYPE_BUSINESS[code]로 사용
		const STRMAP_TYPE_BUSINESS = {
			[E_TYPE_BUSINESS_LIFE]							: "생활체육",
			[E_TYPE_BUSINESS_PRO]							: "전문체육",
			[E_TYPE_BUSINESS_SCHOOL]						: "학교체육",
			[E_TYPE_BUSINESS_VIRTUOUS]						: "선순환 체계",
		};
		Object.freeze(STRMAP_TYPE_BUSINESS); // 객체 고정

		// STRMAP_TYPE_BUSINESS_SCORE[code]로 사용
		const STRMAP_TYPE_BUSINESS_SCORE = {
			[E_TYPE_BUSINESS_LIFE]							: "12",
			[E_TYPE_BUSINESS_PRO]							: "18",
			[E_TYPE_BUSINESS_SCHOOL]						: "5",
			[E_TYPE_BUSINESS_VIRTUOUS]						: "5",
		};
		Object.freeze(STRMAP_TYPE_BUSINESS_SCORE); // 객체 고정
