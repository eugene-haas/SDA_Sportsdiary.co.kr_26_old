<!--#include virtual="/include/asp_setting/charset.asp"-->
<!--#include virtual="/include/ver.asp"-->

<!-- S: meta 태그 영역 -->
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1">
<meta name="apple-mobile-web-app-title" content="" />
<meta name="format-detection" content="telephone=no" />

<link rel="shortcut icon" href="/images/ico/favicon.ico">
<!-- E: meta 태그 영역 -->
<!-- S: 라이브러리 영역 -->
<script src="/js/library/vue/vue.min.js"></script>
   <!-- vue Debug possible key -->
<script src="/js/library/axios/axios.min.js"></script>
<script>
   Vue.config.devtools = true;
</script>
<script src="/js/library/date_format.js"></script>
<!-- E: 라이브러리 영역 -->
<!-- S: 스타일 영역 -->
<link rel="stylesheet" href="/css/reset.css">
<link rel="stylesheet" href="/css/style.css">
<!-- E: 스타일 영역 -->
<!-- S: 스크립트 영역 -->
<script src="/js/etc/default.js<%=DEFAULT_VER%>"></script>
<script defer src="/js/pages/index.js"></script>
<!-- E: 스크립트 영역 -->



<!--#include virtual="/include/asp_setting/receiveParams.asp"-->
<script>
   <%=initscriptstr%>
</script>
