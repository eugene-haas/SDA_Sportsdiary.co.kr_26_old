<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
'  If request("idx") = "" Then
'    Response.redirect "./contest.asp"
'    Response.End
'  End if

  tidx = chkInt(chkReqMethod("idx", "GET"), 1)
  'titleidx = idx

   tidx = 136 
  'request 처리##############
  Set db = new clsDBHelper


  strTableName = " sd_TennisTitle "
  strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,EnterType,stateNO,titleGrade,kgame  "

  SQL = "select top 1 "&strFieldName&" from " & strTableName & " where GameTitleIDX = " & tidx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  title = rs("gameTitleName")
  entertype = rs("EnterType") '유형 엘리트 아마추어 KATA
  game_stateNO  = rs("stateNO") '999게임종료 편집불가
  titlegradestr = findGrade(rs("titleGrade"))
  kgame = rs("kgame") 'YN 체전여부 
%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대진표 > 경기진행  - <%=title%></h1></div>

  <%If CDbl(ADGRADE) > 500 then%>

	<!-- s: 정보 검색 -->
	<div class="info_serch" id="gameinput_area">
		<!-- #include virtual = "/pub/html/riding/gamefindform.asp" -->
      <%'<!-- #include virtual = "/pub/html/riding/gameinfolevelform.asp" -->%>
	</div>
	<!-- e: 정보 검색 -->

    <hr />



	<!-- s: 리스트 버튼 -->
	<div class="btn-toolbar" role="toolbar" aria-label="btns">
		<a href="#" class="btn btn-link">세부종목 부별조정</a>

		<div class="btn-group flr">
			<a href="javascript:alert('진행중 ....이라네')" id="gdmake" class="btn btn-primary">부별조정 실행</a>
			<!-- <a href="javascript:alert('진행중 ....이라네')" id="gdmake" class="btn btn-primary">부별조정 저장</a> -->
		</div>

	</div>
	<!-- e: 리스트 버튼 -->



  <%End if%>


  <div class="table-responsive">

  <%
    Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
    Response.write "<thead><tr><th>번호</th><th>신청/수정/삭제</th><th>종목/마종/세부/안내</th><th>대회일자</th><th>신청기간</th><th>종별</th><th>라운드</th><th>참가비</th><th>신청자관리</th></tr></thead>" '
    Response.write "<tbody id=""contest"">"
    Response.write " <tr class=""gametitle"" ></tr>"
	%><!-- #include virtual = "/pub/html/riding/gameOrderlist.asp" --><%
    Response.write "</tbody>"
    Response.write "</table><br><br><br><br>"
  %>
  </div>




  <!-- #include virtual = "/pub/html/riding/html.modalplayer.asp" -->



</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>
