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


'디폴트값 설정
entrycnt = 60  '참여제한 기본값
courtcnt = 9 '코트수 기본값
joocnt = 32
%>


<%'View ####################################################################################################%>
<div class="admin_content">
  <a name="contenttop"></a>

  <div class="page_title"><h1>대진표 > 경기진행  - [<%=titlegradestr%>]<%=title%></h1></div>

  <%If CDbl(ADGRADE) > 500 then%>

    <div class="info_serch " id="gameinput_area">
<!-- <div class="navi-tp-table-wrap"  id="gameinput_area"> -->
      <!-- #include virtual = "/pub/html/swimAdmin/gameinfolevelform.asp" -->


    </div>

    <hr />

    <div class="btn-toolbar">
      <!-- <a href="javascript:sd.makeGoods()" id="gdmake" class="btn" style="float:left;">상품등록</a> -->


      <div class="btn-group pull-right">
        <a href="./contest.asp" id="btnsave" class="btn btn-primary" accesskey="i">대회목록</a>
      </div>
    </div>

  <%End if%>


  <div class="table-responsive">

  <%

    Response.write "<table cellspacing=""0"" cellpadding=""0"" class=""table table-hover"">"
  If CDbl(ADGRADE) > 500 then
    'Response.write "<thead><tr><th>번호</th><th>구분</th><th>소속</th><th>경기진행</th><th>조수</th><th>신청/수정/삭제</th><th>코트수</th><th>제한</th><th>신청</th><th>선수관리</th></tr></thead>" '
    Response.write "<thead><tr><th>번호</th><th>구분</th><th>그룹</th><th>조수</th><th>신청/수정/삭제</th><th>레인</th><th>제한</th><th>신청</th><th>신청자관리</th></tr></thead>" '
  Else
    Response.write "<thead><tr><th>번호</th><th>그룹</th><th>제한</th><th>신청</th><th>참가자</th></tr></thead>"
  End if
    Response.write "<tbody id=""contest"">"
    Response.write " <tr class=""gametitle"" ></tr>"

    Do Until rs.eof

      entrycnt = rs("EntryCntGame")
      idx = rs("RGameLevelIdx")
      levelgb = rs("level")
      teamgb = rs("teamgb")
      Select Case  Left(teamgb,3)
      Case "201","200"
        boo = "개인전"
      Case "202"
        boo = "단체전"
      End Select
      teamgbnm = rs("TeamGbNm")
      'attcnt = rs("attmembercnt")
  	attcnt = rs("attcnt")
      gametype = rs("gametype")

      Select Case  gametype
      Case "sd043003"
        gametypestr = "리그&gt;토너먼트"
      Case "sd043002"
        gametypestr = "토너먼트"
      End Select

      LevelNm = rs("LevelNm")
      courtcnt = rs("courtcnt")
      rChkJooRull = rs("chkJooRull")
      endround = rs("EndRound")
      joocnt = rs("joocnt")
      setrnkpt = rs("setrnkpt")
  	lastroundmethod = rs("lastroundmethod") '최종라운드 방식 (0 방식선택안됨 1, 리그 2 토너먼트)

      cfg = rs("cfg")
      chk1 = Left(cfg,1)
      chk2 = Mid(cfg,2,1)
      chk3 = Mid(cfg,3,1)
      chk4 = Mid(cfg,4,1)
      If chk1 = "Y" Then
        chk1 = "[변형요강]"
      Else
        chk1 = "[일반요강]"
      End If
  	titlegrade   = rs("titlegrade")
  	If isnull(titlegrade) = True Then
  		titlegrade = 8
  	End if
      %>
        <!-- #include virtual = "/pub/html/swimAdmin/gameinfolevellist.asp" -->
    <%
    rs.movenext
    Loop
    Response.write "</tbody>"
    Response.write "</table>"

    Set rs = Nothing
  %>
  </div>




  <!-- #include virtual = "/pub/html/swimAdmin/html.modalplayer.asp" -->



</div>

<div id="ModallastRound" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
</div>
