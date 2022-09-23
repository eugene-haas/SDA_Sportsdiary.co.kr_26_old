<!-- #include virtual = "/pub/header.bike.asp" -->

<script language="Javascript" runat="server">
function hasown(obj,  prop){
	if (obj.hasOwnProperty(prop) == true){
		return "ok";
	}
	else{
		return "notok";
	}
}
</script>

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################


%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/bike/html.head.asp" -->
<script type="text/javascript" src="/pub/js/bike/bike_contest.js?ver=15"></script>
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
	<!-- #include file = "./body/c.contest.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->	
</body>
</html>