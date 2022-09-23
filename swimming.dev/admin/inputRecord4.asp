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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/draw.js<%=CONST_JSVER%>8"></script>

	<%'토너먼트%>
    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>








<%
'/sportsdiary.co.kr/pub/js/riding/boocontrol.js
'/sportsdiary.co.kr/pub/api/ridingAdmin/api.showtourn.asp

%>

    <link rel="stylesheet" href="http://img.sportsdiary.co.kr/lib/tournament/tournament.css" />
    <script type="text/javascript" src="http://img.sportsdiary.co.kr/lib/tournament/tournament.js"></script>

<script type="text/javascript">
<!--
mx.tablejsondata = "";
mx.OnShowTourn =  function(cmd, packet, html, sender){

	 mx.tablejsondata = packet;

	
      var tournament2 = new Tournament();
	  
	  tournament2.setOption({
        blockBoardWidth: 220, // integer board 너비
        blockBranchWidth: 40, // integer 트리 너비
        blockHeight : 80, // integer 블럭 높이(board 간 간격 조절)
        branchWidth : 2, // integer 트리 두께
        branchColor : '#a9afbf', // string 트리 컬러
        roundOf_textSize : 60, // integer 배경 라운드 텍스트 크기
        scale : 'decimal', // mix decimal or 'auto' 'auto'면 화면 너비에 맞게 스케일 조정
        board : true, // boolean  default:true  false면 1round 제외 board 가리기(대진추첨용)
    		el:document.getElementById('tournament2') // element must have id
    	});

      tournament2.setStyle('#tournament2');
	  tournament2.boardInner = function(data){
		var Lwincolor = "";
		var Rwincolor = "";	

		var Lnm = data.teamnmL;
		var Rnm = data.teamnmR;
		//var Lteamnm = data.LteamAna;
		//var Rteamnm = data.RteamAna;

		if (data.LWL == 'W'){
			Lwincolor = "style='background:orange;'";
		}
		if (data.RWL == 'W'){
			Rwincolor = "style='background:orange;'";
		}


		if (Lnm == '--' || Lnm == null ){
			Lnm = "";
		}
		if (Rnm == '--' || Rnm == null ){
			Rnm = "";
		}

		//		if (Lteamnm == null){
		//			Lteamnm = "";
		//		}
		//		if (Rteamnm == null){
		//			Rteamnm = "";
		//		}
		
		if (Lnm == '' || Rnm == '' || Lnm == '부전' || Rnm == '부전'){
			var makebtn = '';
		}
		else{
			var makebtn = '<button type="button" class="btn btn-block btn-default" onclick="mx.soogooWindow('+data.idx+')">결과입력</button>';
		}

        var html = [
          '<p class="ttMatch ttMatch_first"  '+Lwincolor+'>',
            '<span class="ttMatch__score">'+data.scoreL+'</span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"  title=ㅇㅇㅇ>',
                '<span class="ttMatch__player">'+Lnm+'</span>',
                '<span class="ttMatch__belong">'+makebtn+'</span>',
              '</span>',
            '</span>',
          '</p>',
          '<p class="ttMatch ttMatch_second" '+Rwincolor+'>',
            '<span class="ttMatch__score">'+data.scoreR+'</span>',
            '<span class="ttMatch__playerWrap">',
              '<span class="ttMatch__playerInner"   title=ㅌㅌㅌ>',
                '<span class="ttMatch__player">'+Rnm+'</span>',
                '<span class="ttMatch__belong"></span>',
              '</span>',
            '</span>',
          '</p>'
        ].join('');

    		return html;
    	}


//    tournament3.draw({
//      limitedStartRoundOf: 16, // integer(짝수)  default:0 전체, 그리기 시작할 라운드 ex)8강 부터
//      limitedEndRoundOf: 8, // integer(짝수)  default:0 전체, 그리기 끝날 라운드 ex)4강 까지
//      roundOf:16,
//		data: mx.tablejsondata

      tournament2.draw({
        roundOf:packet.TotalRound,
		data:  packet
      });

};	
//-->
</script>





</head>
<body <%=CONST_BODY%>>

<div class="wrapper">

  <!-- #include virtual = "/pub/html/swimming/html.header.lte.asp" -->



  <%pagename = "gamerecord.asp"%>
  <!-- #include virtual = "/pub/html/swimming/html.left.lte.asp" -->
  <%pagename = "inputRecord4.asp"%>



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
			<!-- #include file = "./body/c.inputRecord4.asp" -->
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

<!-- AdminLTE for demo purposes -->
<%'<script src="/dist/js/demo.js"></script>%>












</body>
</html>	