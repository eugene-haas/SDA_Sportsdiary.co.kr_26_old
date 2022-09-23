<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->
<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>

  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta charset="utf-8">
  <title>KATA</title>

  <link href="http://img.sportsdiary.co.kr/css/NotoKR.css" rel="stylesheet">
  <link href="http://img.sportsdiary.co.kr/css/initialize.css" rel="stylesheet">
  <link href="http://img.sportsdiary.co.kr/css/mgpd.css" rel="stylesheet">
  <link href="http://img.sportsdiary.co.kr/lib/jquery/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />

  <link href="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap.min.css" rel="stylesheet" media="screen">
  <link href="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap-datetimepicker.min.css" rel="stylesheet">

  <link href="http://img.sportsdiary.co.kr/Manager/import_ri.css" rel="stylesheet">
  <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-migrate-3.0.0.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/oLoader/jquery.oLoader.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-ui.min.js"></script>


  <script src="https://cdn.ckeditor.com/4.8.0/full-all/ckeditor.js"></script>

  <script src="http://img.sportsdiary.co.kr/lib/moment/moment-with-locales.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap.min.js"></script>
  <script src='http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap-datetimepicker.min.js'></script>


	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/common_admin.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/menulist.js<%=CONST_JSVER%>"></script>
</head>

<body <%=CONST_BODY%>>
	<div class="t_default">

		<div class="backLayer" style="z-index:999;" > </div>
		<div id="loadingDiv" style="z-index:999;"></div>

		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<div id="body">
				<!-- #include file = "./body/c.adminlist.asp" -->
		</div>
		<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->	
	</div>
</body>
</html>
