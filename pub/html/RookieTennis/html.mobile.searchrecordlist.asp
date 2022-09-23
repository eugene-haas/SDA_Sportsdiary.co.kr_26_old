<%
'If USER_IP = "118.33.86.240" Then
'			response.Write SQL
'End if
%>


  <div class="l_recordTab__wrap">
    <div class="l_recordTab__tab">
      <div class="l_recordList__wrap">
        <!-- .s. 조회 전 .s. -->
        <!-- <div class="l_recordPrev">
          <div class="l_recordPrev__wrap">
            <div class="l_recordPrev__bg"><img src="http://img.sportsdiary.co.kr/images/SD/img/tennis_record_empty_@3x.png" alt="경기 기록실 에서 빠르게 경기결과를 확인하세요!"></div>
          </div>
        </div> -->
        <!-- //e. 조회 전 .e. -->

        <!--
          .s.
          조회 후.
          1,2,3위는 해당 영역을 감싸는 li에  s_ranking 클래스 추가
          .s.
        -->

        <div class="l_recordList" style="display:block;">
          <div class="l_recordList__header">
            <p class="l_recordList__tle"><%=boostr%></p>
            <p class="l_recordList__cmt"><span>*</span> 선수명 클릭 시 랭킹포인트 상세내역을 볼 수 있습니다.</p>
            <button class="l_recordRank__rule" onclick="openSummary('')">랭킹규정</button>
          </div>
          <div class="l_recordList__content">
            <ul id ="ranklist_ul">

			<%
					pageno = 1
					pagesize = 10
					drowshow = True
					chk100 = false

					i = 1

					i = ((pageno -1) * pagesize) + i

					Do Until rs.eof
						pidx = rs(5)

						If F1 <> "" Then
							If CDbl(pidx) = CDbl(F1) Then
								chk100 = true
								drowshow = true
							Else
								drowshow = False
							End if
						End if

						team = rs(6)
						If right(team,1) = "," Then
						team = Replace(team,",", "")
						End if

						If i < 4 Then
							classnm = "class=""s_ranking"" "
						Else
							classnm = ""
						End if

						If drowshow = True then
						%>
									<li <%=classnm%>>
									  <p class="l_recordList__no"><%=rs("orderno")%></p>
									  <button class="l_recordList_btn" onclick="tm.openDetail('playerdetail',<%=pidx%>,<%=teamgb%>,<%=nowyear%>);">
										<p class="l_recordList__name"><%=rs(4)%></p>
										<p class="l_recordList__pos"><%=team%></p>
									  </button>
									  <p class="l_recordList__point"><%=FormatNumber(rs(0),0)%>p</p>
									</li>
						<%
						End if



					lastorder = rs("orderno")
					lastpt = rs(0)
					i = i + 1
					rs.movenext
					loop

					If F1 <> "" And chk100 = false Then '100위안에 없을때 검색해서 출력

					  findplayerwhere = " and a.playeridx = '" & F1 & "' and b.stateno <> '1' group by a.playerIDX "

					  '외부에서 바로 가기로 올경우를 대비해서
					  Select Case teamgb
					  case "20101" '원스타 여
						  boostr = "여자부★ (1스타)"
						  twostar = " a.teamgb = '20102' and a.upgrade = 1 " '승급후 데이터
						  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
						  SQL = "select top 1 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
						  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' " & findplayerwhere

					  case "20104" '원스타 남
						  boostr = "남자부★ (1스타)"
						  twostar = " a.teamgb = '20105' and a.upgrade = 1 " '승급후 데이터
						  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
						  SQL = "select top 1 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
						  SQL = SQL & " where (a.teamGb= '"&teamgb&"' or ("&twostar&")) and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' " & findplayerwhere

					  Case "20102","20105"
						  If teamgb = "20102" Then
						  boostr = "여자부★★ (2스타)"
						  else
						  boostr = "남자부★★ (2스타)"
						  End if
						  teamStr = " max(b.teamNm + ',' + b.team2Nm) "
						  SQL = "select top 1 sum(getpoint),sum(wincnt),sum(windiff),sum(ptdiff),     max(a.username),a.playerIDX,"&teamStr&"  from sd_TennisRPoint_log as a inner join tblPlayer as b on a.playeridx = b.playeridx  "
						  SQL = SQL & " where a.teamGb= '"&teamgb&"' and a.gamedate >= '"&chkdateS&"' and a.gamedate < '"&chkdateE&"' " & findplayerwhere
						  Case "20102","20105"
					  End Select
					  Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

					  If rs.eof Then
					  %>
									<li>
									  <p class="l_recordList__no">&nbsp;</p>
									  <button class="l_recordList_btn">
										<p class="l_recordList__name">입상 내역이 없습니다.</p>
										<p class="l_recordList__pos">&nbsp;</p>
									  </button>
									  <p class="l_recordList__point">0p</p>
									</li>
					  <%

					  else
					  %>
									<li>
									  <p class="l_recordList__no">
									  <%If lastpt = rs(0) then%>
									  <%=lastorder%>
									  <%else%>
									  
									  <%End if%>
									  </p>
									  <button class="l_recordList_btn" onclick="mx.openDetail('playerdetail',<%=F1%>,<%=teamgb%>,<%=nowyear%>);">
										<p class="l_recordList__name"><%=rs(4)%></p>
										<p class="l_recordList__pos"><%=rs(6)%></p>
									  </button>
									  <p class="l_recordList__point"><%=FormatNumber(rs(0),0)%>p</p>
									</li>
					  <%
					  End if

					End if


			%>

            </ul>
<%

If USER_IP = "118.33.86.240" Then
'			response.Write SQL
End if

%>

            <!-- <button class="l_recordList__btn_add">더보기 <span><img src="http://img.sportsdiary.co.kr/images/SD/icon/arrow_down_circle_@3x.png" alt=""></span></button> -->
          </div>
        </div>
        <!-- //e. 조회 후 .e. -->
      </div>

    </div>
  </div>
