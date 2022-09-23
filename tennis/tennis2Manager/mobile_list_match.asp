<!-- #include virtual = "/pub/header.mobileTennisAdmin.asp" -->
<!DOCTYPE html>
<!-- http://tennisadmin2.sportsdiary.co.kr/mobile_list_match.asp -->
<html lang="ko">
  <head>
    <!--#include virtual="./include/mobile_head.asp"-->

 <link href="/pub/js/themes/smoothness/jquery-ui.min.css" rel="stylesheet" type="text/css" />	
  <script src="/pub/js/jquery-ui.min.js"></script>
	
	<script type="text/javascript" src="/pub/js/mobile_tennis_contestlevel.js"></script>
  </head>
  <body class="t_match-list">

	





<style type="text/css">
.modal {
  display: none; /* Hidden by default */
  position: fixed; /* Stay in place */
  z-index: 1; /* Sit on top */
  left: 0;
  top: 0;
  width: 100%; /* Full width */
  height: 100%; /* Full height */
  overflow: auto; /* Enable scroll if needed */
  background-color: #EEE; /* Fallback color */
  background-color: #FFFFFF;
}

/* Modal Content/Box */
.modal-content {
  background-color: #fefefe;
  margin: 15% auto; /* 15% from the top and centered */
  padding: 20px;
  border: 1px solid #888;
  width: 80%; /* Could be more or less, depending on screen size */
}

/* The Close Button */
.close {
  width:50px;
  color: #aa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}	
</style>



	<div id="Modaltest" class="modal"  style="z-index:1100">	</div>
	
	
	<!-- #include file = "./body/c.mobile_list_match.asp" -->
  </body>
</html>
