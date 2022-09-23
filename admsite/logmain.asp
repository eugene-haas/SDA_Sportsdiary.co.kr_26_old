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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/common_admin.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/menulist.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>
<div class="t_default">

  <div class="backLayer" style="z-index:999;"> </div>
  <div id="loadingDiv" style="z-index:999;"></div>

	<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

	<!-- #include virtual = "/pub/html/adm/html.header.asp" -->

	<div id="body">
		<aside>
		<!-- #include virtual = "/pub/html/adm/html.left.asp" -->
		</aside>

		<article>
			<!-- #include file = "./body/c.logmain.asp" -->
		</article>
	</div>

	<!-- #include virtual = "/pub/html/adm/html.footer.asp" -->

</div>
</body>
</html>
