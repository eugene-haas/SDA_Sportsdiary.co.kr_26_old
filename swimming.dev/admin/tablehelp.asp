<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.lte.asp" -->
<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/common_admin.js<%=CONST_JSVER%>"></script>
<script type="text/javascript" src="/pub/js/db/dbcomment.js<%=CONST_JSVER%>"></script>

</head>
<body <%=CONST_BODY%>>
		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

<div class="wrapper">

  <!-- #include virtual = "/pub/html/swimming/html.header.lte.asp" -->
  <!-- #include virtual = "/pub/html/swimming/html.left.lte.asp" -->

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
		<!-- #include file = "./body/c.tablehelp.asp" -->
    </section>
  </div>


  <!-- #include virtual = "/pub/html/swimming/html.footer.lte.asp" -->

  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->




<script>
  $.widget.bridge('uibutton', $.ui.button);
</script>

<!-- DataTables -->
<script src="/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="/plugins/datatables/dataTables.bootstrap.min.js"></script>

<!-- SlimScroll -->
<script src="/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>



<script src="/plugins/fastclick/fastclick.js"></script><!-- FastClick -->
<script src="/dist/js/app.min.js"></script><!-- AdminLTE App -->


<!-- AdminLTE for demo purposes -->
<script src="/dist/js/demo.js"></script>


<script>

  $(function () {
	$('#swtable').DataTable({
	  "paging": true,
      "lengthChange": false,
      "searching": false,
      "ordering": false,
      "info": true,
      "autoWidth": false
    });
  });


</script>

</body>
</html>
