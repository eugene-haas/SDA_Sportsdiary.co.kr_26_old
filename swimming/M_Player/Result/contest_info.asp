<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
	Set db = new clsDBHelper

	tidx = request("tidx")
	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		If hasown(oJSONoutput, "TIDX") = "ok" then
			tidx = oJSONoutput.TIDX
		End If
		If hasown(oJSONoutput, "DD") = "ok" then
			dd = oJSONoutput.DD
		End if
	End if

'tidx = 78 '수구내용확인용

	If isnumeric(tidx) Then
      SQL = "select gametitlename , gameS,gameE,gamearea from sd_gameTitle where gametitleidx = '"&tidx&"' "
      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
      If Not rs.eof Then
        title = rs(0)
        gameS = rs(1)
        gameE = rs(2)
        gamearea = rs(3)
      End if

      SQL = "       select gamedate , min(cda) from ( "
      SQL = SQL & " select "
      SQL = SQL & " tryoutgamedate as gamedate, min(cdcnm) as cda "
      SQL = SQL & " from tblRGameLevel where delyn = 'N' and gametitleidx = "&tidx&" and tryoutgamedate is not null group by tryoutgamedate "
      SQL = SQL & " union all "
      SQL = SQL & " select "
      SQL = SQL & " finalgamedate as gamedate, min(cdcnm) as cda "
      SQL = SQL & " from tblRGameLevel where delyn = 'N' and gametitleidx = "&tidx&" and finalgamestarttime is not null group by finalgamedate "
      SQL = SQL & " ) as a "
      SQL = SQL & " group by gamedate order by gamedate "
      Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

      If Not rs.EOF Then
        tmarr = rs.GetRows()

        For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
          If ari = 0 Then
            start_gamedate = isNullDefault(tmarr(0, ari), "")
          End If
          If isNullDefault(tmarr(0, ari), "") = dd Then
            start_gamedate = isNullDefault(tmarr(0, ari), "")
          End If
        Next

        '경영오전시작시간 오후 끝시간만 가져오자.
        SQL = "select min(am),min(pm) from sd_gameStartAMPM where tidx = "& tidx & " and gamedate = '"&start_gamedate&"' "
        Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
        if not rs.eof then
          start_am = isNullDefault(rs(0), "")
          start_pm = isNullDefault(rs(1), "")      
        end if

        '++++++++++++++++++++++++
        If start_gamedate = "" Then
          '날짜 생성전
        else
          '경영 오전
          fld = " min(RGameLevelidx),CDC,CDCNM,min(tryoutgamedate) ,min(tryoutgamestarttime) ,min(gameno) as gameno,gubunam "
          SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and CDA = 'D2' and tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0 "
          SQL = SQL & " group by cdc,cdcnm,gubunam order by gameno "
          Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
          If Not rs.EOF Then
          arrR = rs.GetRows()
          End If

          fld = " min(RGameLevelidx),CDC,CDCNM,min(finalgamedate) ,min(finalgamestarttime),min(gameno2) as gameno2,gubunpm "

          SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and CDA = 'D2' and finalgamedate = '"&start_gamedate&"' and finalgameingS > 0 "
          SQL = SQL & " group by cdc,cdcnm,gubunpm order by gameno2 "
          Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
          If Not rs.EOF Then
            arrR2 = rs.GetRows()
          End If





          '다이빙(날짤1개로사용) 아티스틱(날짜2개로 사용) 수구까지
          fld = " CDA,CDBNM,CDC,CDCNM,tryoutgamedate,finalgamedate,tryoutgamestarttime,finalgamestarttime,gameno,itgubun "
          SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and CDA in ('E2','F2') and tryoutgamedate = '"&start_gamedate&"' or finalgamedate = '"&start_gamedate&"'  " 'and tryoutgamestarttime = '10:00'  "
          SQL = SQL & " order by cast(gameno as int ) "
          Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
          If Not rs.EOF Then
          arrRs = rs.GetRows()
          End If

        End if

      end if
	End if



	weekarr = array("-", "일","월","화","수","목","금","토")

	
%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
</head>
<body <%=CONST_BODY%>>
<%
'call getrowsdrow(arrrs)
%>


<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>




