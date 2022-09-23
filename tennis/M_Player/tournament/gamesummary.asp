<!--METADATA TYPE= "typelib"  NAME= "ADODB Type Library" FILE="C:\Program Files\Common Files\SYSTEM\ADO\msado15.dll"  -->

<!DOCTYPE html>
<html lang="ko">
<head>
	<!-- #include file="../include/config.asp" -->
<%
'###############################################
'KATA는 따로 ....집어넣을꺼면 여기다 넣지 마시옷 (대회요강)
'###############################################
%>

	<link rel="stylesheet" href="../css/tourney.css">
	<style type="text/css">
		.sub.tourney .tourney{overflow:inherit;padding-bottom:150px;}
	</style>
	<script src="../../webtournament/www/js/global.js"></script>
</head>
<body id="AppBody" class="sd-body">


  <!-- S: sub-header -->
  <div class="sd-header sd-header-sub">
    <!-- #include file="../include/sub_header_arrow.asp" -->
    <h1>대회요강</h1>
    <!-- #include file="../include/sub_header_right.asp" -->
  </div>
  <!-- E: sub-header -->

	<!-- #include file = "../include/gnb.asp" -->

  <!-- S: sub sub-main -->
	<!-- <div class="sub tourney h-fix sd-scroll sd-main-A [ _sd-scroll ]"> -->
	<div class="sd-scroll sd-main-A [ _sd-scroll ]">

		<!-- S: main banner 01 -->
	  <%
	    imType = "1"
	    imSportsGb = "tennis"
	    imLocateIDX = LocateIDX_1

	    LSQL = "EXEC AD_View_S '" & imType & "','" & imSportsGb & "','" & imLocateIDX & "','','','','',''"
	    'response.Write "LSQL="&LSQL&"<br>"
	    'response.End

	    Set LRs = DBCon6.Execute(LSQL)
	    If Not (LRs.Eof Or LRs.Bof) Then
	  %>
	  <div class="major_banner">
	    <div class="banner banner_<%=LRs("LocateGb")%> carousel">
	  	  <div <% if LRs("TypeOutput") = "S" then %>class="bxslider"<% end if %>>
	  		<!-- #include file="../include/banner_Include.asp" -->
	  		</div>
	  	</div>
	  </div>
	  <%
	    End If
	    LRs.close
	  %>


	


<!-- #include virtual = "/pub/cfg/cfg.RookieTennis.asp" -->
<!-- #include virtual = "/pub/class/db_helper.asp" -->
<!-- #include virtual = "/pub/fn/fn.sqlinjection.asp" -->
<!-- #include virtual = "/pub/fn/fn.string.asp" -->
		<%
	  	'내용
		tidx = request("tidx")
		If isnumeric(tidx) = False Then
			Response.End
		End If

		Set db = new clsDBHelper		
	    SQL = "Select top 1 summary from SD_tennisTitle where gametitleidx = " & tidx
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.eof Then
			summary = htmlDecode(rs("summary"))
		End If
		db.Dispose
		Set db = Nothing

	  %>
	  <!-- E: main banner 01 -->

    <!-- S: tourney-title -->
    <div class="sd_subTit s_blue01">
			<h3 id="tourney_title" class="sd_subTit__tit"></h3>
		</div>
    <!-- E: tourney-title -->






		<div class="sub tourney">

		  <!-- S: hidden-main -->
		  <input type="hidden" id="H_GameType" name="H_GameType" value="0">
			<!-- E: hidden-main -->

		  <div class="tourney-mode" id="scoregametable"></div>

		  <!-- S: tourney-list -->
		  <div class="tourney-list result-report" id ="DP_ResultReport"></div>
		  <!-- E: tourney-list -->

			<%=summary%>


		</div>


  </div>
	<!-- E: sub sub-main -->




	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</body>
</html>
<% AD_DBClose() %>
