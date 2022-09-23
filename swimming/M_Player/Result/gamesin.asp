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
		If hasown(oJSONoutput, "CDA") = "ok" then
			cda = oJSONoutput.CDA
		Else
			cda = "D2"
		End if
		If hasown(oJSONoutput, "CDB") = "ok" then
			cdb = oJSONoutput.CDB
		Else
			CDB = "S"
		End if
		If hasown(oJSONoutput, "CDC") = "ok" then
			cdc = oJSONoutput.CDC
		End if
	Else
		cda = "D2"
		CDB = "S"
	End if

	'신기록만 표시
	if tidx = "" Then
		tidx = 0
	end if

	SQL = "Select code , codenm from tblCode where gubun = '4' and idx < 226 order by sortno "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
	rsC = rs.GetRows()


	If isnumeric(tidx) Then
			'대회
			SQL = "select gametitlename , gameS,gameE,gamearea from sd_gameTitle where gametitleidx = '"&tidx&"' "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			If Not rs.eof Then
				title = rs(0)
				gameS = rs(1)
				gameE = rs(2)
				gamearea = rs(3)
			End if



			SQL = ";with rtbl as (select max(rcidx) as rcidx,cda,cdc,sex from tblRecord where delyn= 'N' and rctype = 'R07' and  CDCNM like '%자유%'   group by cda,cdc,sex) "
			SQL = SQL & " select rcidx from rtbl  "
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)
			i = 0
			Do Until rs.eof 
				If i = 0 Then
					rckeys = rs(0)	
				else
					rckeys = rckeys & "," & rs(0)
				End if
			i = i + 1
			rs.movenext
			Loop


			fld =  " rcIDX,gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,preGameResult,gameOrder,rane,DelYN,gubun,kskey2,kskey3,kskey4,playerIDX2,UserName2,playerIDX3,UserName3,playerIDX4,UserName4,levelno,Roundstr,firstRC,RCNO,RgameLevelIDX,midx "

			strSort = " order by  cdc,sex "
			'예선이 있는것만 우선가져오자.and (gubunam = '1' or gubunpm = '1') 음
			'strWhere = " delyn= 'N' and rctype = 'R07' and  CDC in ('01','02','03','04','05','06') "  
			strWhere = " delyn= 'N' and rcidx in ("&rckeys&") "   

			SQL = "Select " & fld & " from tblRecord where " & strWhere & strSort
			Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

			'Call rsdrow(rs)
			'Response.end

			If Not rs.EOF Then
				fr = rs.GetRows()
			End If
	End if

	weekarr = array("-", "일","월","화","수","목","금","토")
%>
<%=CONST_HTMLVER%>
<head>
	<!-- #include virtual = "/pub/html/swimming/html.head.sw.asp" -->
</head>
<body <%=CONST_BODY%>>
<form method='post' name='sform'><input type='hidden' name='p'></form>
<form method='post' name='ssform' style="display:none;"><input type='hidden' name='p' id='p'></form>
<input type="hidden" id = "tidx" value="<%=tidx%>">