<div id="app" class="l contestInfo">

  <!-- #include file = "../include/gnb.asp" -->

	<div class="l_header">
      <div class="m_header s_sub">
      <a href="/Result/institute-search.asp?reqdate=<%=gameS%>" class="m_header__backBtn">이전</a>
      <h1 class="m_header__tit">대회일정</h1>
        <!-- #include file="../include/header_gnb.asp" -->
      </div>
		<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>

  <!-- S: main -->

	<div class="calender">
      <div class="l_content">
        <h2 class="m_resultTit">
          <span><%=title%></span><%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) <%=gamearea%>
        </h2>
        <div class="day_select_box">
		      <select class="day_select" id="gamedd" onchange="px.goSubmit({'TIDX':<%=tidx%>,'DD':$(this).val()},'contest_info.asp?tidx=<%=tidx%>');">
			    <%
					If IsArray(tmarr) Then
						For ari = LBound(tmarr, 2) To UBound(tmarr, 2)

							tm_gamedate= Left(tmarr(0, ari),10)
              l_cda = tmarr(1,ari)
							tm_week = weekarr(weekday(tm_gamedate))

							%><option value="<%=tm_gamedate%>" <%If tm_gamedate = start_gamedate then%>selected<%End if%>><%= tm_gamedate%>&nbsp;&nbsp;<%=tm_week%> <%'=l_cda%></option><%
						Next
					End if
			    %>
          </select>
        </div>


        <%if IsArray(arrR)  Or isArray(arrR2)  then%>
        <div class="contest_file">
          <ul class="table_box">
            <li><span>경영</span>
              
              <table id="swtable">
                <thead>
                  <tr>
                    <th>오전경기 <%=start_am%> ~</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    if IsArray(arrR) then
                    For ari = LBound(arrR, 2) To UBound(arrR, 2)

                      l_idx = arrR(0, ari)
                      l_CDC = arrR(1, ari)
                      l_CDCNM = arrR(2, ari)
                      l_tryoutgamedate = arrR(3, ari)
                      l_gubun = arrR(6, ari)
                      If l_gubun = "1" Then
                      gubunstr = "예선"
                      Else
                      gubunstr = "결승"
                      End if
                      l_week = weekarr(weekday(l_tryoutgamedate))
                      %><tr><td><%=l_CDCNM%></td></tr><%
                    Next
                    End if
                  %>
                </tbody>
              </table>


              <table id="swtable">
                <thead>
                  <tr>
                    <th>오후경기  <%=start_pm%> ~</th>
                  </tr>
                </thead>
                <tbody>
                  <%
                    if isArray(arrR2) then
                    For ari = LBound(arrR2, 2) To UBound(arrR2, 2)
                      l_idx = arrR2(0, ari)
                      l_CDC = arrR2(1, ari)
                      l_CDCNM = arrR2(2, ari)
                      l_finalgamedate = arrR2(3, ari)
                      l_gubun = arrR2(6, ari)
                      If l_gubun = "1" Then
                      gubunstr = "예선"
                      Else
                      gubunstr = "결승"
                      End if
                      %><tr><td><%=l_CDCNM%></td></tr><%
                    Next
                    end if
                  %>
                </tbody>
              </table>
            </li>
          </ul>
        </div>
        <%end if%>

        <%
        '#################################################################################################################
        if IsArray(arrRs) then
        For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
          s_CDA = arrRs(0, ari)
          s_CDC = arrRs(2, ari)
          if s_CDA = "E2" then
            if s_CDC = "31" then
              CDASG = "OK"
            else
              CDAE2 = "OK"
            end if
          end if
          if s_CDA = "F2" then
            CDAF2 = "OK"
          end if          
        next

          if CDAE2 = "OK" then        
          %>
          <div class="contest_file">
            <ul class="table_box">
              <li><span>다이빙</span>
                
                <table id="swtable">
                  <thead>
                    <tr>
                      <th>오전경기</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
                        l_CDA = arrRs(0, ari)
                        l_CDBNM = arrRs(1, ari)
                        l_CDC = arrRs(2, ari)
                        l_CDCNM = arrRs(3, ari)
                        l_tryoutgamedate = arrRs(4, ari)
                        l_finalgamedate = arrRs(5, ari) '다이빙은 안씀
                        l_tryoutgamestarttime = arrRs(6, ari) '10:00 오전 13:00 > 오후 값고정
                        l_finalgamestarttime = arrRs(7, ari) '다이빙안씀
                        l_ITgubun = arrRs(8,ari)
                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if

                        if l_tryoutgamestarttime = "10:00" or l_tryoutgamestarttime = "09:00" then
                        if l_tryoutgamedate = start_gamedate and l_CDA = "E2" then
                        %><tr><td><%=itgubunstr%>&nbsp;<%=l_CDBNM%>&nbsp;<%=l_CDCNM%></td></tr><%
                        end if
                        end if
                      Next
                    %>
                  </tbody>
                </table>

                <table id="swtable">
                  <thead>
                    <tr>
                      <th>오후경기</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
                        l_CDA = arrRs(0, ari)
                        l_CDBNM = arrRs(1, ari)
                        l_CDC = arrRs(2, ari)
                        l_CDCNM = arrRs(3, ari)
                        l_tryoutgamedate = arrRs(4, ari)
                        l_finalgamedate = arrRs(5, ari) '다이빙은 안씀
                        l_tryoutgamestarttime = arrRs(6, ari) '10:00 오전 13:00 > 오후 값고정
                        l_finalgamestarttime = arrRs(7, ari) '다이빙안씀
                        l_ITgubun = arrRs(8,ari)
                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if

                        if l_tryoutgamestarttime = "13:00" then
                        if l_tryoutgamedate = start_gamedate and l_CDA = "E2" then
                        %><tr><td><%=itgubunstr%>&nbsp;<%=l_CDBNM%>&nbsp;<%=l_CDCNM%></td></tr><%
                        end if
                        end if
                      Next
                    %>
                  </tbody>
                </table>

              
              </li>
            </ul>
          </div>        
          <%
          end if

          '##############################################################################

          if CDAF2 = "OK" then        
          %>
          <div class="contest_file">
            <ul class="table_box">
              <li><span>아티스틱</span>
                
                <table id="swtable">
                  <thead>
                    <tr>
                      <th>오전경기</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
                        l_CDA = arrRs(0, ari)
                        l_CDBNM = arrRs(1, ari)
                        l_CDC = arrRs(2, ari)
                        l_CDCNM = arrRs(3, ari)
                        l_tryoutgamedate = arrRs(4, ari)
                        l_finalgamedate = arrRs(5, ari) '다이빙은 안씀
                        l_tryoutgamestarttime = arrRs(6, ari) '10:00 오전 13:00 > 오후 값고정
                        l_finalgamestarttime = arrRs(7, ari) '다이빙안씀
                        l_ITgubun = arrRs(8,ari)
                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if
                        
                        if (l_tryoutgamedate = start_gamedate and (l_tryoutgamestarttime = "10:00" or l_tryoutgamestarttime = "09:00")) or  _
                        (l_finalgamedate = start_gamedate and (l_finalgamestarttime = "10:00" or l_finalgamestarttime = "09:00")) then '프리루틴이면달라져야...
                        
                        if (l_tryoutgamedate = start_gamedate or l_finalgamedate = start_gamedate)  and l_CDA = "F2"  then
                        %><tr><td><%=itgubunstr%>&nbsp;<%=l_CDBNM%>&nbsp;<%=l_CDCNM%></td></tr><%
                        end if

                        end if
                      Next
                    %>
                  </tbody>
                </table>

                <table id="swtable">
                  <thead>
                    <tr>
                      <th>오후경기</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
                        l_CDA = arrRs(0, ari)
                        l_CDBNM = arrRs(1, ari)
                        l_CDC = arrRs(2, ari)
                        l_CDCNM = arrRs(3, ari)
                        l_tryoutgamedate = arrRs(4, ari)
                        l_finalgamedate = arrRs(5, ari) '다이빙은 안씀
                        l_tryoutgamestarttime = arrRs(6, ari) '10:00 오전 13:00 > 오후 값고정
                        l_finalgamestarttime = arrRs(7, ari) '다이빙안씀
                        l_ITgubun = arrRs(8,ari)
                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if

                        'if l_tryoutgamestarttime = "13:00" then 
                        if (l_tryoutgamedate = start_gamedate and (l_tryoutgamestarttime = "13:00" )) or  _
                        (l_finalgamedate = start_gamedate and (l_finalgamestarttime = "13:00")) then '프리루틴이면달라져야...                        

                        if (l_tryoutgamedate = start_gamedate or l_finalgamedate = start_gamedate)  and l_CDA = "F2"  then
                        %><tr><td><%=itgubunstr%>&nbsp;<%=l_CDBNM%>&nbsp;<%=l_CDCNM%></td></tr><%
                        end if
                        end if
                      Next
                    %>
                  </tbody>
                </table>

              </li>
            </ul>
          </div>        
          <%
          end if

          '수구#################################################################################################################

          if CDASG = "OK" then        
          %>
          <div class="contest_file">
            <ul class="table_box">
              <li><span>수구</span>
                
                <table id="swtable">
                  <thead>
                    <tr>
                      <th>경기순서</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
                        l_CDA = arrRs(0, ari)
                        l_CDBNM = arrRs(1, ari)
                        l_CDC = arrRs(2, ari)
                        l_CDCNM = arrRs(3, ari)
                        l_tryoutgamedate = arrRs(4, ari)
                        l_finalgamedate = arrRs(5, ari) '다이빙은 안씀
                        l_tryoutgamestarttime = arrRs(6, ari) '10:00 오전 13:00 > 오후 값고정
                        l_finalgamestarttime = arrRs(7, ari) '다이빙안씀
                        l_ITgubun = arrRs(8,ari)

                        'if l_tryoutgamestarttime = "09:00" then
                        if l_tryoutgamedate = start_gamedate and l_CDA = "E2" and l_CDC = "31" then
                        %><tr><td><%=l_CDBNM%>&nbsp;<%=l_CDCNM%></td></tr><%
                        end if
                        'end if
                      Next
                    %>
                  </tbody>
                </table>
              
              </li>
            </ul>
          </div>        
          <%
          end if

        end if
        %>

      </div>
    </div>



<%'call getrowsdrow(arrRs) 'debug%>



  <!-- E: main -->
  <!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>


</body>
</html>
