<!-- #include virtual = "/pub/header.radingAdmin.asp" -->
<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/riding/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/gameresult.js<%=CONST_JSVER%>"></script>
	<script>
		$(document).ready(function() {
			px.allStorage();
		});
	</script>
</head>
<body <%=CONST_BODY%>>
	<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

	<div id="body" class="t_default">
		<aside>
		<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
		</aside>

		<article>
			<!-- #include file = "./body/c.makeCertificate.asp" -->
		</article>
	</div>

	<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
</body>
</html>
