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
  <script type="text/javascript" src="/admin/js/common_admin.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/admin/js/menulist.js<%=CONST_JSVER%>"></script>
</head>
<body <%=CONST_BODY%>>
		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

<div class="wrapper">

  <!-- #include virtual = "/admin/inc/html.header.lte.asp" -->

  <!-- #include virtual = "/admin/inc/html.left.lte.asp" -->

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        <%=menustr(0)%>
        <small><%=menustr(1)%></small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="/index.asp"><i class="fa fa-fw fa-sitemap"></i> Home</a></li>
        <li class="active"><%=menustr(1)%></li>
      </ol>
    </section>

    <section class="content">
		<!-- #include file = "./body/c.adminlist.asp" -->
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


<script src="/admin/plugins/fastclick/fastclick.js"></script><!-- FastClick -->
<script src="/admin/dist/js/app.min.js"></script><!-- AdminLTE App -->


<script>
  $(function () {
	$('#swtable').DataTable({
	  "paging": false,
      "lengthChange": false,
      "searching": false,
      "ordering": false,
      "info": false,
      "autoWidth": false
    });
  });
</script>

</body>
</html>	
