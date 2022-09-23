<!-- #include virtual = "/pub/header.tennisAdmin.asp" -->

<%
	Set db = new clsDBHelper

'##############################################
' 소스 뷰 경계
'##############################################
%>
<%=CONST_HTMLVER%>

<head>
<!-- #include virtual = "/pub/html/tennisAdmin/html.head.asp" -->
<style>
	.highlighted{background-color: yellow;}
	.highlight{background-color: #fff34d;}
	
	/*
	 * Timepicker stylesheet
	 * Highly inspired from datepicker
	 * FG - Nov 2010 - Web3R 
	 *
	 * version 0.0.3 : Fixed some settings, more dynamic
	 * version 0.0.4 : Removed width:100% on tables
	 * version 0.1.1 : set width 0 on tables to fix an ie6 bug
	 */
	.ui-timepicker-inline { display: inline; }
	#ui-timepicker-div { padding: 0.2em; }
	.ui-timepicker-table { display: inline-table; width: 0; }
	.ui-timepicker-table table { margin:0.15em 0 0 0; border-collapse: collapse; }
	.ui-timepicker-hours, .ui-timepicker-minutes { padding: 0.2em;  }
	.ui-timepicker-table .ui-timepicker-title { line-height: 1.8em; text-align: center; }
	.ui-timepicker-table td { padding: 0.1em; width: 2.2em; }
	.ui-timepicker-table th.periods { padding: 0.1em; width: 2.2em; }

	/* span for disabled cells */
	.ui-timepicker-table td span {
		display:block;
		padding:0.2em 0.3em 0.2em 0.5em;
		width: 1.2em;

		text-align:right;
		text-decoration:none;
	}
	/* anchors for clickable cells */
	.ui-timepicker-table td a {
		display:block;
		padding:0.2em 0.3em 0.2em 0.5em;
	   /* width: 1.2em;*/
		cursor: pointer;
		text-align:right;
		text-decoration:none;
	}


	/* buttons and button pane styling */
	.ui-timepicker .ui-timepicker-buttonpane {
		background-image: none; margin: .7em 0 0 0; padding:0 .2em; border-left: 0; border-right: 0; border-bottom: 0;
	}
	.ui-timepicker .ui-timepicker-buttonpane button { margin: .5em .2em .4em; cursor: pointer; padding: .2em .6em .3em .6em; width:auto; overflow:visible; }
	/* The close button */
	.ui-timepicker .ui-timepicker-close { float: right }

	/* the now button */
	.ui-timepicker .ui-timepicker-now { float: left; }

	/* the deselect button */
	.ui-timepicker .ui-timepicker-deselect { float: left; }

</style>
<script src='//cdn.rawgit.com/fgelinas/timepicker/master/jquery.ui.timepicker.js'></script>
<%If request("test") = "ok" then%>
<script type="text/javascript" src="/pub/js/tennis_contestlevel_test.js?ver=16"></script>
<%else%>
<script type="text/javascript" src="/pub/js/tennis_contestlevel.js?ver=190412"></script>
<%End if%>

<script type="text/javascript" src="/pub/js/menu1/tennis_contestlevel_result.js?ver=191220"></script>

</head>

<body <%=CONST_BODY%>>
<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>

<div id="myLevelModel" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myLevelModelLabel"></div>

<div id="myConfirm"   title="승패" class="modal hide fade" role="dialog"></div>







	<!-- #include file = "./body/c.contestlevel.asp" -->



<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->	
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