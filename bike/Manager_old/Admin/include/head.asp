<!DOCTYPE HTML>
<html lang="ko-KR">
<head>
  <meta charset="utf-8" />
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>자전거 관리자</title>
  <script type="text/javascript" src="/Admin/js/jquery-1.12.2.min.js"></script>

  <link rel="stylesheet" href="/Admin/css/lib/jquery.timepicker.min.css">
    <script type="text/javascript" src="/Admin/js/library/jquery.timepicker.min.js"></script>
  <link rel="stylesheet" href="/Admin/css/lib/jquery-ui.min.css">
  <link rel="stylesheet" href="/Admin/css/lib/bootstrap-datepicker.css">
  <link rel="stylesheet" type="text/css" href="/Admin/css/bootstrap.css">
  <link rel="stylesheet" type="text/css" href="/Admin/css/fontawesome-all.css">
  <link rel="stylesheet" type="text/css" href="/Admin/css/style.css">
  
  <!-- sd_admin.css -->
  <link rel="stylesheet" type="text/css" href="/Admin/css/admin/admin.d.style.css">

  <script type="text/javascript" src="/Admin/js/library/bootstrap-datepicker.js"></script>
  <script type="text/javascript" src="/Admin/js/jquery-migrate-1.4.1.min.js"></script>
  <script type="text/javascript" src="/Admin/js/library/selectivizr-min.js"></script>
  <script type="text/javascript" src="/Admin/js/library/jquery-ui.min.js"></script>
  <script type="text/javascript" src="/Admin/js/library/jquery.easing.min.js"></script>
  <script type="text/javascript" src="/Admin/js/library/bootstrap.min.js"></script>
  <script src="/Admin/js/library/placeholders.min.js"></script>
  <script type="text/javascript" src="/Admin/js/library/datepicker-ko.js"></script>
  <script type="text/javascript" src="/Admin/dev/dist/Common_Js.js" ></script>
  <script type="text/javascript" src="/Admin/js/CommonAjax.js"></script>
  <script type="text/javascript" src="/Admin/js/bdadmin.js"></script>
  <script>
    var locationStr = "";
  </script>
</head>
<body>
  <%
    Check_AdminLogin()

    AdminYN = fInject(Request("AdminYN"))
    AdminYN = decode(AdminYN,0)
    UserID = fInject(Request.cookies("UserID"))
    UserID = decode(UserID,0)
    
  %>

  <!-- S : header -->
  <div id="header">
    <div class="top-btm">
      <p class="home">
        <a href="/Main/AdminMenu/Admin_Index.asp"><img src="/Images/admin_logo.png" alt="Bike 자전거"></a>
      </p>
      <%
        IF UserID <> "" and AdminYN = "Y" Then
      %>
      <div class="header_btn">
        <a href="javascript:chk_logout_Admin();" class="btn-logout" title="Log Out">Log Out</a>
        <a href="javascript:alert('회원정보수정');" class="btn-member" title="회원정보관리"><i class="fas fa-user-circle"></i></a>
      </div>
      <p class="txt-member">안녕하세요. <%=Request.Cookies("UserName")%>님. 접속을 환영합니다.</p>
      <% Else %>

      <% End IF %>
    </div>
  </div>
  <!-- S : header -->

  <!--#include file="left_menu.asp"-->
