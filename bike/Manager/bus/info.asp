<!-- #include virtual = "/pub/header.bike.asp" -->

<%
' --대회정보
' select * from tblBikeTitle
'
' --개인정보
' select * from SD_Member.dbo.tblMember
'
' -- 결제정보
' select * from tblBikePayment
'
' -- 버스정보
' select * from tblBikeBusList
' select * from tblBikeBusApply
'
' -- 환불요청
' select * from tblBikeRefund

%>


<!doctype html>
<html>
<head>
  <!-- #include virtual = "/include/head.asp" -->
  <script src="/js/bus.js"></script>
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
			<div class="page_title"><h1>버스관리</h1></div>
      <!-- ================================================================================================ -->

      <!-- 대회정보 input ================================================================================== -->
      <div class="info_serch form-horizontal" id="inputForm">
        <% Server.Execute("info_input.asp")%>
			</div>
      <!-- ================================================================================================ -->
      <hr>

      <!-- 대회정보 search ================================================================================= -->
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
