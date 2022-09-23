<!-- #include virtual = "/pub/header.radingAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/riding/html.head.v1.asp" -->
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/utill.js<%=CONST_JSVER%>"></script>
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/boocontrol.js<%=CONST_JSVER%>"></script>


<script type="text/javascript">
<!--
mx.init = function(){

  $(function() {
		for (var i = 1  ;i < 3 ;i++ ){
			$('#GameTimeWrap'+i).datetimepicker({
			  format: 'LT',
			  locale:'KO'
			});
		}
  });

};
	
	
	
	
	$(document).ready(function(){
		mx.init();
	});
//-->
</script>




</head>

</head>


<body <%=CONST_BODY%>>
	<div class="t_default">

		<div id="myModal" class="modal fade" role="dialog" aria-labelledby="myModalLabel"></div>

		<div id="myLevelModel" class="modal fade" role="dialog" aria-labelledby="myLevelModelLabel"></div>

		<div id="myConfirm" title="승패" class="modal fade" role="dialog"></div>



		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

		<div id="body">
			<aside>
			<%pagename = "gameorder.asp"%>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			<%pagename = "sc.asp"%>
			</aside>

			<article id="sc_body">
			<!-- #include file = "./body/c.sc.asp" -->
			</article>
		</div>

		<!-- #include virtual = "/pub/html/riding/html.footer.asp" -->

	</div>
	<script>
    /**
     * 가로 아코디언 호출
     * tennis_contestlevel.js 파일에서 mx.accordian
     */
		$('.tourney_admin_modal').on('show.bs.modal', function(){
      var mxAccordian = new mx.Accordian('.tourney_admin_modal');
      var onOffSwitch = new mx.OnOffSwitch('.chk_btn');
    })
	</script>
</body>
</html>
