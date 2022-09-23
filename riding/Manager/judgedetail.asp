<!-- #include virtual = "/pub/header.radingAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/riding/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/judgedetail.js<%=CONST_JSVER%>"></script>
	<script language="javascript" src="/pub/js/riding/shortcut.js"></script>
</head>


<body <%=CONST_BODY%>>
	<div class="t_default">

		<div id="myModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"></div>

		<div id="myLevelModel" class="modal fade" role="dialog" aria-labelledby="myLevelModelLabel"></div>

		<div id="myConfirm" title="승패" class="modal fade" role="dialog"></div>




		<div id="recordInputModal" class="modal" role="dialog" data-backdrop="static">

			<!--팝업 -->
			<div class="modal-dialog modal-xl" id="rcmodalcontents">

			</div>
		</div>






		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			</aside>

			<article id="sc_body">
			<!-- #include file = "./body/c.judgedetail.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->

	</div>
</body>
</html>
