<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<%
	Set db = new clsDBHelper
'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>
<head>
<!-- #include virtual = "/pub/html/tennisAdmin/html.head.v1.asp" -->
<script type="text/javascript" src="/pub/js/tennis_gamerull3.js?ver=1"></script>
</head>

<body <%=CONST_BODY%>>
  <div class="backLayer" style="z-index:999;" > </div>
  <div id="loadingDiv" style="z-index:999;"></div>

	<div id="myModal" class="modal hide fade tourney_admin_modal contest_page"></div>
	<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->
	<div id="body">

		<aside>
		<!-- #include virtual = "/pub/html/tennisAdmin/html.left.asp" -->
		</aside>
		<article>
		<!-- #include file = "./body/c.gamerull3.asp" -->
		</article>

	</div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->	
</body>
</html>