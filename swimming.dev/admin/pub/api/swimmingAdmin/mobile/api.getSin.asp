<%
'#############################################
'검색이름의 참가팀 대진표 목록
'#############################################
	Set db = new clsDBHelper

	If hasown(oJSONoutput, "TIDX") = "ok" then
		tidx = oJSONoutput.TIDX
	End if
	If hasown(oJSONoutput, "RCCODE") = "ok" Then
		rccode = oJSONoutput.RCCODE
'		R01	대회유년
'		R02	대회초등
'		R03	대회중등
'		R04	대회고등
'		R05	대회대학
'		R06	대회일반
'		R07	한국기록
	End if
	If hasown(oJSONoutput, "BOONM") = "ok" Then
		boonm = oJSONoutput.BOONM
'		<option value="1">자유형</option>
'		<option value="2">배영</option>
'		<option value="3">평영</option>
'		<option value="4">접영</option>
'		<option value="5">혼영</option>
'		<option value="6">계영</option>
	End if


	fld =  " rcIDX,gametitleidx,titleCode,titlename,CDA,CDANM,CDB,CDBNM,CDC,CDCNM,kskey,ksportsno,playerIDX,UserName,Birthday,Sex,nation,sidoCode,sido,gameDate,EnterType,Team,TeamNm,userClass,rctype,gamearea,gameResult,preGameResult,gameOrder,rane,DelYN,gubun,kskey2,kskey3,kskey4,playerIDX2,UserName2,playerIDX3,UserName3,playerIDX4,UserName4,levelno,Roundstr,firstRC,RCNO,RgameLevelIDX,midx "
	If boonm = "계영" then
	strSort = " order by  cdcnm,sex,gamedate "
	Else
	strSort = " order by  cdc,sex,gamedate "
	End if
	'예선이 있는것만 우선가져오자.and (gubunam = '1' or gubunpm = '1') 음
	strWhere = " delyn= 'N' and rctype = '"&rccode&"' and  CDCNM like '%"&boonm&"%' "   'and a.DelYN = 'N'  " 'and  (gubunam = '1' or gubunpm = '1') "

	SQL = "Select " & fld & " from tblRecord where " & strWhere & strSort
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'Response.write sql

	'Call rsdrow(rs)
	'Response.end

	If rs.eof Then
		Call oJSONoutput.Set("result", 1 )
		strjson = JSON.stringify(oJSONoutput)
		Response.Write strjson

		Set rs = Nothing
		db.Dispose
		Set db = Nothing
		Response.end
	else
		fr = rs.GetRows()
	End if


	Set rs = Nothing
	db.Dispose
	Set db = Nothing
'################################################

If rccode = "R07" then
%>

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
								<strong><%=l_UserName%>(<%=shortNm(l_TeamNm)%>)<%If boonm = "계영" then%>,<%=l_UserName2%>,<%=l_UserName3%>,<%=l_UserName4%><%End if%></strong>
								<%=l_titlename%>
								<span><%Call SetRC(l_gameResult)%></span>
							  </td>
							</tr>
							<%
					Next 
					End if
				%>
          </table>



  <%else%>


  <h3 class="hide">신기록 표</h3>
  <table class="match-new-result2-con__tab-box__con clear">
	<thead class="match-new-result2-con__tab-box__con__thead">
	  <tr>
		<th colspan="2">종목</th>
		<th>대회명</th>
		<th>이름</th>
		<th>시도</th>
		<th>소속</th>
		<th>기록</th>
		<th>수립년도</th>
	  </tr>
	</thead>
	<tbody class="match-new-result2-con__tab-box__con__tbody">
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
						<%If ari = 0 then%>
						<th rowspan="<%=Cdbl(rowcnt)+1%>">
						  <span style="writing-mode:vertical-rl;text-orientation: upright;"><%=boonm%></span>
						</th>
						<%End if%>
						<td><%=l_cdcnm%></td>
						<td><%=l_titlename%></td>
						<td><%=l_UserName%>(<%=sexstr%>)<%If boonm = "계영" then%>,<%=l_UserName2%>,<%=l_UserName3%>,<%=l_UserName4%><%End if%></td>
						<td><%=l_sido%></td>
						<td><%=shortNm(l_TeamNm)%></td>
						<td><%Call SetRC(l_gameResult)%></td>
						<td><%=year(l_gameDate)%></td>
					  </tr>

					<%
			Next
			End if
		%>
	</tbody>
  </table>

  <%End if%>
