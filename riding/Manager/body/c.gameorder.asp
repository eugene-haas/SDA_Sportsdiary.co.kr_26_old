<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################


	Set db = new clsDBHelper

	'등록된 최소년도
	SQL = "Select min(GameYear) from sd_TennisTitle where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End if
  
  
  	'search
	If chkBlank(F2) Then
		strWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' " 
		findWhere = " DelYN = 'N'  and GameYear = '"&year(date)&"' " 

		nowgameyear = year(date)
	Else
		If InStr(F1, ",") > 0  Then
			F1 = Split(F1, ",")
			F2 = Split(F2, ",")
		End If

		If IsArray(F1) Then
			fieldarr = array("GameYear","gametitleidx")
			F2_0 = F2(0)
			F2_1 = F2(1)

			tidx = F2_1
			strWhere = " DelYN = 'N' and "&fieldarr(0)&" = '" & F2_0 &"' and "&fieldarr(1)&" = '"& F2_1 &"' "
			findWhere = " DelYN = 'N'  and GameYear = '"&F2_0&"' " 

			nowgameyear = F2_0	
		Else
			strWhere = " DelYN = 'N' and "&F1&" = '"& F2 &"' "

			If LCase(F1) = "gameyear" Then
				nowgameyear = F2
			End if
		End if
	End if
  


	'년도별 대회명검색
	fieldstr =  "GameTitleIDX,GameTitleName,GameS,GameE,GameYear,GameArea,kgame  "
	SQL = "Select  "&fieldstr&" from sd_TennisTitle where " & findWhere & " order by GameS desc"
	Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rss.EOF Then
		arrPub = rss.GetRows()
		If tidx = "" Then
			If IsArray(arrPub)  Then
				For ar = LBound(arrPub, 2) To UBound(arrPub, 2)
					If ar = 0 then
					tidx = arrPub(0, ar)
					End if
				Next
			End if
		End if
	End If

'Response.write req & "##########"
%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대회진행 > 대회 출전순서표 생성 (일정관리)</h1></div>

  <%If CDbl(ADGRADE) > 500 then%>

	<div class="info_serch form-horizontal" id="gameinput_area">
	  <!-- #include virtual = "/pub/html/riding/orderform.asp" -->
	</div>



	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/boocontrolform.asp" -->
	</div>
	<!-- e: 정보 검색 -->

    <hr />



	<!-- s: 리스트 버튼 -->
	<div class="btn-toolbar" role="toolbar" aria-label="btns">
		<!-- <a href='javascript:mx.setTimeAll(<%=req%>)' class="btn btn-link">세부종목 부별조정</a> --><!-- 검색된 내용 가져와야함... -->

		<div class="col-sm-2" style="width:320px;">
			시작시간 전체 동일 적용
				<div class='input-group date' id='GameTimeWrap' style="float:left;width:80%;">
					<input type='text' class="form-control" id="allstarttime" value="<%=setTimeFormat(now)%>"/>
					<span class="input-group-addon">
					<span class="glyphicon glyphicon-time"></span>
					</span>
			  </div>
			  <div  style="float:left;">&nbsp;<a href='javascript:mx.setTimeAll(<%=tidx%>,<%=nowgameyear%>)' class="btn btn-primary">확인</a></div>

		</div>

		<!-- <div class="input-group">

		</div> -->

		<div class="btn-group flr">
			<!-- <a href="javascript:alert('진행중 ....이라네')" id="gdmake" class="btn btn-primary">출전순서표 생성</a> -->
			<!-- <a href="javascript:alert('진행중 ....이라네')" id="gdmake" class="btn btn-primary">부별조정 저장</a> -->
		</div>

	</div>
	<!-- e: 리스트 버튼 -->



  <%End if%>


  <div class="table-responsive">

  <%
    Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
    Response.write "<thead><tr><th>대회일자</th><th>순서</th><th>종목/마종/세부/안내</th><th>경기시작시간</th><th>경기종료시간</th><th>부별조정</th><th>출전순서표</th><th>일정관리</th></tr></thead>" '
    Response.write "<tbody id=""listcontents"">"
    Response.write " <tr class=""gametitle"" ></tr>"
	If isArray(arrPub) then
	%><!-- #include virtual = "/pub/html/riding/gameOrderlist.asp" --><%
	End if
	Response.write "</tbody>"
    Response.write "</table><br><br><br><br>"
  %>
  </div>




  <!-- #include virtual = "/pub/html/riding/html.modalplayer.asp" -->



</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>
