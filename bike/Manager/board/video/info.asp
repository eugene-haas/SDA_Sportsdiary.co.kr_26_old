<!-- #include virtual = "/pub/header.bike.asp" -->
<!doctype html>
<html>
<head>
  <!-- #include virtual = "/include/head.asp" -->
  <script src="/js/video.js"></script>
  <!-- ==================================== -->
</head>
<body>
<div class="t_default">


  <!-- #include virtual = "/include/header.asp" -->
  <!-- ====================================== -->
  <!-- #include virtual = "/include/aside.asp" -->
  <!-- ===================================== -->


  <article>
		<div class="admin_content">

      <!-- ================================================================================================ -->

			<div class="page_title"><h1>대회영상</h1></div>

      <!-- ================================================================================================ -->

			<div class="info_serch form-horizontal" id="infoSearch">
        <% Server.Execute("info_search.asp")%>
			</div>

      <!-- ================================================================================================ -->
      <hr>

      <div id="infoList">
        <% Server.Execute("info_list.asp")%>
      </div>
      <!-- ================================================================================================ -->

		</div>
  </article>





</div>
</body>
</html>
