<!-- #include virtual = "/pub/header.adm.asp" -->

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
<!-- #include virtual = "/pub/html/adm/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/swimming/utill.js?v=190820"></script>
<%'Call topnav(menustr(0),menustr(1))%>
</head>

<body <%=CONST_BODY%>>
	<div class="t_default">

		<div class="backLayer" style="z-index:999;" > </div>
		<div id="loadingDiv" style="z-index:999;"></div>


		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<!-- #include virtual = "/pub/html/adm/html.header.asp" -->

		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/adm/html.left.asp" -->
			</aside>

			<article>
				<!-- #include file = "./body/c.judolog.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/adm/html.footer.asp" -->
	</div>
</body>
</html>
