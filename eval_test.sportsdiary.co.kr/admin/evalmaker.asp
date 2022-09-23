<!-- #include virtual = "/admin/inc/header.admin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/admin/inc/html.head.lte.asp" -->
  <script type="text/javascript" src="/admin/js/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/admin/js/evalmaker.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>

<div class="wrapper">

  <!-- #include virtual = "/admin/inc/html.header.lte.asp" -->

  <%pagename = "evalindex.asp"%>  
  <!-- #include virtual = "/admin/inc/html.left.lte.asp" -->
  <%pagename = "evalmaker.asp"%>  

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        <%=menustr(0) & " 관리"%>
        <small><%=menustr(1) & " 관리"%></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-fw fa-sitemap"></i> Home</a></li>
        <li class="active"><%=menustr(1) & " 관리"%></li>
      </ol>
    </section>

    <section class="content">
			<!-- #include file = "./body/c.evalmaker.asp" -->
    </section>
  </div>

  <!-- #include virtual = "/admin/inc/html.footer.lte.asp" -->

  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->


<script>
  $.widget.bridge('uibutton', $.ui.button);
</script>

<!-- DataTables -->
<script src="/admin/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="/admin/plugins/datatables/dataTables.bootstrap.min.js"></script>

<!-- SlimScroll -->
<script src="/admin/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/admin/plugins/fastclick/fastclick.js"></script>

<script src="/admin/dist/js/app.min.js"></script><!-- AdminLTE App -->


<!-- date-range-picker -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
<script src="/admin/plugins/daterangepicker/daterangepicker.js"></script>
<!-- bootstrap datepicker -->
<script src="/admin/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- bootstrap time picker -->
<script src="/admin/plugins/timepicker/bootstrap-timepicker.min.js"></script>
<!-- iCheck 1.0.1 -->
<script src="/admin/plugins/iCheck/icheck.min.js"></script>

<!-- Page script -->
</body>
</html>	