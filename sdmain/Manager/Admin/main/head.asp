<%

	Check_AdminLogin()

	AdminYN = fInject(Request("AdminYN"))
	'AdminYN = decode(AdminYN,0)
  AdminYN = crypt.DecryptStringENC(AdminYN)
	UserID = fInject(Request.cookies("UserID"))
	'UserID = decode(UserID,0)
  UserID = crypt.DecryptStringENC(UserID)
	
%>
<!DOCTYPE HTML>
<html lang="ko-KR">
<head>
  <title>SD 통합 어드민</title>
  <meta charset="utf-8" />
  <link rel="stylesheet" type="text/css" href="css/normalize-4.1.1.css">
  <link rel="stylesheet" href="css/lib/jquery-ui.min.css">
  <link rel="stylesheet" type="text/css" href="css/style.css">
  <link rel="stylesheet" type="text/css" href="css/font-awesome.min.css">
  <script src="Js/jquery-1.12.2.min.js"></script>
  <script src="js/jquery-migrate-1.4.1.min.js"></script>
  <!--<script src="js/library/html5shiv.min.js"></script>-->
  <script src="js/library/selectivizr-min.js"></script>
  <!--상태바 관련-->
  <!-- <script type="text/javascript" src="js/common.js"></script>
  <script type="text/javascript" src="js/popup.js"></script> -->
  <!--상태바 관련-->
  <!-- <script type="text/javascript" src="Js/js.js"></script> -->
  <script src="js/library/jquery-ui.min.js"></script>
  <script src="js/library/datepicker-ko.js"></script>
  <script src="../dev/dist/Common_Js.js" type="text/javascript"></script>

</head>
<body>
   <div class="wrap">
      <!-- S : header -->
      <header>
        <div id="header">
          <div class="top-btm">
            <p class="home"><a href="./Admin_Index.asp"><img src="./Images/sd_logo__origin.png" style="width:40%;" alt="" /></a></p>
						<%
							IF UserID <> "" and AdminYN = "Y" Then
						%>
						<ul class="btn-member-list">
              <li><a href="javascript:chk_logout_Admin();" class="btn-logout" title="Log Out">Log Out</a></li>
              <li><a href="javascript:alert('회원정보수정');" class="btn-member" title="회원정보관리"><i class="fa fa-user" aria-hidden="true"></i></a></li>
            </ul>
            <p class="txt-member">안녕하세요. <%=Request.Cookies("UserName")%>님. 접속을 환영합니다.</p>
						<% Else %>
            
						<% End IF %>
          </div>
        </div>
      </header>
      <!-- S : header -->

      <!-- S : container -->
      <div id="container">
      <!--#include file="left_menu.asp"-->
