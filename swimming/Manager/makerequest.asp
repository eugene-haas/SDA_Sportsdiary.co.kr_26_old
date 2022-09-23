<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/makerequest.js<%=CONST_JSVER%>"></script>
</head>


<body <%=CONST_BODY%>>
	<div class="t_default">
		<div id="myModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"></div>


		<!-- #include virtual = "/pub/html/swimming/html.header.asp" -->

		<div id="body">
			<aside>
			<%'pagename = "gameorder.asp"%>
			<!-- #include virtual = "/pub/html/swimming/html.left.asp" -->
			<%'pagename = "sc.asp"%>
			</aside>

			<article id="sc_body">
			<!-- #include file = "./body/c.makerequest.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/swimming/html.footer.asp" -->

	</div>
</body>
</html>
