<%
 'Controller ################################################################################################
  Set db = new clsDBHelper

  'request 처리##############
  page = chkInt(chkReqMethod("page", "GET"), 1)
  search_word = chkLength(chkStrRpl(chkReqMethod("search_word", ""), ""), 10) 'chkStrReq 막음 chkStrRpl replace
  search_first = chkInt(chkReqMethod("search_first", "POST"), 0)

  page = iif(search_first = "1", 1, page)
  'request 처리##############


	strTableName = " sd_TennisTitle a"
  strTableName2 = " tblRGameLevel b"
	'stateNo = 게임상태 0표시전, 3 예선대진표보임 , 4 예선마감상태, 5 본선대진표보임 , 6 본선마감사태 , 7 결과발표보임
	strFieldName = " a.GameTitleIDX, a.gameTitleName, a.GameS, a.GameE, a.GameYear, a.cfg, a.GameRcvDateS, a.GameRcvDateE, a.ViewYN, a.MatchYN, a.viewState, a.stateNo, a.titlecode, a.titlegrade, a.vacReturnYN , a.tnshowhide " '본선대진보임안보임

	strSort = "  order by GameS desc"
	strSortR = "  order by GameS"

	'대회의 날짜가 오늘거만 가져오자.
	strWhere = " a.DelYN = 'N' "

	SQL =  " select top 5 " & strFieldName & " from " & strTableName & " left join " & strTableName2 & " on a.GameTitleIDX = b.GameTitleIDX and b.delyn = 'N' "

	If request("test") = "" then
	SQL = SQL &  " where " & strWhere & " and  b.GameDay = '"&Date()&"'  " & strSort
	Else
	SQL = SQL &  " where " & strWhere & " and  (b.GameDay =  '"&Date()&"' or a.gameTitleIDX = "&request("test")&") " & strSort
	End if
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'response.write Sql
'response.end

%>
<div class="l_main">
  <h2><strong class="hide">메인 콘텐츠 시작</strong></h2>
  <section class="">
    <h1 class="l_main__header hide">대회 리스트 시작</h1>
    <div class="l_main__con">
      <ul>
        <%
        Do Until rs.eof
          idx = rs("GameTitleIDX")
          title = rs("gameTitleName")
          sdate = rs("GameS")
          edate = rs("GameE")
          gamecfg = rs("cfg")
          rcvs = rs("GameRcvDateS")
          rcve = rs("GameRcvDateE")
          tnshow = rs("tnshowhide") '본선 대진표 보임 안보임

          ViewYN = rs("ViewYN")
          MatchYN = rs("stateNo")
          viewState = rs("viewState")
          vacReturnYN = rs("vacReturnYN")

          titleCode = rs("titleCode")
          titleGrade = findGrade(rs("titleGrade"))
          %>
          <li class="index__list" id="titlelist_<%=idx%>" onclick="mx.golevel(<%=idx%>,'<%=title%>')">
            <span><%=titleGrade%></span>
            <h2><%=title%></h2>
          </li>
          <%
          rs.movenext
          Loop
          Set rs = Nothing
        %>
        
		<%If request("t") = "test" then%>
		<li class="index__list" id="titlelist_25" onclick="mx.golevel(25,'가이드 작성용 대회')">
          <span>E</span>
          <h2>가이드 작성용 테스트 대회</h2>
        </li>
		<%End if%>
		
		 </ul>
    </div>
  </section>
</div>
