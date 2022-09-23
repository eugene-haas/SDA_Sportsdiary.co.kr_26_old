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

<%'<script type="text/javascript" src="/pub/js/tennis_contest.js?ver=15"></script>%>


	<style>
	div.backLayer {
        display:none;
        background-color:black;
        position:absolute;
        left:0px;
        top:0px;
    }
    div#loadingDiv{
		left: 50%;
		top: 50%;
		z-index: 1;
		width: 150px;
		height: 150px;
		background-color:skyblue;
        display: none;
        position: absolute;
        width:300px;
        height:300px;
		-webkit-animation: spin 2s linear infinite;
		animation: spin 2s linear infinite;
	    margin: -75px 0 0 -75px;
		border: 16px solid #f3f3f3;
		border-radius: 50%;
		border-top: 16px solid #3498db;
		width: 120px;
		height: 120px;
	}

  </style>


</head>

<body <%=CONST_BODY%>>
  <div class="backLayer" style="z-index:999;" > </div>
  <div id="loadingDiv" style="z-index:999;"></div>

<div id="myModal" class="modal hide fade tourney_admin_modal" role="dialog" aria-labelledby="myModalLabel"></div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.header.asp" -->

<div id="body" style="padding-top:50px;">
	<!-- <aside> -->
	<!-- include virtual = "/pub/html/tennisAdmin/html.left.asp" -->
	<!-- </aside>

	<article> -->
	<!-- #include file = "./body/c.proceeding.asp" -->
	<!-- </article> -->
</div>

<!-- #include virtual = "/pub/html/tennisAdmin/html.footer.asp" -->	
</body>
</html>