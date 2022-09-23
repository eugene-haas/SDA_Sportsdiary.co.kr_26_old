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
	<script type="text/javascript" src="/pub/js/adm/bbs.js<%=CONST_JSVER%>"></script>

</head>

<body <%=CONST_BODY%>>
	<div class="t_default">

		<div class="backLayer" style="z-index:999;" > </div>
		<div id="loadingDiv" style="z-index:999;"></div>


		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<!-- #include virtual = "/pub/html/adm/html.header.asp" -->

		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/adm/html.left.asp" -->
			</aside>

			<article  id="sc_body"><%'submit 후 스크롤 체크영역%>
				<!-- #include file = "./body/c.bbs.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/adm/html.footer.asp" -->
	</div>
</body>
</html>
