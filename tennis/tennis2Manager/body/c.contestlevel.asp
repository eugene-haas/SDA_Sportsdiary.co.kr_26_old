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
  strFieldName = " RGameLevelIdx,a.Level,a.TeamGbNm,GameTime,attmembercnt,a.gametype,b.LevelNm,a.TeamGb,a.teamGbSort,GameDay,EntryCntGame,courtcnt,a.chkJooRull,EndRound,cfg,joocnt,setrnkpt, " & attcnt & "," & titlegradef & ", lastroundmethod "



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
<a name="contenttop"></a>

    <div class="top-navi-inner">

      <div class="top-navi-tp">
        <h3>경기진행 부서  - <%=title%></h3>
      </div>
    </div>





<%
  Response.write "<table class=""table-list admin-table-list"">"
  Response.write "<thead><th>소속</th><th>경기진행</th><th>조수</th><th>코트수</th></thead>" 

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
      chk1 = "[변형]"
    Else
      chk1 = "[일반]"   
    End If
	titlegrade   = rs("titlegrade")
	If isnull(titlegrade) = True Then
		titlegrade = 8
	End if
    %>
  <tr class="gametitle"  id="titlelist_<%=idx%>" >
    <td   style="text-align:left;padding-left:10px;"><%=teamgbnm%><%If LevelNm <> "" then%>(<%=LevelNm%>)<%End if%>&nbsp;<span><%=chk1%></span></td>  
    </td>   
    <td>
    <%If LevelNm = "최종라운드" then%>
        <a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func">리그</a>
        <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func">토너먼트</a>
        <a href="javascript:mx.setLastRound(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=levelgb%>')" class="btn_a btn_func btn_final_round">최종라운드생성</a>
    <%else%>

		<%If  setrnkpt = "Y" then%>
          <%If isnumeric(joocnt) = False then%>
            <a href="javascript:mx.leaguepre(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" >1 대회 준비</a><br>
			<a href="javascript:alert('예선 조수가 입력되어있지 않습니다.');mx.input_edit(<%=idx%>);"" class='btn_a btn_func'>1 대회 준비</a><br>
			<a href="javascript:alert('예선 조수가 입력되어있지 않습니다.');mx.input_edit(<%=idx%>);"" class='btn_a btn_func'>2 예선 진행</a><br>
          <%else%>
            <a href="javascript:mx.leaguepre(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" >1 대회 준비</a><br>
			<a href="javascript:mx.leaguepre(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" >1 대회 준비</a><br>
			<a href="javascript:mx.league(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')" class="btn_a btn_func" >2 예선 진행</a><br>
          <%End if%>

		  <a href="javascript:mx.tournament(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>')" class="btn_a btn_func" >3 본선 진행</a><br>
        <%End if%>
    <%End if%>
    </td>
    <td><%=joocnt%></td>
    <td><%=courtcnt%></td>
  </tr>
  <%
  rs.movenext
  Loop
  Response.write "</tbody>"
  Response.write "</table>"

  Set rs = Nothing
%>



<!-- #include virtual = "/pub/html/tennisAdmin/html.modalplayer.asp" -->


<div id="ModallastRound" class="modal hide fade step2modal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" style="z-index:1100">
</div>

