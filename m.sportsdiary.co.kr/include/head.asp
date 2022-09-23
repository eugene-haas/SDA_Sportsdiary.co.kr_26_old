<!-- S: meta 태그 영역 -->
   <meta charset="UTF-8">
   <!-- <meta http-equiv="X-UA-Compatible" content="IE=Edge, chrome=1">
   <meta http-equiv="Expires" content="-1">
   <meta http-equiv="Pragma" content="no-cache">
   <meta http-equiv="Cache-Control" content="No-Cache"> -->
   <meta name="viewport" content="width=device-width">
   <meta name="apple-mobile-web-app-title" content="스포츠다이어리" />
   <meta name="format-detection" content="telephone=no" />
   <meta name="mobile-web-app-capable" content="yes">
   <meta name="apple-mobile-web-app-capable" content="yes">
   <!-- <link rel="manifest" href="/include/manifest.json"> -->
<!-- E: meta 태그 영역 -->

<!-- S: icon 영역 -->
   <!-- <link rel="icon" type="image/png" href="/images/ico_knsu.png" sizes="192x192"/>
   <link rel="apple-touch-icon" href="/images/ico_knsu.png" sizes="192x192"/> -->
<!-- E: icon 영역 -->

<title>스포츠다이어리</title>

<!-- S: 스타일 영역 -->
   <link rel="stylesheet" href="/css/reset.css">
   <link rel="stylesheet" href="/css/fonts.css<%=FONTS_CSS_VER%>">
   <link rel="stylesheet" href="/css/style.css<%=STYLE_CSS_VER%>">
<!-- E: 스타일 영역 -->

<!-- S: 라이브러리 영역 -->
   <!-- <script src="/js/library/jquery/jquery-1.12.2.min.js"></script>
   <script src="/js/library/jquery/jquery.easing-1.4.1.min.js"></script>
   <script src="/js/library/jquery/jquery.transit.min.js"></script> -->
   <script src="/js/library/vue/vue.min.js"></script>
   <link href="/js/library/vue/vue.min.js.map">
   <script src="/js/library/axios/axios.min.js"></script>
   <link href="/js/library/axios/axios.min.map">
   <script src="/js/library/date_format.js"></script>
   <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/xeicon@2.3.3/xeicon.min.css">
<!-- E: 라이브러리 영역 -->


<!-- S: 스크립트 영역 -->
   <script async src="/js/etc/default.js<%=DEFAULT_VER%>"></script>
   <!-- default: 기본 스크립트 셋팅 or events -->
   <script async src="/js/etc/define.js<%=DEFINE_VER%>"></script>
   <!-- define: 스포츠 다이어리앱 전역 Define - 대문자로 작성 -->
   <script async src="/js/etc/cm_fn.js<%=CM_FN_VER%>"></script>
   <!-- cm_fn: cm_fn 유틸 함수 객체 선언 -->
   <script async src="/js/etc/vue_filter.js<%=VUE_FILTER_VER%>"></script>
   <!-- vue_filter: vue 전역 필터 -->

<!-- E: 스크립트 영역 -->

<script>
/* ==================================================================================
      /include/receiveParams.asp 에서 만든 전역변수 선언문
      전역 변수 (수정 x, g_etc_obj 를 활용하세요.)
   ================================================================================== */
const g_localStoragePack = JSON.parse(localStorage.getItem(location.pathname));
const g_page_no = Number('<%=page_no%>') || (g_localStoragePack && g_localStoragePack.g_page_no) || null; // 페이지 번호
const g_scrollTop = Number('<%=scrollTop%>') || (g_localStoragePack &&g_localStoragePack.g_scrollTop) || null; // 페이지 스크롤값
const g_search_obj = JSON.parse(('<%=search_obj%>')?'<%=search_obj%>':'""') || (g_localStoragePack &&g_localStoragePack.g_search_obj) || {}; // 검색 조건 obj
const g_etc_obj = JSON.parse(('<%=etc_obj%>')?'<%=etc_obj%>':'""') || (g_localStoragePack &&g_localStoragePack.g_etc_obj) || {}; // 기타 params"
</script>
