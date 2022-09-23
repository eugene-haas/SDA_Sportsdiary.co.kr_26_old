<!-- #include virtual = "/pub/header.adm.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/adm/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/adm/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/adm/makerequest.js<%=CONST_JSVER%>"></script>
</head>


<body <%=CONST_BODY%>>
	<div class="t_default">
		<div id="myModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"></div>


		<!-- #include virtual = "/pub/html/adm/html.header.asp" -->

		<div id="body">
			<aside>
			<%'pagename = "gameorder.asp"%>
			<!-- #include virtual = "/pub/html/adm/html.left.asp" -->
			<%'pagename = "sc.asp"%>
			</aside>

			<article id="sc_body">
			<!-- #include file = "./body/c.jsonP.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/adm/html.footer.asp" -->

	</div>
</body>
</html>
