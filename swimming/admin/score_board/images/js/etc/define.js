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
			세부종목
		----------------------------------------------------------------------------------- */
		const E_CDCICON_P										= 1;	// 플렛포옴다이빙(다이빙)
		const E_CDCICON_SB									= 2;	// 스프링보오드(다이빙)
		const E_CDCICON_SD									= 3;	// 스프링다이빙(다이빙)
		const E_CDCICON_S										= 4;  // 싱크로다이빙(다이빙)
		const E_CDCICON_F										= 5;  // 피겨(아티스틱)
		const E_CDCICON_T										= 6;  // 테크(아티스틱)
		const E_CDCICON_FREE									= 7;  // 프리(아티스틱)

		// STRMAP_CDCICON[code]로 사용
		const STRMAP_CDCICON = {
			[E_CDCICON_P]										: "P",	// 플렛포옴다이빙
			[E_CDCICON_SB]										: "SB",	// 스프링보오드
			[E_CDCICON_SD]										: "SD",	// 스프링다이빙
			[E_CDCICON_S]										: "S",  	// 싱크로다이빙
			[E_CDCICON_F]										: "F",  	// 피겨
			[E_CDCICON_T]										: "T",  	// 테크
			[E_CDCICON_FREE]									: "FREE",// 프리
		};
		Object.freeze(STRMAP_CDCICON); // 객체 고정

		// STRMAP_CDCICON_NAME[code]로 사용
		const STRMAP_CDCICON_NAME = {
			[E_CDCICON_P]										: "플렛포옴다이빙",
			[E_CDCICON_SB]										: "스프링보오드",
			[E_CDCICON_SD]										: "스프링다이빙",
			[E_CDCICON_S]										: "싱크로다이빙",
			[E_CDCICON_F]										: "피겨",
			[E_CDCICON_T]										: "테크",
			[E_CDCICON_FREE]									: "프리",
		};
		Object.freeze(STRMAP_CDCICON_NAME); // 객체 고정

	/* -----------------------------------------------------------------------------------
			세부종목 > 경기타입 코드
		----------------------------------------------------------------------------------- */
		const E_CDC_CODE_P									= 21;	//플렛포옴다이빙
		const E_CDC_CODE_SB_1								= 22;	//스프링보오드1M
		const E_CDC_CODE_SB_3								= 23;	//스프링보오드3M
		const E_CDC_CODE_SD									= 26;	//스프링다이빙
		const E_CDC_CODE_S_3									= 24;	//싱크로다이빙3M
		const E_CDC_CODE_S_10								= 25;	//싱크로다이빙10M
		const E_CDC_CODE_SUGU								= 31;	//수구
		const E_CDC_CODE_F_S									= 1;	//피겨 솔로(Solo)
		const E_CDC_CODE_F_D									= 2;	//피겨 듀엣(Duet)
		const E_CDC_CODE_F_T									= 3;	//피겨 팀(Team)
		const E_CDC_CODE_T_S									= 4;	//테크니컬 솔로
		const E_CDC_CODE_T_D									= 6;	//테크니컬 듀엣
		const E_CDC_CODE_T_T									= 12;	//테크니컬 팀
		const E_CDC_CODE_FREE_S								= 5;	//프리 솔로
		const E_CDC_CODE_FREE_D								= 7;	//프리 듀엣
		const E_CDC_CODE_FREE_T								= 11;	//프리 팀

		// STRMAP_CDC_CODE[code]로 사용
		const STRMAP_CDC_CODE = {
			[E_CDC_CODE_P]										: "P",		//플렛포옴다이빙
			[E_CDC_CODE_SB_1]									: "SB_1",	//스프링보오드1M
			[E_CDC_CODE_SB_3]									: "SB_3",	//스프링보오드3M
			[E_CDC_CODE_SD]									: "SD",		//스프링다이빙
			[E_CDC_CODE_S_3]									: "S_3",		//싱크로다이빙3M
			[E_CDC_CODE_S_10]									: "S_10",	//싱크로다이빙10M
			[E_CDC_CODE_SUGU]									: "SUGU",	//수구
			[E_CDC_CODE_F_S]									: "F_S",		//솔로(Solo)
			[E_CDC_CODE_F_D]									: "F_D",		//듀엣(Duet)
			[E_CDC_CODE_F_T]									: "F_T",		//팀(Team)
			[E_CDC_CODE_T_S]									: "T_S",		//테크니컬 솔로
			[E_CDC_CODE_T_D]									: "T_D",		//테크니컬 듀엣
			[E_CDC_CODE_T_T]									: "T_T",		//테크니컬 팀
			[E_CDC_CODE_FREE_S]								: "FREE_S",	//프리 솔로
			[E_CDC_CODE_FREE_D]								: "FREE_D",	//프리 듀엣
			[E_CDC_CODE_FREE_T]								: "FREE_T",	//프리 팀
		};
		Object.freeze(STRMAP_CDC_CODE); // 객체 고정



	/* -----------------------------------------------------------------------------------
			key input enumerate
		----------------------------------------------------------------------------------- */
		const E_KEY_BACKSPACE								= 10;		// 띄어쓰기
		const E_KEY_DOT										= 11;		// .

		// // STRMAP_BED_TYPE[code]로 사용
		// const STRMAP_BED_TYPE = {
		// 	[E_BED_TYPE_A]										: "A",
		// 	[E_BED_TYPE_B]										: "B",
		// 	[E_BED_TYPE_C]										: "C",
		// 	[E_BED_TYPE_D]										: "D",
		// };
		// Object.freeze(STRMAP_BED_TYPE); // 객체 고정
