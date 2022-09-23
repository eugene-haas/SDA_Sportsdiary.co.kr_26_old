<!-- #include virtual = "/pub/header.bm.asp" -->
<%
If USER_IP <> "118.33.86.240" Then
	Response.End
End if



	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>
<head>
<!-- #include virtual = "/pub/html/html.head.migration.asp" -->

<script type="text/javascript" src="/pub/js/bm_migration.js?ver=<%= second(now)%>"></script>
</head>

<body <%=CONST_BODY%>>

<!-- #include file = "./body/body.migration.asp" -->


<!-- #include virtual = "/pub/html/html.footer.migration.asp" -->
</body>
</html>