<!-- #include virtual = "/pub/header.swimAdmin.asp" -->
<%
	If Request.Cookies("UserID") = "" Then
		'Response.Write "<script>top.location.href='./Gate.asp'</script>"
		'Response.End
	End If

	If CDbl(ADGRADE) <= 500 Then
		Response.redirect "./contest.asp"
		Response.End
	End if
%>
<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/swimAdmin/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/swim/tennis_contest.js<%=CONST_JSVER%>5"></script>
</head>
<body <%=CONST_BODY%>>
	<!-- #include virtual = "/pub/html/swimAdmin/html.header.asp" -->

	<div id="body" class="t_default">
		<aside>
		<!-- #include virtual = "/pub/html/swimAdmin/html.left.asp" -->
		</aside>

		<article>
		<!-- #include file = "./body/c.body.asp" -->
		</article>
	</div>

	<!-- #include virtual = "/pub/html/swimAdmin/html.footer.asp" -->
</body>
</html>
