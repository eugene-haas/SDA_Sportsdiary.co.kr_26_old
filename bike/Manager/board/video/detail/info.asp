<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/library/fn.bike.asp" -->

<%
SET db = Server.CreateObject("ADODB.Connection")
    db.CommandTimeout = 1000
    db.Open B_ConStr

titleIdx = request("titleIdx")
SQL = " SELECT TitleName FROM tblBikeTitle WHERE TitleIdx = "& titleIdx &" "
Set rs = db.Execute(SQL)
If Not rs.eof Then
  titleName = rs(0)
End If
%>

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

			<div class="page_title"><h1><%=titleName%></h1></div>

      <!-- ================================================================================================ -->

      <div class="info_serch form-horizontal" id="inputForm">
        <% Server.Execute("info_input.asp")%>
      </div>

      <hr>

      <div class="info_serch form-horizontal" id="searchForm">
        <% Server.Execute("info_search.asp")%>
      </div>

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
