<%
 'Controller ################################################################################################

Set db = new clsDBHelper

Select Case F1
Case "1"
	SQL = ";with cnta as ( "
	SQL = SQL & " select count(*) as ca from  (select PlayerIDX FROM SD_Tennis.dbo.sd_TennisMember where gubun = 1 group by PlayerIDX) as a"
	SQL = SQL & " ),"
	SQL = SQL & " cntb as ( "
	SQL = SQL & " select count(*) as cb from ( "
	SQL = SQL & " select distinct(playeridx) from SD_Tennis.dbo.sd_TennisMember_partner where  "
	SQL = SQL & " PlayerIDX not in (select PlayerIDX FROM SD_Tennis.dbo.sd_TennisMember where gubun = 1 group by PlayerIDX)) as b  "
	SQL = SQL & " ) "

	SQL = SQL & " select (cnta.ca + cntb.cb) as 'KATA 중복제거 대회참가자수' from cnta inner join cntb on 1=1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

Case "2"

	
	SQL = ";with cnta as ( "
	SQL = SQL & " select count(*) as ca from  (select PlayerIDX FROM sd_rookietennis.dbo.sd_TennisMember  where gubun = 1 and WriteDate > '2019-01-01' group by PlayerIDX) as a"
	SQL = SQL & " ),"
	SQL = SQL & " cntb as ( "
	SQL = SQL & " select count(*) as cb from ( "
	SQL = SQL & " select distinct(playeridx) from sd_rookietennis.dbo.sd_TennisMember_partner where   lastupdate > '2019-01-01'  and  "
	SQL = SQL & " PlayerIDX not in (select PlayerIDX FROM sd_rookietennis.dbo.sd_TennisMember where gubun = 1 group by PlayerIDX)) as b  "
	SQL = SQL & " ) "

	SQL = SQL & " select (cnta.ca + cntb.cb) as 'SD 중복제거 대회참가자수' from cnta inner join cntb on 1=1 "
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)




Case "3"
	SQL = "select count(*) as '중복제거 수영 참가자수' from (select distinct(P1_playeridx)  from SD_swim.dbo.tblgamerequest where gametitleidx >= 127 and delYN='N') as a"
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

Case "4" '승마
	SQL = "select count(*) as '승마 대회 참가 중복제거 명수' from  (select PlayerIDX FROM sd_riding.dbo.sd_TennisMember where gubun = 1 group by PlayerIDX) as a"
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

	SQL = "select count(*) as '승마 등록된 선수' from sd_riding.dbo.tblPlayer where usertype = 'P' "
	Set rs2 = db.ExecSQLReturnRS(SQL , null, T_ConStr)

Case "5" '자전거
	SQL = "select count(*) as '자전거 선수 적용정보수' from SD_Bike.dbo.tblBikeApplyMemberInfo where delyn ='N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

Case "6"'앱참가자
	SQL = "select count(*) as '앱 회원수' from SD_member.dbo.tblmember where delyn = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)


Case "7" '민턴
	SQL = "SELECT count(*) as '배드민턴 동호인 등록완료 인원' 	FROM koreabadminton.dbo.tblAmatureRegAuth 	WHERE AuthYN = 'Y' AND DelYN = 'N' "
	Set rs = db.ExecSQLReturnRS(SQL , null, BM_ConStr)

	SQL = "SELECT count(*) as '배드민턴 동호인 등록대기 인원' 	FROM koreabadminton.dbo.tblAmatureRegAuth WHERE AuthYN = 'N' AND DelYN = 'N' "
	Set rs2 = db.ExecSQLReturnRS(SQL , null, BM_ConStr)

	'--배드민턴참가신청인원
	SQL = "select count(*) as '배드민턴참가신청인원'  from (SELECT  MemberIDX 	FROM koreabadminton.dbo.tblGameTitle A "
	SQL = SQL & "	INNER JOIN koreabadminton.dbo.tblGameLevel B ON B.GameTitleIDX = A.GameTitleIDX "
	SQL = SQL & "	INNER JOIN koreabadminton.dbo.tblGameRequestplayer C ON C.GameLevelidx = B.GameLevelidx "
	SQL = SQL & "	WHERE A.EnterType = 'A'	AND A.DelYN = 'N'	 AND B.DelYN = 'N'	 AND C.DelYN = 'N' 	AND A.MobileViewYN = 'Y' 	GROUP BY MemberIDX ) as a "
	Set rs3 = db.ExecSQLReturnRS(SQL , null, BM_ConStr)

Case "8" '유도
'--유도 동호인등록인원
	SQL = "select count(*) as '유도 동호인 등록인원' from (SELECT memberidx FROM sportsdiary.dbo.tblClubPayInfoRC WHERE DelYN = 'N' group by memberidx ) as a "
	Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)


'--유도생활체육 참가신청인원

	SQL = "select count(*) as '유도 생활체육 참가신청 인원' from (select PlayerCode from sportsdiary.dbo.tblGameTitle A "
	SQL = SQL & "	INNER JOIN sportsdiary.dbo.tblGameRequest B ON B.GameTitleIDX = A.GameTItleIDX "
	SQL = SQL & "	WHERE A.DelYN = 'N' AND B.DelYN = 'N' AND A.ViewYN = 'Y' AND NOT A.GameTitleName like '%테스트%' "
	SQL = SQL & "	 AND NOT A.GameTitleName like '%정구%' AND A.GameTitleIDX > 54 AND LEFT(B.Team,1) = 'A' GROUP BY B.PlayerCode ) as a "
	Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)


