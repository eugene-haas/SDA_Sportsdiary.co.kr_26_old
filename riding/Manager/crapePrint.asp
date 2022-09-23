<!-- #include virtual = "/pub/header.radingAdmin.asp" -->

<%
 'Controller ################################################################################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "IDXARR") = "ok" then
		Set idxs= oJSONoutput.IDXARR
		idxlen = idxs.length
	End if	
	If hasown(oJSONoutput, "TRARR") = "ok" then
		Set trarr= oJSONoutput.TRARR
		trlen = trarr.length
	End if	
	If hasown(oJSONoutput, "JANG") = "ok" then
		jang= oJSONoutput.JANG
	End if	
	If hasown(oJSONoutput, "CONTENTS") = "ok" then
		CONTENTS= oJSONoutput.CONTENTS
	End if	


	If hasown(oJSONoutput, "IDXARR") = "ok" then
		Set idxs = oJSONoutput.IDXARR
		idxlen = idxs.length
	End if	

	'Set db = new clsDBHelper





	For i = 0 To trlen -1
		Response.write trarr.Get(i) & "<br>"
		Response.write jang & "<br>"
		Response.write Replace(CONTENTS,vblf,"<br>") & "<br>"
	Next




Response.end
%>



<%=CONST_HTMLVER%>

<head>
	<!-- #include virtual = "/pub/html/riding/html.head.v1.asp" -->
  <style>
		html,body,h1,div,p,span,table,colgroup,col,thead,tbody,tr,th,td,br{margin:0;padding:0;overflow:initial;}
		body{font-weight: bold;font-family:Calibri, Arial, Helvetica, sans-serif;background:#fff;box-sizing:border-box;}

		.page{width:290mm;height:198mm;font-size:9pt;font-weight:400;margin:0 auto 30px auto;}
		.page+.page{page-break-before:always;}

		.header{display:flex;flex-wrap:wrap;justify-content:space-between;}
		.header__titleName{width:100%;}
		.header__titleDate{width:50%;}
		.header__titleLevel{width:50%;text-align:right;}

		table{width:100%;margin-top:1mm;}
		table th{border:0.01mm solid #ccc;text-align:center;font-weight:400;line-height:1.1;}
		table td{border:0.01mm solid #ccc;font-weight:400;line-height:1.2;padding:0 1mm 0 .5mm;}

		table th.order{width:7.5mm;} /* 출전순서 */
		table th.partName{width:11mm;} /* 통합부명 */
		table th.playerName{width:13mm;} /* 선수명 */
		table th.horseName{width:20mm;} /* 마명 */
		table th.belongName{width:25mm;} /* 소속 */

		table th.partRanking{width:7.5mm;} /* 부별순위 */
		table th.totalRanking{width:7.5mm;} /* 전체순위*/

		table td.order{text-align:left;} /* 출전순서 */
		table td.partName{text-align:left;} /* 통합부명 */
		table td.playerName{text-align:left;} /* 선수명 */
		table td.horseName{text-align:left;} /* 마명 */
		table td.belongName{text-align:left;} /* 소속 */

		table td.partRanking{text-align:right;} /* 부별순위 */
		table td.totalRanking{text-align:right;} /* 전체순위 */


		/* 마장마술 */
		table.dressage th{height:6mm;}
		table.dressage td{height:8mm;font-size:8pt;}

		table.dressage td.pointRate{text-align:right;} /* 지점별 비율 */
		table.dressage td.pointRanking{text-align:right;} /* 지점별 순위 */
		table.dressage td.totalRate{text-align:right;} /* 총비율 */

		table.dressage tfoot tr th.noBorder{border:0;}
		table.dressage tfoot tr td.noBorder{border:0;}
		table.dressage tfoot tr td{height:16mm;}


		/* 장애물 */
		table.obstacles th{height:8mm;}
		table.obstacles td{font-size:8pt;}

		/* tableA, 2phase */
		table.obstacles th.obstacle{width:7.5mm;} /* 장애물 */
		table.obstacles th.etc{} /* 비고 */
		table.obstacles th.duration{width:10mm;} /* 소요시간 */
		table.obstacles th.timePenalty{width:7.5mm;} /* 시간감점 */
		table.obstacles th.obstaclePenalty{width:7.5mm;} /* 장애감점 */
		table.obstacles th.totalPenalty{width:7.5mm;} /* 감점합계 */

		table.obstacles.s_2phase td{height:5.2mm;}
		table.obstacles.s_TableA td{height:10mm;}
		table.obstacles td.obstacle{text-align:right;} /* 장애물 */
		table.obstacles td.etc{text-align:right;} /* 비고 */
		table.obstacles td.duration{text-align:right;} /* 소요시간 */
		table.obstacles td.timePenalty{text-align:right;} /* 시간감점 */
		table.obstacles td.obstaclePenalty{text-align:right;} /* 장애감점 */
		table.obstacles td.totalPenalty{text-align:right;} /* 감점합계 */


		/* tableC */
		table.obstacles th.duration_c{width:12mm;} /* 소요시간 */
		table.obstacles th.timePenalty_c{width:12mm;} /* 벌초 */
		table.obstacles th.totalDuration_c{width:12mm;} /* 총소요시간 */

		table.obstacles.s_TableC td{height:10mm;}
		table.obstacles td.duration_c{text-align:right;} /* 소요시간 */
		table.obstacles td.timePenalty_c{text-align:right;} /* 벌초 */
		table.obstacles td.totalDuration_c{text-align:right;} /* 총 소요시간 */


		/* 장애물 하단 */
		table.obstaclesBottom{margin-top:3mm;}
		table.obstaclesBottom th{height:8mm;}
		table.obstaclesBottom td{height:8mm;}
		table.obstaclesBottom th.game{width:25mm;text-align:center;}
		table.obstaclesBottom th.phase{width:25mm;text-align:center;}
		table.obstaclesBottom td.length{width:40mm;text-align:center;}
		table.obstaclesBottom td.tempo{width:40mm;text-align:center;}
		table.obstaclesBottom td.allowed{width:40mm;text-align:center;}
		table.obstaclesBottom td.limit{width:40mm;text-align:center;}
		table.obstaclesBottom td.sign{text-align:left;padding:0 2mm;}

		@media print{
			.page{margin-bottom:0px;}
		}

    /* @page{margin:3mm;} */


  </style>

</head>
<body <%=CONST_BODY%>>


<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%>
<%If sel_orderType = "MM" then%>

		<!-- #include file = "./body/printMM.asp" -->

<%'@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@%>
<%else%>


	<%Select Case r_classhelp %>
	<%Case CONST_TYPEA1 , CONST_TYPEA2,CONST_TYPEA_1 'type A   재경기가 있는 장애물 %>
		<!-- #include file = "./body/printJA.asp" -->

	<%Case CONST_TYPEB 'type B%>
		<!-- #include file = "./body/printJB2phase.asp" -->

	<%Case CONST_TYPEC 'type C%>
		<!-- #include file = "./body/printJC.asp" -->

	<%End select%>
<%End if%>


<%
	Call db.Dispose
	Set db = Nothing
%>
</body>
</html>
