<%
'#############################################

'(대진표 RGameList )에서 (코트정보입력창 enter_score )으로 갈때 필요한 정보 확인

'#############################################
	'request
	idx = oJSONoutput.IDX
	titleidx = oJSONoutput.TitleIDX
	'title = oJSONoutput.Title

	Set db = new clsDBHelper

	SQL = " select GameTitleName "
	SQL = SQL & " From sd_TennisTitle "
	SQL = SQL & " Where GameTitleIDX = " & titleidx
	Set rs2 = db.ExecSQLReturnRS(SQL , null, ConStr)		 

	If Not rs2.eof Then
		title = rs2("GameTitleName")
	eND IF


	strTableName = "  tblRGameLevel as a left join tblLevelInfo as b  ON a. level = b.level "
	strFieldName = " RGameLevelIdx,a.Level,a.TeamGbNm,GameTime,attmembercnt,a.gametype,b.LevelNm,a.TeamGb,a.teamGbSort,a.GameDay,a.GameTime,a.startscore,a.EndRound,a.gametype,EntryCntGame,courtcnt,a.bigo,a.cfg,a.joocnt,fee,fund,LastRchk "
	strWhere = " a.DelYN = 'N' and RGameLevelIdx = " & idx

	strSql = "SELECT top 1 " & strFieldName
	strSql = strSql &  "  FROM  " & strTableName
	strSql = strSql &  " WHERE " & strWhere
	
	Set rs = db.ExecSQLReturnRS(strSQL , null, ConStr)		 

	If Not rs.eof Then

		fstr2 = rs("TeamGb")
		If Left(fstr2, 3) = "202" then
			fstr = "tn001002" '단체전
		Else
			fstr = "tn001001" '개인전
		End if



		If Left(fstr2,3) = "201" Then
			boo = "개인전"
		Else
			boo = "단체전"
		End if

		flevel = CStr(rs("level"))		
		teamgbnm = rs("TeamGbNm")
		attcnt = rs("attmembercnt")
		gametype = rs("gametype")
		Select Case  gametype
		Case  "sd043003"
			gametypestr = "리그&gt;토너먼트"
		Case "sd043002"
			gametypestr = "토너먼트"
		End Select
		LevelNm = rs("LevelNm")
		gamedate = rs("gameday")
		gametime = rs("gametime")
		startscore = rs("startscore")
		endround = rs("endround")
		gametype = rs("gametype")
		updateidx = rs("RGameLevelIdx")
		entrycnt = rs("EntryCntGame")
		courtcnt = rs("courtcnt")
        bigo= rs("bigo")
		cfg = rs("cfg")
		chk1 = Left(cfg,1)
		chk2 = Mid(cfg,2,1)
		chk3 = Mid(cfg,3,1)
		chk4 = Mid(cfg,4,1) '요강 ,일반 변형
		joocnt = rs("joocnt")

		fee = rs("fee")
		fund = rs("fund")
		LastRchk = rs("LastRchk") '마지막 라운드 강수( 최종라운드에 랭킹산정시 사용)

		'#######################
		If  fstr = "tn001001" then
		SQL = "select sex,PTeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis' and PTeamGb in ('200', '201') and DelYN = 'N' order by Orderby asc"
		Else
		SQL = "select sex,TeamGb,PTeamGbNm,TeamGb, TeamGbNm,EnterType from tblTeamGbInfo where SportsGb = 'tennis'  and PTeamGb in ('202') and DelYN = 'N' order by Orderby asc"
		End if
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrRS = rs.GetRows()
		End If
		'#######################
		If fstr = "tn001002" Or fstr2 = "20001" Then
		else
		SQL = "select Level,LevelNm,Orderby  from tblLevelINfo where SportsGb = 'tennis' and TeamGb = '"&fstr2&"' and DelYN = 'N' order by Orderby asc"
		Set rs = db.ExecSQLReturnRS(SQL , null, ConStr)

		If Not rs.EOF Then 
			arrRS2 = rs.GetRows()
		End If
		End if
		'#######################


	End if

	db.Dispose
	Set db = Nothing


%>
<!-- #include virtual = "/pub/html/tennisAdmin/gameinfolevelform.asp" -->