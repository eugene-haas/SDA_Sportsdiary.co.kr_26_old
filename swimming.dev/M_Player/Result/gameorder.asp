<!-- #include virtual = "/pub/header.swimmingAdmin.asp" -->
<%
'###########
'오전 ####
'###########

	Set db = new clsDBHelper

	tidx = request("tidx")
	REQ = request("P") 'fInject(chkReqMethod("p", "POST"))
	If REQ <> "" then
		Set oJSONoutput = JSON.Parse( join(array(REQ)) )

		If hasown(oJSONoutput, "TIDX") = "ok" then
			tidx = oJSONoutput.TIDX
		End If
		If hasown(oJSONoutput, "DD") = "ok" then
			dd = replace(oJSONoutput.get("DD"),"/","-")
		End if
	End if

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
      SQL = SQL & " from tblRGameLevel where delyn = 'N' and gametitleidx = "&tidx&" and tryoutgamedate is not null and (grouplevelidx is null or grouplevelidx = RGameLevelidx ) group by tryoutgamedate "
      SQL = SQL & " union all "
      SQL = SQL & " select "
      SQL = SQL & " finalgamedate as gamedate, min(cdcnm) as cda "
      SQL = SQL & " from tblRGameLevel where delyn = 'N' and gametitleidx = "&tidx&" and finalgamedate is not null and (grouplevelidx is null or grouplevelidx = RGameLevelidx ) group by finalgamedate "
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

					tm_gamedate= Replace(Left(tmarr(1, ari),10),"/","-")
					If tm_gamedate = CStr(Date) Then
						todaycheck = True
					End if
				Next

				SQL = "select idx,gamedate,am,pm,selectflag from sd_gameStartAMPM where tidx = "& tidx & " order by gamedate"
				Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rss.EOF Then
					tmrs = rss.GetRows()
				End If

				If IsArray(tmrs) Then
					For ari = LBound(tmrs, 2) To UBound(tmrs, 2)
						If ari = 0 Then
							start_am = isNullDefault(tmrs(2, ari), "")
							start_pm = isNullDefault(tmrs(3, ari), "")
						End If

						If isNullDefault(tmrs(1, ari), "") = dd Then
							start_am = isNullDefault(tmrs(2, ari), "")
							start_pm = isNullDefault(tmrs(3, ari), "")
						End If

					Next
				End if




			end if

			'++++++++++++++++++++++++
			fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm ,resultopenAMYN,resultopenPMYN,levelno,roundcnt"
			If start_gamedate = "" Then
				'날짜 생성전
			else


				If todaycheck = True then
					SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&date&"' and tryoutgameingS > 0) order by gameno " 'tryoutgameingS 진행될 초
				Else
					SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0) order by gameno " 'tryoutgameingS 진행될 초
				End if

				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
					arrR = rs.GetRows()
				End If

				fld = " a.RGameLevelidx,a.GbIDX,a.ITgubun,a.CDA,a.CDANM,a.CDB,a.CDBNM,a.CDC,a.CDCNM,a.SetBestScoreYN,a.tryoutgamedate,a.tryoutgamestarttime,a.tryoutgameingS "
				fld = fld & " ,a.finalgamedate,a.finalgamestarttime,a.finalgameingS,a.gameno,a.joono,a.gameno2,a.joono2,a.gubunam,a.gubunpm ,a.resultopenAMYN,a.resultopenPMYN,a.levelno,a.roundcnt"
				fld = fld & " , (select count(*) from tblRGameLevel where grouplevelidx is not null and grouplevelidx = a.grouplevelidx ) as gcnt " '신규추가 필드 
				'다이빙(날짤1개로사용) 아티스틱(날짜2개로 사용) 수구까지
				SQL = "select "&fld&" from tblRGameLevel as a "
				SQL = SQL & "	where a.delyn = 'N' and a.gametitleidx =  " & tidx  & " and a.CDA in ('E2','F2') and (a.tryoutgamedate = '"&start_gamedate&"' or a.finalgamedate = '"&start_gamedate&"')  " 'and tryoutgamestarttime = '10:00'  "
				SQL = SQL & " and (  grouplevelidx is null or grouplevelidx = RGameLevelidx ) "
				SQL = SQL & " order by cast(a.gameno as int ) "
				Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
				If Not rs.EOF Then
				arrRs = rs.GetRows()
				End If

			End if


	End if

	weekarr = array("-", "일","월","화","수","목","금","토")

	Set rs = Nothing
	db.Dispose
	Set db = Nothing
