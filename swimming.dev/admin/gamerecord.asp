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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/contest.js<%=CONST_JSVER%>"></script>

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
		<!-- #include file = "./body/c.gameRecord.asp" -->
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
<script src="/dist/js/app.min.js"></script><!-- AdminLTE App -->



<!-- date-range-picker -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.11.2/moment.min.js"></script>
<script src="/plugins/daterangepicker/daterangepicker.js"></script>
<!-- bootstrap datepicker -->
<script src="/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- bootstrap time picker -->
<script src="/plugins/timepicker/bootstrap-timepicker.min.js"></script>
<!-- iCheck 1.0.1 -->
<script src="/plugins/iCheck/icheck.min.js"></script>


<!-- Page script -->
<script>
  $(function () {
    //Date range picker
    $('#mk_g13').daterangepicker({format: 'YYYY/MM/DD',locale:'KO'});
    //Date range picker with time picker
    $('#mk_g14').daterangepicker({timePicker: true, timePickerIncrement: 30, format: 'YYYY/MM/DD h:mm A',locale:'KO'});
    //Date range as a button
    $('#daterange-btn').daterangepicker(
        {
          ranges: {
            'Today': [moment(), moment()],
            'Yesterday': [moment().subtract(1, 'days'), moment().subtract(1, 'days')],
            'Last 7 Days': [moment().subtract(6, 'days'), moment()],
            'Last 30 Days': [moment().subtract(29, 'days'), moment()],
            'This Month': [moment().startOf('month'), moment().endOf('month')],
            'Last Month': [moment().subtract(1, 'month').startOf('month'), moment().subtract(1, 'month').endOf('month')]
          },
          startDate: moment().subtract(29, 'days'),
          endDate: moment()
        },
        function (start, end) {
          $('#daterange-btn span').html(start.format('MMMM D, YYYY') + ' - ' + end.format('MMMM D, YYYY'));
        }
    );

  });
</script>


</body>
</html>
