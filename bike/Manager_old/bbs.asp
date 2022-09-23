<!-- #include virtual = "/pub/header.bike.asp" -->

<!-- #include virtual = "/pub/inc/crypt.asp" -->
<!-- #include virtual = "/pub/inc/bike/request.bbs.asp" -->
<%
	Set db = new clsDBHelper


	chkrule = False
'##############################################
%>
<%=CONST_HTMLVER%>
<!-- #include virtual = "/pub/html/bike/html.head.admin.asp" -->

<script type="text/javascript" src="/pub/js/common.js?ver=1"></script>
<script type="text/javascript" src="/pub/js/bike/bbs.js?ver=1"></script>

<script src="/ckeditor/ckeditor.js"></script>
<%'<script src="https://cdn.ckeditor.com/4.8.0/full-all/ckeditor.js"></script>%>
</head>

<body <%=CONST_BODY%>>
	<!-- 레이어팝업 공통 -->
	<div class="modal fade basic-modal dbhelp_modal" id="dbhelp_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	</div>
	<!-- 레이어팝업 공통 -->


<!-- S: warp -->
<div class="warp">
	<!-- #include virtual = "/pub/html/bike/html.top.admin.asp" --><%'상단영역 , 로그인여부체크%>

	<div class="content">
		  <!-- #include virtual = "/pub/html/bike/html.left.admin.asp" -->

		  <!-- S: right-content -->
		  <div class="right-content">
				<!-- S: navigation -->
				<%Call topnav(menustr(0),menustr(1))%>
				<!-- E: navigation -->

				
				
				<!-- S: pd-30 -->
				<div class="pd-30" id="bbscontents">
						<!-- #include file = "./body/c.bbs.asp" -->
				</div>
				<!-- E: pd-30 -->


		  </div>
		  <!-- E: right-content -->

	</div>
</div>
<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->
</body>
</html>
