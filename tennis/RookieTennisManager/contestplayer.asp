<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookietennisAdmin/html.head.asp" -->
<script type="text/javascript" src="/pub/js/RookieTennis/tennis_contestplayer.js<%=CONST_JSVER%>8"></script>
</head>

<body <%=CONST_BODY%>>

<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/RookietennisAdmin/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.contestplayer.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.footer.asp" -->
</body>
</html>