%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
</head>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
<input type="hidden" id = "tidx" value="<%=tidx%>">
<input type="hidden" id = "CDA" value="D2">
<input type="hidden" id = "ampm" value="am">


<div id="app" class="l contestInfo">
  <!-- #include file = "../include/gnbapp.asp" -->
	<div class="l_header">
    <div class="m_header s_sub">
		<a href="/Result/institute-search.asp?reqdate=<%=gameS%>" class="m_header__backBtn">이전</a>
			<h1 class="m_header__tit">경기순서</h1>
			<!-- #include file="../include/header_gnb.asp" -->
    </div>
		<!-- S: main banner 01 -->
		<!-- E: main banner 01 -->
	</div>

  <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">
		<!-- 여기에 내용 넣어주세요 -->
    <div class="match-order">
      <h2 class="m_resultTit">
        <span><%=title%></span><%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) <%=gamearea%>
      </h2>
      <div class="match-order-con">
        <div class="match-order-con__search clear" action="" method="post">
          <div class="match-order-con__search__box-selc">
            <label for="selcMatchDate" class="hide">경기 날짜 선택</label>
						<select id="selcMatchDate" onchange="px.goSubmit({'TIDX':<%=tidx%>,'DD':$(this).val()},'gameorder.asp?tidx=<%=tidx%>');">
						<%
								If IsArray(tmarr) Then
									For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
										tm_gamedate= replace(Left(tmarr(0, ari),10),"-","/")
										tm_week = weekarr(weekday(tm_gamedate))

										If todaycheck = True Then
											%><option value="<%=tm_gamedate%>" <%If Cdate(tm_gamedate) = date then%>selected<%End if%>><%= tm_gamedate%>&nbsp;(<%=tm_week%>)</option><%
										else
											%><option value="<%=tm_gamedate%>" <%If Cdate(tm_gamedate) = Cdate(start_gamedate) then%>selected<%End if%>><%= tm_gamedate%>&nbsp;(<%=tm_week%>)</option><%
										End if
									Next
								End if
						%>
						</select>

          </div>
          <div class="match-order-con__search__box-input">
            <label for="player_nm" class="hide">선수명을 검색해 주세요</label>
						<input type="text"  placeholder="선수명 입력" id="player_nm" value="">
            <span class="match-order-con__search__box-input__button" id="btnSearchMatchOrder"></span>
          </div>
        </div>

        <nav class="match-order-con__nav clear">
          <!-- s_on = 링크 강조 표시 -->
          <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':1,'DD':$('#selcMatchDate').val()},'gameorder.asp?tidx=<%=tidx%>');" id="linkMorningTime" class="match-order-con__nav__link s_on">
            오전 <%If IsArray(arrR) Then%><%=start_am%><%end if%> ~ </a>
          <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':1,'DD':$('#selcMatchDate').val()},'gameorder2.asp?tidx=<%=tidx%>');" id="linkAfternoonTime" class="match-order-con__nav__link">
            오후 <%If IsArray(arrR) Then%><%=start_pm%><%end if%> ~ </a>
        </nav>

		
				<!-- 경영 -->
				<div class="match-order-con__tab-box" id="sw_orderlist">

					<%If IsArray(arrR) Then%>
						<h3 class="hide">경기순서 표</h3>
						<table class="match-order-con__tab-box__con">
							<thead class="match-order-con__tab-box__con__thead">
								<tr>
									<th>순서</th>
									<th>부별</th>
									<th>종목</th>
									<th>정보</th>
								</tr>
							</thead>
							<tbody class="match-order-con__tab-box__con__tbody">
									<%
										'오전
										For ari = LBound(arrR, 2) To UBound(arrR, 2)
											l_idx = arrR(0, ari)
											l_GbIDX = arrR(1, ari)
											l_ITgubun = arrR(2, ari)
											l_CDA = arrR(3, ari)
											l_CDANM = arrR(4, ari)
											l_CDB = arrR(5, ari)
											l_CDBNM = arrR(6, ari)
											l_CDC = arrR(7, ari)
											l_CDCNM = arrR(8, ari)
											l_SetBestScoreYN = arrR(9, ari)
											l_tryoutgamedate = arrR(10, ari)
											l_tryoutgamestarttime = arrR(11, ari)
											l_tryoutgameingS = arrR(12, ari)
											l_finalgamedate = arrR(13, ari)
											l_finalgamestarttime = arrR(14, ari)
											l_finalgameingS = arrR(15, ari)
											l_gameno = arrR(16, ari)
											l_joono = arrR(17, ari)
											l_week = weekarr(weekday(l_tryoutgamedate))
											l_resultopenAMYN = arrR(22,ari)
											l_resultopenPMYN = arrR(23,ari)
											l_levelno = arrR(24,ari)


											l_gubun = arrR(20, ari)
											If l_gubun = "1" Then
											gubunstr = "예선"
											Else
											gubunstr = "결승"
											End if

											selectval = l_idx &"_"& l_levelno

											%>
												<tr>
												<td><%=l_gameno%>_<%=l_joono%></td>
												<td><%=shortBoo(l_CDBNM)%></td>
												<td><%=l_CDCNM%>[<%=gubunstr%>]</td>
												<td class="match-order-con__tab-box__con__link-info">
													<%If l_resultopenAMYN = "Y" then%>
													<!-- <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':4,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkRecordMatch">기록보기</a> -->
													경기종료
													<%else%>
													<!-- <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':4,'DD':$('#selcMatchDate').val()},'gameorderdetail.asp');" id="linkPlayerMatch">선수보기</a> -->
													대진표
													<%End if%>
												</td>
												</tr>
											<%
										Next
									%>
							</tbody>
						</table>
					<%End if%>

        <%
        '#################################################################################################################
        if IsArray(arrRs) then
					For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
						s_CDA = arrRs(3, ari)
						s_CDC = arrRs(5, ari)
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

          '다이빙#######################################
          if CDAE2 = "OK" then        
          %>
						<table class="match-order-con__tab-box__con" style="margin-top:5px;">
							<thead class="match-order-con__tab-box__con__thead">
								<tr>
									<th>순서</th>
									<th>(다이빙)종목</th>
									<th>라운드</th>
									<th>정보</th>
								</tr>
							</thead>
							<tbody class="match-order-con__tab-box__con__tbody">
                    <%
											i = 1
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
												l_idx = arrRs(0, ari)
												l_GbIDX = arrRs(1, ari)
												l_ITgubun = arrRs(2, ari)
												l_CDA = arrRs(3, ari)
												l_CDANM = arrRs(4, ari)
												l_CDB = arrRs(5, ari)
												l_CDBNM = arrRs(6, ari)
												l_CDC = arrRs(7, ari)
												l_CDCNM = arrRs(8, ari)
												l_tryoutgamedate = arrRs(10, ari)
												l_tryoutgamestarttime = arrRs(11, ari)
												l_finalgamedate = arrRs(13, ari)
												l_finalgamestarttime = arrRs(14, ari)
												l_gameno = arrRs(16, ari)
												l_resultopenAMYN = arrRs(22,ari)
												l_resultopenPMYN = arrRs(23,ari)
												l_levelno = arrRs(24,ari)
												l_roundcnt = arrRs(25,ari)

												l_gcnt = arrRs(26,ari)
												
												If l_resultopenAMYN = "Y"  then
													resulttext = "경기종료"
												else
													resulttext = "-"
												end if

                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if

												if ((l_tryoutgamestarttime = "10:00" or l_tryoutgamestarttime = "09:00") and l_tryoutgamedate = start_gamedate) or _
												((l_finalgamestarttime = "10:00" or l_finalgamestarttime = "09:00") and l_finalgamedate = start_gamedate)  then 
                        if l_CDA = "E2" then
                        %>
												<tr>
													<td><%=i%></td>
													<td><%=itgubunstr%>&nbsp;<%=shortBoo(l_CDBNM)%> <%=l_CDCNM%> <%If l_gcnt > 0 then%><span style="color:red;font-size:12px;">&nbsp;+<%=l_gcnt-1%></span><%End if%></td>
													<td style="text-align:center;"><%=l_roundcnt%>R</td>												
												%>
													<td class="match-order-con__tab-box__con__link-info"><%=resulttext%></td>
												</td>
												</tr>												
												<%
												i = i + 1
                        end if
                        end if
                      Next
                    %>
                  </tbody>
                </table>

          <%
          end if

          '아티스틱######################################

          if CDAF2 = "OK" then        
          %>

						<table class="match-order-con__tab-box__con" style="margin-top:5px;">
							<thead class="match-order-con__tab-box__con__thead">
								<tr>
									<th>순서</th>
									<th>(아티스틱)종목</th>
									<th>라운드</th>
									<th>정보</th>
								</tr>
							</thead>
							<tbody class="match-order-con__tab-box__con__tbody">
                    <%
											i=1
                      For ari = LBound(arrRs, 2) To UBound(arrRs, 2)
												l_idx = arrRs(0, ari)
												l_GbIDX = arrRs(1, ari)
												l_ITgubun = arrRs(2, ari)
												l_CDA = arrRs(3, ari)
												l_CDANM = arrRs(4, ari)
												l_CDB = arrRs(5, ari)
												l_CDBNM = arrRs(6, ari)
												l_CDC = arrRs(7, ari)
												l_CDCNM = arrRs(8, ari)
												l_tryoutgamedate = arrRs(10, ari)
												l_tryoutgamestarttime = arrRs(11, ari)
												l_finalgamedate = arrRs(13, ari)
												l_finalgamestarttime = arrRs(14, ari)
												l_gameno = arrRs(16, ari)
												l_resultopenAMYN = arrRs(22,ari)
												l_resultopenPMYN = arrRs(23,ari)
												l_levelno = arrRs(24,ari)
												l_roundcnt = arrRs(25,ari)
												
												l_gcnt = arrRs(26,ari)

                        if l_ITgubun = "I" then
                          itgubunstr = "개인"
                        else
                          itgubunstr = "단체"
                        end if
                        
                        '오전경기만
												if ((l_tryoutgamestarttime = "10:00" or l_tryoutgamestarttime = "09:00") and l_tryoutgamedate = start_gamedate) or _
												((l_finalgamestarttime = "10:00" or l_finalgamestarttime = "09:00") and l_finalgamedate = start_gamedate)  then 
                        if l_CDA = "F2"  then
                        %>
												<tr>
												<td><%=i%><%'=l_gameno%></td>
												<td><%=itgubunstr%>&nbsp;<%=shortBoo(l_CDBNM)%>&nbsp;<%=l_CDCNM%> <%If l_gcnt > 0 then%><span style="color:red;font-size:12px;">&nbsp;+<%=l_gcnt-1%></span><%End if%></td>
												
												<%
												Select Case l_CDC 
												Case "04","06","12"	'테크니컬
												
													if l_tryoutgamedate = l_finalgamedate then
														roundstr = "테크+프리"
													else
														if l_tryoutgamedate = start_gamedate then
															roundstr = "테크니컬"
														else
															roundstr = "프리루틴"													
														end if
													end if

												Case "01" '피겨솔로

													if l_tryoutgamedate = l_finalgamedate then
														roundstr = "피겨+프리"
													else
														if l_tryoutgamedate = start_gamedate then
															roundstr = "피겨루틴"
														else
															roundstr = "프리루틴"													
														end if
													end if

												Case "02","03" '피겨듀엣 ,'피겨팀
														roundstr = "프리루틴"
												Case Else '프리 루틴
														roundstr = "프리루틴"												
												end select


												If l_resultopenAMYN = "Y" and l_resultopenPMYN = "Y" then
													resulttext = "경기종료"
												else
													resulttext = "-"
												end if
												%>
													<td style="text-align:center;"><%=roundstr%></td>
													<td class="match-order-con__tab-box__con__link-info"><%=resulttext%></td>
												</tr>
												<%
												i = i + 1
                        end if
                        end if
                      Next
                    %>
                  </tbody>
                </table>
          <%
          end if

          '수구###########################################
          if CDASG = "OK" then        
          %>
                <table>
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
              
      
          <%
          end if
        end if
        '#################################################################################################################
        %>
				</div>


      </div>
    </div>
		<!-- 여기에 내용 넣어주세요 -->
  </div>
  <!-- E: main -->



<%'call GetRowsdrow(arrrs)%>



  <!-- #include virtual="/include/bottom_menu.asp" -->
  <!-- #include virtual= "/include/bot_config.asp" -->

</div>



</body>
</html>
