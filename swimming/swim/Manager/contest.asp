<!-- #include virtual = "/pub/header.swimAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/swimAdmin/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/swim/tennis_contest.js<%=CONST_JSVER%>"></script>

</head>
<body <%=CONST_BODY%>>
	<div class="t_default contest">
			
		<!-- #include virtual = "/pub/html/swimAdmin/html.header.asp" -->

		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/swimAdmin/html.left.asp" -->
			</aside>

			<article>
			<!-- #include file = "./body/c.contest.asp" -->
			</article>
		</div>
		
		<!-- #include virtual = "/pub/html/swimAdmin/html.footer.asp" -->
	</div>
</body>
</html>
