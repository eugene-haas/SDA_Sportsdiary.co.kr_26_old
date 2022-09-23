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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/tennis_contestplayer.js<%=CONST_JSVER%>8"></script>

</head>

<body <%=CONST_BODY%>>
	<div class="t_default">

		<div id="myModal" class="modal hide fade tourney_admin_modal" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

		<div id="body">
			<aside>
			<%pagename = "contest.asp"%>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			<%pagename = "contestplayer.asp"%>
			</aside>

			<article>
			<!-- #include file = "./body/c.contestplayer.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
	</div>
</body>
</html>
