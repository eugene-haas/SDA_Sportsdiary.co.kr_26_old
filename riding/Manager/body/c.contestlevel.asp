<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
  If request("idx") = "" Then
    Response.redirect "./contest.asp"
    Response.End
  End if

  tidx = chkInt(chkReqMethod("idx", "GET"), 1)
  titleidx = idx
  'request 처리##############
  Set db = new clsDBHelper


  strTableName = " sd_TennisTitle "
  strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,EnterType,stateNO,titleGrade,kgame  "

  SQL = "select top 1 "&strFieldName&" from " & strTableName & " where GameTitleIDX = " & tidx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  If Not rs.eof then
	  title = rs("gameTitleName")
	  entertype = rs("EnterType") '유형 엘리트 아마추어 KATA
	  game_stateNO  = rs("stateNO") '999게임종료 편집불가
	  kgame = rs("kgame") 'YN 체전여부 
  End if

%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대진표 > 경기진행  - <%=title%></h1></div>

  <%If CDbl(ADGRADE) > 500 then%>

    <div class="info_serch " id="gameinput_area">
      <!-- #include virtual = "/pub/html/riding/gameinfolevelform.asp" -->
    </div>

    <hr />

	<div class="btn-toolbar">
      <div class="btn-group pull-right">
        <a href="javascript:mx.setLimit(<%=tidx%>,'<%=title%>',1, 1)" id="gdmake" class="btn btn-green">참가신청제한관리</a>&nbsp;<%'선수말, 1,2 , 개인단체 1,2%>
		
		
		<a href="./contest.asp" id="btnsave" class="btn btn-primary" accesskey="i">대회목록</a>
      </div>
    </div>

  <%End if%>


  <div class="table-responsive">
  <%
    Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
	Response.write "<thead><tr><th>순서</th><th>출력용</th><th>종목/마종/세부/안내</th><th>대회일자</th><th>신청기간</th><th>종별</th><th>라운드</th><th>참가비</th><th>신청자관리</th></tr></thead>" '
    Response.write "<tbody id=""contest"">"
    Response.write " <tr class=""gametitle"" ></tr>"
	%><!-- #include virtual = "/pub/html/riding/gameinfolevellist.asp" --><%
    Response.write "</tbody>"
    Response.write "</table><br><br><br><br>"
  %>
  </div>








</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
<!-- /sportsdiary.co.kr/pub/api/ridingAdmin/api.limit.asp -->
</div>
