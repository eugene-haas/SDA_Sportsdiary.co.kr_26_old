<!-- #include virtual = "/pub/header.ksports.asp" -->
<%
	Set db = new clsDBHelper
'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/ksports/html.head.login.asp" -->
  <link rel="stylesheet" type="text/css" href="/pub/css/tn_login_style.css?v=1">
	<script src="/pub/js/ksports_login.js?v=1"></script>
</head>

<body <%=CONST_BODY%>>

<!-- #include virtual = "/pub/html/ksports/html.header.asp" -->

		<div class="admin_login_box">
			<h1 class="logo">	</h1>

			<div class="login_con">
				<div class="in_list">
					<ul>
						<li>
							<span class="l_text">User ID</span>
						</li>
						<li>
							<input type="text" id="UserID" class="in_10" onkeydown="if(event.keyCode == 13){mx.login();}"/>
						</li>
						<li>
							<span>Password</span>
						</li>
						<li>
							<input type="password" id="UserPass"  class="in_10" autocomplete="off" onkeydown="if(event.keyCode == 13){mx.login();}"/>
						</li>
					</ul>
				</div>
				<a href="javascript:mx.login();"  id="btnOK" name="btnOK" class="login_btn">로그인</a>
			</div>

			<p class="copy_text">Copyright &copy; <strong>WIDLINE</strong> All Rights Reserved.</p>
		</div>

<!-- #include virtual = "/pub/html/ksports/html.footer.asp" -->	
</body>
</html>
