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
	<%'<script src="https://cdn.ckeditor.com/4.8.0/full-all/ckeditor.js"></script>%>
	<script src="/ckeditor/ckeditor.js"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/contest.js<%=CONST_JSVER%>"></script>

</head>
<body <%=CONST_BODY%>>
	<div class="t_default contest">
		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->
		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			</aside>

			<article>
				<!-- #include file = "./body/c.contest.asp" -->
			</article>
		</div>
		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
	</div>
</body>
</html>
