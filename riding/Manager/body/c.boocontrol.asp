<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->
<!-- #include virtual = "/pub/fn/fn.log.asp" -->
<!-- #include virtual = "/pub/fn/riding/fn.auto.merge.asp" -->

<%
 'Controller ################################################################################################

	'request 처리##############
	'tidx = chkInt(chkReqMethod("tidx", "GET"), 1)
	'javascript:px.goSubmit( {'F1':'useyear','F2':$('#fnd_y').val()}  '특정대회인덱스로 받기

    Dim strRDetail, strBLimit 
	Set db = new clsDBHelper

	'등록된 최소년도
	SQL = "Select min(GameYear) from sd_TennisTitle where delYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL, null, ConStr)
	If  isNull(rs(0)) = true then
	  minyear = year(date)
	Else
	  minyear = rs(0)
	End If
	rs.close
  
  
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
	End If

  


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
	rss.close


%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대회관리 > 부별조정</h1></div>

  <%If CDbl(ADGRADE) > 500 then%>

	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/boocontrolform.asp" -->
	</div>
	<!-- e: 정보 검색 -->
    <hr />

	<!-- s: 리스트 버튼 -->
	<div class="btn-toolbar" role="toolbar" aria-label="btns">
		<a href="#" class="btn btn-link">세부종목 부별조정</a>
		<div class="btn-group flr">
			<a href="javascript:onBtnAutoSumBoo('listcontents')" id="gdmake" class="btn btn-primary">부별조정 실행</a>
			<a href="javascript:mx.sumBoo()" id="gdmake" class="btn btn-primary">선택항목 통합</a>
			<a href="javascript:mx.divBoo()" id="gdmake" class="btn btn-danger">선택항목 분리 </a><!-- 이건 통합된것들 버튼으로 표시 -->
		</div>
	</div>
	<!-- e: 리스트 버튼 -->

  <%End if%>


  <div class="table-responsive">

  <%
    Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
    Response.write "<thead><tr><th>대회일자</th><th>번호</th><th>종목/마종/세부/안내</th><th>종별</th><th>실인원</th><th>신청(명)</th><th>부별성립여부</th><th>선택</th><th>조정</th><th>출전순서생성</th></tr></thead>" '
    Response.write "<tbody id=""listcontents"">"
    Response.write " <tr class=""gametitle"" ></tr>"

	If isArray(arrPub) then
	%><!-- #include virtual = "/pub/html/riding/boocontrollist.asp" --><%
	End if
    Response.write "</tbody>"
    Response.write "</table><br><br><br><br>"
  %>
  </div>




  <!-- #include virtual = "/pub/html/riding/html.modalplayer.asp" -->



</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>

<script language="Javascript">
/* ======================================================================= 
   ======================================================================= */
    // Event Listener
    
/*  =================================================================================== 
        자동 부 합치기 
    =================================================================================== */    
    function onBtnAutoSumBoo(sender)
    {     
        var strRDetail, strBLimit, tIdx, gYear;
        strRDetail = ctx.getHiddenVal("hide_strRDetail");
        strBLimit = ctx.getHiddenVal("hide_strBLimit");
        tIdx = ctx.getHiddenVal("hide_tidx");
        gYear = ctx.getHiddenVal("hide_gYear");

        mx.autoSumBoo(sender, tIdx, gYear, strRDetail, strBLimit);
    }



</script>


