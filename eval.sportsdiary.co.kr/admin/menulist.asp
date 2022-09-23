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
              <li><a href="#"><i class="fa fa-fw fa-sitemap"></i> Home</a></li>
              <li class="active"><%=menustr(1)%></li>
            </ol>
          </section>

          <section class="content">
          <!-- #include file = "./body/c.menulist.asp" -->
          </section>
        </div>


  <!-- /.content-wrapper -->
  <!-- #include virtual = "/admin/inc/html.footer.lte.asp" -->

  <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->

<%
'<script src="plugins/jQuery/jQuery-2.2.0.min.js"></script><!-- jQuery 2.2.0 -->
'<script src="https://code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script><!-- jQuery UI 1.11.4 -->
%>
<script>
  $.widget.bridge('uibutton', $.ui.button); //https://code-examples.net/ko/docs/jqueryui/jquery.widget.bridge
</script>

<!-- DataTables -->
<script src="/admin/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="/admin/plugins/datatables/dataTables.bootstrap.min.js"></script>

<!-- SlimScroll -->
<script src="/admin/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/admin/plugins/fastclick/fastclick.js"></script>



<script src="/admin/plugins/fastclick/fastclick.js"></script><!-- FastClick --><%'모바일웹에서 터치 딜레이를 없애주는 라이브러리%>
<script src="/admin/dist/js/app.min.js"></script><!-- AdminLTE App -->


<!-- AdminLTE for demo purposes -->
<%'<script src="/dist/js/demo.js"></script>%>


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
