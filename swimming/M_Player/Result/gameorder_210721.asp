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
			dd = oJSONoutput.DD
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

			'설정날짜
			SQL = "select idx,gamedate,am,pm,selectflag from sd_gameStartAMPM where tidx = "& tidx & " order by gamedate"
			Set rss = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rss.EOF Then
				tmarr = rss.GetRows()
				last_gamedate= tmarr(1, UBound(tmarr, 2))
			End If

			If IsArray(tmarr) Then
				For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
					tm_selectflag = tmarr(4, ari)

					If ari = 0 Then
						start_gamedate = isNullDefault(tmarr(1, ari), "")
						start_am = isNullDefault(tmarr(2, ari), "")
						start_pm = isNullDefault(tmarr(3, ari), "")
					End If

					If isNullDefault(tmarr(1, ari), "") = dd Then
						start_gamedate = isNullDefault(tmarr(1, ari), "")
						start_am = isNullDefault(tmarr(2, ari), "")
						start_pm = isNullDefault(tmarr(3, ari), "")
					End If

				Next
			End if


			If REQ = "" then
			If IsArray(tmarr) Then
				For ari = LBound(tmarr, 2) To UBound(tmarr, 2)
					tm_gamedate= Replace(Left(tmarr(1, ari),10),"/","-")
					If tm_gamedate = CStr(Date) Then
						todaycheck = True
					End if
				Next
			End If
			End if




		  '++++++++++++++++++++++++
		  fld = " RGameLevelidx,GbIDX,ITgubun,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,SetBestScoreYN,tryoutgamedate,tryoutgamestarttime,tryoutgameingS,finalgamedate,finalgamestarttime,finalgameingS,gameno,joono,gameno2,joono2,gubunam,gubunpm ,resultopenAMYN,resultopenPMYN,levelno"
		  If start_gamedate = "" Then
			'날짜 생성전
		  else

			'오전 오후 두개 가져오자.
			If todaycheck = True then
			SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&date&"' and tryoutgameingS > 0) order by gameno " 'tryoutgameingS 진행될 초
			Else
			SQL = "select "&fld&" from tblRGameLevel where delyn = 'N' and gametitleidx =  " & tidx  & " and (tryoutgamedate = '"&start_gamedate&"' and tryoutgameingS > 0) order by gameno " 'tryoutgameingS 진행될 초
			End if
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.EOF Then
				arrR = rs.GetRows()
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

								tm_idx = tmarr(0, ari) 'idx
								tm_gamedate= Left(tmarr(1, ari),10)
								tm_am= tmarr(2, ari)
								tm_pm= tmarr(3, ari)
								tm_selectflag= tmarr(4, ari)

								tm_week = weekarr(weekday(tm_gamedate))

								If CStr(idx) = CStr(l_idx) Or CStr(e_idx) = CStr(l_idx) Then
									find_gbidx = l_gbidx
									find_cdc = l_CDC  '기준 배영200m
								End if


								If todaycheck = True Then
									%><option value="<%=tm_gamedate%>" <%If Replace(tm_gamedate,"/","-") = CStr(date) then%>selected<%End if%>><%= tm_gamedate%>&nbsp;(<%=tm_week%>)</option><%
								else
									%><option value="<%=tm_gamedate%>" <%If tm_gamedate = start_gamedate then%>selected<%End if%>><%= tm_gamedate%>&nbsp;(<%=tm_week%>)</option><%
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
            오전 <%=start_am%> ~
          </a>
          <a href="javascript:px.goSubmit({'TIDX':<%=tidx%>,'LIDX':'<%=l_idx%>','LNO':'<%=l_levelno%>','JOONO':1,'TABNO':1,'DD':$('#selcMatchDate').val()},'gameorder2.asp?tidx=<%=tidx%>');" id="linkAfternoonTime" class="match-order-con__nav__link">
            오후 <%=start_pm%> ~
          </a>
        </nav>

		<div class="match-order-con__tab-box" id="sw_orderlist">
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
              <!-- match-order-con__tab-box__con__link-info 아이디 값에따라 색 변화 -->
              <!-- match-order-con__tab-box__con__tbody > td
              s_yellow =색변화 -->
			<%
					If IsArray(arrR) Then  '오전
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
								<td>﻿<%=shortBoo(l_CDBNM)%></td>
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
					End if
			%>

            </tbody>
          </table>
        </div>
      </div>
    </div>
		<!-- 여기에 내용 넣어주세요 -->
  </div>
  <!-- E: main -->







  <!-- #include virtual="/include/bottom_menu.asp" -->
  <!-- #include virtual= "/include/bot_config.asp" -->

</div>



</body>
</html>
