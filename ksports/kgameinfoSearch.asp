<!-- #include virtual = "/pub/header.ksports.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/ksports/html.head.asp" -->
<script type="text/javascript" src="/pub/js/ksports/ksports_gameinfo.js?ver=1"></script>
</head>
<body <%=CONST_BODY%> style="overflow:scroll;">

	<div id="loadingDiv" style="z-index:999;"></div>
	<div id="myModal" class="modal hide fade tourney_admin_modal contest_page" role="dialog" aria-labelledby="myModalLabel"></div>



<div id="body">

	<!-- #include file = "./body/c.kgameinfoSearch.asp" -->

</div>

<!-- #include virtual = "/pub/html/ksports/html.footer.asp" -->
</body>
</html>
