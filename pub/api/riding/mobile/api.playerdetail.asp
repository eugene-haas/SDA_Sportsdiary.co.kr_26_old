<%
'######################
'검색리스트  http://tennis.sportsdiary.co.kr/tennis/tsm_player/record/record_sd.asp or ajax에서 사용
'######################


	If hasown(oJSONoutput, "YY") = "ok" Then '년도
		YY = oJSONoutput.YY
	End If
	If hasown(oJSONoutput, "GB") = "ok" Then '코드
		teamgb = oJSONoutput.GB
	Else
		teamgb = 20101
	End If
	If hasown(oJSONoutput, "F1") = "ok" Then '이름 검색어
		F1 = oJSONoutput.F1
	End If



	nowyear = YY
	startyy = nowyear
	Endyy = nowyear
	startyy = CDbl(startyy) -4

	If startyy < 2019 Then
		startyy = 2019
	End if

	chkdateS  = nowyear & "-01-01"
	chkdateE  = CDbl(nowyear) + 1 & "-01-01"


	Set db = new clsDBHelper


	SQL = "select top 1 playeridx,MemberIDX,userID,UserName,UserPhone,birthday,sex,TeamGB,teamNm,team2Nm,belongBoo  from tblPlayer where playeridx = '"&F1&"' and TeamGB <> ''  "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.eof Then
		unm = rs("username")
		t1 = rs("teamNm")
		t2 = rs("team2Nm")
		gbnm = rs("belongBoo")
		birthday = rs("birthday")

		sex = rs("sex")
		If LCase(sex ) = "man" Then
			sex = "남"
		Else
			sex = "여"
		End if
	End if



  sortstr = " group by a.playerIDX"
  Select Case teamgb 
  case "20101" '원스타 여
	  boostr = "여자부★ (1스타)"
	  twostar = " a.teamgb = '20102' and a.upgrade = 1 " '승급후 데이터
	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
	  SQL = "select top 1 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and a.playerIDX = '"&F1&"' " & sortstr

  case "20104" '원스타 남
	  boostr = "남자부★ (1스타)"
	  twostar = " a.teamgb = '20104' and a.upgrade = 1 " '승급후 데이터
	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
	  SQL = "select top 1 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and a.playerIDX = '"&F1&"' " & sortstr

  Case "20102","20105"
	  If teamgb = "20102" Then
	  boostr = "여자부★★ (2스타)"
	  else
	  boostr = "남자부★★ (2스타)"
	  End if
	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
	  SQL = "select top 1 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
	  SQL = SQL & " where a.teamGb= '"&teamgb&"' and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and a.playerIDX = '"&F1&"' " & sortstr
	  Case "20102","20105"
  End Select
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

  mypoint = FormatNumber(rs(0),0)

%>
            <div class="playerDetail__header">
              <div class="playerDetail__photo"><img src="" alt=""></div>
              <div class="playerDetail__summary">
                <div class="playerDetail__name"><%=unm%> (<%=gbnm%>)</div>
                <div class="playerDetail__info s_top_round">
                  <p class="playerDetail__txt">기본클럽</p>
                  <p class="playerDetail__txt2"><%=t1%></p>
                </div>
                <div class="playerDetail__info">
                  <p class="playerDetail__txt">기타클럽</p>
                  <p class="playerDetail__txt2"><%=t2%></p>
                </div>
                <div class="playerDetail__info s_bottom_round">
                  <p class="playerDetail__txt">프로필</p>
                  <p class="playerDetail__txt2"><%=Left(birthday,4)%> / <%=sex%></p>
                </div>
                <div class="playerDetail__info s_round">
                  <p class="playerDetail__txt">총포인트</p>
                  <p class="playerDetail__txt2"><%=mypoint%></p>
                </div>
              </div>
            </div>


<%
  sortstr = " order by  gamedate desc"
  Select Case teamgb 
  case "20101" '원스타 여
	  boostr = "여자부★ (1스타)"
	  twostar = " a.teamgb = '20102' and a.upgrade = 1 " '승급후 데이터

	  SQL = "select  getpoint,wincnt,windiff,ptdiff,titlename,teamGbName       from sd_TennisRPoint_log as a   "
	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and a.playerIDX = '"&F1&"' " & sortstr

  case "20104" '원스타 남
	  boostr = "남자부★ (1스타)"
	  twostar = " a.teamgb = '20104' and a.upgrade = 1 " '승급후 데이터
	  SQL = "select  getpoint,wincnt,windiff,ptdiff,titlename,teamGbName       from sd_TennisRPoint_log as a   "
	  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and a.playerIDX = '"&F1&"' " & sortstr

  Case "20102","20105"
	  If teamgb = "20102" Then
	  boostr = "여자부★★ (2스타)"
	  else
	  boostr = "남자부★★ (2스타)"
	  End if
	  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
	  SQL = "select  getpoint,wincnt,windiff,ptdiff,titlename,teamGbName       from sd_TennisRPoint_log as a   "
	  SQL = SQL & " where a.teamGb= '"&teamgb&"' and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' and a.playerIDX = '"&F1&"' " & sortstr
	  Case "20102","20105"
  End Select
  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
%>
            <div class="playerDetail__list">
              <ul>
				<%
				i = 1
				Do Until rs.eof
					titlename = rs("titlename")
					getpoint = FormatNumber(rs("getpoint"),0)
				%>
				  <li>
                    <div class="playerDetail__listwrap">
                      <p class="playerDetail__listno"><%=i%></p>
                      <div class="playerDetail__infos">
                        <div class="playerDetail__infotop">
                          <p class="playerDetail__comp"><%=titlename%></p>
                          <p class="playerDetail__point"><%=getpoint%>p</p>
                          <p class="playerDetail__result">1위</p>
                        </div>
                        <p class="playerDetail__pos">★ 1스타</p>
                      </div>
                    </div>
                  </li>
				<%
				i = i + 1
				rs.movenext
				loop
				%>


              </ul>
            </div>
            <!-- <button class="l_recordList__btn_add">더보기 <span><img src="http://tennis.sportsdiary.co.kr/tennis/tsm_player/record/btn_more.png" alt=""></span></button> -->
<%




	db.Dispose
	Set db = Nothing
%>