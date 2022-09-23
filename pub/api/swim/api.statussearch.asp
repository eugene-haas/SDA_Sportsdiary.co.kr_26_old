<%
	'request
	gidx = oJSONoutput.GIDX '게임인덱스
	strs1 = oJSONoutput.S1 '진행현황 수상현황 s01 s02
	'  strs2 = oJSONoutput.S2 '경기유형
	'  strs3 = oJSONoutput.S2 '종목선택
	tabletype = oJSONoutput.TT '구분 전체0, 기타 상세 코드

	Set db = new clsDBHelper


Select Case strs1
Case "s01"

	If tabletype <> "0" Then
		booquery = " and level = " & tabletype & " "
	End if

	SQL = "SELECT gamekeyname ,key3, [0] as 'ready',[2] as 'ing', [1] as 'gameend' FROM "
	SQL = SQL & " (select gamekeyname, MAX(gamekey3) as key3, stateno,COUNT(*) as cnt  from  sd_TennisResult where GameTitleIDX = "&gidx & booquery &   "  group by gamekeyname,stateno) as t "
	SQL = SQL & "PIVOT( max(cnt) FOR stateno IN ([0],[2],[1]) ) as PivotTable "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

'Response.write sql

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if

Case "s02"

	If tabletype <> "0" Then
		booquery = " and level = " & tabletype & " "
	End if

	SQL = "select top 4 key3name,key3,ranknum,max(m1name) as m1nm ,max(m1team1) as m1t1,max(m1team2) as m1t2, max(m2name) as m2nm ,max(m2team1) as m2t1,max(m2team2) as m2t2,max(rt_confirm) as rt_con  from sd_TennisRanking where GameTitleIDX = "&gidx & booquery & " and ranknum > 0 group by key3name,key3,ranknum order by key3name, ranknum asc"
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

	If Not rs.EOF Then 
		arrRS = rs.GetRows()
	End if

End Select 


	'///////////////대회마다 다름...
	strSql = "SELECT  a.TeamGb,a.TeamGbNm,  a.Level, b.LevelNm  "
	strSql = strSql &  "  FROM tblRGameLevel as a inner join tblLevelInfo as b  ON a. level = b.level "
	strSql = strSql &  " WHERE a.GameTitleIDX = " & gidx 
	strSql = strSql &  " AND a.DelYN = 'N'"
	strSql = strSql &  " ORDER BY a.TeamGbSort ASC"

	'strSql = "select TeamGb,TeamGbNm  from tblTeamGbInfo where SportsGb = 'tennis' order by Orderby asc"
	Set rs = db.ExecSQLReturnRS(strSql , null, ConStr)

	If Not rs.EOF Then 
		arrRS2 = rs.GetRows()
	End if

	db.Dispose
	Set db = Nothing
%>

<%
'=======================
'tabletype 
'0 현황조회
'=======================

