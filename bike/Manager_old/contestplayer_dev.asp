<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennisAdmin/html.head.asp" -->
<script type="text/javascript" src="/pub/js/tennis_contestplayer.js?ver=17"></script>
</head>

<body <%=CONST_BODY%>>

<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/tennisAdmin/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.contestplayer_dev.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->
</body>
</html>
