<!-- #include virtual = "/pub/header.bike.asp" -->
<!doctype html>
<html>
<head>
  <!-- #include virtual = "/include/head.asp" -->
  <script src="/js/apply_refund.js"></script>
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
			<div class="page_title"><h1>환불요청 정보</h1></div>
      <!-- ================================================================================================ -->

      <!-- 대회정보 input ================================================================================== -->
      <div class="info_serch form-horizontal" id="inputForm">
        <% Server.Execute("info_search.asp")%>
			</div>
      <!-- ================================================================================================ -->
      <hr>

      <!-- 대회 리스트 ===================================================================================== -->
      <div id="infoList">
        <% Server.Execute("info_list.asp")%>
      </div>
      <!-- ================================================================================================ -->

		</div>
  </article>


  <!-- ================================================================================================ -->





</div>
</body>
</html>
