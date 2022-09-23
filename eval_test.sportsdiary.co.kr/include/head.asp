<%
   ' If (Request.ServerVariables("REMOTE_ADDR") <> "112.187.195.132") Then
   If (0) Then
      Response.write ""
   End If
%>

<!-- S: meta 태그 영역 -->
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<meta
  name="viewport"
  content="width=device-width,initial-scale=1,maximum-scale=5"
/>
<meta name="apple-mobile-web-app-title" content="" />
<meta name="format-detection" content="telephone=no" />

<meta name="mobile-web-app-capable" content="yes" />
<meta name="apple-mobile-web-app-capable" content="yes" />
<!-- <link rel="manifest" href="/main/include/manifest.json"> -->
<link
  rel="icon"
  type="image/png"
  href="/main/images/app/ico_knsu.png"
  sizes="192x192"
/>
<link
  rel="apple-touch-icon"
  href="/main/images/app/ico_knsu.png"
  sizes="192x192"
/>

<link rel="shortcut icon" href="/images/ico/favicon.ico" />
<!-- E: meta 태그 영역 -->

<title>체육단체 혁신평가</title>
<meta name="description" content="체육단체 혁신평가 시스템입니다." />

<!-- S: 스타일 영역 -->
<link rel="stylesheet" href="/css/fonts.css?ver=1.0.0.0<%=GLOBAL_VER%>" />
<link rel="stylesheet" href="/css/reset.css?ver=1.0.0.0<%=GLOBAL_VER%>" />
<link rel="stylesheet" href="/css/style.css?ver=1.0.0.0<%=GLOBAL_VER%>" />
<!-- E: 스타일 영역 -->

<!-- S: 라이브러리 영역 -->
<script src="/js/library/vue/vue.min.js"></script>
<!-- vue Debug possible key -->
<script src="/js/library/axios/axios.min.js"></script>
<script>
  Vue.config.devtools = true;
</script>
<script src="/js/library/date_format.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
<script src="/js/library/Chart/chart.js"></script>
<script src="/js/library/Chart/chartjs-plugin-datalabels.js"></script>
<script>
  Chart.register(ChartDataLabels);
</script>
<!-- E: 라이브러리 영역 -->
<!-- S: 스크립트 영역 -->
<script src="/js/etc/define.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
<script src="/js/etc/default.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
<script src="/js/etc/vue_filter.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
<script src="/js/etc/cm_fn.js?ver=1.0.0.0<%=GLOBAL_VER%>"></script>
<!-- E: 스크립트 영역 -->
<script>
   const g_user_info = <%=Cookies_adminDecode%>;
   <%=initscriptstr%>
</script>
