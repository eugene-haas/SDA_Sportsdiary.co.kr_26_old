<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookietennisAdmin/html.head.v1.asp" -->
<script type="text/javascript" src="/pub/js/RookieTennis/tennis_contest.js<%=CONST_JSVER%>"></script>




</head>

<body <%=CONST_BODY%>>

  
  <div class="backLayer" style="z-index:999;" > </div>
  <div id="loadingDiv" style="z-index:999;"></div>


<div id="myModal" class="modal hide fade tourney_admin_modal contest_page" role="dialog" aria-labelledby="myModalLabel"></div>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.header.asp" -->

<div id="body">
	<aside>
	<!-- #include virtual = "/pub/html/RookietennisAdmin/html.left.asp" -->
	</aside>

	<article>
	<!-- #include file = "./body/c.contest.asp" -->
	</article>
</div>

<!-- #include virtual = "/pub/html/RookietennisAdmin/html.footer.asp" -->	
</body>
</html>