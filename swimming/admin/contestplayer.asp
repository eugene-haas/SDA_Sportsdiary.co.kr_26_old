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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/FindContestplayer.js<%=CONST_JSVER%>8"></script>
</head>
<body <%=CONST_BODY%>>

<div class="wrapper">

  <!-- #include virtual = "/pub/html/swimming/html.header.lte.asp" -->


  <%pagename = "contest.asp"%>
  <!-- #include virtual = "/pub/html/swimming/html.left.lte.asp" -->
  <%pagename = "contestlevel.asp"%>


  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper">
    <!-- Content Header (Page header) -->
    <section class="content-header">
      <h1>
        <%=menustr(0)%>
        <small>출전선수관리</small>
      </h1>
      <ol class="breadcrumb">
        <li><a href="#"><i class="fa fa-fw fa-sitemap"></i> Home</a></li>
        <li class="active">출전선수관리</li>
      </ol>
    </section>

    <section class="content">
			<!-- #include file = "./body/c.contestplayer.asp" -->
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


<!-- Select2 -->
<script src="/plugins/select2/select2.full.min.js"></script>


<!-- SlimScroll -->
<script src="/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="/plugins/fastclick/fastclick.js"></script>

<script src="/dist/js/app.min.js"></script><!-- AdminLTE App -->



<script type="text/javascript">
<!--

  $(function () {
	$('#swtable').DataTable({
	  "paging": false,
      "lengthChange": false,
      "searching": true,
      "ordering": false,
      "info":  false,
      "autoWidth": true
    });
  });


//-->
</script>












</body>
</html>	