Select Case strs1
Case "s01"
%>

		<!-- S: operating-tab -->
			<div class="operating-tab">
			  <ul class="operating-list">
				<li>
				  <a href="javascript:score.statusSearch(0);" <%If tabletype = "0" then%>class="on"<%End if%>>전체</a>
				</li>

				<%
				If IsArray(arrRS2) Then
				For ar = LBound(arrRS2, 2) To UBound(arrRS2, 2) 
				teamidx = arrRS2(0, ar) 
				teamname =  arrRS2(1, ar)	
				teamlvl =  arrRS2(2, ar)	
				teamlvlname  =  arrRS2(3, ar)	
				%>
				<li>
				  <a href="javascript:score.statusSearch(<%=teamlvl%>);" <%If CStr(tabletype) = CStr(teamlvl) then%>class="on"<%End if%>><%=teamname%> (<%=teamlvlname%>)</a>
				</li>
				<%Next
				End if
				%>				
			  </ul>
			</div>
		<!-- E: operating-tab -->

		<!-- S: preli -->
		<div id="list_body" class="preli">

		  <!-- S: opera-table -->
		  <div class="opera-table">
			<!-- S: playing-table -->
			<table class="playing-table">
			  <thead>
				<th>종목</th>
				<th colspan="2">대전방식</th>
				<th>총경기</th>
				<th>경기완료</th>
				<th>진행중</th>
				<th>남은 경기</th>
				<th>진행률</th>
				<th>결과보기</th>
			  </thead>
			  <tbody>
				
				<%
				If IsArray(arrRS) Then
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
					booname = arrRS(0, ar) 
					key3 = arrRS(1, ar)
					readycnt =  arrRS(2, ar)
					ingcnt =  arrRS(3, ar)
					endcnt =  arrRS(4, ar)

					If isNull(readycnt) = True Then
						readycnt = 0
					End if
					If isNull(ingcnt) = True Then
						ingcnt = 0
					End if
					If isNull(endcnt) = True Then
						endcnt = 0
					End if

					totalcnt = CDbl(readycnt) + CDbl(ingcnt) + CDbl(endcnt)
					ingper = FormatPercent(endcnt/totalcnt,0)
				%>
				  </tr>
					<td><%=booname%></td>
					<td>예선</td>
					<td>리그</td>
					<td><%=totalcnt%></td>
					<td><%=endcnt%></td>
					<td><%=ingcnt%></td>
					<td><%=readycnt%></td>
					<td><%=ingper%></td>
					<td>
					  <a href="javascript:score.gameSearch(20, <%If tabletype = "0" then%><%=key3%><%else%><%=tabletype%><%End if%>)" class="btn btn-show-result">보기</a>
					</td>
					</tr>
				<%Next
				End if
				%>

			  </tbody>
			</table>
			<!-- E: playing-table -->
		  </div>
		  <!-- E: opera-table -->

		</div>

