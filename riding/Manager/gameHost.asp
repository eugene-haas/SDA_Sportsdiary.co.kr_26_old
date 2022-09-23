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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/gamehost.js<%=CONST_JSVER%>"></script>


<style type="text/css" media="print">

@page {
  size: landscape;
}

.landscape { 
    width: 100%; 
    height: 100%; 
    margin: 0% 0% 0% 0%; filter: progid:DXImageTransform.Microsoft.BasicImage(Rotation=1); 
} 
</style>


</head>
<body <%=CONST_BODY%>>
	<div class="t_default contest">
		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->
		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			</aside>

			<article>
			      <!-- #include file = "./body/c.gameHost.asp" -->
			</article>
		</div>
		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->
	</div>
</body>
</html>