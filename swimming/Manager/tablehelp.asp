<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
	'내부아이피에서만 호출되도록 설정
	'If USER_IP = "118.33.86.240" Then
	'Else
	'	Response.end
	'End if

	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/swimming/html.head.v1.asp" -->
<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/common_admin.js<%=CONST_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/db/dbcomment.js<%=CONST_JSVER%>"></script>

<%'Call topnav(menustr(0),menustr(1))%>
</head>

<body <%=CONST_BODY%>>
	<div class="t_default">

		<div class="backLayer" style="z-index:999;" > </div>
		<div id="loadingDiv" style="z-index:999;"></div>


		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<!-- #include virtual = "/pub/html/swimming/html.header.asp" -->

		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/swimming/html.left.asp" -->
			</aside>

			<article>
				<!-- #include file = "./body/c.tablehelp.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/swimming/html.footer.asp" -->
	</div>
</body>
</html>
