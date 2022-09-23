<!-- #include virtual = "/pub/header.bike.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/bike/html.head.asp" -->
<script type="text/javascript" src="/pub/js/bike/bike_findcontestplayer.js?ver=1"></script>
</head>

<body <%=CONST_BODY%>>
<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>



<!-- #include virtual = "/pub/html/bike/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/bike/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.findcontestplayer.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->
</body>
</html>
