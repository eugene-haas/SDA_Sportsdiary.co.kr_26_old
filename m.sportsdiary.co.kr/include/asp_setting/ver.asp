<%
'   ===============================================================================
'    Purpose : 버전관리 define 입니다.
'    Author  : chansoo
'   ===============================================================================
%>

<%
'   ===============================================================================
'      global version
'   ===============================================================================
	GLOBAL_VER   								= "&g_ver=1.0.1.0" 				           ' include/header.js
'   ===============================================================================

'   ===============================================================================
'      include dir File version
'   ===============================================================================
	INCLUDE_HEADER_VER   					= "?ver=1.0.1.2" & GLOBAL_VER     	     ' include/header.js
	INCLUDE_ASIDE_VER   						= "?ver=1.0.1.1" & GLOBAL_VER            ' include/aside.js
'   ===============================================================================

'   ===============================================================================
'      etc dir File version
'   ===============================================================================
	DEFAULT_VER		 							= "?ver=1.0.2.9" & GLOBAL_VER            ' default.js
	CM_FN_VER   								= "?ver=1.0.1.0" & GLOBAL_VER            ' Utility cm_fn.js
	DEFINE_VER		 							= "?ver=1.0.1.0" & GLOBAL_VER            ' define.js
	VUE_FILTER_VER 							= "?ver=1.0.1.0" & GLOBAL_VER            ' vue_filter.js
'   ===============================================================================

'   ===============================================================================
'    judo  index + etc dir File version
'   ===============================================================================
	JUDO_INDEX_VER   							= "?ver=1.0.1.0" & GLOBAL_VER         	  ' pages/judo/index.js
	JUDO_LOGIN_VER   							= "?ver=1.0.1.0" & GLOBAL_VER         	  ' page/etc/login.js

	JUDO_GAME_LIST_VER	   				= "?ver=1.0.1.0" & GLOBAL_VER         	  ' page/judo/game/list.js
	JUDO_GAME_INFO_VER	   				= "?ver=1.0.1.0" & GLOBAL_VER         	  ' page/judo/game/info.js
	JUDO_GAME_ATTEND_LIST_VER	   		= "?ver=1.0.1.0" & GLOBAL_VER         	  ' page/judo/game/attend_list.js
'   ===============================================================================

'   ===============================================================================
'      css File version
'   ===============================================================================
	DEFAULT_CSS_VER   						= "?ver=1.0.1.0" & GLOBAL_VER            ' /css/default.css
	FONTS_CSS_VER   							= "?ver=1.0.1.0" & GLOBAL_VER            ' /css/fonts.css
	STYLE_CSS_VER   							= "?ver=1.0.4.6" & GLOBAL_VER            ' /css/style.css
'   ===============================================================================
%>
