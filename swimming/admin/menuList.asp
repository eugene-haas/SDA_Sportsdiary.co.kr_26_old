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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/menulist.js<%=CONST_JSVER%>"></script>

</head>
<body <%=CONST_BODY%>>

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
        <li><a href="#"><i class="fa fa-fw fa-sitemap"></i> Home</a></li>
        <li class="active"><%=menustr(1)%></li>
      </ol>
    </section>

    <section class="content">
		<!-- #include file = "./body/c.menulist.asp" -->
    </section>
  </div>


  <!-- #include virtual = "/pub/html/swimming/html.footer.lte.asp" -->

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
<script src="/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="/plugins/datatables/dataTables.bootstrap.min.js"></script>

<!-- SlimScroll -->
<script src="/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>



<script src="/plugins/fastclick/fastclick.js"></script><!-- FastClick --><%'모바일웹에서 터치 딜레이를 없애주는 라이브러리%>
<script src="/dist/js/app.min.js"></script><!-- AdminLTE App -->


<!-- AdminLTE for demo purposes -->
<%'<script src="/dist/js/demo.js"></script>%>


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

// var table = $('#swtable').DataTable();
// table.order([0, 'asc']).draw();
//  //table.rows( {page:'current'} ).data();
//table
//    .column( '0:visible' )
//    .order( 'asc' )
//    .draw();


</script>

</body>
</html>	
