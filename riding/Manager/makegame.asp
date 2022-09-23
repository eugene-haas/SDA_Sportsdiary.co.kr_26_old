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
	<script type="text/javascript" src="/pub/js/riding/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/RDN01_ADM.js<%=CONST_JSVER%>"></script>
</head>


<body <%=CONST_BODY%>>
	<div class="t_default">
		<div id="myModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"></div>


		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

		<div id="body">
			<aside>
			<%'pagename = "gameorder.asp"%>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			<%'pagename = "sc.asp"%>
			</aside>

			<article id="sc_body">
			<!-- #include file = "./body/c.makegame.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->

	</div>
</body>
</html>
