<!-- #include virtual = "/pub/header.bike.asp" -->
<!doctype html>
<html>
<head>
  <!-- #include virtual = "/include/head.asp" -->

<style type="text/css">
.modal.on {
    opacity: 1;
}		
</style>

  <script src="/js/contest.js"></script>
  <!-- ==================================== -->
</head>
<body>

<div class="t_default">
<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel" ></div>


  <!-- #include virtual = "/include/header.asp" -->
  <!-- ====================================== -->
  <!-- #include virtual = "/include/aside.asp" -->
  <!-- ===================================== -->

  <article>
		<div class="admin_content">

      <!-- ================================================================================================ -->
			<div class="page_title"><h1>대회정보관리</h1></div>
      <!-- ================================================================================================ -->

      <!-- 대회정보 input ================================================================================== -->
      <div class="info_serch form-horizontal" id="inputForm">
        <% Server.Execute("info_input.asp")%>
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





</div>
</body>
</html>
