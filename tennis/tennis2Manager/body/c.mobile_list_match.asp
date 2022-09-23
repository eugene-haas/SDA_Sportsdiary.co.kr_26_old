<%
 'Controller ################################################################################################
  Set db = new clsDBHelper

  'request 처리##############
  If request("idx") = "" Then
    Response.redirect "./mobile_index.asp"
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

  db.dispose()
%>


<!-- s 헤더 영역 -->
<header class="header clear">
  <div class="header__side-con">
	<button class="header__side-con__btn" type="button" name="button">대회정보관리</button>
    <a href="./mobile_index.asp" class="header__side-con__btn header__btn-home t_ico"><img src="./Images/mobile_ico_home.svg" alt="홈"></a>
    <button onclick="closeModal()" class="header__side-con__btn header__btn-cancel t_ico"><img src="./Images/mobile_ico_close.svg" alt="닫기"></a>
  </div>
  <h1 class="header__main-con"><%=title%></h1>
  <div class="header__side-con">
    <button class="header__side-con__btn" type="button" name="button">로그아웃</button>
    <button class="header__side-con__btn header__btn-reset t_ico"><img src="./Images/mobile_ico_reset.svg" alt="새로고침"></button>
  </div>
</header>
<!-- e 헤더 영역 -->
<!-- s 메인 영역 -->
<div class="l_main">
  <h2><strong class="hide">메인 콘텐츠 시작</strong></h2>
  <section class="">
    <h1 class="l_main__header hide">대회 리스트 시작</h1>
    <div class="l_main__con">
      <ul>
        <%
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
        <li class="match__list clear">
          <h2><%=teamgbnm%><%If LevelNm <> "" then%>(<%=LevelNm%>)<%End if%>&nbsp; <%=chk1%></h2>
          <ol>
            <li class="match__list__list"><button type="button" name="button" onclick="mx.initCourt(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')">
              <h4>1.코트등록/관리</h4>
            </button></li>
            <li class="match__list__list"><button type="button" name="button" onclick="mx.leaguepre(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>', 1)">
              <h4>2.출전신고 / 예선 대진표</h4>
            </button></li>
            <li class="match__list__list"><button type="button" name="button" onclick="mx.league_ing(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>', 1)">
              <h4>3.예선 경기진행</h4>
            </button></li>
            <li class="match__list__list"><button type="button" name="button" onclick="mx.league_draw(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','<%=game_stateNO%>')">
              <h4>4.본선대진추첨/코트배정</h4>
            </button></li>
            <li class="match__list__list"><button type="button" name="button" onclick="mx.tournament_ing(<%=idx%>,'<%=teamgbnm%>','<%=LevelNm%>','roundsel')">
              <h4>5.본선 경기진행</h4>
            </button></li>
          </ol>
        </li>
        <%
          rs.movenext
          Loop
          Set rs = Nothing
        %>
      </ul>
    </div>
  </section>
</div>
<!-- e 메인 영역 -->


<!-- s 모달창 영역 -->
<!-- 코트 -->
<section class="l_modal t_court" id="t_court"></section>
<section class="l_modal t_match-list" id="t_league_pre"></section>
<section class="l_modal t_league_pre" id="t_match-list"></section>
<section class="l_modal t_draw-lots" id="t_draw-lots"></section>
<section class="l_modal t_match_main" id="t_match_main"></section>
<!-- e 모달창 영역 -->

<script>
  function openModal(index) {
    document.querySelectorAll('.l_modal')[index].classList.add('s_show');
    document.querySelector('body').classList.add('s_modal');
  }

</script>
