<!-- #include virtual = "/pub/fn/fn_bbs_select.asp" -->
<!-- #include virtual = "/pub/fn/fn.paging.asp" -->

<%
 'Controller ################################################################################################

  'request 처리##############
  If request("idx") = "" Then
    Response.redirect "./contest.asp"
    Response.End
  End if

  idx = chkInt(chkReqMethod("idx", "GET"), 1)
  page = chkInt(chkReqMethod("page", "GET"), 1)

  search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
  search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

  page = iif(search_first = "1", 1, page)
  titleidx = idx
  'request 처리##############

  'ConStr = Replace(ConStr, "ITEMCENTER", "itemcenter_test")
  Set db = new clsDBHelper

	'사은품
	SQL = "Select name from sd_gamePrize where gubun = 1  and delYN = 'N'"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then
		arrG = rs.GetRows()
	End If



  strTableName = " sd_TennisTitle "
  strFieldName = " GameTitleIDX,gameTitleName,GameS,GameE,GameYear,cfg,GameRcvDateS,GameRcvDateE,EnterType,stateNO,titleGrade  "

  SQL = "select top 1 "&strFieldName&" from " & strTableName & " where GameTitleIDX = " & idx
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  title = rs("gameTitleName")
  entertype = rs("EnterType") '유형 엘리트 아마추어 KATA
  game_stateNO  = rs("stateNO") '999게임종료 편집불가
  titlegradestr = findGrade(rs("titleGrade"))


  '######################

  intPageNum = page
  intPageSize = 100

  attcnt = " (select count(*) from tblGameRequest where gametitleIDx = "&idx&" and level = a.level and delYN = 'N' ) as attcnt "
  titlegradef = " (select titleGrade from sd_TennisTitle where gametitleIDx = "&idx&" and delYN = 'N' ) as titlegrade "

  strTableName = "  tblRGameLevel as a inner join tblLevelInfo as b  ON a.level = b.level and b.DelYN ='N' "
  strFieldName = " RGameLevelIdx,a.Level,a.TeamGbNm,GameTime,attmembercnt,a.gametype,b.LevelNm,a.TeamGb,a.teamGbSort,GameDay,EntryCntGame,courtcnt,a.chkJooRull,EndRound,cfg,joocnt,setrnkpt, " & attcnt & "," & titlegradef & ", lastroundmethod ,gameprize "

  strSort = "  ORDER BY gameday ,level, RGameLevelidx Desc"
  strSortR = "  ORDER BY gameday desc, level desc,RGameLevelidx Asc"
  strWhere = " a.GameTitleIDX = "&idx&" and a.DelYN = 'N' "

  SQL = "Select "&strFieldName&" from "&strTableName&" where " & strWhere & strSort
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)



  SQL = "Select p1_teamnm,count(*),max(p1_team) from tblGameRequest where gametitleidx = " & idx & " and delyn = 'N' group by p1_teamnm "
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'디폴트값 설정
entrycnt = 60  '참여제한 기본값
courtcnt = 9 '코트수 기본값
joocnt = 32
%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>
  <div class="page_title"><h1>대진표 > 경기진행  - [<%=titlegradestr%>]<%=title%></h1></div>

  <div class="btn-toolbar mgt20">    
    <div class="btn-group flr">
      <a href="./attexcel.asp?tidx=<%=titleidx%>" class="btn btn-primary"><span class="glyphicon glyphicon-save-file"></span>참가신청엑셀다운</a>
    </div>
  </div>

  <div class="table-responsive">
<%

  Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
  Response.write "<thead><tr><th>단체코드</th><th>단체명</th><th>신청명수</th><th>참가자목록</th></tr></thead>"

  Response.write "<tbody id=""contest"">"
  Response.write " <tr class=""gametitle""></tr>"

  Do Until rs.eof

    teamnm = rs(0)
    attcnt = rs(1)
	teamcode = rs(2)

    %>
      <!-- #include virtual = "/pub/html/riding/gameinfoteamlist.asp" -->
  <%
  rs.movenext
  Loop
  Response.write "</tbody>"
  Response.write "</table>"

  Set rs = Nothing
%>

</div>






<!-- #include virtual = "/pub/html/riding/html.modalplayer.asp" -->




<div id="ModallastRound" class="modal hide fade step2modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="z-index:1100">
</div>