<%Case "s02" '##################################################################%>

		<!-- S: operating-tab -->
			<div class="operating-tab">
			  <ul class="operating-list">

				<li>
				  <a href="javascript:score.statusSearch(0);" <%If tabletype = "0" then%>class="on"<%End if%>>전체</a>
				</li>

				<%
				If IsArray(arrRS2) Then
				For ar = LBound(arrRS2, 2) To UBound(arrRS2, 2) 
				teamidx = arrRS2(0, ar) 
				teamname =  arrRS2(1, ar)	
				teamlvl =  arrRS2(2, ar)	
				teamlvlname  =  arrRS2(3, ar)	
				%>
				<li>
				  <a href="javascript:score.statusSearch(<%=teamlvl%>);" <%If CStr(tabletype) = CStr(teamlvl) then%>class="on"<%End if%>><%=teamname%> (<%=teamlvlname%>)</a>
				</li>
				<%Next
				End if
				%>	

			  </ul>
			</div>
		<!-- E: operating-tab -->

		<!-- S: preli -->
		<div id="list_body" class="preli">
		  <!-- S: opera-table -->
		  <div class="opera-table">
			<!-- S: winner-table -->
			<table class="winner-table">

			  <thead>
				<th>종목</th>
				<th colspan="2">
				  <span class="ic-deco"><img src="images/tournerment/public/champ1@3x.png" alt="1위"></span>
				  <span>1위</span>
				</th>
				<th colspan="2">
				  <span class="ic-deco"><img src="images/tournerment/public/champ2@3x.png" alt="2위"></span>
				  <span>2위</span>
				</th>
				<th colspan="2">
				  <span class="ic-deco"><img src="images/tournerment/public/champ3@3x.png" alt="3위"></span>
				  <span>3위</span>
				</th>
				<th colspan="2">
				  <span class="ic-deco"><img src="images/tournerment/public/champ3@3x.png" alt="3위"></span>
				  <span>3위</span>
				</th>
				<th>결과보기</th>
				<th>확인</th>
			  </thead>
			  
			  <tbody>
				  <tr>
				<%
				i = 0
				If IsArray(arrRS) Then
				For ar = LBound(arrRS, 2) To UBound(arrRS, 2) 
					key3name = arrRS(0, ar) 
					key3 = arrRS(1, ar)
					ranknum =  arrRS(2, ar)

					m1nm =  arrRS(3, ar)
					m1t1 =  arrRS(4, ar)
					m1t2 =  arrRS(5, ar)

					m2nm =  arrRS(6, ar)
					m2t1 =  arrRS(7, ar)
					m2t2 =  arrRS(8, ar)

					rtconfirm =  arrRS(9, ar)
				%>
				  <%If i > 0 And key3name <> prename then%>
					<%For n = 1 To 4- prerank%>
						<td><span class="player-name"></span><span class="player-belong"></span></td>
						<td><span class="player-name"></span><span class="player-belong"></span></td>
					<%next%>
					<td>
					  <a href="javascript:score.gameSearch(20, <%If tabletype = "0" then%><%=prekey3%><%else%><%=tabletype%><%End if%>)" class="btn btn-show-result">보기</a>
					  <!-- <a href="javascript:mx.SendPacket('list_body', {'CMD':mx.CMD_GAMESEARCH,'S1': 'tn001001','S2': '200','S3':'20001','TT': 21 })" class="btn btn-show-result">보기</a> -->
					</td>
					<td>
					  <a href="#" class="btn btn-chk on"></a>
					</td>
				  </tr>
				  <tr>
					<%End if%>
					<%If ranknum = "1" then%>
						<td><%=key3name%></td>
						<td>
						  <span class="player-name"><%=m1nm%></span>
						  <span class="player-belong"><%=m1t1%>,<%=m1t2%></span>
						</td>
						<td>
						  <span class="player-name"><%=m2nm%></span>
						  <span class="player-belong"><%=m2t1%>,<%=m2t2%></span>
						</td>
					<%End if%>

					<%If ranknum = "2" then%>
						<td>
						  <span class="player-name"><%=m1nm%></span>
						  <span class="player-belong"><%=m1t1%>,<%=m1t2%></span>
						</td>
						<td>
						  <span class="player-name"><%=m2nm%></span>
						  <span class="player-belong"><%=m2t1%>,<%=m2t2%></span>
						</td>
					<%End if%>

					<%If ranknum = "3" then%>
						<td>
						  <span class="player-name"><%=m1nm%></span>
						  <span class="player-belong"><%=m1t1%>,<%=m1t2%></span>
						</td>
						<td>
						  <span class="player-name"><%=m2nm%></span>
						  <span class="player-belong"><%=m2t1%>,<%=m2t2%></span>
						</td>
					<%End if%>

					<%If ranknum = "4" then%>
						<td>
						  <span class="player-name"><%=m1nm%></span>
						  <span class="player-belong"><%=m1t1%>,<%=m1t2%></span>
						</td>
						<td>
						  <span class="player-name"><%=m2nm%></span>
						  <span class="player-belong"><%=m2t1%>,<%=m2t2%></span>
						</td>
					<%End if%>
				<%
				i = i + 1
				prertcon = rtconfirm
				prekey3 = key3
				prerank = ranknum
				prename = key3name
				Next
				End if
				%>

					<%
					If IsArray(arrRS) Then
					For n = 1 To 4- prerank%>
						<td><span class="player-name"></span><span class="player-belong"></span></td>
						<td><span class="player-name"></span><span class="player-belong"></span></td>
					<%next%>
					<td>
					  <a href="javascript:score.gameSearch(20, <%If tabletype = "0" then%><%=key3%><%else%><%=tabletype%><%End if%>)" class="btn btn-show-result">보기</a>
					</td>
					<td>
					  <a href="#" class="btn btn-chk on"></a>
					</td>
					<%End if%>

				  </tr>






			  </tbody>

			</table>
			<!-- E: winner-table -->
		  </div>
		  <!-- E: opera-table -->
		</div>
<%End Select%>




