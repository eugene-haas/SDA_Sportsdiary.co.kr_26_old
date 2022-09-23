<!-- #include virtual = "/pub/header.RookieTennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계 

Response.End  '(사용안함)
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/RookietennisAdmin/html.head.asp" -->
<script type="text/javascript" src="/pub/js/RookieTennis/tennis_contestplayer.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>

<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>


<div id="body">

	<article>
	<!-- #include file = "./body/c.contesttryout.asp" -->
	</article>
</div>

</body>
</html>