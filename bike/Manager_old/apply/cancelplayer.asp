<!-- #include virtual = "/pub/header.bike.asp" -->
<!-- #include virtual = "/pub/inc/crypt.asp" -->
<!-- #include virtual = "/pub/inc/bike/request.url.asp" -->
<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/bike/html.head.admin.asp" -->
<script type="text/javascript" src="/pub/js/bike/bike_findcontestplayer.js?ver=1"></script>
</head>

<body <%=CONST_BODY%>>
<!-- #include virtual = "/pub/html/bike/html.top.admin.asp" -->
<div class="modal fade basic-modal refund_modal" id="refund_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"></div>

<!-- S: content -->
<div class="content">
	<!-- S: left-gnb -->
	<!-- #include virtual = "/pub/html/bike/html.left.admin.asp" -->
	<!-- E: left-gnb -->
    <!-- S: right-content -->
    <div class="right-content">
        <!-- S: navigation -->
        <%Call topnav(menustr(0),menustr(1))%>
        <!-- E: navigation -->

    	<div class="pd-30">
    	<!-- #include file = "../body/Apply/c.cancelplayer.asp" -->
        </div>
    </div>
    <!-- E: right-content -->
</div>
<!-- E: content -->

<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->
</body>
</html>
