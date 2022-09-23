<!-- #include file = "./inc/header.admin.asp" -->

<!DOCTYPE HTML>
<html lang="ko-KR">
<head>
  <title>관리자로그인</title>
  <meta charset="utf-8" />

  <link rel="stylesheet" type="text/css" href="./css/admin_login_box.css">
  <script src="./js/jquery-1.11.1.min.js"></script>
  <script type="text/javascript" src="./js/common_admlogin.js"></script>
  <style type="text/css">
	#element::-webkit-scrollbar {display: none;}
	::-webkit-scrollbar {display: none;}
	::-webkit-scrollbar {display: block;}
  </style>

<%
'쿠키삭제 오류안나도록
	' 'session.Abandon
	' for each Item in request.cookies
	' 	if item = "saveinfo" or IsNumeric(item) = true then 'popup info / login info
	' 		'pass
	' 	else
	' 		Response.cookies(item).expires	= date - 1365
	' 		Response.cookies(item).domain	= CHKDOMAIN
	' 	end if
	' Next
%>


</head>
<body style="background:#e8ebf0;overflow-y: hidden; overflow-x: hidden;" scroll="no">
<form method='post' name='ssform'><input type='hidden' name='p'></form>
<%
	Set db = new clsDBHelper
	chkrule = False

	indexPage = "/admin/index.asp"
'##############################################
%>
	<form name="form1" id="form1">
		<div class="admin_login_box">
			<div class="login_con">
				<h1 class="logo">
					<img src="http://sdmainadmin.sportsdiary.co.kr/admin/main/Images/sd_logo__origin.png" style="width:40%;" alt="SD ADMIN" />
				</h1>
				<div class="in_list">
					<ul>
						<li>
							<input type="text" id="txtID" name="txtID" class="in_10" placeholder="아이디" onkeydown="if(event.keyCode == 13){plg.login(this, '<%=indexPage%>')}" value="<%=Cookies_adminID%>"  autocomplete="nope"/>
						</li>
						<li>
							<input type="password" id="psAdmin" name="psAdmin" onkeyup="" class="in_10" placeholder="비밀번호"   onkeydown="if(event.keyCode == 13){plg.login(this, '<%=indexPage%>')}"  autocomplete="new-password"/>
						</li>


					</ul>

				</div>
				<a href="javascript:plg.login(this, '<%=indexPage%>')" onkeydown="if(event.keyCode == 13){plg.login(this, '<%=indexPage%>')}" id="btnOK" name="btnOK" class="login_btn">로그인</a>
			</div>
			<p class="copy_text">Copyright 2017 WIDLINE Co., Ltd.. All Rights Reserved.</p>
		</div>
	</form>


</body>
</html>
