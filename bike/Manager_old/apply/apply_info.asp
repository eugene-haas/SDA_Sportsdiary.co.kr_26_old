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
<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>
<!-- #include virtual = "/pub/html/bike/html.top.admin.asp" -->
<!-- S: content -->
<div class="content">
<!-- #include virtual = "/pub/html/bike/html.left.admin.asp" -->

    <!-- S: right-content -->
    <div class="right-content">
        <!-- S: navigation -->
        <%Call topnav(menustr(0),menustr(1))%>
        <!-- E: navigation -->

    	<div class="pd-30">
            <!-- S: sub-content -->
		    <div class="sub-content">
	           <!-- #include file = "../body/Apply/c.apply_info.asp" -->
    	    </div>
            <!-- E: sub-content -->
        </div>

    </div>
    <!-- E: right-content -->
</div>
<!-- E: content -->

<%
global_HP = "bike"

	AdminGameTitlee = fInject(Request.cookies("AdminGameTitle"))
	AdminGameTitle = decode(AdminGameTitlee,0)
	Authority = fInject(crypt.DecryptStringENC(Request.cookies(global_HP)("Authority")))

Response.write Authority & "--------"
%>

<!-- #include virtual = "/pub/html/bike/html.footer.asp" -->
</body>
</html>
