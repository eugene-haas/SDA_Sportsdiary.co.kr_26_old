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
<%If request("test") = "t" then%>
<script type="text/javascript" src="/pub/js/ksports/ksports_list_ts.js?ver=15"></script>
<%else%>
<script type="text/javascript" src="/pub/js/ksports/ksports_list_v2.js?ver=15"></script>
<%End if%>


<style>
  .admin_content .table_list table tr:nth-child(2n){background-color:#f7f9fb;}
  .admin_content .table_list table tr:nth-child(2n) td{background:none;}

</style>

</head>
<body <%=CONST_BODY%>>
	<div class="backLayer" style="z-index:999;" > </div>
	<div id="loadingDiv" style="z-index:999;"></div>
	<div id="myModal" class="modal hide fade tourney_admin_modal contest_page" role="dialog" aria-labelledby="myModalLabel"></div>

<!-- #include virtual = "/pub/html/ksports/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/ksports/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.klist.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/ksports/html.footer.asp" -->
</body>
</html>