Case "9" '선수정보 루키테니스

	SQL = ";with cnta as ( "
	SQL = SQL & " select PlayerIDX from  (select PlayerIDX FROM sd_rookietennis.dbo.sd_TennisMember  where gubun = 1 and WriteDate > '2019-01-01' and gametitleidx <> 142  group by PlayerIDX) as a"
	SQL = SQL & " ),"
	SQL = SQL & " cntb as ( "
	SQL = SQL & " select PlayerIDX from ( "
	SQL = SQL & " select distinct(playeridx) as playeridx from sd_rookietennis.dbo.sd_TennisMember_partner where   lastupdate > '2019-01-01'  and  "
	SQL = SQL & " PlayerIDX not in (select PlayerIDX FROM sd_rookietennis.dbo.sd_TennisMember where gubun = 1 and gametitleidx <> 142  group by PlayerIDX)) as b  "
	SQL = SQL & " ) "

	'SQL = SQL & " select (cnta.ca + cntb.cb) as 'SD 중복제거 대회참가자수' from cnta inner join cntb on 1=1 "

	SQL = SQL & " select * from sd_rookietennis.dbo.tblPlayer where playeridx in (select playeridx from cnta UNION select playeridx from cntb ) "
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)

Case "10" '남여카운트

	SQL = ";with cnta as ( "
	SQL = SQL & " select PlayerIDX from  (select PlayerIDX FROM sd_rookietennis.dbo.sd_TennisMember  where gubun = 1 and WriteDate > '2019-01-01' and gametitleidx <> 142  group by PlayerIDX) as a"
	SQL = SQL & " ),"
	SQL = SQL & " cntb as ( "
	SQL = SQL & " select PlayerIDX from ( "
	SQL = SQL & " select distinct(playeridx) as playeridx from sd_rookietennis.dbo.sd_TennisMember_partner where   lastupdate > '2019-01-01'  and  "
	SQL = SQL & " PlayerIDX not in (select PlayerIDX FROM sd_rookietennis.dbo.sd_TennisMember where gubun = 1 and gametitleidx <> 142  group by PlayerIDX)) as b  "
	SQL = SQL & " ) "

	'SQL = SQL & " select (cnta.ca + cntb.cb) as 'SD 중복제거 대회참가자수' from cnta inner join cntb on 1=1 "

	SQL = SQL & " select sex as '성별' ,count(*) as '각명수' from sd_rookietennis.dbo.tblPlayer where playeridx in (select playeridx from cnta UNION select playeridx from cntb ) group by sex"
	Set rs = db.ExecSQLReturnRS(SQL , null, T_ConStr)



End Select 








'Call rsdrow(rs)


%>
<%'View ####################################################################################################%>

		<!-- s: 콘텐츠 시작 -->
		<div class="admin_content">
			<div class="page_title"><h1>로그검색</h1></div>


			<!-- s: 정보 검색 -->
			<div class="info_serch" id="gameinput_area">
				<div id="ul_1" class="form-horizontal">
					<div class="form-group">
						<%
						'jsonstr = JSON.stringify(oJSONoutput)
						%>

							<textarea id="query" style="width:99%;height:200px;"></textarea>


					</div>
					<div>
						<a href='javascript:px.goSearch({},1,"1", "<%=F2%>")' class="btn btn-primary">테니스</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"2", "<%=F2%>")'  class="btn btn-primary">SD 테니스</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"3", "<%=F2%>")'  class="btn btn-primary">수영</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"4", "<%=F2%>")'  class="btn btn-primary">승마</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"5", "<%=F2%>")'  class="btn btn-primary">자전거</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"6", "<%=F2%>")'  class="btn btn-primary">SD앱</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"7", "<%=F2%>")'  class="btn btn-primary">배드민턴</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"8", "<%=F2%>")'  class="btn btn-primary">유도</a>&nbsp;

						<a href='javascript:px.goSearch({},1,"9", "<%=F2%>")'  class="btn btn-primary">루키 참가자 정보</a>&nbsp;
						<a href='javascript:px.goSearch({},1,"10", "<%=F2%>")'  class="btn btn-primary">루키 남여 각명수</a>&nbsp;



					</div>
				</div>
			</div>

			<!-- e: 정보 검색 -->

			<hr />
			<!-- s: 테이블 리스트 -->
			<div class="table-responsive">
				<%
				If F1 <> "" then
				
					Call rsDrow(rs)
					
					Select Case F1
					Case "4"
						Call rsDrow(rs2)
					Case "7"
						Call rsDrow(rs2)
						Call rsDrow(rs3)
					Case "8"
						Call rsDrow(rs2)
					End Select

				End If
				%>
			</div>
			<!-- e: 테이블 리스트 -->


			
			<!-- s: 더보기 버튼 -->

			<!-- e: 더보기 버튼 -->

		</div>
		<!-- s: 콘텐츠 끝 -->
