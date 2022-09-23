<!-- #include virtual = "/pub/header.mall.admin.asp" -->
<!-- #include virtual = "/pub/fn/fn.log.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
<!-- #include virtual = "/pub/util/badmt/sql/sql.badmt.asp" -->


<%
    Dim testID, testLogin      
	Set db = new clsDBHelper

	chkrule = False


    testID = sLOGINID
    If Cookies_aID <> "" Then 
        testID = Cookies_aID 
    End If 

    If (testID = "20181003") Then 
        testLogin = 1
    End If  

    'testLogin = 0
'##############################################
%>

<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/mall/html.head.admin.asp" -->
<script type="text/javascript" src="/pub/util/badmt/js/badmt.js?ver=1"></script>
<script type="text/javascript" src="/pub/js/etc/utx.js?ver=1"></script>
<script type="text/javascript" src="/pub/js/etc/ctx.js?ver=1"></script>
</head>

<body <%=CONST_BODY%>>
    <!-- Search Form value -->
    <form method='post' id='sform' name='sform'><input type='hidden' id='p' name='p'></form>

	<!-- 레이어팝업 공통 -->
	<div class="modal fade basic-modal coupon_modal" id="coupon_modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"></div>
	<!-- 레이어팝업 공통 -->
	<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>
<!-- #include virtual = "/pub/html/mall/html.top.admin.asp" -->

    <!-- S: content -->
    <div class="content">
<!-- #include virtual = "/pub/html/mall/html.left.admin.asp" -->

        <!-- S: right-content -->
        <div class="right-content">
            <!-- S: navigation -->
            <%Call topnav(menustr(0),menustr(1))%>
            <!-- E: navigation -->

            <div class="pd-30">

                <!-- S: sub-content -->
                <div class="sub-content">
                    <!-- #include file = "./body/c.mod.join.req.asp" -->
                </div>
                <!-- E: sub-content -->
            </div>

        </div>
        <!-- E: right-content -->

    </div>
    <!-- E: content -->

<!-- #include virtual = "/pub/html/mall/html.footer.asp" -->
</body>
</html>