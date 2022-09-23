<!-- #include virtual = "/pub/header.bike.asp" -->

<!-- #include virtual = "/pub/inc/crypt.asp" -->
<!-- #include virtual = "/pub/inc/bike/request.admin.asp" -->
<%
	Set db = new clsDBHelper


	'왼쪽 등록 페이지 아님
	chkrule = False
	PAGENAME = "contest2.asp" '상위 페이지명
	'왼쪽 등록 페이지 아님

'##############################################
%>
<%=CONST_HTMLVER%>
<!-- #include virtual = "/pub/html/bike/html.head.admin.asp" -->

<script type="text/javascript" src="/pub/js/common.js?ver=1"></script>
<script type="text/javascript" src="/pub/js/bike/bike_contestlevel.js?ver=15"></script>
</head>

<body <%=CONST_BODY%>>
	<!-- 레이어팝업 공통 -->
	<!-- <div class="backLayer" style="z-index:999;" ></div>
	<div id="loadingDiv" style="z-index:999;"></div> -->
	<div id="myModal" class="modal hide fade tourney_admin_modal contest_page" role="dialog" aria-labelledby="myModalLabel"></div>
	<!-- 레이어팝업 공통 -->


	<!-- #include virtual = "/pub/html/bike/html.top.admin.asp" --><%'상단영역 , 로그인여부체크%>

	<div class="content">
		  <!-- #include virtual = "/pub/html/bike/html.left.admin.asp" -->

		  <!-- S: right-content -->
		  <div class="right-content">
				<!-- S: navigation -->
				<%Call topnav(menustr(0),"부서관리")%>
				<!-- E: navigation -->

				<!-- S: pd-30 -->
				<div class="pd-30">
						<!-- #include file = "./body/c.contestlevel2.asp" -->
				</div>
				<!-- E: pd-30 -->
		  </div>
		  <!-- E: right-content -->

	</div>

<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->
</body>
</html>
