
<!-- S: meta 태그 영역 -->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=5">
<meta name="apple-mobile-web-app-title" content="" />
<meta name="format-detection" content="telephone=no" />

<meta name="mobile-web-app-capable" content="yes">
<meta name="apple-mobile-web-app-capable" content="yes">
<!-- <link rel="manifest" href="/main/include/manifest.json"> -->
<link rel="icon" type="image/png" href="/main/images/app/ico_knsu.png" sizes="192x192"/>
<link rel="apple-touch-icon" href="/main/images/app/ico_knsu.png" sizes="192x192"/>

<link rel="shortcut icon" href="/score_board/images/ico/favicon.ico">
<!-- E: meta 태그 영역 -->

<title>대한수영연맹 스코어보드</title>
<meta name="description" content="대한수영연맹의 전광판입니다.">

<!-- S: 라이브러리 영역 -->
<script src="/score_board/js/library/vue/vue.min.js"></script>
   <!-- vue Debug possible key -->
<script src="/score_board/js/library/axios/axios.min.js"></script>
<script>
   Vue.config.devtools = true;
</script>
<script src="/score_board/js/library/date_format.js"></script>
<!-- E: 라이브러리 영역 -->
<!-- S: 스타일 영역 -->
<link rel="stylesheet" href="/score_board/css/fonts.css">
<link rel="stylesheet" href="/score_board/css/reset.css<%=CSS_RESET_VER%>">
<link rel="stylesheet" href="/score_board/css/style.css<%=CSS_STYLE_VER%>">
<!-- E: 스타일 영역 -->
<!-- S: 스크립트 영역 -->
<script src="/score_board/js/etc/define.js<%=DEFINE_VER%>"></script>
<script src="/score_board/js/etc/default.js<%=DEFAULT_VER%>"></script>
<script src="/score_board/js/etc/vue_filter.js<%=VUE_FILTER_VER%>"></script>
<script src="/score_board/js/etc/cm_fn.js<%=COMMON_FN_VER%>"></script>
<!-- E: 스크립트 영역 -->

<script>
   <%=initscriptstr%>
</script>
