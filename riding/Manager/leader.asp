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
	<script type="text/javascript" src="/pub/js/riding/utill.js?v=<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/riding/leader.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>
<div class="t_default">
	<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

	<div id="body">
		<aside>
		<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
		</aside>

		<article>
		<!-- #include file = "./body/c.leader.asp" -->
		</article>
	</div>

	<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
</div>
</body>
</html>
