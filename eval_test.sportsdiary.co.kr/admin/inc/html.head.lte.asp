  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="theme-color" content="#000000">
  <title>혁신평가</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="/admin/bootstrap/css/bootstrap.min.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.5.0/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/ionicons/2.0.1/css/ionicons.min.css">


  <link href="/admin/plugins/JQueryUI/jquery-ui.min.css" rel="stylesheet" type="text/css" />

  <!-- daterange picker -->
  <link rel="stylesheet" href="/admin/plugins/daterangepicker/daterangepicker-bs3.css">
  <!-- bootstrap datepicker -->
  <link rel="stylesheet" href="/admin/plugins/datepicker/datepicker3.css">
  <!-- iCheck for checkboxes and radio inputs -->
  <link rel="stylesheet" href="/admin/plugins/iCheck/all.css">
  <!-- Bootstrap time Picker -->
  <link rel="stylesheet" href="/admin/plugins/timepicker/bootstrap-timepicker.min.css">


   <%'테이블 관련 css%>
  <link rel="stylesheet" href="/admin/plugins/datatables/dataTables.bootstrap.css">

  <!-- Select2 자동검색-->
  <link rel="stylesheet" href="/admin/plugins/select2/select2.min.css">


  <!-- Theme style -->
  <link rel="stylesheet" href="/admin/dist/css/AdminLTE.min.css?ver=0.0.1">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="/admin/dist/css/skins/_all-skins.min.css">
  <!-- iCheck -->
  <link rel="stylesheet" href="/admin/plugins/iCheck/flat/blue.css">
  <!-- Morris chart -->
  <link rel="stylesheet" href="/admin/plugins/morris/morris.css">
  <!-- jvectormap -->
  <link rel="stylesheet" href="/admin/plugins/jvectormap/jquery-jvectormap-1.2.2.css">
  <!-- Date Picker -->
  <link rel="stylesheet" href="/admin/plugins/datepicker/datepicker3.css">
  <!-- Daterange picker -->
  <link rel="stylesheet" href="/admin/plugins/daterangepicker/daterangepicker-bs3.css">
  <!-- bootstrap wysihtml5 - text editor -->
  <link rel="stylesheet" href="/admin/plugins/bootstrap-wysihtml5/bootstrap3-wysihtml5.min.css">



<script src="/admin/plugins/jQuery/jQuery-2.2.0.min.js"></script><!-- jQuery 2.2.0 -->
<script src="/admin/plugins/JQueryUI/jquery-ui.min.js"></script>
<script src="/admin/bootstrap/js/bootstrap.min.js"></script><!-- Bootstrap 3.3.6 -->


  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->


<style type="text/css">
	/*기본 테이블 tr 라인 */
	#tblbody tr td{border-bottom: 1px solid #ddd;}

	/*db 모달 설정*/
	.modal-xl{width:95%;}
	#Modaltestbody{height:600px;overflow:auto;}
	.modal-header{
		background-color: #357ca5;
		color: #c1cada;
	}
	.modal-body{background-color: #ecf0f5;}
	.modal-footer{background-color: #ecf0f5;}
	#swtable thead tr th{vertical-align:middle;text-align:center;}

	.col-md-6{width:25%;}
   .col-md-6.t_sticky{position:sticky;top:30px;}
</style>


<script type="text/javascript">
<!--
//클릭위치로 돌려놓기
$(document).ready(function(){
	$("#sc_body").scrollTop(localStorage.getItem('scrollpostion'));

	$("#sc_body").click(function(event){
		window.toriScroll = $("#sc_body").scrollTop();
		localStorage.setItem('scrollpostion',window.toriScroll);
		//console.log(window.toriScroll);
	});
});
//-->
</script>
