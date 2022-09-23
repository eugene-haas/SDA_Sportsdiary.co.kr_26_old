<!-- #include virtual = "/pub/header.bike.asp" -->
<%
    response.redirect "index2.asp"
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/bike/html.head.asp" -->
<%'<script type="text/javascript" src="/pub/js/bike/bike_contest.js?ver=15"></script>%>
</head>
<body <%=CONST_BODY%>>
	<div class="backLayer" style="z-index:999;" > </div>
	<div id="loadingDiv" style="z-index:999;"></div>
	<div id="myModal" class="modal hide fade tourney_admin_modal contest_page" role="dialog" aria-labelledby="myModalLabel"></div>

<!-- #include virtual = "/pub/html/bike/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/bike/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.bike.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->
</body>
</html>
