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
	<script type="text/javascript" src="/pub/js/<%=CONST_PATH%>/gameorder.js<%=CONST_JSVER%>"></script>


<script type="text/javascript">
<!--
	$(document).ready(function(){
		  $(function() {
				$('#GameTimeWrap').datetimepicker({
				  format: 'LT',
				  locale:'KO'
				});

				$('#GameTimeWrap1').datetimepicker({
				  format: 'LT',
				  locale:'KO'
				});


				$('#GameTimeWrap2').datetimepicker({
				  format: 'LT',
				  locale:'KO'
				});

		  });
	});
//-->
</script>
</head>


<body <%=CONST_BODY%>>
	<div class="t_default">

		<div id="myModal" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myModalLabel"></div>

		<div id="myLevelModel" class="modal fade" data-backdrop="static" role="dialog" aria-labelledby="myLevelModelLabel"></div>

		<div id="myConfirm" title="승패" class="modal fade" data-backdrop="static" role="dialog"></div>



		<!-- #include virtual = "/pub/html/riding/html.header.asp" -->

		<div id="body">
			<aside>
			<!-- #include virtual = "/pub/html/riding/html.left.asp" -->
			</aside>

			<article id="sc_body">
			<!-- #include file = "./body/c.gameorder.asp" -->
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
