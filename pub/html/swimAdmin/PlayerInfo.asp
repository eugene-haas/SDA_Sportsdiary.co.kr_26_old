<!-- #include virtual = "/pub/header.swimAdmin.asp" -->
<%'<!-- #include virtual = "/pub/class/jsonObejct.class.asp" -->%>

<%
	Set db = new clsDBHelper
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/swimAdmin/html.head.asp" -->
</head>

<body <%=CONST_BODY%>>

<!-- #include virtual = "/pub/html/swimAdmin/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/swimAdmin/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.PlayerInfo.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/swimAdmin/html.footer.asp" -->	
</body>
</html>