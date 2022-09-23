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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/standard.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>
	<div class="t_default">


		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

		<div id="body">
			<%pagename = "jgstandard.asp"%>
			<aside>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			</aside>

			<article>
			<!-- #include file = "./body/c.jgstandardW.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->

	</div>
</body>
</html>
