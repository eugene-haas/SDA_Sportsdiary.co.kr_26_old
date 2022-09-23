<!-- #include virtual = "/pub/header.pub.asp" -->

<!DOCTYPE HTML>
<html lang="ko-KR">
<head>
  <title>관리자로그인</title>
  <meta charset="utf-8" />

  <link rel="stylesheet" type="text/css" href="/pub/css/artisticadmin_login_box.css">
  <script src="/pub/js/jquery-1.11.1.min.js"></script>
  <script type="text/javascript" src="/pub/js/common_admlogin.js"></script>
  <style type="text/css">
	#element::-webkit-scrollbar {display: none;}
	::-webkit-scrollbar {display: none;}
	::-webkit-scrollbar {display: block;}	


	#intro-bg {background-image: url('http://j.sportsdiary.co.kr/WebTournament/www/images/tournerment/intro/bg.jpg');-webkit-background-size: cover;background-size: cover;background-repeat: no-repeat;width: 1280px;height: 775px;}
  </style>

<%
'쿠키삭제 오류안나도록

	'session.Abandon
	for each Item in request.cookies
		if item = "saveinfo" or IsNumeric(item) = true then 'popup info / login info 
			'pass
		else
			Response.cookies(item).expires	= date - 1365
			Response.cookies(item).domain	= CHKDOMAIN	
		end if
	Next
%>


</head>
<body style="background:#e8ebf0;overflow-y: hidden; overflow-x: hidden;" scroll="no">

<form method='post' name='ssform'><input type='hidden' name='p'></form>
<%
	Set db = new clsDBHelper
	chkrule = False


	'도메인에 따라 처음 로그인후 갈  인덱스 페이지 지정 
	'indexPage = "http://www.sdmembers.co.kr/admin/main/main_banner_list.asp"
	indexPage = "/index.asp"
'##############################################
%>
	<form name="form1" id="form1">
		<div class="admin_login_box" >
			<div class="login_con" id="intro-bg">
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

						<li>
							<input type="text" id="txtCODE" name="txtCODE" class="in_10" placeholder="업체코드" onkeydown="if(event.keyCode == 13){plg.login(this, '<%=indexPage%>')}"  autocomplete="nope"/>
						</li>

					</ul>
					<label for="login-check-1">
						<input type="checkbox" id="login-check-1"  <%If Cookies_adminID <> "" then%>checked<%End if%>/>
						<span>아이디 저장</span>
					</label>
				</div>
				<a href="javascript:plg.login(this, '<%=indexPage%>')" onkeydown="if(event.keyCode == 13){plg.login(this, '<%=indexPage%>')}" id="btnOK" name="btnOK" class="login_btn">로그인</a>
			</div>
			<p class="copy_text">Copyright 2017 WIDLINE Co., Ltd.. All Rights Reserved.</p>
		</div>
	</form>


<%'<!-- #include virtual = "/pub/html/mall/html.footer.admlogin.asp" -->%>
</body>
</html>