<div id="app" class="l contestInfo">

  <!-- #include file = "../include/gnbapp.asp" -->
	<div class="l_header">
    <div class="m_header s_sub">
	  <a href="javascript:history.back()" class="m_header__backBtn">이전</a>
	  <!-- <a href="/Result/result.asp?tidx=<%=tidx%>" class="m_header__backBtn">이전</a> -->
  		<h1 class="m_header__tit">대회결과/신기록</h1>
  		<!-- #include file="../include/header_gnb.asp" -->
    </div>
	<!-- S: main banner 01 -->
    <!-- E: main banner 01 -->
	</div>




    <!-- S: main -->
  <div class="l_content m_scroll [ _content _scroll ]">
		<!-- 여기에 내용 넣어주세요 -->


    <div class="match-result">

		<%if tidx > 0 then%>
		<h2 class="m_resultTit">
        <span><%=title%></span><%=games%> (<%=weekarr(weekday(games))%>) ~<%=gameE%> (<%=weekarr(weekday(gamee))%>) | <%=gamearea%>
      </h2>
		<%end if%>

		<nav class="match-result-nav clear">
			<!-- s_on = 링크 강조 표시 -->
			<%if tidx > 0 then%>
			<a href="javascript:px.goSubmit({'TIDX':<%=tidx%>},'gameresult.asp?tidx=<%=tidx%>');" id="linkMatchResult" class="match-result-nav__link">
				대회결과
			</a>
			<a href="#a" id="linkNewRecord" class="match-result-nav__link s_on">
				신기록
			</a>
			<%end if%>
		</nav>
	  <div class="match-result-con">

        <div class="match-result-con__search clear" id="NewMatch">
          <div class="match-result-con__search__box-selc">
            <label class="hide" for="rctype">범위 선택</label>
            <select class="match-result-con__search__box-selc__selc" id="rctype" onchange="mx.getRC(<%=tidx%>,$('#rctype').val(),$('#boono').val())">
			<%
				If IsArray(rsC) Then
					For ari = LBound(rsC, 2) To UBound(rsC, 2)

						l_code = rsC(0, ari) 'idx
						l_codenm = rsC(1, ari)
						%><option value="<%=l_code%>"><%=l_codenm%></option><%
					Next
				End if
			%>
            </select>
          </div>
          <div class="match-result-con__search__box-selc">
            <label class="hide" for="boono">종목 선택</label>
            <select class="match-result-con__search__box-selc__selc" id="boono" onchange="mx.getRC(<%=tidx%>,$('#rctype').val(),$('#boono').val())">
				<option value="자유형">자유형</option>
				<option value="배영">배영</option>
				<option value="평영">평영</option>
				<option value="접영">접영</option>
				<%If now > CDate("2021-05-14 19:50:00") then%>
				<option value="혼영">개인혼영</option>
				<option value="계영">혼계영</option>
				<%else%>
				<option value="혼영">혼영</option>
				<option value="계영">계영</option>
				<%End if%>
            </select>
          </div>
        </div>


        <div class="match-result-con__tab-box" id="sw_gametable">
          <h3 class="hide">신기록 표</h3>
          <table class="match-new-result1-con__tab-box__con">
				<%
				If IsArray(fr) Then
					rowcnt = UBound(fr, 2)
					For ari = LBound(fr, 2) To UBound(fr, 2)
							l_rcIDX = fr(0, ari)
							l_gametitleidx = fr(1, ari)
							l_titleCode = fr(2, ari)
							l_titlename = fr(3, ari)
							l_CDA = fr(4, ari)
							l_CDANM = fr(5, ari)
							l_CDB = fr(6, ari)
							l_CDBNM = fr(7, ari)
							l_CDC = fr(8, ari)
							l_CDCNM = fr(9, ari)
							l_kskey = fr(10, ari)
							l_ksportsno = fr(11, ari)
							l_playerIDX = fr(12, ari)
							l_UserName = fr(13, ari)
							l_Birthday = fr(14, ari)
							l_Sex = fr(15, ari)
							l_nation = fr(16, ari)
							l_sidoCode = fr(17, ari)
							l_sido = fr(18, ari)
							l_gameDate = fr(19, ari)
							l_EnterType = fr(20, ari)
							l_Team = fr(21, ari)
							l_TeamNm = fr(22, ari)
							l_userClass = fr(23, ari)
							l_rctype = fr(24, ari)
							l_gamearea = fr(25, ari)
							l_gameResult = fr(26, ari)
							l_preGameResult = fr(27, ari)
							l_gameOrder = fr(28, ari)
							l_rane = fr(29, ari)
							l_DelYN = fr(30, ari)
							l_gubun = fr(31, ari)
							l_kskey2 = fr(32, ari)
							l_kskey3 = fr(33, ari)
							l_kskey4 = fr(34, ari)
							l_playerIDX2 = fr(35, ari)
							l_UserName2 = fr(36, ari)
							l_playerIDX3 = fr(37, ari)
							l_UserName3 = fr(38, ari)
							l_playerIDX4 = fr(39, ari)
							l_UserName4 = fr(40, ari)
							l_levelno = fr(41, ari)
							l_Roundstr = fr(42, ari)
							l_firstRC = fr(43, ari)
							l_RCNO = fr(44, ari)
							l_RgameLevelIDX = fr(45, ari)
							l_midx  = fr(46, ari)
							Select Case l_sex
							Case "1" :							sexstr  = "남"
							Case "2" :							sexstr = "여"
							Case "3" : 							sexstr = "혼"
							End select
							%>
							<tr>
							  <%If ari Mod 2 = 0 then%>
							  <th scope="rowgroup" rowspan="2"><%=l_cdcnm%></th>
							  <%End if%>
							  <td><%=sexstr%></td>
							  <td>
								<strong><%=l_UserName%>(<%=shortNm(l_TeamNm)%>)</strong>
								<%=l_titlename%>
								<span><%Call SetRC(l_gameResult)%></span>
							  </td>
							</tr>
							<%
					Next
					End if
				%>
          </table>
        </div>




		<!-- 여기에 내용 넣어주세요 -->
  </div>
  <!-- E: main -->




	<!-- #include file="../include/bottom_menu.asp" -->
  <!-- #include file= "../include/bot_config.asp" -->
</div>




</body>
</html>

<%
  set rs = Nothing
  db.Dispose
  Set db = Nothing
%>
