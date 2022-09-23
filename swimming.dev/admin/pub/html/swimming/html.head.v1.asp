  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
  <meta name="mobile-web-app-capable" content="yes">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
  <meta charset="utf-8">
  <title>대한수영연맹</title>

  <link href="http://img.sportsdiary.co.kr/css/NotoKR.css" rel="stylesheet">
  <link href="http://img.sportsdiary.co.kr/css/initialize.css" rel="stylesheet">
  <link href="http://img.sportsdiary.co.kr/css/mgpd.css" rel="stylesheet">
  <link href="http://img.sportsdiary.co.kr/lib/jquery/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />

  <link href="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap.min.css" rel="stylesheet" media="screen">
  <link href="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap-datetimepicker.min.css" rel="stylesheet">

  <link href="http://img.sportsdiary.co.kr/Manager/import_ri.css" rel="stylesheet">
  <style>
    [draggable] {
      -moz-user-select: none;
      -khtml-user-select: none;
      -webkit-user-select: none;
      user-select: none;
      /* Required to make elements draggable in old WebKit */
      -khtml-user-drag: element;
      -webkit-user-drag: element;
    }
  </style>

  <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-3.1.1.min.js"></script>
  <!-- <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-migrate-1.4.1.min.js"></script> -->
  <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-migrate-3.0.0.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/oLoader/jquery.oLoader.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/jquery/jquery-ui.min.js"></script>


  <script src="https://cdn.ckeditor.com/4.8.0/full-all/ckeditor.js"></script>

  <script src="http://img.sportsdiary.co.kr/lib/moment/moment-with-locales.min.js"></script>
  <script src="http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap.min.js"></script>
	<script src='http://img.sportsdiary.co.kr/lib/bootstrap/bootstrap-datetimepicker.min.js'></script>

  <script>
    $(function(){
      //S:Loading Bar
      $(document).ajaxStart(function(){
        $('body').oLoader({
          backgroundColor: '#fff',
          // image: 'http://img.sportsdiary.co.kr/images/loader1.gif',
          style: "<div id='DP_LoadingBar' style='position:absolute;left:0px;right:0;top:160px;background:#000;color:#fff;padding:20px;border-radius:4px; width:250px; margin:0 auto; text-align:center;'><br><br><img src='http://img.sportsdiary.co.kr/images/loader1.gif'></div>",
          fadeInTime: 0,
          fadeOutTime: 0,
          fadeLevel: 0,
          wholeWindow: true,
          lockOverflow: true
        });
      });

      $(document).ajaxStop(function(){
        $('body').oLoader('hide');
      });
      //E: Loading Bar

    });
  </script>
