<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
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
<!-- #include virtual = "/pub/html/tennisAdmin/html.head.asp" -->
<script type="text/javascript" src="/pub/js/tennis_contest.js?ver=16"></script>
</head>

<body <%=CONST_BODY%>>



<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/tennisAdmin/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.body.asp" -->
	</article>
</div>
<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->	
</body>
</html>
