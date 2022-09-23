<!-- #include virtual = "/pub/header.bike.asp" -->
<%
Dim titleIdx
titleIdx = request("titleIdx")
If titleIdx = "" Then
  response.redirect "contest.asp"
End If
%>
<!doctype html>
<html>
<head>
  <!-- #include virtual = "/include/head.asp" -->
  <script src="/js/contest_event.js"></script>
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
			<div class="page_title"><h1>종목관리</h1></div>
      <!-- ================================================================================================ -->

			<div class="info_serch form-horizontal" id="inputForm">
    		<% Server.Execute("info_input.asp")%>
			</div>

      <!-- ================================================================================================ -->
      <hr>

      <div id="infoList" data-title-idx="<%=titleIdx%>">
        <% Server.Execute("info_list.asp")%>
      </div>
      <!-- ================================================================================================ -->

		</div>
  </article>

</div>
</body>
</html>
